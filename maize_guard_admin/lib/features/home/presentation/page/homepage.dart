import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize_guard_admin/features/auth/presentation/pages/sign_up_page.dart';
import 'package:maize_guard_admin/features/home/presentation/bloc/home_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/entity.dart';

class ManageExpertsPage extends StatefulWidget {
  @override
  _ManageExpertsPageState createState() => _ManageExpertsPageState();
}

class _ManageExpertsPageState extends State<ManageExpertsPage> {
  List<Expert> experts = [];

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  int? editingIndex;

  void _showExpertDialog({Expert? expert, int? index}) {
    if (expert != null) {
      emailController.text = expert.email;
      passwordController.text = expert.password;
      firstNameController.text = expert.firstName;
      lastNameController.text = expert.lastName;
      phoneController.text = expert.phone;

      editingIndex = index;
    } else {
      emailController.clear();
      firstNameController.clear();
      lastNameController.clear();
      phoneController.clear();
      passwordController.clear();
      editingIndex = null;
    }
    bool obscureText = true;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.white,
            title: Text(
              editingIndex == null ? 'Add Expert' : 'Edit Expert',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 33, 75, 148),
              ),
              textAlign: TextAlign.center,
            ),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Enter first name'
                          : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter last name' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty)
                          return 'Email is required';
                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
                        return emailRegex.hasMatch(val)
                            ? null
                            : 'Enter valid email';
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: "09XXXXXXXX",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Phone number is required';
                          }
                          final phoneRegex = RegExp(r'^(09\d{8})$');
                          return phoneRegex.hasMatch(val)
                              ? null
                              : 'Enter valid phone number';
                        }),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }

                        if (value.contains(' ')) {
                          return 'Password cannot contain spaces';
                        }

                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }

                        final pattern =
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~])[A-Za-z\d!@#\$&*~]{8,}$';

                        if (!RegExp(pattern).hasMatch(value)) {
                          return 'Password must include uppercase,lowercase,\nnumber,and special character';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 75, 148),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newExpert = Expert(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      phone: phoneController.text,
                      role: 'expert',
                    );
                    if (editingIndex == null) {
                      context.read<HomeBloc>().add(
                            AddExpertEvent(expert: newExpert),
                          );
                    } else {
                      final updatedExpert = experts[editingIndex!].copyWith(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        phone: phoneController.text,
                      );
                      context.read<HomeBloc>().add(
                            UpdateExpertEvent(expert: updatedExpert),
                          );
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(
                  editingIndex == null ? 'Add' : 'Update',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteExpert(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Delete Expert',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 33, 75, 148),
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Are you sure you want to delete this expert?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 33, 75, 148),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              context.read<HomeBloc>().add(
                    DeleteExpertEvent(id: experts[index].id),
                  );
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetExpertsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'Logout') {
                context.read<AuthBloc>().add(AuthLogoutEvent());
              } else if (value == 'Signup') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupPage()));
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Logout',
                child: Text('Logout'),
              ),
              PopupMenuItem(
                value: 'Signup',
                child: Text('Signup'),
              ),
            ],
          ),
        ],
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 75, 148),
        title: Text('Manage Experts',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetExpertsSuccessState) {
            experts = state.experts;
          }
          if (state is AddExpertSuccessState ||
              state is UpdateExpertSuccessState ||
              state is DeleteExpertSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Operation successful"),
                backgroundColor: Colors.green,
              ),
            );
            context.read<HomeBloc>().add(GetExpertsEvent());
          }
          if (state is HomeFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          print("state: $state");
          if (state is HomeInitial) {
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: EdgeInsets.all(10),
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(GetExpertsEvent());
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    experts.isEmpty
                        ? Center(child: Text('No experts added yet.'))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: experts.length,
                            itemBuilder: (_, index) {
                              final expert = experts[index];
                              return Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  title: Text(
                                    expert.firstName + ' ' + expert.lastName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${"Expert"} | ${expert.email}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () => _showExpertDialog(
                                            expert: expert, index: index),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _deleteExpert(index),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 33, 75, 148),
        tooltip: 'Add Expert',
        onPressed: () => _showExpertDialog(),
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
