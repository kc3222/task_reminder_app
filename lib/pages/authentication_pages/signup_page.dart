import 'package:flutter/material.dart';
import 'package:reminder_note_app/pages/notes/note_list_page.dart';
import 'package:reminder_note_app/services/user_authentication.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUpPage({Key key}) : super(key: key);
  
  // Future<void> _signInAnonymously() async {
  //   try {
  //     // await FirebaseAuth.instance.signInAnonymously();
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(email: "test@test.com", password: "abcd1234");
  //     DatabaseWrapper.db.setFireBaseUser(FirebaseAuth.instance.currentUser());
  //   } catch (e) {
  //     print(e); // TODO: show dialog with error
  //   }
  // }

  _signUp(BuildContext context, {String email: "test2@test.com", String password: "abcd1234"}) {
    try {
      context.read<AuthenticationService>().signUp(email: email, password: password);
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    final emailField = TextField(
      controller: _emailController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      controller: _passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          // _signUp(context, email: _emailController.text, password: _passwordController.text);
          _signUp(context);
          Navigator.pop(context);
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => NoteListPage()));
        },
        child: Text("Sign up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  // child: Image.asset(
                  //   "assets/logo.png",
                  //   fit: BoxFit.contain,
                  // ),
                ),
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                signUpButton,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
        )
    );
  }
}