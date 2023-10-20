import 'package:flutter/material.dart';
import 'package:flutter_api_hive/post.dart';
import 'package:hive/hive.dart';

class AddedItemsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Added Items'),
      ),
      body: FutureBuilder(
        future: Hive.openBox('items'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final box = Hive.box('items');
            final items = box.values.map((item) {
              if (item is Map<String, dynamic>) {
                return Post.fromJson(item);
              } else {
                // Handle any unexpected data gracefully.
                return Post(userId: 0, id: 0, title: '', body: '');
              }
            }).toList();
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: Key(item.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    final itemsBox = Hive.box('items');
                    itemsBox.deleteAt(index);
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text('ID: ${item.id}'),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}