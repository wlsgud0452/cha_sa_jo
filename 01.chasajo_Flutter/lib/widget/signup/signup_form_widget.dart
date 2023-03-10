import 'package:cha_sa_jo_flutter/constants/sizes.dart';
import 'package:cha_sa_jo_flutter/constants/text_strings.dart';
import 'package:cha_sa_jo_flutter/view/chatting/chat_screen.dart';
import 'package:cha_sa_jo_flutter/view/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _authentication = FirebaseAuth.instance;
    String Nickname = '';
    String email = '';
    String password = '';
    String password2 = '';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Nickname'),
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              onChanged: (value) {
                Nickname = value;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              decoration: const InputDecoration(
                label: Text(tEmail),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              onChanged: (value) {
                email = value;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            // TextFormField(
            //   decoration: const InputDecoration(
            //     label: Text(tPhoneNo),
            //     prefixIcon: Icon(Icons.numbers),
            //   ),
            // ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                label: Text(tPassword),
                prefixIcon: Icon(Icons.fingerprint),
              ),
              onChanged: (value) {
                password = value;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                label: Text(cPassword),
                prefixIcon: Icon(Icons.fingerprint),
              ),
              onChanged: (value) {
                password2 = value;
              },
            ),
            const SizedBox(height: tFormHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  //
                  _SignupCheck(Nickname, email, password, password2, context);
                  //_Signup(email, password, Nickname, context);
                },
                child: Text(tSignup.toUpperCase()),
              ),
            )
          ],
        ),
      ),
    );
  }

//------------------Funtions --------------------------------
  Future<void> _Signup(String email, String password, String Nickname,
      BuildContext context) async {
    try {
      final newUser =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('user')
          .doc(newUser.user!.uid)
          .set({
        'userName': Nickname,
        'email': email,
      });
      _showDialog(context);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please check your email and password."),
        ),
      );
    }
  }

  void _SignupCheck(String Nickname, String Email, String password1,
      String password2, BuildContext context) {
    if (Nickname == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a nickname."),
        ),
      );
    } else if (Email == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email."),
        ),
      );
    } else if (password1 == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your password."),
        ),
      );
    } else if (password1.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the password in at least 6 characters."),
        ),
      );
    } else if (password2 == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter password verification."),
        ),
      );
    } else if (password1 != password2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("The password doesn't match."),
        ),
      );
    } else {
      _Signup(Email, password1, Nickname, context);
    }
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SingUp'),
          content: const Text('Welcome.\nSingUp completed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
                Get.to(const LoginScreen());
              },
              child: const Text(
                'OK',
              ),
            ),
          ],
        );
      },
    );
  }
  //---------------End--------------------------------
}
