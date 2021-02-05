import 'package:buscado_de_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class CreateGifTable extends StatelessWidget {
  final BuildContext ctx;
  final AsyncSnapshot snapshot;
  final Function fn;
  final String search;

  CreateGifTable(this.ctx, this.snapshot, this.fn, this.search);

  int _getCount(List data) {
    if (search == "")
      return data.length;
    else
      return data.length + 1;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (ctx, index) {
        if (search == "" || index < snapshot.data["data"].length)
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"],
              height: 300,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                ctx,
                MaterialPageRoute(
                    builder: (ctx) => GifPage(snapshot.data["data"][index])),
              );
            },
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"]);
            },
          );
        else
          return Container(
            child: GestureDetector(
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 100,
                ),
              ),
              onTap: fn,
            ),
          );
      },
    );
  }
}
