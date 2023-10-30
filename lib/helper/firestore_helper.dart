import 'package:cloud_firestore/cloud_firestore.dart';
import '../global/variables.dart';
import '../main.dart';
import '../models/care_task.dart';
import '../models/caretaker.dart';
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

void addCaretakerToDb(Caretaker caretaker) {
  Map<String, dynamic> caretakerData = {
    'id': caretaker.id,
    'name': caretaker.name,
    'startDate': caretaker.startDate,
    'patients': '',
  };
  addDocumentToCollection('caretakers', caretakerData);
}

void removePatientFromDb(int id) async {
  String docID = await getDocumentID(id);
  await db.collection('patients').doc(docID).delete();
}

void removeCaretakerFromDb(int id) async {
  String docID = await getDocumentID(id);
  await db.collection('caretakers').doc(docID).delete();
}

Future<String> getDocumentID(int id) async {
  var snapshot =
      await db.collection('patients').where('id', isEqualTo: id).get();

  String docID = snapshot.docs[0].id;
  return docID;
}

Future<List<Patient>> loadPatientsFromFirestore() async {
  List<Patient> patients = [];
  QuerySnapshot querySnapshot = await db.collection('patients').get();

  for (var doc in querySnapshot.docs) {
    var careTasksCollection = doc['careTasks'];
    List<CareTask> careTasks = [];
    for (var map in careTasksCollection) {
      String date = DateTime.now().toString();
      Frequency frequency = Frequency.weekly;
      String taskName = 'default';
      map.forEach((key, value) {
        switch (key) {
          case 'date':
            {
              date = date;
            }
            break;
          case 'frequency':
            {
              frequency = Frequency.values.byName(value);
            }
          case 'task':
            {
              taskName = value;
            }
        }
      });
      careTasks.add(
          CareTask(taskName: taskName, taskFrequency: frequency, date: date));
    }

    patients.add(Patient(
        id: doc['id'],
        name: doc['name'],
        startDate: doc['startDate'].toDate(),
        careTasks: careTasks));
  }

  return patients;
}
