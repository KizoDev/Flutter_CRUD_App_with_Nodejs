import 'dart:ffi';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/item.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final String serverUrl = "http://192.168.43.58:8000";
  late Future<List<Item>> items;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    items = fetchItems();
  }

  Future<List<Item>> fetchItems() async {
    final response = await http.get(Uri.parse('$serverUrl/api/items'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> itemList = jsonResponse['data'];
      final List<Item> items = itemList.map((item) {
        return Item.fromJson(item);
      }).toList();
      return items;
    } else {
      throw Exception('Unable to fetch items');
    }
  }

  Future<Item> addItem(String title, String description) async {
    final response = await http.post(
      Uri.parse('$serverUrl/api/addItem'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'title': title, 'description': description}),
    );

    if (response.statusCode == 201) {
      final dynamic json = jsonDecode(response.body);
      final Item item = Item.fromJson(json['data']);
      return item;
    } else {
      print('Failed to add item: ${response.body}');
      throw Exception('Unable to add item: ${response.statusCode}');
    }
  }

  Future<Item> updateItem(String id, String title, String description) async {
    final response = await http.put(
      Uri.parse('$serverUrl/api/updateItem/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'title': title, 'description': description}),
    );

    if (response.statusCode == 200) {
      final dynamic json = jsonDecode(response.body);
      final Item updatedItem = Item.fromJson(json['data']);
      return updatedItem;
    } else {
      print('Failed to update item: ${response.body}');
      throw Exception('Unable to update item: ${response.statusCode}');
    }
  }

  void _submitNewItem(String title, String description) async {
    try {
      final newItem = await addItem(title, description);
      setState(() {
        items = items.then((currentItems) => [...currentItems, newItem]);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  void _submitUpdatedItem(String id, String title, String description) async {
    try {
      final updatedItem = await updateItem(id, title, description);
      setState(() {
        items = items.then((currentItems) {
          final itemIndex = currentItems.indexWhere((item) => item.id == id);
          if (itemIndex != -1) {
            currentItems[itemIndex] = updatedItem;
          }
          return currentItems;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text(
          'ITEM LIST',
          style: TextStyle(color: Colors.amber),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.blue,
          child: Column(
            children: [
              FutureBuilder<List<Item>>(
                future: items,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    final items = snapshot.data!;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            title: Text(item.title),
                            subtitle: Text(item.description),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                nameController.text = item.title;
                                descriptionController.text = item.description;
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Edit Item'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: nameController,
                                            decoration: const InputDecoration(
                                                labelText: 'Item Title',
                                                fillColor: Colors.amberAccent),
                                          ),
                                          TextFormField(
                                            controller: descriptionController,
                                            decoration: const InputDecoration(
                                                labelText: 'Item Description'),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _submitUpdatedItem(
                                                item.id,
                                                nameController.text,
                                                descriptionController.text);
                                            nameController.clear();
                                            descriptionController.clear();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Update'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('No items found'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Item'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'Item Title'),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Item Description'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _submitNewItem(
                          nameController.text, descriptionController.text);
                      nameController.clear();
                      descriptionController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: "Add Item",
        child: const Icon(Icons.add),
      ),
    );
  }
}
