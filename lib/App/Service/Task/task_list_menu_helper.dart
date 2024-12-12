class Workflow {
  final Map<String, List<String>> responsibleWorkflow = {
    'New': ['Start'],
    'Owner Respond': ['Responsible close'],
    'Responsible Respond': ['Responsible close'],
    'Start': ['Responsible close'],
  };

  final Map<String, List<String>> ownerWorkflow = {
    'New': ['Canceled'],
    'Start': ['Close', 'Canceled'],
    'Owner Respond': ['Close', 'Canceled'],
    'Responsible Respond': ['Close', 'Canceled'],
    'Responsible close': ['Close'],
    'Canceled': ['Revert cancellation'],
  };

  bool _isTransitionAllowed(
      Map<String, List<String>> workflow, String status, String targetStatus) {
    final allowedTransitions = workflow[status];
    return allowedTransitions != null &&
        allowedTransitions.contains(targetStatus);
  }

  bool canChangeStatusForResponsible(String status, String targetStatus) {
    return _isTransitionAllowed(responsibleWorkflow, status, targetStatus);
  }

  bool canChangeStatusForOwner(String status, String targetStatus) {
    return _isTransitionAllowed(ownerWorkflow, status, targetStatus);
  }

  bool isCanShow(
      String status, bool isOwner, bool isResponsible, String targetStatus) {
    if (!isOwner && !isResponsible) {
      return false;
    }

    if (isOwner == true) {
      return canChangeStatusForOwner(status, targetStatus);
    }
    if (isResponsible == true) {
      return canChangeStatusForResponsible(status, targetStatus);
    }
    return false;
  }
}
