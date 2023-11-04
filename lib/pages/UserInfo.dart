import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/consts/shared_preferences.dart';
import 'package:fastenglish/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late ScrollController _scrollController;
  final user = FirebaseAuth.instance.currentUser!;
  var top = 0.0;
  bool value_ = false;
  String nigth = 'Activar ';
  final FirebaseAuth auth_ = FirebaseAuth.instance;
  String? uid;
  String? name;
  String? email;
  String? userUrlImage;
  bool _light = false;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    getData();
    _loadTheme();
  }

  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _light = prefs.getBool('isDarkMode') ?? false;
      Provider.of<ThemeProvider>(context, listen: false).toggleTheme(_light);
    });
  }

  _saveTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }

  void getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await shared_preferences().isValueExists('Email')) {
      setState(() {
        uid = prefs.getString('uid')!;
        email = prefs.getString('Email')!;
        name = prefs.getString('UserName')!;
        userUrlImage = prefs.getString('ImagenUrl')!;
      });
    } else {
      final DataSnapshot userDoc =
          await FirebaseDatabase.instance.ref().child("Users").get();
      setState(() {
        for (DataSnapshot sn in userDoc.children) {
          if (user.email == sn.child('Email').value) {
            uid = sn.key.toString();
            email = sn.child('Email').value.toString();
            name = sn.child('UserName').value.toString();
            userUrlImage = sn.child('ImagenUrl').value.toString();
            prefs.setString('uid', sn.key.toString());
            prefs.setString('Email', sn.child('Email').value.toString());
            prefs.setString('UserName', sn.child('UserName').value.toString());
            prefs.setString(
                'ImagenUrl', sn.child('ImagenUrl').value.toString());
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constrains) {
                    top = constrains.biggest.height;
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.purple, Colors.cyanAccent],
                            begin: FractionalOffset(0.0, 0.0),
                            end: FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        centerTitle: true,
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 12,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 30.0),
                                  height: kToolbarHeight * 1,
                                  width: kToolbarHeight * 1,
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 1.0),
                                      ],
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(userUrlImage ??
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEpWWQrAJpIR6Xy7FhzhCT00vzSmT7xw9S2Q&usqp=CAU'),
                                      )),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  name ?? '',
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            )
                          ],
                        ),
                        background: const Image(
                          image: AssetImage('assets/fondoDefecto.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  titles('Informacion de Usuario'),
                  userListTile(
                      'Nombre de Usuario', name ?? '', Icons.person, context),
                  userListTile('E-mail', email ?? '', Icons.email, context),
                  titles('Configuración de Usuario'),
                  const Divider(
                    thickness: 1,
                  ),
                  ListTileSwitch(
                    value: _light,
                    leading: Icon(Icons.nightlight_sharp,
                        color: ColorsConsts.endColor),
                    onChanged: (bool value) {
                      setState(() {
                        _light = value;
                      });
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(value);
                      _saveTheme(value);
                    },
                    visualDensity: VisualDensity.comfortable,
                    switchType: SwitchType.material,
                    switchActiveColor: Colors.indigo,
                    title: Text(
                      'Modo Nocturno',
                      style: GoogleFonts.ubuntu(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      child: ListTile(
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text(
                                      'Cerra Sesión',
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.red),
                                    ),
                                    content: const Text(
                                        '¿Estas seguro de cerrar la sesión?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text(
                                          'Cancelar',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          FirebaseAuth.instance.signOut();
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          await prefs.clear();
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text(
                                          'Si',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ));
                        },
                        title: const Text(
                          'Cerrar Session',
                          style: TextStyle(color: Colors.red),
                        ),
                        leading: Icon(Icons.logout_outlined,
                            color: ColorsConsts.endColor),
                      ),
                    ),
                  )
                  //userListTile('Cerrar Sesion','****',    Icons.exit_to_app_rounded, context),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }

  /*
  *
  * */
  Widget userListTile(
      String title, String subtitle, IconData icon, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        child: ListTile(
          onTap: () {},
          title: Text(
            title,
            style:
                GoogleFonts.ubuntu(fontSize: 15, fontWeight: FontWeight.w300),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.ubuntu(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          leading: Icon(icon, color: ColorsConsts.endColor),
        ),
      ),
    );
  }

  Widget titles(String text) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: GoogleFonts.ubuntu(fontSize: 20, fontWeight: FontWeight.bold),
        ));
  }
}
