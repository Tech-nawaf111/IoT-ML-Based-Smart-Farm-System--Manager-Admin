import 'package:admin_app/routes.dart';
import 'package:admin_app/splash_screen_bloc/spalsh_screen_bloc.dart';
import 'package:admin_app/splash_screen_widget.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/app_bloc.dart';
import 'constants.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState  extends State<SplashScreen > {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  BlocProvider<SplashScreenBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashScreenBloc(Initial()),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: bgColor,
        child: Center(
          // Here I have used BlocBuilder, but instead you can also use BlocListner as well.
          child: BlocBuilder<SplashScreenBloc, SplashScreenState>(
            builder: (context, state){

              if ((state is Initial) || (state is Loading)) {
               return SplashScreenWidget();
              }
              else if (state is Loaded) {
              return FlowBuilder<AppStatus>(
                state: context.select((AppBloc bloc) => bloc.state.status),
                onGeneratePages: onGenerateAppViewPages,
              );
              }
              return FlowBuilder<AppStatus>(
                state: context.select((AppBloc bloc) => bloc.state.status),
                onGeneratePages: onGenerateAppViewPages,
              );
            },
          ),
        ),
      ),
    );
  }
}