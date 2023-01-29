import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:todoapp/add_todo/add_todo.dart';
import 'package:todoapp/helper/database_helper.dart';
import 'package:todoapp/login/login.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = false;
  late model.DocumentList todoList;
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: todoList.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('${todoList.documents[index].data['title']}'),
                  leading: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.grey,
                    child: Text(
                      '$index',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  subtitle:
                      Text('${todoList.documents[index].data['description']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (todoList.documents[index].data['image'] != null)
                        FutureBuilder(
                          future: DatabaseHelper().storage.getFilePreview(
                                bucketId: '63cef83f0d7f3ebe0ae5',
                                fileId: todoList.documents[index].data['image']
                                    as String,
                              ),
                          builder: (context, snapshot) {
                            return snapshot.hasData && snapshot.data != null
                                ? Image.memory(
                                    snapshot.data!,
                                  )
                                : const CircularProgressIndicator();
                          },
                        ),
                      Checkbox(
                        value: todoList.documents[index].data['isCompleted']
                            as bool,
                        onChanged: (value) {
                          setState(() {
                            todoList.documents[index].data['isCompleted'] =
                                value;
                          });
                          DatabaseHelper().updateIsCompleted(
                            documentId: todoList.documents[index].$id,
                            isCompleted: value,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          //delete todo document
                          DatabaseHelper().deleteTodoDocument(
                            documentId: todoList.documents[index].$id,
                            image: todoList.documents[index].data['image']
                                as String,
                          );
                          setState(() {
                            todoList.documents.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTodoPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    todoList = await DatabaseHelper().getTodoDocument();
    setState(() {
      isLoading = false;
    });
  }
}
