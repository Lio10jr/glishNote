import 'package:fastenglish/all_pages_view.dart';
import 'package:fastenglish/consts/colors.dart';
import 'package:flutter/material.dart';
import 'all_app_bar.dart';

const IconData facebook = IconData(0xe255, fontFamily: 'MaterialIcons');

//PagSecundaria con sesion iniciada
class PrincipalSession extends StatefulWidget {
  const PrincipalSession({Key? key}) : super(key: key);

  @override
  stateHomePageSession createState() => stateHomePageSession();
}

class stateHomePageSession extends State<PrincipalSession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConsts.white,
      body: Column(
        children: [
          todoAppBarLog(),
          const AllPageView()
        ],
      ),
    );
  }
}
