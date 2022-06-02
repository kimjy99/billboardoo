import 'package:billboardoo/components/horizontal_divider.dart';
import 'package:billboardoo/components/music_card.dart';
import 'package:billboardoo/data/constant.dart';
import 'package:billboardoo/data/music.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late TextEditingController _textEditingController;

  List<Music> musics = [];
  List<int> ids = [];
  int selected = 0;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _loadMusics();
  }

  _loadMusics() async {
    final response = await http.get(jsonUrl + (selected == 0 ? "" : "&_sort=incRank"));
    var statusCode = response.statusCode;
    var responseBody = utf8.decode(response.bodyBytes);
    print("statusCode: $statusCode");

    List<dynamic> list = jsonDecode(responseBody);

    setState(() {
      musics = [];
      for (dynamic music in list) {
        musics.add(Music.fromJsonMap(music));
      }
      _searchMusic(_textEditingController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "billboardoo",
          style: TextStyle(
            fontFamily: "BunyaBlack",
            fontSize: 50,
          ),
        ),
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSelection("누적", 0),
              _buildSelection("실시간", 1),
              Flexible(child: _buildSearchCard()),
            ],
          ),
          const HorizontalDivider(),
          Expanded(
            child: ListView.builder(
              itemCount: ids.length,
              itemBuilder: (BuildContext context, int index) {
                return MusicCard(music: musics[ids[index]], selected: selected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelection(String text, int val) {
    return CupertinoButton(
      onPressed: () {
        if (selected != val) {
          setState(() {
            selected = val;
            _loadMusics();
          });
        }
      },
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: selected == val ? Colors.black : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return SizedBox(
      width: pageWidth - 200,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: _textEditingController,
          cursorColor: Colors.black,
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            constraints: const BoxConstraints(maxHeight: 40),
            hintText: '검색',
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.black, size: 20),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.black, size: 20),
              onPressed: () {
                _textEditingController.text = "";
                _searchMusic("");
              },
            ),
          ),
          textInputAction: TextInputAction.go,
          onSubmitted: _searchMusic,
        ),
      ),
    );
  }

  void _searchMusic(String text) {
    setState(() {
      ids = [];
      if (text.isEmpty) {
        for (int i = 0; i < musics.length; i++) {
          ids.add(i);
        }
      } else {
        for (int i = 0; i < musics.length; i++) {
          Music m = musics[i];
          if (m.title.contains(text) || m.singer.contains(text) || m.producer.contains(text)) {
            ids.add(i);
          }
        }
      }
    });
  }
}
