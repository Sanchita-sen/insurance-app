enum Role { admin, agent, employee }

extension RoleParsing on String {
  Role toRole() {
    switch (toLowerCase().trim()) {
      case 'admin':
        return Role.admin;
      case 'agent':
        return Role.agent;
      case 'employee':
        return Role.employee;
      default:
        return Role.employee; // safe default
    }
  }
}

extension RoleName on Role {
  String get label {
    switch (this) {
      case Role.admin:
        return 'Admin';
      case Role.agent:
        return 'Agent';
      case Role.employee:
        return 'Employee';
    }
  }
}
