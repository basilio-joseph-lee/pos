import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pos/services/variables.dart';
import 'package:http/http.dart' as http;

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  List<dynamic> userList = [];
  List<dynamic> storeList = [];

  TextEditingController _username = TextEditingController();
  TextEditingController _fullname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  String? selectedStatus;
  String? selectedStore;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchStores();
    fetchUsers();
  }

  // FETCH STORES FOR DROPDOWN
  Future<void> fetchStores() async {
    try {
      final res = await http.get(Uri.parse(server + "api/store/fetch.php"));
      setState(() {
        storeList = jsonDecode(res.body) ?? [];
      });
    } catch (e) {
      print(e);
    }
  }

  // FETCH USERS
  Future<void> fetchUsers() async {
    try {
      final res = await http.get(Uri.parse(server + "api/user/fetch.php"));
      setState(() {
        userList = jsonDecode(res.body) ?? [];
      });
    } catch (e) {
      print(e);
    }
  }

  // CLEAR FORM FIELDS
  void _clearFields() {
    _username.clear();
    _fullname.clear();
    _email.clear();
    _password.clear();
    selectedStatus = null;
    selectedStore = null;
  }

  // SAVE OR UPDATE USER
  Future<void> saveUser({Map<String, dynamic>? user}) async {
    try {
      setState(() => isLoading = true);

      Map<String, dynamic> data = {
        "userID": user?['userID'] ?? '',
        "storeID": selectedStore ?? '',
        "Username": _username.text,
        "Fullname": _fullname.text,
        "Email": _email.text,
        "Password": _password.text,
        "Status": selectedStatus ?? '',
      };

      final url =
          server +
          (user == null ? "api/user/insert.php" : "api/user/update.php");
      final res = await http.post(Uri.parse(url), body: data);
      final result = jsonDecode(res.body);

      setState(() => isLoading = false);

      if (result['success'] == true) {
        _clearFields();
        await fetchUsers();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Operation successful'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Operation failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      print(e);
    }
  }

  // DELETE USER
  Future<void> deleteUser(String id) async {
    try {
      final res = await http.post(
        Uri.parse(server + "api/user/delete.php"),
        body: {"userID": id},
      );
      final result = jsonDecode(res.body);
      if (result['success'] == true) {
        await fetchUsers();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Delete failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting user"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // SHOW DIALOG
  void showUserDialog({Map<String, dynamic>? user}) {
    if (user != null) {
      _username.text = user['Username'];
      _fullname.text = user['Fullname'];
      _email.text = user['Email'];
      _password.text = '';
      selectedStatus = user['Status'];
      selectedStore = user['storeID'].toString();
    } else {
      _clearFields();
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                user != null ? "Edit User" : "Add New User",
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(height: 1),
                    SizedBox(height: 20),
                    if (isLoading) LinearProgressIndicator(),
                    SizedBox(height: 10),
                    TextField(
                      controller: _username,
                      decoration: InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _fullname,
                      decoration: InputDecoration(
                        labelText: "Fullname",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _password,
                      decoration: InputDecoration(
                        labelText: user != null
                            ? "Password (Leave blank to keep)"
                            : "Password",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Store",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedStore,
                      items: storeList.map((store) {
                        return DropdownMenuItem(
                          value: store['storeID'].toString(),
                          child: Text(store['Name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedStore = value;
                        setStateDialog(() {});
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Status",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedStatus,
                      items: [
                        DropdownMenuItem(
                          value: "Active",
                          child: Text("Active"),
                        ),
                        DropdownMenuItem(
                          value: "Inactive",
                          child: Text("Inactive"),
                        ),
                      ],
                      onChanged: (value) {
                        selectedStatus = value;
                        setStateDialog(() {});
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => saveUser(user: user),
                  child: Text(user != null ? "Update" : "Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "User Management",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 10),
                child: ElevatedButton.icon(
                  onPressed: () => showUserDialog(),
                  icon: Icon(Icons.add),
                  label: Text("Add User"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Align(
                  alignment: Alignment.topCenter, // 👈 key line
                  child: DataTable(
                    columnSpacing: 40,
                    headingRowHeight: 56,
                    dataRowHeight: 52,
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columns: const [
                      DataColumn(label: Text("Username")),
                      DataColumn(label: Text("Fullname")),
                      DataColumn(label: Text("Email")),
                      DataColumn(label: Text("Store")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Action")),
                    ],
                    rows: userList.map((user) {
                      final storeName = storeList.firstWhere(
                        (store) =>
                            store['storeID'].toString() ==
                            user['storeID'].toString(),
                        orElse: () => {'Name': 'Unknown'},
                      )['Name'];

                      return DataRow(
                        cells: [
                          DataCell(Text(user['Username'] ?? '')),
                          DataCell(Text(user['Fullname'] ?? '')),
                          DataCell(Text(user['Email'] ?? '')),
                          DataCell(Text(storeName)),
                          DataCell(Text(user['Status'] ?? '')),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => showUserDialog(user: user),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () =>
                                      deleteUser(user['userID'].toString()),
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
            ),
          ),
        ],
      ),
    );
  }
}
