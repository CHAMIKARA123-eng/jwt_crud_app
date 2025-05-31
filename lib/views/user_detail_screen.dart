import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;

  UserDetailScreen({required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Future<User> _userFuture;
  final _formKey = GlobalKey<FormState>();
  String _username = '';

  @override
  void initState() {
    super.initState();
    _userFuture = Provider.of<ApiService>(context, listen: false)
        .getUser(widget.userId);
  }

  Future<void> _updateUser() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();

    final success = await Provider.of<ApiService>(context, listen: false)
        .updateUser(widget.userId, _username);

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User updated')));
      setState(() {
        _userFuture = Provider.of<ApiService>(context, listen: false)
            .getUser(widget.userId);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update user')));
    }
  }

  Future<void> _deleteUser() async {
    final success = await Provider.of<ApiService>(context, listen: false)
        .deleteUser(widget.userId);

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User deleted')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete user')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Detail')),
      body: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Error loading user.'));
          }

          final user = snapshot.data!;

          return Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User ID: ${user.id}'),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: user.username,
                    decoration: InputDecoration(labelText: 'Username'),
                    onSaved: (value) => _username = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? 'Enter username' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateUser,
                    child: Text('Update User'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _deleteUser,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('Delete User'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
