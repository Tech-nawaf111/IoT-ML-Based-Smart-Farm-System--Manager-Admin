import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../cubit/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {},
      child: Align(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/bloc_logo_small.png',
                height: 120,
              ),
              const SizedBox(height: 30),
              _EmailInput(),
              const SizedBox(height: 8),
              _PasswordInput(),
              const SizedBox(height: 30),
              _LoginButton(),
              const SizedBox(height: 4),

            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,

      builder: (context, state) {
       FocusNode myFocusNode = new FocusNode();
        return TextFormField(

          key: const Key('loginForm_emailInput_textField'),

          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email',
            labelStyle: TextStyle(
                color: myFocusNode.hasFocus ? Colors.white : Color(0xFF292723),

            ),
            prefixIcon: Icon(Icons.email, color: Colors.brown,),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.brown, width: 2),

            ),
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {

        FocusNode myFocusNode = new FocusNode();
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
              labelStyle: TextStyle(
                color: myFocusNode.hasFocus ? Colors.white : Color(0xFF292723),

              ),
            prefixIcon: Icon(Icons.lock, color: Colors.brown,),


            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.brown, width: 2),

            ),

            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : Container(
            height: 50,
           width: 400,
           child:  ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(

                  primary: const Color(0xFF292723),
                ),

                onPressed: state.status.isValidated
                    ? () => context.read<LoginCubit>().logInWithCredentials(context)
                    : null,
                child: const Text('LOGIN'),
              )
            );
      },
    );
  }


}


