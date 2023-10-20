import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';

Future<void> addDocumentToCollection(
    String collectionName, Map<String, dynamic> data) async {
  // Add a new document to the collection
  await db.collection(collectionName).add(data);
}

void addDocumentToCareTasks(
    Map<String, Map<String, String>> data, String documentID) {
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('patients').doc(documentID);

  // Add the new collection to the document data
  documentReference.update({'careTasks': data});
}

Future<String> getDocumentID(int id) async {
  var snapshot =
      await db.collection('patients').where('id', isEqualTo: id).get();

  String docID = snapshot.docs[0].id;
  return docID;
}
