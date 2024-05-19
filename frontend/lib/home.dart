/*import 'dart:convert';
import 'dart:ffi';
//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:frontend/item.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String serverUrl = "http://192.168.43.58:8000";
  late Future<List<Item>> items;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

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
      throw Exception('Unable to fetch item: ${response.statusCode}');
    }
  }

  Future<Item> addItem(String title, String description) async {
    final response = await http.post(Uri.parse('$serverUrl/api/addItem'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'title': title, 'description': description}));

    if (response.statusCode == 201) {
      final dynamic json = jsonDecode(response.body);
      final Item item = Item.fromJson(json['data']);
      return item;
    } else {
      print('Failed to add item: ${response.body}');
      throw Exception('Unable to add item: ${response.statusCode}');
    }
  }

  Future<void> updateItem(int id, String title, String description) async {
    final response = await http.put(Uri.parse('$serverUrl/api/updateItem/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'title': title, 'description': description}));

    if (response.statusCode != 200) {
      throw Exception('Unable to fetch item: ${response.statusCode}');
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
        centerTitle: true,
        title: const Text('Item List'),
      ),
      body: SafeArea(
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
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.description),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          nameController.text = item.title;
                          descriptionController.text = item.description;
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Edit Item'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                          labelText: 'Item Title'),
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
                                ]);
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No items found'),
                );
              }
            },
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('add item'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'item title'),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'item description'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('cancel')),
                  TextButton(
                      onPressed: () {
                        addItem(
                            nameController.text, descriptionController.text);
                        setState(() {
                          nameController.clear();
                          descriptionController.clear();
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Add')),
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
*/
