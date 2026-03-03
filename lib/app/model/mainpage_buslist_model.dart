class MainPageBusListResponse {
  final MetaData metaData;
  final List<BusList> busList;

  MainPageBusListResponse({required this.metaData, required this.busList});

  factory MainPageBusListResponse.fromJson(Map<String, dynamic> json) {
    var listBusList = json['data'] as List;

    List<BusList> busListList =
        listBusList.map((i) => BusList.fromJson(i)).toList();

    return MainPageBusListResponse(
      metaData: MetaData.fromJson(json['meta']),
      busList: busListList,
    );
  }
}

class MetaData {
  final int busListCount;

  MetaData({required this.busListCount});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      busListCount: json['busListCount'],
    );
  }
}

class BusList {
  @override
  String toString() {
    return 'BusList{title: $title, subtitle: $subtitle, busTypeText: $busTypeText, busTypeBgColor: $busTypeBgColor, pageLink: $pageLink, pageWebviewLink: $pageWebviewLink, altPageLink: $altPageLink, noticeText: $noticeText, useAltPageLink: $useAltPageLink, showAnimation: $showAnimation, showNoticeText: $showNoticeText}';
  }

  final String title;
  final String subtitle;
  final String busTypeText;
  final String busTypeBgColor;
  final String pageLink;
  final String? pageWebviewLink;
  final String? altPageLink;

  final String? noticeText;
  final bool useAltPageLink;
  final bool showAnimation;

  final bool showNoticeText;

  BusList({
    required this.title,
    required this.subtitle,
    required this.busTypeText,
    required this.busTypeBgColor,
    required this.pageLink,
    this.pageWebviewLink,
    this.altPageLink,
    this.noticeText,
    required this.useAltPageLink,
    required this.showAnimation,
    required this.showNoticeText,
  });

  factory BusList.fromJson(Map<String, dynamic> json) {
    return BusList(
      title: json['title'],
      subtitle: json['subtitle'],
      busTypeText: json['busTypeText'],
      busTypeBgColor: json['busTypeBgColor'],
      pageLink: json['pageLink'],
      pageWebviewLink: json['pageWebviewLink'],
      altPageLink: json['altPageLink'],
      noticeText: json['noticeText'],
      useAltPageLink: json['useAltPageLink'],
      showAnimation: json['showAnimation'],
      showNoticeText: json['showNoticeText'],
    );
  }
}
