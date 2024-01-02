class Relative {
  int id = 0;
  String name = '';
  String password = '';
  String email = '';
  String phoneNumber = '';
  bool wantsToBeNotified = true;

  Relative({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.wantsToBeNotified,
  });
  //initialize without values
  Relative.justID(int idParam) {
    id = idParam;
    name = '';
    password = '';
    email = '';
    phoneNumber = '';
    wantsToBeNotified = true;
  }

  Relative.empty();
}
