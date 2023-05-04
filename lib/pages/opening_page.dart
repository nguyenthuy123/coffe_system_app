// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:datn/utils/http_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/build_context_ext.dart';
import 'home_page.dart';

class MyOpeningPage extends StatefulWidget {
  const MyOpeningPage({super.key});

  @override
  State<MyOpeningPage> createState() => _MyOpeningPageState();
}

class _MyOpeningPageState extends State<MyOpeningPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    () async {
      prefs = await SharedPreferences.getInstance();
    }();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'My Coffee\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Have a nice day at work',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: context.height / 3),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: usernameController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.lock),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: context.width - 80,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              final userStr = await HttpUtils.login(
                                usernameController.text.trim(),
                                passwordController.text.trim(),
                              );
                              final userJson = jsonDecode(userStr);

                              if (userJson['status']['code'] == 1000) {
                                prefs.setString('user', userStr);
                                context.push(const MyHomePage());
                              } else {
                                context.showSnackBar(userJson['data']);
                              }
                            } catch (e) {
                              context.showSnackBar(e.toString());
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
