import 'package:flutter/material.dart';
import '/Model/constants.dart';
import '/Network/client.dart';
import '/Model/hash.dart';
import '../Interfaces/interaction_main.dart';
import '/Model/user_settings.dart';

class AddAccountScreen extends StatefulWidget {
  final InteractionMain interMain;

  const AddAccountScreen({Key? key, required this.interMain}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _passwordRepeat = TextEditingController();

  InteractionMain get interMain => widget.interMain;

  ///Try to add a new user
  ///
  ///If connection fails => Exception
  Future<void> addAccount() async {
    if (_formKey.currentState!.validate()) {
      UserSettings.setUsername(_username.text);
      Constants.username = _username.text;
      Constants.password = Hash.hashString(_password.text);
      try {
        await Client.request('add_account', {});
        Navigator.pop(context);
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
        title: const Text('Add account'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else if (value.characters.length < 8) {
                        return 'Password too small, min 8 characters';
                      }
                      return null;
                    },
                  ),
                ),
                /* PASSWORD 2 */
                Container(
                  width: 220,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: TextFormField(
                    controller: _passwordRepeat,
                    decoration: const InputDecoration(hintText: 'password'),
                    obscureText: true,
                    onFieldSubmitted: (value) => addAccount(),
                    validator: (value) {
                      if (_password.text != _passwordRepeat.text) {
                        return 'Passwords not identical';
                      }
                      return null;
                    },
                  ),
                ),
                /* CONNECT */
                OutlinedButton(
                  child: const Text('Add account'),
                  onPressed: () => addAccount(),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
