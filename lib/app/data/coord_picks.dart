/// Temporary coordinate picks data
/// Format: [lng, lat] name (number)

class CoordPick {
  final double lng;
  final double lat;
  final String name;
  final String number;

  const CoordPick({
    required this.lng,
    required this.lat,
    required this.name,
    required this.number,
  });
}

const List<CoordPick> coordPicks = [
  CoordPick(lng: 126.97101234049347, lat: 37.295186575433455, name: '대운동장', number: '6'),
  CoordPick(lng: 126.97087412489668, lat: 37.29366422243775, name: '축구장', number: '7'),
  CoordPick(lng: 126.97071945506633, lat: 37.29299793787427, name: '테니스장', number: '08'),
  CoordPick(lng: 126.97111929304594, lat: 37.291487321940146, name: '야구장', number: '09'),
  CoordPick(lng: 126.97109325338465, lat: 37.2957779566842, name: '농구장', number: '10'),
  CoordPick(lng: 126.97359943991086, lat: 37.29413402719724, name: '학생회관', number: '03'),
  CoordPick(lng: 126.97258074690939, lat: 37.29400988207236, name: '복지회관', number: '04'),
  CoordPick(lng: 126.97215607723757, lat: 37.29326483971394, name: '수성관', number: '05'),
  CoordPick(lng: 126.97857538078449, lat: 37.29397971403797, name: '유틸리티센터', number: '11'),
  CoordPick(lng: 126.97492875799281, lat: 37.2939874289944, name: '삼성학술정보관', number: '48'),
  CoordPick(lng: 126.97188526138422, lat: 37.2945816221786, name: '운용재', number: '49'),
  CoordPick(lng: 126.97239391709854, lat: 37.29241860457214, name: '대강당', number: '70'),
  CoordPick(lng: 126.97076266090954, lat: 37.29257945891793, name: '체육관', number: '72'),
  CoordPick(lng: 126.97179368585734, lat: 37.29442399594442, name: '학군단', number: '89'),
];
