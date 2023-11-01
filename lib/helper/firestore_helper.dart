import 'package:cloud_firestore/cloud_firestore.dart';
import '../global/variables.dart';
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

void updateCaretaker(Caretaker caretaker, String documentID) {
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('caretakers').doc(documentID);
  Map<String, dynamic> caretakerData = {
    'id': caretaker.id,
    'name': caretaker.name,
    'startDate': caretaker.startDate,
    'patients': '',
  };
  documentReference.set(caretakerData, SetOptions(merge: true));
}

void modifyPatientInDb(Patient patient) async {
  String docID = await getDocumentID(patient.id, 'patients');
  updatePatient(patient, docID);
}

void modifyCaretakerInDb(Caretaker caretaker) async {
  String docID = await getDocumentID(caretaker.id, 'caretakers');
  updateCaretaker(caretaker, docID);
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
  String docID = await getDocumentID(id, 'patients');
  await db.collection('patients').doc(docID).delete();
}

void removeCaretakerFromDb(int id) async {
  String docID = await getDocumentID(id, 'caretakers');
  await db.collection('caretakers').doc(docID).delete();
}

Future<String> getDocumentID(int id, String collection) async {
  var snapshot =
      await db.collection(collection).where('id', isEqualTo: id).get();

  String docID = snapshot.docs[0].id;
  return docID;
}

Future<List<String>> getCareTaskNamesFromPatientId(String id) async {
  String docID = await getDocumentID(int.parse(id), 'patients');
  var snapshot = await db.collection('patients').doc(docID).get();
  List<String> careTaskNames = [];
  if (snapshot.exists) {
    for (var careTask in snapshot.data()!['careTasks']) {
      careTaskNames.add(careTask['task']);
    }
  }
  return careTaskNames;
}

Future<List<Caretaker>> loadCaretakersFromFirestore() async {
  List<Caretaker> caretakers = [];
  QuerySnapshot querySnapshot = await db.collection('caretakers').get();

  for (var doc in querySnapshot.docs) {
    caretakers.add(Caretaker(
      id: doc['id'],
      name: doc['name'],
      startDate: doc['startDate'].toDate(),
    ));
  }

  return caretakers;
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
              date = value;
            }
            break;
          case 'frequency':
            {
              frequency = Frequency.values.byName(value);
            }
            break;
          case 'task':
            {
              taskName = value;
            }
            break;
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
