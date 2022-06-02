class Music {
  final int rank;
  final String rankChange;
  final int incRank;
  final String incRankChange;
  final String title;
  final String singer;
  final String producer;
  final int view1;
  final int view2;
  final int viewInc1;
  final int viewInc2;
  final String url1;
  final String url2;
  final String date;

  Music({
    this.rank = 0,
    this.rankChange = "",
    this.incRank = 0,
    this.incRankChange = "",
    this.title = "",
    this.singer = "",
    this.producer = "",
    this.view1 = 0,
    this.view2 = 0,
    this.viewInc1 = 0,
    this.viewInc2 = 0,
    this.url1 = "",
    this.url2 = "",
    this.date = "2000. 1. 1.",
  });

  Music.fromJsonMap(dynamic music)
      : rank = music['rank'],
        rankChange = music['rankChange'],
        incRank = music['incRank'],
        incRankChange = music['incRankChange'],
        title = music['title'],
        singer = music['singer'],
        producer = music['producer'],
        view1 = music['view'],
        view2 = music['view2'],
        viewInc1 = music['viewInc'],
        viewInc2 = music['view2Inc'],
        url1 = music['url'],
        url2 = music['url2'],
        date = music['date'];

  String smallImage() {
    return "https://img.youtube.com/vi/${url1.split('/')[3]}/default.jpg";
  }

  String largeImage() {
    return "https://img.youtube.com/vi/${url1.split('/')[3]}/mqdefault.jpg";
  }
}
