
import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'video_list.dart';


class DemoApp extends StatefulWidget {
  late String name;

  DemoApp(String name) {
    this.name = name;
  }

  @override
  _DemoAppState createState() => _DemoAppState(name);
}

class _DemoAppState extends State<DemoApp> {
  late String name;
  var controllers = [];
  static String key = "AIzaSyD-RUc3eNgGxCPB3NOJDtQk68SdDuYJT4M";
  YoutubeAPI youtube = YoutubeAPI(key);
  List<YouTubeVideo> videoResult = [];

  _DemoAppState(String name) {
    this.name = name;
  }
  Future<void> callAPI() async {
    String query = name;
    videoResult = await youtube.search(
        query,
        order: 'relevance',
        videoDuration: 'any',
        type: 'video'
    );
    //videoResult = await youtube.nextPage();

    videoResult.forEach((element) {
      String id = element.id ?? "";
      controllers.add(YoutubePlayerController(initialVideoId: id));
    });

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    callAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Search Results for: " + name),
      ),
      body: Container(
        color: Color.fromRGBO(0, 0, 0, 42),
        child: ListView(
          children: videoResult.map<Widget>(listItem).toList(),
        ),
      )
    );
  }

  Widget listItem(YouTubeVideo video) {
    return Card(
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 42),
          child: InkWell(
              onTap: () async {
                videoResult = await youtube.search(
                    video.title,
                    order: 'relevance',
                    videoDuration: 'any',
                    type: 'video'
                );
                Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) => VideoList(video, video.id),
                ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Image.network(
                          video.thumbnail.medium.url ?? '',
                          height: 220,
                          fit: BoxFit.fill
                      ),
                      Text(video.duration??'', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(12, 10, 10, 10),
                    child: Text(
                      video.title,
                      softWrap: true,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(12, 0, 10, 10),
                    child: Text(
                      video.channelTitle,
                      softWrap: true,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
          ),
        )
    );
  }
}

