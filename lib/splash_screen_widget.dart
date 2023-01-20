import 'package:admin_app/splash_screen_bloc/spalsh_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();
    this._dispatchEvent(
        context); // This will dispatch the navigateToHomeScreen event.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color:bgColor,
      child: Image.asset('assets/images/bloc_logo_small.png'),
    );
  }

  //This method will dispatch the navigateToHomeScreen event.
  void _dispatchEvent(BuildContext context) {
    BlocProvider.of<SplashScreenBloc>(context).add(
      NavigateToHomeScreenEvent(),
    );
  }
}