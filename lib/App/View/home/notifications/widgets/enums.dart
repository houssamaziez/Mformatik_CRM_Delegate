 
enum NotificationStatus {
  unDelivred(
    id: 1,
  ),
  delivered(
    id: 2,
  ),
  seen(id: 3),
  read(id: 4);

  final int id;
  const NotificationStatus({required this.id});
}

enum NotificationTitle {
  newMission(id: 'newMission', title: 'has created new mission'),
  missionStatusChanged(id: 'missionStatusChange', title: 'has changed mission status'),
  newTask(id: 'newTask', title: 'has created new task'),
  taskObserver(id: 'assignAsObserver', title: 'has assigned you as task Observer'),
  taksResponsible(id: 'assignAsResponsible', title: 'has assigned you as task responsible'),
  taskStatusChanged(id: 'taskStatusChange', title: 'has changed task status');

  final String id;
  final String title;
  const NotificationTitle({required this.id, required this.title});
}
 