import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/create_gif_table.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = "";

  int _offSet = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == "")
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=E077F0Aax1PrewZdKbD7fIcgIulzsdAC&limit=20&rating=g");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=E077F0Aax1PrewZdKbD7fIcgIulzsdAC&q=$_search&limit=19&offset=$_offSet&rating=g&lang=en");

    return json.decode(response.body);
  }

  _changeOffSet() {
    setState(() {
      _offSet += 19;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image(
          image: AssetImage(
              "assets/gifs/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
          fit: BoxFit.cover,
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Buscar",
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  border: OutlineInputBorder()),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: Container(
                            height: 150,
                            width: 150,
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              strokeWidth: 5,
                            )),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(
                          child: Container(
                            child: Text(
                              'Erro ao Carregar Dados :(',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        return CreateGifTable(
                          context,
                          snapshot,
                          _changeOffSet,
                          _search,
                        );
                      }
                  }
                }),
          ),
        ],
      ),
    );
  }
}
