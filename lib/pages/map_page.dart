import 'package:flutter/material.dart';

class mapPage extends StatefulWidget {
  const mapPage({super.key});

  @override
  State<mapPage> createState() => _mapPageState();
}

class _mapPageState extends State<mapPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    appBar: AppBar(
        elevation: 0,
        title: Text('Map'),
        backgroundColor: Colors.transparent,
        leading: Row(
          children: <Widget>[
            SizedBox(width: 5.0),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: <Widget>[
          //boton para favs
          ElevatedButton(onPressed: (){
            //  Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => mapPage()),
            //   );

          }, child: Text('Lista de ubicaciones Guardadas')),
          SizedBox(width: 20.0),
        ],
      ));
  }
}