import 'package:billboardoo/components/horizontal_divider.dart';
import 'package:billboardoo/data/music.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:billboardoo/data/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicCard extends StatefulWidget {
  const MusicCard({Key? key, required this.music, required this.selected}) : super(key: key);

  final Music music;
  final int selected;

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isOpen = !isOpen;
            });
          },
          splashColor: Colors.transparent,
          child: SizedBox(
            height: cardSize,
            width: pageWidth,
            child: Row(
              children: [
                Container(
                  width: cardSize,
                  color: const Color(0xFF101119),
                  child: Center(
                    child: Text(
                      (widget.selected == 0 ? widget.music.rank : widget.music.incRank).toString(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                ),
                Image.network(widget.music.smallImage(), height: cardSize),
                const SizedBox(width: 20),
                SizedBox(
                  width: 45,
                  child: Center(
                      child: _rankChangeWidget(
                          widget.selected == 0 ? widget.music.rankChange : widget.music.incRankChange)),
                ),
                const SizedBox(width: 35),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.music.title.replaceAll('', '\u{200B}'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        widget.music.singer.replaceAll('', '\u{200B}'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          comma(widget.music.view1 + widget.music.view2),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '+${comma(widget.music.viewInc1 + widget.music.viewInc2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isOpen)
          SizedBox(
            width: pageWidth,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(widget.music.largeImage(), width: 300),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildDateCard()),
                            if (widget.music.producer.isNotEmpty) Expanded(child: _buildProducerCard()),
                          ],
                        ),
                        Row(
                          children: [
                            _buildLinkCard("원본", widget.music.view1, widget.music.viewInc1, widget.music.url1),
                            if (widget.music.view2 > 0)
                              _buildLinkCard("반응", widget.music.view2, widget.music.viewInc2, widget.music.url2),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        const HorizontalDivider(),
      ],
    );
  }

  Widget _rankChangeWidget(String rankChange) {
    if (rankChange.isEmpty) {
      return const Text(
        "NEW",
        style: TextStyle(color: Color(0xff64e188), fontSize: 16),
      );
    } else if (rankChange.startsWith("-")) {
      return Row(children: [
        const Icon(
          Icons.arrow_drop_down,
          color: Color(0xff82bbff),
        ),
        Text(
          rankChange.substring(1),
          style: const TextStyle(color: Color(0xff82bbff), fontSize: 16),
        ),
      ]);
    } else if (rankChange.startsWith("0")) {
      return const Icon(Icons.horizontal_rule, color: Color(0xffcccccc));
    } else {
      return Row(children: [
        const Icon(
          Icons.arrow_drop_up,
          color: Color(0xfff0780a),
        ),
        Text(
          rankChange,
          style: const TextStyle(color: Color(0xfff0780a), fontSize: 16),
        ),
      ]);
    }
  }

  String comma(int s) {
    return NumberFormat('###,###,###').format(s);
  }

  Widget _buildDateCard() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.date_range, size: 25),
          const SizedBox(width: 16),
          Text("발매일:  ${widget.music.date}", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildProducerCard() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.video_camera_front, size: 25),
          const SizedBox(width: 16),
          Text("제작:  ${widget.music.producer}", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildLinkCard(String text, int view, int viewInc, String url) {
    return InkWell(
      onTap: () {
        _launchUrl(url);
      },
      splashColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.music_video, size: 25),
                const SizedBox(width: 20),
                Text(
                  text,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 45),
                Text(
                  comma(view),
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 45),
                Text(
                  "+${comma(viewInc)}",
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }
}
