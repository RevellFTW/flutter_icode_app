class User {
  final int id;
  final String email;
  //if caretaker or patient, the specific caretakerId, or patientId
  final String roleId;
  //whether its patient or caretaker
  final Role role;
  final bool approved;

  User({
    required this.id,
    required this.email,
    required this.roleId,
    required this.role,
    required this.approved,
  });
}

enum Role { patient, caretaker, backoffice, relative }
