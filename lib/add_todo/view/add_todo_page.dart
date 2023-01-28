import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/helper/database_helper.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  //formkey
  final formKey = GlobalKey<FormState>();
  TodoModel model = TodoModel(title: '', description: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Todo')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Title'),
                  hintText: 'Enter your title',
                  border: OutlineInputBorder(),
                ),
                onSaved: (newValue) => model.title = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Description'),
                  hintText: 'Enter your description',
                  border: OutlineInputBorder(),
                ),
                onSaved: (newValue) => model.description = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    model.image = image.path;
                    setState(() {});
                  }
                },
                child: Text(model.image != null ? 'Image added' : 'Add image'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    await DatabaseHelper().createTodoDocument(
                      title: model.title!,
                      description: model.description!,
                      image: model.image!,
                    );
                    //snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Todo added successfully'),
                      ),
                    );
                  }
                },
                child: const Text('Add TODO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoModel {
  TodoModel({
    this.title,
    this.description,
    this.image,
    this.isCompleted = false,
  });
  String? title;
  String? description;
  final bool isCompleted;
  String? image;
  final DateTime createdOn = DateTime.now();
}
