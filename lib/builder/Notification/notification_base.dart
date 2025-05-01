// Modelo base de notificación
abstract class Notification {
  String get type;
  Map<String, dynamic> toJson();
}