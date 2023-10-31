class EventLog {
  EventLog(
      {required this.id,
      required this.name,
      required this.description,
      required this.date,
      required this.caretakerId,
      required this.patientId});

  final String id;
  final String name;
  final String description;
  final DateTime date;
  final String caretakerId;
  final String patientId;
}
