import 'package:flutter/material.dart';
import 'package:pos/models/store_model.dart';
import 'package:pos/services/store_service.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final StoreService _storeService = StoreService();
  List<Store> _storeList = [];

  // Load all stores
  Future<void> _loadStores() async {
    try {
      final list = await _storeService.fetchStores();
      setState(() {
        _storeList = list;
      });
    } catch (e) {
      setState(() {
        _storeList = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  // Save or update store
  Future<void> _saveStore(Store store) async {
    try {
      if (store.id == null) {
        await _storeService.insertStore(store);
      } else {
        await _storeService.updateStore(store);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Saved successfully"),
          backgroundColor: Colors.green,
        ),
      );
      _loadStores();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Delete store
  Future<void> _deleteStore(String id) async {
    try {
      final result = await _storeService.deleteStore(id);
      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Deleted successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
      _loadStores();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showStoreDialog({Store? store}) {
    final nameController = TextEditingController(text: store?.name ?? "");
    final managerController = TextEditingController(text: store?.manager ?? "");
    final locationController = TextEditingController(
      text: store?.location ?? "",
    );
    final phoneController = TextEditingController(text: store?.phone ?? "");
    final statusController = TextEditingController(text: store?.status ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(store == null ? "Add New Store" : "Edit Store"),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Name", nameController),
              _buildTextField("Manager", managerController),
              _buildTextField("Location", locationController),
              _buildTextField("Phone", phoneController),
              _buildTextField("Status", statusController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newStore = Store(
                id: store?.id,
                name: nameController.text,
                manager: managerController.text,
                location: locationController.text,
                phone: phoneController.text,
                status: statusController.text,
              );
              _saveStore(newStore);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Store Management",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton.icon(
                onPressed: () => _showStoreDialog(),
                icon: const Icon(Icons.add),
                label: const Text("Add Store"),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(color: Colors.grey),
                columns: const [
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Manager")),
                  DataColumn(label: Text("Location")),
                  DataColumn(label: Text("Phone")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: _storeList.map((store) {
                  return DataRow(
                    cells: [
                      DataCell(Text(store.name)),
                      DataCell(Text(store.manager)),
                      DataCell(Text(store.location)),
                      DataCell(Text(store.phone)),
                      DataCell(Text(store.status)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showStoreDialog(store: store),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteStore(store.id!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
