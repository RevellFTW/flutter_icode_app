import 'package:cloud_firestore/cloud_firestore.dart';
import '../global/variables.dart';
import '../main.dart';
import '../models/care_task.dart';
import '../models/patient.dart';

Future<void> addDocumentToCollection(
    String collectionName, Map<String, dynamic> data) async {
  // Add a new document to the collection
  await db.collection(collectionName).add(data);
}

void updatePatient(Patient patient, String documentID) {
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('patients').doc(documentID);
  Map<String, dynamic> patientData = {
    'id': patient.id,
    'name': patient.name,
    'startDate': patient.startDate,
    'careTasks':
        patient.careTasks.map((careTask) => careTask.toJson()).toList(),
  };
  documentReference.set(patientData, SetOptions(merge: true));
}

void addPatientToDb(Patient patient) {
  Map<String, dynamic> patientData = {
    'id': patient.id,
    'name': patient.name,
    'startDate': patient.startDate,
    'careTasks':
        patient.careTasks.map((careTask) => careTask.toJson()).toList(),
  };
  addDocumentToCollection('patients', patientData);
}

Future<String> getDocumentID(int id) async {
  var snapshot =
      await db.collection('patients').where('id', isEqualTo: id).get();

  String docID = snapshot.docs[0].id;
  return docID;
}
