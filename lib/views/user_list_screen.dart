import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../views/login_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = Provider.of<ApiService>(context, listen: false).getUsers();
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = Provider.of<ApiService>(context, listen: false).getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('All Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              apiService.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text('Error loading users'));

          final users = snapshot.data!;

          if (users.isEmpty)
            return Center(child: Text('No users found'));

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(user.username, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('ID: ${user.id}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Edit',
                        onPressed: () async {
                          final newUsername = await _showEditDialog(context, user.username);
                          if (newUsername != null && newUsername.trim().isNotEmpty) {
                            final success = await apiService.updateUser(user.id.toString(), newUsername.trim());
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User updated')));
                              _refreshUsers();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed')));
                            }
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete',
                        onPressed: () async {
                          final confirm = await _confirmDelete(context);
                          if (confirm) {
                            final success = await apiService.deleteUser(user.id.toString());
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User deleted')));
                              _refreshUsers();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed')));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<String?> _showEditDialog(BuildContext context, String currentUsername) async {
    final controller = TextEditingController(text: currentUsername);
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Username'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(border: OutlineInputBorder()),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: Text('Update')),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('No')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('Yes')),
        ],
      ),
    ).then((value) => value ?? false);
  }
}
