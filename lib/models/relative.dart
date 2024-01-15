class Relative {
  int id = 0;
  String name = '';
  String password = '';
  String email = '';
  String phoneNumber = '';
  String patientId = '';
  bool wantsToBeNotified = true;

  Relative({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.wantsToBeNotified,
    required this.patientId,
  });
  //initialize without values
  Relative.justID(int idParam) {
    id = idParam;
    name = '';
    password = '';
    email = '';
    phoneNumber = '';
    patientId = '';
    wantsToBeNotified = true;
  }

  Relative.empty();
}
