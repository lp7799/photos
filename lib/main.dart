import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photos/img/select_img.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
              subtitle1: TextStyle(
                  color: Color(0xff9e9e9e),
                  fontWeight: FontWeight.w400,
                  fontSize: 12)),
          appBarTheme: const AppBarTheme(
              color: Colors.white,
              elevation: .5,
              iconTheme: IconThemeData(color: Color(0xd9000000)),
              titleTextStyle: TextStyle(
                  color: Color(0xd9000000),
                  fontSize: 24,
                  fontWeight: FontWeight.w700))),
      home: const MyHomePage(title: 'Hyperbound Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ImgModel> imgs = [
    ImgModel(
        img: 'assets/images/demo_1.png',
        platform: 'android',
        dateTime: DateTime.now()
            .add(
              Duration(days: -2, hours: 1),
            )
            .millisecondsSinceEpoch),
    ImgModel(
        img: 'assets/images/demo_2.png',
        platform: 'ios',
        dateTime: DateTime.now()
            .add(
              Duration(days: -3, hours: 1),
            )
            .millisecondsSinceEpoch),
    ImgModel(
        img: 'assets/images/demo_3.png',
        platform: 'android',
        dateTime: DateTime.now()
            .add(
              Duration(days: -4, hours: 1),
            )
            .millisecondsSinceEpoch),
    ImgModel(
        img: 'assets/images/demo_4.png',
        platform: 'ios',
        dateTime: DateTime.now()
            .add(
              Duration(days: -5, hours: 1),
            )
            .millisecondsSinceEpoch),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: Builder(builder: (context) {
        return SizedBox(
          height: 78,
          width: 78,
          child: IconButton(
            onPressed: () {
              toSelectImg(context);
            },
            icon: Image.asset(
              'assets/images/ic_fab.png',
              width: 78,
              height: 78,
            ),
          ),
        );
      }),
      body: ListView.separated(
        itemCount: imgs.length,
        itemBuilder: (context, index) {
          final imgModel = imgs[index];
          return Itmes(imgModel: imgModel);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1,
            color: Color(0xffe8e8e8),
          );
        },
      ),
    );
  }

  Future<void> toSelectImg(BuildContext context) async {
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.isAuth) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SelectImg()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '当前没有权限哦',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ));
    }
  }
}

class Itmes extends StatelessWidget {
  const Itmes({
    Key? key,
    required this.imgModel,
  }) : super(key: key);

  final ImgModel imgModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          const SizedBox(
            width: 29,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.asset(
                  imgModel.img,
                  width: 158,
                  height: 158,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(imgModel.formatTime + '   ${imgModel.platform}',
                  style: Theme.of(context).textTheme.subtitle1),
              const SizedBox(
                height: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImgModel {
  final String img;
  final int dateTime;
  final String platform;
  String get formatTime {
    var d = DateFormat('yyyy-MM-dd hh-mm');
    var time = DateTime.fromMillisecondsSinceEpoch(dateTime);
    return d.format(time);
  }

  ImgModel({required this.img, required this.platform, required this.dateTime});
}
