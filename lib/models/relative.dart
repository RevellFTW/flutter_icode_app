class Relative {
  int id;
  String name;
  String userName;
  String password;
  String email;
  String phoneNumber;
  bool wantsToBeNotified;
  List<int> assignedPatientIDs = [];

  Relative({
    required this.id,
    required this.name,
    required this.userName,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.wantsToBeNotified,
    required this.assignedPatientIDs,
  });
}
