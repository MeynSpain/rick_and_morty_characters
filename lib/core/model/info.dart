import 'dart:math';

class Info {
  final int currentPage;
  final int totalPage;

  Info({required this.currentPage, required this.totalPage});

  factory Info.fromJson(Map<String, dynamic> json) {
    int page = _getCurrentPage(json);
    return Info(currentPage: page, totalPage: json['pages']);
  }

  static int _getCurrentPage(Map<String, dynamic> json) {
    if (json['next'] == null) {
      return json['pages'];
    }
    final String next = json['next'] as String;

    final uri = Uri.parse(next);
    final pageParam = uri.queryParameters['page'];

    int page = 0;
    if (pageParam != null) {
      page = int.tryParse(pageParam) ?? 0;
      page = max(0, page - 1);
    } else {
      page = json['pages'];
    }

    return page;
  }
}
