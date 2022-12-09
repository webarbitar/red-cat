class DashboardModel {
  int dependentUsers;
  int attendenceReports;
  int leaves;

  DashboardModel.fromJson(Map<String, dynamic> json)
      : dependentUsers = json["dependent_users"],
        attendenceReports = json["attendence_reports"],
        leaves = json["leaves"];
}
