// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:get/get.dart';

// String? routeToNavigate;

// @pragma('vm:entry-point')
// Future<void> notificationResponseHandler(NotificationResponse response) async {
//   Get.toNamed('/eskara');
// }

// class FlutterLocalNotification {
//   FlutterLocalNotification._();

//   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static init() async {
//     AndroidInitializationSettings androidInitializationSettings =
//         const AndroidInitializationSettings('mipmap/ic_launcher');

//     DarwinInitializationSettings iosInitializationSettings =
//         const DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     InitializationSettings initializationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iosInitializationSettings,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {
//       Get.toNamed('/eskara');
//     }, onDidReceiveBackgroundNotificationResponse: notificationResponseHandler);
//   }

//   static NotificationDetails notificationDetails() {
//     return const NotificationDetails(
//         android: AndroidNotificationDetails('skkubus', 'skkubus',
//             channelDescription: 'skkubus', importance: Importance.max),
//         iOS: DarwinNotificationDetails());
//   }

//   Future showNotification(
//       {int id = 0, String? title, String? body, String? payLoad}) async {
//     return flutterLocalNotificationsPlugin.show(
//         id, title, body, notificationDetails());
//   }

//   static Future<void> scheduleNotification1() async {
//     final scheduledDate =
//         tz.TZDateTime(tz.getLocation('Asia/Seoul'), 2023, 9, 13, 08, 00, 02);
//     final currentDate = tz.TZDateTime.now(tz.getLocation('Asia/Seoul'));

//     if (scheduledDate.isAfter(currentDate)) {
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         0, // Notification ID
//         'ESKARA 전야제 인자셔틀 정보', // Notification title
//         '스꾸버스에서 변경된 인자셔틀 탑승시간, 위치 정보를 확인할 수 있어요', // Notification body
//         scheduledDate, // Date and time
//         notificationDetails(),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//       );
//     }
//   }

//   static Future<void> scheduleNotification2() async {
//     final scheduledDate =
//         tz.TZDateTime(tz.getLocation('Asia/Seoul'), 2023, 9, 14, 08, 00, 02);
//     final currentDate = tz.TZDateTime.now(tz.getLocation('Asia/Seoul'));

//     if (scheduledDate.isAfter(currentDate)) {
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         1, // Notification ID
//         'ESKARA 인자셔틀 정보', // Notification title
//         '스꾸버스에서 변경된 인자셔틀 탑승시간, 위치 정보를 확인할 수 있어요', // Notification body
//         scheduledDate, // Date and time
//         notificationDetails(),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//       );
//     }
//   }

//   static Future<void> scheduleNotification3() async {
//     final scheduledDate =
//         tz.TZDateTime(tz.getLocation('Asia/Seoul'), 2023, 9, 10, 11, 17, 02);
//     final currentDate = tz.TZDateTime.now(tz.getLocation('Asia/Seoul'));

//     if (scheduledDate.isAfter(currentDate)) {
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         2, // Notification ID
//         'ESKARA 인자셔틀 정보', // Notification title
//         '스꾸버스에서 변경된 인자셔틀 탑승시간, 위치 정보를 확인할 수 있어요', // Notification body
//         scheduledDate, // Date and time
//         notificationDetails(),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//       );
//     }
//   }

//   static Future<void> scheduleNotification4() async {
//     final scheduledDate =
//         tz.TZDateTime(tz.getLocation('Asia/Seoul'), 2023, 9, 10, 11, 18, 02);
//     final currentDate = tz.TZDateTime.now(tz.getLocation('Asia/Seoul'));

//     if (scheduledDate.isAfter(currentDate)) {
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         3, // Notification ID
//         'ESKARA 인자셔틀 정보', // Notification title
//         '스꾸버스에서 변경된 인자셔틀 탑승시간, 위치 정보를 확인할 수 있어요', // Notification body
//         scheduledDate, // Date and time
//         notificationDetails(),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//       );
//     }
//   }
// }
