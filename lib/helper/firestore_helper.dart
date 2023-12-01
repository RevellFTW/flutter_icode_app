import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/models/relative.dart';
import '../global/variables.dart';
import '../models/care_task.dart';
import '../models/caretaker.dart';
import '../models/event_log.dart';
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
    'dateOfBirth': patient.dateOfBirth,
    'medicalState': patient.medicalState,
    'dailyHours': patient.dailyHours,
    'takenMedicines': patient.takenMedicines,
    'allergies': patient.allergies,
    'assignedCaretakers': '',
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

void updateRelative(Relative relative, String documentID) {
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('relatives').doc(documentID);
  Map<String, dynamic> relativeData = {
    'id': relative.id,
    'name': relative.name,
    'userName': relative.userName,
    'password': relative.password,
    'email': relative.email,
    'phoneNumber': relative.phoneNumber,
    'assignedPatientIDs': relative.assignedPatientIDs,
  };
  documentReference.set(relativeData, SetOptions(merge: true));
}

void updateEventLog(EventLog eventLog, String documentID) {
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('patientTasks').doc(documentID);
  Map<String, dynamic> eventLogData = {
    'id': eventLog.id,
    'patientId': eventLog.patientId,
    'name': eventLog.name,
    'description': eventLog.description,
    'date': eventLog.date,
    'caretakerId': eventLog.caretakerId,
  };
  documentReference.set(eventLogData, SetOptions(merge: true));
}

void modifyRelativeInDb(Relative relative) async {
  String docID = await getDocumentID(relative.id, 'relatives');
  updateRelative(relative, docID);
}

void modifyPatientInDb(Patient patient) async {
  String docID = await getDocumentID(patient.id, 'patients');
  updatePatient(patient, docID);
}

void modifyCaretakerInDb(Caretaker caretaker) async {
  String docID = await getDocumentID(caretaker.id, 'caretakers');
  updateCaretaker(caretaker, docID);
}

void addEventLogInDb(EventLog eventLog) async {
  Map<String, dynamic> eventLogData = {
    'id': eventLog.id,
    'patientId': eventLog.patientId,
    'name': eventLog.name,
    'description': eventLog.description,
    'date': eventLog.date,
    'caretakerId': eventLog.caretakerId,
  };
  addDocumentToCollection('patientTasks', eventLogData);
}

void addRelativeToDb(Relative relative) {
  Map<String, dynamic> relativeData = {
    'id': relative.id,
    'name': relative.name,
    'userName': relative.userName,
    'password': relative.password,
    'email': relative.email,
    'phoneNumber': relative.phoneNumber,
    'assignedPatientIDs': relative.assignedPatientIDs,
  };
  addDocumentToCollection('relatives', relativeData);
}

void addPatientToDb(Patient patient) {
  Map<String, dynamic> patientData = {
    'id': patient.id,
    'name': patient.name,
    'startDate': patient.startDate,
    'careTasks':
        patient.careTasks.map((careTask) => careTask.toJson()).toList(),
    'dateOfBirth': patient.dateOfBirth,
    'medicalState': patient.medicalState,
    'dailyHours': patient.dailyHours,
    'takenMedicines': patient.takenMedicines,
    'allergies': patient.allergies,
    'assignedCaretakers': '',
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

  if (snapshot.docs.isEmpty) {
    return '';
  } else {
    return snapshot.docs[0].id;
  }
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

Future<List<String>> getPatientNamesFromCaretakerId(String id) async {
  String docID = await getDocumentID(int.parse(id), 'caretakers');
  var snapshot = await db.collection('caretakers').doc(docID).get();
  List<String> patientNames = [];
  if (snapshot.exists) {
    for (var patient in snapshot.data()!['patients']) {
      patientNames.add(patient['name']);
    }
  }
  return patientNames;
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

void deleteEventLogFromFireStore(EventLog eventLog) async {
  var eventLogId = await getDocumentID(eventLog.id, 'patientTasks');
  db.collection('patientTasks').doc(eventLogId).delete();
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
        dateOfBirth: doc['dateOfBirth'].toDate(),
        medicalState: doc['medicalState'],
        dailyHours: doc['dailyHours'],
        takenMedicines: doc['takenMedicines'],
        allergies: doc['allergies'],
        assignedCaretakers: [],
        careTasks: careTasks));
  }

  return patients;
}
