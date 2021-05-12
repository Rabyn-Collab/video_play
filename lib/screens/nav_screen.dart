import 'package:flutter/material.dart';
import 'package:flutter_app_ex/models/datas_.dart';
import 'package:flutter_app_ex/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';


final videoProvider = StateProvider<Data>((ref) => null);
final playerProvider = StateProvider.autoDispose<MiniplayerController>((ref) => MiniplayerController());
class NavScreen extends StatefulWidget {
  const NavScreen({Key key}) : super(key: key);

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _currentIndex = 0;
List<Widget> _pages =[
HomeScreen(),
  const Scaffold(body: Center(child: Text('hello welcome'),),),
  const Scaffold(body: Center(child: Text('hello welcome'),),),
  const Scaffold(body: Center(child: Text('hello welcome'),),)
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(
          builder: (context, watch, child) {
            return Stack(
              children: _pages.asMap().map((i, screen) =>
                  MapEntry(
                      i, Offstage(
                    offstage: _currentIndex != i,
                    child: screen,))).values.toList(),
              );
          }
        ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex:  _currentIndex,
          onTap: (index){
          setState(() {
            _currentIndex = index;
          });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border_outlined), activeIcon: Icon(Icons.favorite), label: 'Favourites'),
            BottomNavigationBarItem(icon: Icon(Icons.video_collection_outlined), activeIcon: Icon(Icons.video_collection), label: 'Collection'),
            BottomNavigationBarItem(icon: Icon(Icons.menu_outlined), activeIcon: Icon(Icons.menu), label: 'Menu'),
          ]
      )
    );
  }




}
