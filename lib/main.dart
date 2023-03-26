import 'package:beamer/beamer.dart';
import 'package:tiogo/models/carModel.dart';
import 'package:tiogo/services/authServices.dart';
import 'package:tiogo/services/dbServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tiogo/views/shared-ui/splashScreen.dart';
import 'beamDelegate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      StreamProvider<User?>.value(
        initialData: null,
        value: AuthService().user,
      ),
      StreamProvider<List<Car>>.value(
        initialData: [],
        value: DatabaseService().cars,
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final _routerDelegate = routerDelegate(context);
    return BeamerProvider(
      routerDelegate: _routerDelegate,
      child: MaterialApp.router(
        title: 'Fire cars',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(backgroundColor: Colors.white),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.lightBlue,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        routerDelegate: _routerDelegate,
        routeInformationParser: BeamerParser(),
        builder: (context, child) {
          return StreamBuilder(
            initialData: 'loading',
            stream: AuthService().user,
            builder: (context, snapshot) {
              if (snapshot.data.toString() != 'loading') return child!;
              return SplashScreen();
            },
          );
        },
      ),
    );
  }
}
