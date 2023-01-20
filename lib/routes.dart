import 'package:admin_app/screens/main/main_screen.dart';
import 'package:flutter/widgets.dart';
import 'bloc/app_bloc.dart';
import 'login/view/login_page.dart';
import 'main_screen.dart';

/// authorized route for user already signedIn or loggedIn
/// unAuthorized for user not logged or signed in

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages){

  switch (state) {
    case AppStatus.unauthenticated:
      print('here1');
      return [LoginPage.page()];
    case AppStatus.authenticated:
      print('here2');
      return [MainScreen.page()];


  }


}

