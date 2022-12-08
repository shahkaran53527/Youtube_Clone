//****** Readme
// The project uses two external package- 1) Youtube_api and 2) Youtube Player
// In this app, one can browse trending videos in home screen, search
// videos using the search icon and last but not least watch videos
// Interface similar to Youtube but with very limited capabilities



import 'package:flutter/material.dart';
import 'Results.dart';
import 'Search.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'video_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  var controllers = [];
  int index = 0;

  static String key = "AIzaSyD-RUc3eNgGxCPB3NOJDtQk68SdDuYJT4M";
  YoutubeAPI youtube = YoutubeAPI(key, maxResults: 10);
  List<YouTubeVideo> videoResult = [];

  Future<void> callAPI() async {
    videoResult = await youtube.getTrends(regionCode: "US");

    videoResult.forEach((element) async {
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
     body: Container(
       color: Color.fromRGBO(0, 0, 0, 42),
       child: CustomScrollView(
         slivers: [
           SliverAppBar(
               backgroundColor: Colors.black,
               leading: Icon(Icons.voice_chat_sharp, color: Colors.red),
               title: Text("Fake YouTube", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
               actions: [
                 Icon(Icons.connected_tv),
                 Padding(padding: EdgeInsets.all(6)),
                 InkWell(
                   child: Icon(Icons.search_sharp),
                     onTap: () => Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                     builder: (context) => Search(),
                                   ),
                             )
                 ),
                 Padding(padding: EdgeInsets.all(6)),
                 Icon(Icons.doorbell),
                 Padding(padding: EdgeInsets.all(6)),
               ],
               expandedHeight: 100,
               flexibleSpace: FlexibleSpaceBar(
                   centerTitle: true,
                   title: Wrap(
                     children: [
                       Text("Search for Videos using Icon above", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.8)),
                     ],
                   )
                   ),
               ),
           SliverList(
             delegate: SliverChildListDelegate(
               videoResult.map<Widget>(listItem).toList(),
             ),
           ),
         ],
       ),
     )
   );
  }



  Widget listItem(YouTubeVideo video) {
    return Card(
        elevation: 0,
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 42),
          child: InkWell(
              onTap: () {
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
