import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_ex/screens/nav_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white60
    )
  );
SystemChrome.setPreferredOrientations(
  [DeviceOrientation.portraitUp]
);
  runApp(ProviderScope(child: Home()));
}
class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.brown,
          unselectedItemColor: Colors.black26
        ),
      ),
      home: NavScreen(),
    );
  }
}










//
//
// import 'dart:io';
//
// import 'package:downloads_path_provider/downloads_path_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:permission_handler/permission_handler.dart';
//
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await FlutterDownloader.initialize(
//     debug: true
//   );
//
//   runApp(new MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final platform = Theme.of(context).platform;
//
//     return new MaterialApp(
//       title: 'Flutter Demo',
//       theme:  ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomeScreen()
//     );
//   }
// }
//
//
// class HomeScreen extends StatelessWidget {
// final url = 'https://vdownload-34.sb-cd.com/8/9/8921415-480p.mp4?secure=DFBJxP7dR5tbcWMRSGnOXg,1620782080&m=34&d=4&_tid=8921415&name=SpankBang.com_nitr+276+sasakura+an+middle+aged_480p.mp4';
// final imageUrl = 'https://images.unsplash.com/photo-1514315384763-ba401779410f?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&dl=sonnie-hiles-gG70fyu3qsg-unsplash.jpg';
//
//
//
// void _requestDownload() async {
//
//
//     PermissionStatus status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }
//
//     Directory appDocDir = await DownloadsPathProvider.downloadsDirectory;
//
//     final path = appDocDir.path ;
//      await FlutterDownloader.enqueue(
//       url: imageUrl,
//       savedDir: path,
//       showNotification: true,
//       openFileFromNotification: true,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: Container(
//             child: ElevatedButton(
//                 onPressed: (){
//                _requestDownload();
//             }, child: Text('Download')),
//           )
//       ),
//     );
//   }
// }
