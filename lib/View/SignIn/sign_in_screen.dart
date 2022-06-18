import 'package:flutter/material.dart';
import '/Model/constants.dart';
import '/Network/client.dart';
import '/View/AddAccount/add_account_screen.dart';
import '/Model/hash.dart';
import '../Interfaces/interaction_main.dart';
import '/View/Interfaces/interaction_view.dart';
import '/Model/user_settings.dart';

class SignInScreen extends StatefulWidget {
  final InteractionMain interMain;
  final InteractionView interView;

  const SignInScreen(
      {required this.interMain, required this.interView, Key? key})
      : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<SignInScreen> {
  InteractionMain get interMain => widget.interMain;

  InteractionView get interView => widget.interView;
  final _formKey = GlobalKey<FormState>();
  final RegExp ipv4Reg = RegExp(
      r'^(?!0)(?!.*\.$)((1?\d?\d|25[0-5]|2[0-4]\d)(\.|$)){4}$',
      caseSensitive: false,
      multiLine: false);
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    defaultValues();
  }

  Future<void> defaultValues() async {
    _username.text = await UserSettings.getUsername();
    setState(() => {});
  }

  ///Try to login
  ///
  ///If connection fails => Exception
  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      UserSettings.setUsername(_username.text);
      Constants.username = _username.text;
      Constants.password = Hash.hashString(_password.text);
      try {
        await Client.request('sign_in', {});
        interView.gotoCellScreen(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Sign in'),
            ),
            body: Center(
                child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /* USERNAME */
                    Container(
                      width: 220,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _username,
                        decoration: const InputDecoration(hintText: 'username'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    /* PASSWORD */
                    Container(
                      width: 220,
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: TextFormField(
                        controller: _password,
                        decoration: const InputDecoration(hintText: 'password'),
                        obscureText: true,
                        onFieldSubmitted: (value) => signIn(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    /* CONNECT */
                    OutlinedButton(
                      child: const Text('Sign in'),
                      onPressed: () => signIn(),
                    ),
                  ],
                ),
              ),
            )),
            floatingActionButton: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddAccountScreen(interMain: interMain)));
                },
                child: const Text('Add account'))));
  }
}
