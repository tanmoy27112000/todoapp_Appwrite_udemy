import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:todoapp/app/app.dart';

class DatabaseHelper {
  Databases databases = Databases(client);
  Storage storage = Storage(client);

  //create todo document
  Future<model.Document> createTodoDocument({
    required String title,
    required String description,
    String? image,
  }) async {
    final model.Document response;
    try {
      if (image != null) {
        final imageId = await createFileInStorage(image);
        response = await databases.createDocument(
          databaseId: '63c70922542b7f61083b',
          collectionId: '63c7093b5d1cb3fb8c76',
          documentId: ID.unique(),
          data: {
            'title': title,
            'description': description,
            'image': imageId,
            'isCompleted': false,
          },
        );
      } else {
        response = await databases.createDocument(
          databaseId: '63c70922542b7f61083b',
          collectionId: '63c7093b5d1cb3fb8c76',
          documentId: ID.unique(),
          data: {
            'title': title,
            'description': description,
            'isCompleted': false,
          },
        );
      }
      return response;
    } on AppwriteException {
      rethrow;
    }
  }

  void deleteImage(String id) {
    storage.deleteFile(
      bucketId: '63cef83f0d7f3ebe0ae5',
      fileId: id,
    );
  }

  //get todo document
  Future<model.DocumentList> getTodoDocument() async {
    try {
      final response = await databases.listDocuments(
        databaseId: '63c70922542b7f61083b',
        collectionId: '63c7093b5d1cb3fb8c76',
      );
      return response;
    } on AppwriteException {
      rethrow;
    }
  }

  void updateIsCompleted({required String documentId, bool? isCompleted}) {
    try {
      databases.updateDocument(
        databaseId: '63c70922542b7f61083b',
        collectionId: '63c7093b5d1cb3fb8c76',
        documentId: documentId,
        data: {
          'isCompleted': isCompleted,
        },
      );
    } on AppwriteException {
      rethrow;
    }
  }

  void deleteTodoDocument({
    required String documentId,
    required String? image,
  }) {
    try {
      databases.deleteDocument(
        databaseId: '63c70922542b7f61083b',
        collectionId: '63c7093b5d1cb3fb8c76',
        documentId: documentId,
      );
      if (image != null) {
        deleteImage(image);
      }
    } on AppwriteException {
      rethrow;
    }
  }

  Future<String> createFileInStorage(String image) async {
    try {
      final response = await storage.createFile(
        bucketId: '63cef83f0d7f3ebe0ae5',
        file: InputFile(path: image),
        fileId: ID.unique(),
      );
      return response.$id;
    } on AppwriteException {
      rethrow;
    }
  }
}
