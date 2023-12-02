class Relative {
  int id = 0;
  String name = '';
  String userName = '';
  String password = '';
  String email = '';
  String phoneNumber = '';
  bool wantsToBeNotified = true;

  Relative({
    required this.id,
    required this.name,
    required this.userName,
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
    email = '';
    phoneNumber = '';
    wantsToBeNotified = true;
  }

  Relative.empty();
}
