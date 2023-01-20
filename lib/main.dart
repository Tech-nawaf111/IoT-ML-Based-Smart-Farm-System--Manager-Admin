import 'package:admin_app/screens/main/main_screen.dart';
import 'package:admin_app/splash_screen_bloc/spalsh_screen_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'Splash_Screen.dart';
import 'bloc/app_bloc.dart';
import 'bloc_observer.dart';
import 'constants.dart';
import 'controllers/MenuController.dart';
void main() async {

  return BlocOverrides.runZoned(
        () async {
      WidgetsFlutterBinding?.ensureInitialized();
      await Firebase.initializeApp();
      final authenticationRepository = AuthenticationRepository();
      await authenticationRepository.user.first;
      runApp(App(authenticationRepository: authenticationRepository,));
    },
    blocObserver: AppBlocObserver(),
  );
}

class App extends StatelessWidget {
  const App({
    Key? key,
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(key: key);

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {

    return RepositoryProvider.value(
      value: _authenticationRepository,
      child:MultiBlocProvider(providers: [


        BlocProvider<SplashScreenBloc>(
          create: (counterCubitContext) => SplashScreenBloc(null),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => AppBloc(
              authenticationRepository: _authenticationRepository,
          ),
        )
      ],


        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Admin Panel',
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: bgColor,
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
          .apply(bodyColor: Colors.white),
      canvasColor: secondaryColor,
    ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
        ],
        child: SplashScreen(),
      ),
    );
  }
}

