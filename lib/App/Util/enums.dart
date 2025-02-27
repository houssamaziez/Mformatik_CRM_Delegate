enum TaskStatus {
  NEW,
  STARTED,
  OWNER_RESPOND,
  RESPONSIBLE_RESPOND,
  RESPONSIBLE_CLOSED,
  CLOSED,
  CANCELED,
}

extension TaskStatusExtension on TaskStatus {
  String get description {
    switch (this) {
      case TaskStatus.NEW:
        return "created a task";
      case TaskStatus.STARTED:
        return "started a task";
      case TaskStatus.OWNER_RESPOND:
        return "has responded to a task";
      case TaskStatus.RESPONSIBLE_RESPOND:
        return "has responded to a task";
      case TaskStatus.RESPONSIBLE_CLOSED:
        return "has closed a task";
      case TaskStatus.CLOSED:
        return "closed a task";
      case TaskStatus.CANCELED:
        return "cancelled a task";
    }
  }
}
