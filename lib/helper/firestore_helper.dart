import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/models/relative.dart';
import 'package:todoapp/screens/home_page.dart';
import '../global/variables.dart';
import '../models/care_task.dart';
import '../models/caretaker.dart';
import '../models/event_log.dart';
import '../models/patient.dart';

//#region general
Future<void> addDocumentToCollection(
    String collectionName, Map<String, dynamic> data) async {
  // Add a new document to the collection
  await db.collection(collectionName).add(data);
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

Future<UserCredential> register(String email, String password) async {
  FirebaseApp app = await Firebase.initializeApp(
      name: 'Secondary', options: Firebase.app().options);
  UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
      .createUserWithEmailAndPassword(email: email, password: password);

  await app.delete();
  return Future.sync(() => userCredential);
}
//#endregion

//#region patients
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
    'assignedCaretakers':
        patient.assignedCaretakers!.map((caretaker) => caretaker.id).toList(),
    'relativeIDs': patient.relatives.map((relative) => relative.id).toList(),
  };
  documentReference.set(patientData, SetOptions(merge: true));
}

void addPatientToDb(Patient patient) {
  Map<String, dynamic> patientData = {
    'id': patient.id,
    'name': patient.name,
    'email': patient.email,
    'startDate': patient.startDate,
    'careTasks':
        patient.careTasks.map((careTask) => careTask.toJson()).toList(),
    'dateOfBirth': patient.dateOfBirth,
    'medicalState': patient.medicalState,
    'dailyHours': patient.dailyHours,
    'takenMedicines': patient.takenMedicines,
    'allergies': patient.allergies,
    'assignedCaretakers':
        patient.assignedCaretakers!.map((caretaker) => caretaker.id).toList(),
    'relativeIDs': patient.relatives.map((relative) => relative.id).toList(),
  };
  addDocumentToCollection('patients', patientData);
}

void modifyPatientInDb(Patient patient) async {
  String docID = await getDocumentID(patient.id, 'patients');
  updatePatient(patient, docID);
}

void removePatientFromDb(int id) async {
  String docID = await getDocumentID(id, 'patients');
  await db.collection('patients').doc(docID).delete();
  var tasks =
      db.collection('patientTasks').where('patientId', isEqualTo: id).get();
  tasks.then((value) => value.docs.forEach((element) {
        element.reference.delete();
      }));
  await db
      .collection('users')
      .where('roleId', isEqualTo: id)
      .get()
      .then((value) => value.docs.forEach((element) {
            element.reference.delete();
          }));
}

Future<List<Patient>> loadPatientsFromFirestore() async {
  List<Patient> patients = [];
  QuerySnapshot querySnapshot = await db.collection('patients').get();

  for (var doc in querySnapshot.docs) {
    var careTasksCollection = doc['careTasks'];
    List<CareTask> careTasks = [];
    List<Relative> relatives = [];
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

    if (doc['relativeIDs'] != null) {
      for (var value in doc['relativeIDs']) {
        var relative = await getRelativeFromDb(value.toString());
        relatives.add(relative);
      }
    }

    List<Caretaker> caretakers = doc['assignedCaretakers'] != null
        ? await loadCaretakersFromFirestore()
        : [];
    List<Caretaker> assignedCaretakers = caretakers
        .where((element) => doc['assignedCaretakers'].contains(element.id))
        .toList();

    patients.add(Patient(
        id: doc['id'],
        name: doc['name'],
        email: doc['email'],
        startDate: doc['startDate'].toDate(),
        dateOfBirth: doc['dateOfBirth'].toDate(),
        medicalState: doc['medicalState'],
        dailyHours: doc['dailyHours'],
        takenMedicines: doc['takenMedicines'],
        allergies: doc['allergies'],
        assignedCaretakers: assignedCaretakers,
        careTasks: careTasks,
        relatives: relatives));
  }

  return patients;
}

Future<Patient> getPatientBydocID(String docID) async {
  var doc = await db.collection('patients').doc(docID).get();

  var careTasksCollection = doc['careTasks'];
  List<CareTask> careTasks = [];
  List<Relative> relatives = [];
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

  if (doc['relativeIDs'] != null) {
    for (var value in doc['relativeIDs']) {
      var relative = await getRelativeFromDb(value.toString());
      relatives.add(relative);
    }
  }

  List<Caretaker> caretakers = doc['assignedCaretakers'] != null
      ? await loadCaretakersFromFirestore()
      : [];
  List<Caretaker> assignedCaretakers = caretakers
      .where((element) => doc['assignedCaretakers'].contains(element.id))
      .toList();

  Patient patient = Patient(
    id: doc['id'],
    name: doc['name'],
    email: doc['email'],
    startDate: doc['startDate'].toDate(),
    dateOfBirth: doc['dateOfBirth'].toDate(),
    medicalState: doc['medicalState'],
    dailyHours: doc['dailyHours'],
    takenMedicines: doc['takenMedicines'],
    allergies: doc['allergies'],
    assignedCaretakers: assignedCaretakers,
    careTasks: careTasks,
    relatives: relatives,
  );
  return patient;
}

void addPatientUserInDb(Patient patient, String uid) {
  Map<String, dynamic> userData = {
    'approved': false,
    'email': patient.email,
    'id': uid,
    'role': 'patient',
    'roleId': patient.id,
  };

  db.collection('users').doc(uid).set(userData);
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

Future<Patient> getPatientFromDb(int id) async {
  String docID = await getDocumentID(id, 'patients');
  return getPatientBydocID(docID);
}

//#endregion

//#region caretakers
void updateCaretaker(Caretaker caretaker, String documentID) {
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('caretakers').doc(documentID);
  Map<String, dynamic> caretakerData = {
    'id': caretaker.id,
    'name': caretaker.name,
    'dateOfBirth': caretaker.dateOfBirth,
    'email': caretaker.email,
    'workTypes': caretaker.workTypes,
    'availability': caretaker.availability,
    'startDate': caretaker.startDate,
    'patients': '',
  };
  documentReference.set(caretakerData, SetOptions(merge: true));
}

void modifyCaretakerInDb(Caretaker caretaker) async {
  String docID = await getDocumentID(caretaker.id, 'caretakers');
  updateCaretaker(caretaker, docID);
}

void removeCaretakerFromDb(int id) async {
  String docID = await getDocumentID(id, 'caretakers');
  await db.collection('caretakers').doc(docID).delete();
}

void addCaretakerUserInDb(Caretaker caretaker, String uid) {
  Map<String, dynamic> userData = {
    'approved': 'false',
    'email': caretaker.email,
    'id': uid,
    'role': 'caretaker',
    'roleId': caretaker.id,
  };
  addDocumentToCollection('users', userData);
}

void addCaretakerToDb(Caretaker caretaker) {
  Map<String, dynamic> caretakerData = {
    'id': caretaker.id,
    'name': caretaker.name,
    'startDate': caretaker.startDate,
    'dateOfBirth': caretaker.dateOfBirth,
    'email': caretaker.email,
    'workTypes': caretaker.workTypes,
    'availability': caretaker.availability,
    'patients': '',
  };
  addDocumentToCollection('caretakers', caretakerData);
}

Future<Caretaker> getCaretakerFromDb(int id) async {
  String docID = await getDocumentID(id, 'caretakers');
  var snapshot = await db.collection('caretakers').doc(docID).get();
  Caretaker caretaker = Caretaker(
    id: snapshot['id'],
    name: snapshot['name'],
    email: snapshot['email'],
    workTypes: snapshot['workTypes'],
    availability: snapshot['availability'],
    dateOfBirth: snapshot['dateOfBirth'].toDate(),
    startDate: snapshot['startDate'].toDate(),
  );
  return caretaker;
}

Future<List<Caretaker>> loadCaretakersFromFirestore() async {
  List<Caretaker> caretakers = [];
  QuerySnapshot querySnapshot = await db.collection('caretakers').get();

  for (var doc in querySnapshot.docs) {
    caretakers.add(Caretaker(
      id: doc['id'],
      name: doc['name'],
      email: doc['email'],
      workTypes: doc['workTypes'],
      availability: doc['availability'],
      dateOfBirth: doc['dateOfBirth'].toDate(),
      startDate: doc['startDate'].toDate(),
    ));
  }

  return caretakers;
}

//#endregion

//#region relatives
void updateRelative(Relative relative, String documentID) {
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('relatives').doc(documentID);
  Map<String, dynamic> relativeData = {
    'id': relative.id,
    'name': relative.name,
    'password': relative.password,
    'email': relative.email,
    'phoneNumber': relative.phoneNumber,
    'wantsToBeNotified': relative.wantsToBeNotified,
    'token': relative.token,
  };
  documentReference.set(relativeData, SetOptions(merge: true));
}

void modifyRelativeInDb(Relative relative) async {
  String docID = await getDocumentID(relative.id, 'relatives');
  updateRelative(relative, docID);
}

void addRelativeToDb(Relative relative) {
  Map<String, dynamic> relativeData = {
    'id': relative.id,
    'name': relative.name,
    'password': relative.password,
    'email': relative.email,
    'phoneNumber': relative.phoneNumber,
    'wantsToBeNotified': relative.wantsToBeNotified,
    'patientId': relative.patientId,
    'token': relative.token,
  };
  addDocumentToCollection('relatives', relativeData);
}

void removeRelativeFromDb(int id) async {
  String docID = await getDocumentID(id, 'relatives');
  await db.collection('relatives').doc(docID).delete();
}

Future<List<Relative>> loadRelativesFromFirestore() async {
  List<Relative> relatives = [];
  QuerySnapshot querySnapshot = await db.collection('relatives').get();

  for (var doc in querySnapshot.docs) {
    relatives.add(Relative(
      id: doc['id'],
      name: doc['name'],
      password: doc['password'],
      email: doc['email'], // Add the missing identifier here
      phoneNumber: doc['phoneNumber'], // Add the missing parameter here
      patientId: doc['patientId'], // Add the missing parameter here
      wantsToBeNotified: doc['wantsToBeNotified'],
      token: doc['token'], // Add the missing parameter here
    ));
  }

  return relatives;
}

void addRelativeUserInDb(Relative relative, String uid) {
  Map<String, dynamic> userData = {
    'approved': false,
    'email': relative.email,
    'id': uid,
    'role': 'relative',
    'roleId': relative.id,
    'patientId': relative.patientId,
    'token': relative.token,
  };

  db.collection('users').doc(uid).set(userData);
}

Future<int> getRelativesCountFromFirestore() async {
  QuerySnapshot querySnapshot = await db.collection('relatives').get();

  return querySnapshot.docs.length;
}

Future<Relative> getRelativeFromDb(String id) async {
  String docID = await getDocumentID(int.parse(id), 'relatives');
  var snapshot = await db.collection('relatives').doc(docID).get();
  Relative relative = Relative(
    id: snapshot['id'],
    name: snapshot['name'],
    password: snapshot['password'],
    email: snapshot['email'],
    phoneNumber: snapshot['phoneNumber'],
    wantsToBeNotified: snapshot['wantsToBeNotified'],
    patientId: snapshot['patientId'],
    token: snapshot['token'],
  );
  return relative;
}

//#region eventlogs

void updateEventLog(EventLog eventLog, String documentID) {
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('patientTasks').doc(documentID);
  Map<String, dynamic> eventLogData = {
    'id': eventLog.id,
    'patientId': eventLog.patient.id,
    'name': eventLog.name,
    'description': eventLog.description,
    'date': eventLog.date,
    'caretakerId': eventLog.caretaker.id,
  };
  documentReference.set(eventLogData, SetOptions(merge: true));
}

void addEventLogInDb(EventLog eventLog) async {
  Map<String, dynamic> eventLogData = {
    'id': eventLog.id,
    'patientId': eventLog.patient.id,
    'name': eventLog.name,
    'description': eventLog.description,
    'date': eventLog.date,
    'caretakerId': eventLog.caretaker.id,
  };
  addDocumentToCollection('patientTasks', eventLogData);
}

void modifyEventLogInDb(EventLog eventLog) async {
  String docID = await getDocumentID(eventLog.id, 'patientTasks');
  updateEventLog(eventLog, docID);
}

Future<List<EventLog>> loadEventLogsFromFirestore(int id, Caller caller) async {
  List<EventLog> tasks = [];
  QuerySnapshot querySnapshot =
      (caller == Caller.patient || caller == Caller.backOfficePatient)
          ? await db
              .collection('patientTasks')
              .where('patientId', isEqualTo: id)
              .get()
          : await db
              .collection('patientTasks')
              .where('caretakerId', isEqualTo: id)
              .get();

  for (var doc in querySnapshot.docs) {
    tasks.add(EventLog(
        id: doc['id'],
        name: doc['name'],
        description: doc['description'],
        date: doc['date'],
        caretaker: await getCaretakerFromDb(doc['caretakerId']),
        patient: await getPatientFromDb(doc['patientId'])));
  }

  return tasks;
}

void deleteEventLogFromFireStore(EventLog eventLog) async {
  var eventLogId = await getDocumentID(eventLog.id, 'patientTasks');
  db.collection('patientTasks').doc(eventLogId).delete();
}

Future<int> getEventLogCountFromFirestore() {
  return db.collection('patientTasks').get().then((value) => value.docs.length);
}
//#endregion

//#region caretasks
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

//#endregion

