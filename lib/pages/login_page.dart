// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:datn/pages/home_page.dart';
import 'package:datn/utils/build_context_ext.dart';
import 'package:datn/utils/http_utils.dart';
import 'package:datn/widgets/button_widget.dart';
import 'package:datn/widgets/input_widget.dart';
import 'package:datn/widgets/text_subtitle_widget.dart';
import 'package:datn/widgets/text_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late SharedPreferences prefs;

  initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
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
              Column(
                children: [
                  InputWidget(
                    controller: usernameController,
                    label: 'Username',
                    iconData: Icons.person,
                    isAutoFocus: true,
                  ),
                  InputWidget(
                    controller: passwordController,
                    label: 'Password',
                    iconData: Icons.lock,
                    isObscure: true,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8, right: 8, top: 32),
                    child: Row(
                      children: [
                        ButtonWidget(
                          onPressed: () async {
                            try {
                              showDialog(
                                context: context,
                                builder: ((_) => AlertDialog(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          TextTitleWidget(text: 'Login'),
                                          SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(),
                                          ),
                                        ],
                                      ),
                                      content: const TextSubtitleWidget(
                                        text: 'Waiting for minutes',
                                      ),
                                    )),
                              );

                              final userResponse = await HttpUtils.login(
                                usernameController.text.trim(),
                                passwordController.text.trim(),
                              );

                              if (userResponse?.user != null) {
                                await prefs.setString(
                                  'user',
                                  jsonEncode(userResponse!.user!),
                                );

                                context.pop();
                                context.push(const HomePage());
                              } else {
                                context.showSnackBar('Cannot login');
                              }
                            } catch (e) {
                              context.showSnackBar(e.toString());
                            }
                          },
                          text: 'Login',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
