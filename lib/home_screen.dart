import 'package:flutter/material.dart';
import 'package:flutter_api_hive/add_item_screen.dart';
import 'package:flutter_api_hive/post.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> posts = [];

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        posts = data.map((post) => Post.fromJson(post)).toList();
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Data'),
        actions: [
          IconButton(onPressed: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> AddedItemsScreen()));
          }, icon: Icon(Icons.next_plan_rounded))
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return GestureDetector(
            onTap: () {
              // Add the post to Hive database here
              // Access the Hive box
              final itemsBox = Hive.box('items');

              // Convert the post data to a Map to store it in Hive
              final postMap = {
                'userId': post.userId,
                'id': post.id,
                'title': post.title,
                'body': post.body,
              };

              // Add the post to Hive database
              itemsBox.add(postMap);

              // Show a message to the user or update the UI to indicate that the post has been added
            },
            child: Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title: ${post.title}', overflow: TextOverflow.ellipsis,maxLines: 5,),
                    Text('ID: ${post.id}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
