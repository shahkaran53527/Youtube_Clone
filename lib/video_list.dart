import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_api/youtube_api.dart';


/// Creates list of video players
class VideoList extends StatefulWidget {
  late String id;
  late YouTubeVideo video;

  VideoList(YouTubeVideo video, String? id) {
    this.video = video;
    this.id = id ?? "";
  }

  @override
  _VideoListState createState() => _VideoListState(video, id);
}

class _VideoListState extends State<VideoList> {
  late String id;
  List<YouTubeVideo> videoResult = [];
  late YoutubePlayerController contr;
  late YouTubeVideo video;
  static String key = "AIzaSyD-RUc3eNgGxCPB3NOJDtQk68SdDuYJT4M";
  YoutubeAPI youtube = YoutubeAPI(key, maxResults: 10);

  Future<void> callAPI() async {
    videoResult = await youtube.search(
        video.title,
        order: 'relevance',
        videoDuration: 'any',
        type: 'video'
    );
    videoResult.removeAt(0);
    setState(() {

    });
  }

  _VideoListState(YouTubeVideo video, String id) {
    this.video = video;
    this.id = id;
    contr = YoutubePlayerController(initialVideoId: this.id);
  }


  @override
  void initState() {
    super.initState();
    callAPI();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(0, 0, 0, 42),
        child: Column(
            children: [
              Padding(padding: EdgeInsets.all(12)),
              YoutubePlayer(
                controller: contr,
                actionsPadding: const EdgeInsets.only(left: 18.0),
                topActions: [
                  InkWell(
                    child: Icon(Icons.arrow_back_ios, color: Colors.red),
                    onTap: () => Navigator.pop(context),
                  ),
                  Expanded(
                      child: Text(video.title, softWrap: true, style: TextStyle(fontSize: 16, color: Colors.white))
                  ),
                ],
                bottomActions: [
                  CurrentPosition(),
                  const SizedBox(width: 10.0),
                  ProgressBar(
                      isExpanded: true,
                      colors: ProgressBarColors(
                        handleColor: Colors.red,
                        playedColor: Colors.red,
                      )
                  ),
                  const SizedBox(width: 10.0),
                  RemainingDuration(),
                  Padding(padding: EdgeInsets.all(10))
                ],
              ),
              Wrap(
                children: [
                 Container(
                   alignment: Alignment.topLeft,
                   width: 1000,
                   padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                   color: Colors.black,
                   child: Column(
                     children: [
                       Padding(padding: EdgeInsets.all(6)),
                       Text(
                         video.title,
                         style: TextStyle(fontSize: 18.0, color: Colors.white),
                       ),
                       Padding(padding: EdgeInsets.all(6)),
                     ],
                   )
                 )
                ],
              ),
              Expanded(
                child: ListView(
                  children: videoResult.map<Widget>(listItem).toList(),
                ),
              ),
            ]
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
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => VideoList(video, video.id),
                ));
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


