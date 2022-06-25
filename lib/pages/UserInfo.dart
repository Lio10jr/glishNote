import 'dart:ui';
import 'package:fastenglish/dark_theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late ScrollController _scrollController;
  final user = FirebaseAuth.instance.currentUser!;
  var top = 0.0;
  bool _value = false;
  String nigth = 'Activar ';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _name;
  String? _email;
  String? _userUrlImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    getData();
  }

  void getData() async {
    final DataSnapshot userDoc =
        await FirebaseDatabase.instance.ref().child("Users").get();
    setState(() {
      for (DataSnapshot sn in userDoc.children) {
        if (user.email == sn.child('Email').value) {
          _uid = sn.key.toString();
          _email = sn.child('Email').value.toString();
          _name = sn.child('UserName').value.toString();
          _userUrlImage = sn.child('ImagenUrl').value.toString();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Stack(
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
                                height: kToolbarHeight / 1.8,
                                width: kToolbarHeight / 1.8,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 1.0),
                                    ],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(_userUrlImage ??
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEpWWQrAJpIR6Xy7FhzhCT00vzSmT7xw9S2Q&usqp=CAU'),
                                    )),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                _name ?? '',
                                style: const TextStyle(
                                    fontSize: 20.0, color: Colors.white),
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
                    'Nombre de Usuario', _name ?? '', Icons.person, context),
                userListTile('E-mail', _email ?? '', Icons.email, context),
                titles('Configuración de Usuario'),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                ListTileSwitch(
                  value: themeChange.darkTheme,
                  leading: const Icon(Icons.nightlight_sharp),
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                      themeChange.darkTheme = value;
                    });
                  },
                  visualDensity: VisualDensity.comfortable,
                  switchType: SwitchType.material,
                  switchActiveColor: Colors.indigo,
                  title: const Text('Modo Nocturno'),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Theme.of(context).splashColor,
                    child: ListTile(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return AlertDialog(
                                title: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Cerra Sesion'),
                                    )
                                  ],
                                ),
                                content: const Text(
                                    '¿Estas seguro de cerrar la session?'),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      FirebaseAuth.instance.signOut();
                                    },
                                    child: const Text(
                                      'Si',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      title: const Text(
                        'Cerrar Session',
                        style: TextStyle(color: Colors.red),
                      ),
                      leading: const Icon(Icons.exit_to_app_rounded),
                    ),
                  ),
                )
                //userListTile('Cerrar Sesion','****',    Icons.exit_to_app_rounded, context),
              ],
            ))
          ],
        )
      ],
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
          title: Text(title),
          subtitle: Text(subtitle),
          leading: Icon(icon),
        ),
      ),
    );
  }

  Widget titles(String text) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ));
  }
}
