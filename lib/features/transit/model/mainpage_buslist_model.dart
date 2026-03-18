class BusListItem {
  final String groupId;
  final BusListCard card;
  final BusListAction action;

  const BusListItem({
    required this.groupId,
    required this.card,
    required this.action,
  });

  factory BusListItem.fromJson(Map<String, dynamic> json) {
    return BusListItem(
      groupId: json['groupId'] as String,
      card: BusListCard.fromJson(json['card'] as Map<String, dynamic>),
      action: BusListAction.fromJson(json['action'] as Map<String, dynamic>),
    );
  }
}

class BusListCard {
  final String label;
  final String themeColor;
  final String iconType;
  final String busTypeText;
  final String? subtitle;

  const BusListCard({
    required this.label,
    required this.themeColor,
    required this.iconType,
    required this.busTypeText,
    this.subtitle,
  });

  factory BusListCard.fromJson(Map<String, dynamic> json) {
    return BusListCard(
      label: json['label'] as String,
      themeColor: json['themeColor'] as String,
      iconType: json['iconType'] as String,
      busTypeText: json['busTypeText'] as String,
      subtitle: json['subtitle'] as String?,
    );
  }
}

class BusListAction {
  final String route;
  final String groupId;

  const BusListAction({
    required this.route,
    required this.groupId,
  });

  factory BusListAction.fromJson(Map<String, dynamic> json) {
    return BusListAction(
      route: json['route'] as String,
      groupId: json['groupId'] as String,
    );
  }
}
