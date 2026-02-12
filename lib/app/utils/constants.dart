class BusConstants {
  static const double busComponentLeftpadding = 70;
  static const double infoComponentLeftpadding = busComponentLeftpadding - 42.5;
}

class ApiConfig {
  static const String baseUrl = 'http://43.200.90.214:3000';
}

class CampusCoordinates {
  // Seoul campus (Insacamp) main location
  static const double seoulCampusLat = 37.587347;
  static const double seoulCampusLon = 126.994140;
  static const String seoulCampusDestnameEncode =
      '%EC%8A%A4%EA%BE%B8%EB%B2%84%EC%8A%A4%20%7C%20%EC%9D%B8%EC%82%AC%EC%BA%A0';

  // Suwon campus (Jagwacamp) main location
  static const double suwonCampusLat = 37.296362;
  static const double suwonCampusLon = 126.970565;
  static const String suwonCampusDestnameEncode =
      '%EC%8A%A4%EA%BE%B8%EB%B2%84%EC%8A%A4%20%7C%20%EC%9E%90%EA%B3%BC%EC%BA%A0';

  // Seoul campus shuttle boarding location
  static const double seoulShuttleLat = 37.587308;
  static const double seoulShuttleLon = 126.993688;
  static const String seoulShuttleDestnameEncode =
      '%EC%8A%A4%EA%BE%B8%EB%B2%84%EC%8A%A4%20%7C%20%EC%9D%B8%EC%82%AC%EC%BA%A0%20%EC%85%94%ED%8B%80%20%EC%9C%84%EC%B9%98';

  // Suwon campus shuttle boarding location
  static const double suwonShuttleLat = 37.292345;
  static const double suwonShuttleLon = 126.975532;
  static const String suwonShuttleDestnameEncode =
      '%EC%8A%A4%EA%BE%B8%EB%B2%84%EC%8A%A4%20%7C%20%EC%9E%90%EA%B3%BC%EC%BA%A0%20%EC%85%94%ED%8B%80%20%EC%9C%84%EC%B9%98';
}
