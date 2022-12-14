import 'dart:async';
import 'dart:convert';

import 'package:clock_mobile/verify_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final _emailController = TextEditingController();
  late final _passwordController = TextEditingController();
  late final _confirmPasswordController = TextEditingController();
  bool _validateemail = false;
  bool _validatepassword = false;
  bool _validateconfirmpassword = false;
  bool _check = false;

  Future<void> register() async {
    _check = true;
    setState(() {});
    final response = await http.post(
      Uri.parse("https://calcappworks.herokuapp.com/register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );
    if (response.statusCode == 200) {
      _check = false;
      print(response.body);
      var verifyCode = json.decoder.convert(response.body)['verefy'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              VerifyPage(_emailController.text, verifyCode.toString()),
        ),
      );
      setState(() {});
    } else {
      _check = false;
      if (json.decoder.convert(response.body)['error'] !=
          "email already exist") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buning email bilan ro\'yxatdan o\'tmagan'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            //time out 2 sec
            duration: Duration(milliseconds: 700),
            //position of snackbar
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Qandaydir xatolik yuz berdi'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            //time out 2 sec
            duration: Duration(milliseconds: 700),
            //position of snackbar
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> valFun() async {
    //time out 2 sec _validateEmail = false;
    Timer(const Duration(milliseconds: 2000), () {
      _check = false;
      setState(() {
        _validateemail = false;
        _validatepassword = false;
        _validateconfirmpassword = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
          elevation: 3,
        ),
      ),
      body: Center(
          child: Column(children: [
        const Expanded(child: Text('')),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 221, 221, 221),
              border: Border.all(
                  color: const Color.fromARGB(255, 221, 221, 221), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              // The validator receives the text that the user has entered.
              cursorColor: Colors.deepPurpleAccent,
              controller: _emailController,
              textAlign: TextAlign.left,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
                border: InputBorder.none,
                hintText: 'Pochta',
                errorText: _validateemail ? 'Pochta kiriting' : null,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 221, 221, 221),
              border: Border.all(
                  color: const Color.fromARGB(255, 221, 221, 221), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              cursorColor: Colors.deepPurpleAccent,
              controller: _passwordController,
              textAlign: TextAlign.left,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                border: InputBorder.none,
                hintText: 'Parol',
                errorText: _validatepassword ? 'Parol kiriting' : null,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 221, 221, 221),
              border: Border.all(
                  color: const Color.fromARGB(255, 221, 221, 221), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              cursorColor: Colors.deepPurpleAccent,
              controller: _confirmPasswordController,
              textAlign: TextAlign.left,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                border: InputBorder.none,
                hintText: 'Parolni qaytadan kiriting',
                errorText: _validateconfirmpassword
                    ? 'Parolni qaytadan kiriting'
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        if (!_check)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.055,
              child: ElevatedButton(
                onPressed: () {
                  if (_emailController.text.isEmpty) {
                    setState(() {
                      _validateemail = true;
                    });
                  } else {
                    setState(() {
                      _validateemail = false;
                    });
                  }
                  if (_passwordController.text.isEmpty) {
                    setState(() {
                      _validatepassword = true;
                    });
                  } else {
                    setState(() {
                      _validatepassword = false;
                    });
                  }
                  if (_confirmPasswordController.text.isEmpty) {
                    setState(() {
                      _validateconfirmpassword = true;
                    });
                  } else {
                    setState(() {
                      _validateconfirmpassword = false;
                    });
                  }
                  if (_passwordController.text.isNotEmpty &&
                      _passwordController.text ==
                          _confirmPasswordController.text) {
                    _check = true;
                    setState(() {});
                    register();
                  } else {
                    valFun();
                    _confirmPasswordController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Qandaydir xatolik yuz berdi'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        //time out 2 sec
                        duration: Duration(milliseconds: 1200),
                        //position of snackbar
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Ro\'yxatdan o\'tish',
                ),
              ),
            ),
          ),
        if (_check) const CircularProgressIndicator(),
        //bottom sign up text password
        const Expanded(child: Text('')),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Hisobingiz bormi?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              TextButton(
                onPressed: () {
                  //finish activity
                  Navigator.pop(context);
                },
                child: const Text(
                  'Kirish',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
      ])),
    );
  }
}
