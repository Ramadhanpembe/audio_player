class CallInfo {
  CallInfo(
      {required this.phone,
      this.caller,
      this.duration,
      this.datetime,
      this.isExpanded = false});

  String phone;
  String? caller;
  String? duration;
  String? datetime;
  bool isExpanded;
}
