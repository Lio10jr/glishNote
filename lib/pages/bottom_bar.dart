import 'package:fastenglish/Home.dart';
import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/pages/Camera.dart';
import 'package:fastenglish/pages/Configuracion.dart';
import 'package:fastenglish/pages/UserInfo.dart';
import 'package:fastenglish/pages/pag_translation.dart';
import 'package:flutter/material.dart';

class BottomBarScreen extends StatefulWidget {
  @override
    _BottomBarScreenState createState() => _BottomBarScreenState();
  }



class _BottomBarScreenState extends State<BottomBarScreen> {
  late List<Map<String, Widget>> _pages;
  int _selectedPageIndex = 0;
  @override
  void initState() {
    _pages = [
      {
        'page': const PrincipalSession(),
      },
      {
        'page': const PageTranslation(),
      },
      {
        'page': Camera(),
      },
      {
        'page': UserInfo(),
      },
      {
        'page': Configuracion(),
      },
    ];
    super.initState();
  }

  void _selectPage(int index){
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedPageIndex]['page'],
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 0.01,
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: kBottomNavigationBarHeight * 0.98,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 209, 35, 145),
                border: Border(
                  top: BorderSide(
                    color: ColorsConsts.cartBadgeColor,
                    width: 0.5,
                  )
                )
              ),
              child: BottomNavigationBar(
                onTap: _selectPage,
                  backgroundColor: Theme.of(context).primaryColor,
                unselectedItemColor: ColorsConsts.endColor,
                selectedItemColor: ColorsConsts.cartColor,
                currentIndex: _selectedPageIndex,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.translate),
                    label: 'Translation',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: null,
                    icon: Icon(null),
                    label: 'Camera',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      floatingActionButtonLocation:
        FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.9),
        child: FloatingActionButton(
          hoverElevation: 10,
          splashColor: Color.fromARGB(255, 29, 12, 138),
          backgroundColor: ColorsConsts.endColor,
          tooltip: 'Camera',
          elevation: 4,
          child: const Icon(Icons.camera),
          onPressed: () => setState(() {
            _selectedPageIndex = 2;
          })
        ),
      ),
    );
  }
}
