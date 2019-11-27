import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_code/model/Exercise.dart';
import 'package:flutter_qr_code/model/SportEquipment.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ScannerPage(),
    );
  }
}

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  GlobalKey qrKey = GlobalKey();

  var qrText = "  Henüz tarama yapmadın";

  QRViewController controller;
  Widget currentWidget;


  @override
  void initState() {
    currentWidget = Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Text("Odağınızı QR koda getirin"),
          ),
        ),
      ),
    );
    print("${exercise.toJson().toString()}");
    super.initState();
  }

  Exercise exercise = new Exercise(
      id: "1",
      name: "Squats",
      image:
      "https://media0.giphy.com/media/gfT6lcOsOBeanppUUR/giphy.webp?cid=790b761105eff7fcf084e35bbf7426a6f245a7fa06e6476f&rid=giphy.webp",
      set: 3,
      repeatCount: 15);

  SportEquipment sportEquipment = new SportEquipment(
      id: "1",
      name: "Koşu bandı",
      image:
      "https://media.giphy.com/media/ZaMLw0FvXg29W/giphy.gif",
      equipmentNumber: 1,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                  borderRadius: 8,
                  borderColor: Colors.red,
                  borderLength: 60,
                  borderWidth: 10,
                  cutOutSize: 250),
              onQRViewCreated: _onQRViewCreate,
            ),
          ),
          Expanded(
              flex: 2,
              child: currentWidget,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
        print("Barcode $qrText");

        var parsedJson = json.decode(scanData);
        print("${parsedJson["type"]}");

        switch(parsedJson["type"]){
          case "Exercise":
            Exercise exercise = Exercise.fromJson(parsedJson['Exercise']);
            setState(() {
              currentWidget = ExersizeItem(exercise);
            });
            break;
          case "SportEquipment":
            SportEquipment sportEquipment = SportEquipment.fromJson(parsedJson['SportEquipment']);
            setState(() {
              currentWidget = SportEquipmentItem(sportEquipment);
            });
            break;
          case "SignIn":
            setState(() {
              currentWidget = SignIn();
            });
            break;

          case "SignOut":
            setState(() {
              currentWidget = SignOut();
            });
            break;
        }


      });
    });
  }
}

class ExersizeItem extends StatelessWidget {
  Exercise exercise;

  ExersizeItem(this.exercise);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Row(
            children: <Widget>[
            Container(
              width: 150,
              height: 150,
              child: CachedNetworkImage(
                imageUrl: exercise.image,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(exercise.name, style: Theme
                        .of(context)
                        .textTheme
                        .title, textAlign: TextAlign.center,),
                    ListTile(
                      leading: Icon(Icons.repeat, color: Colors.orange,),
                      title: Text("${exercise.set} set"),
                    ),
                    ListTile(
                      leading: Icon(Icons.repeat, color: Colors.blue,),
                      title: Text("${exercise.repeatCount} tekrar"),
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SportEquipmentItem extends StatelessWidget {
  SportEquipment sportEquipment;

  SportEquipmentItem(this.sportEquipment);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Row(
            children: <Widget>[
              Container(
                width: 150,
                child: CachedNetworkImage(
                  imageUrl: sportEquipment.image,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(sportEquipment.name, style: Theme
                        .of(context)
                        .textTheme
                        .title, textAlign: TextAlign.center,),
                    ListTile(
                      leading: Icon(Icons.directions_run, color: Colors.orange,),
                      title: Text("Alet numarası: ${sportEquipment.equipmentNumber}"),
                    ),
                    FlatButton(
                      onPressed: (){

                      },
                      child: Text("Aleti salonda göster"),
                    )

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: "https://media1.giphy.com/media/xUPGGDNsLvqsBOhuU0/200.webp?cid=790b76119eafe2d004eeced0fa5d1728bb602fc48ca57b17&rid=200.webp",
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Text("Salona hoşgeldin Furkan Kayalı")
            ],
          ),
        ),
      ),
    );
  }
}

class SignOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: "https://media0.giphy.com/media/26u4b45b8KlgAB7iM/200.webp?cid=790b761129b7e184469d5b518047e56b3689879f74420dc0&rid=200.webp",
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Text("Güle güle Furkan Kayalı")
            ],
          ),
        ),
      ),
    );
  }
}
