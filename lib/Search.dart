import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'video_list.dart';
import 'Results.dart';



class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(0, 0, 0, 42),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              titleSpacing: 0,
              backgroundColor: Colors.black,
              leading: InkWell(
                child: Icon(Icons.arrow_back),
                onTap: () => Navigator.pop(context),
              ),
              title: Container(
                height: 36,
                child: TextField(
                  onSubmitted: (String) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DemoApp(String),
                    ),
                  ),
                  autocorrect: false,
                  style: TextStyle(color: Colors.white),
                  decoration: new InputDecoration(
                    fillColor: Colors.grey,
                    filled: true,
                    hintText: 'Search Fake YouTube',
                  ),
                  cursorColor: Colors.red,
                  controller: myController,
                ),
              ),
              actions: [
                Padding(padding: EdgeInsets.all(6)),
                InkWell(
                    child: Icon(Icons.arrow_forward_ios_sharp),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DemoApp(myController.text),
                      ),
                    )
                ),
                Padding(padding: EdgeInsets.all(6)),
              ],
            ),
          ],
        ),
      )
    );
  }
}