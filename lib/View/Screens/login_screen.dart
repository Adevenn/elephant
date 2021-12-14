import 'package:flutter/material.dart';
import '/Model/user_settings.dart';
import '../Interfaces/interaction_view.dart';

class LoginScreen extends StatefulWidget {
  final InteractionMain _interView;
  const LoginScreen(this._interView, {Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen>{
  InteractionMain get interView => widget._interView;
  final _formKey = GlobalKey<FormState>();
  RegExp ipv4Reg = RegExp(r'^(?!0)(?!.*\.$)((1?\d?\d|25[0-5]|2[0-4]\d)(\.|$)){4}$', caseSensitive: false, multiLine: false);
  final _ip = TextEditingController();
  final _port = TextEditingController();
  final _database = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState(){
    super.initState();
    defaultValues();
  }

  Future<void> defaultValues() async{
    _ip.text = await UserSettings.getIp();
    _port.text = (await UserSettings.getPort()).toString();
    _database.text = await UserSettings.getDatabase();
    _username.text = await UserSettings.getUsername();
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /* IP */
                  Container(
                    width: 220,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _ip,
                      decoration: const InputDecoration(hintText: 'ip address : 127.0.0.1'),
                      validator: (value){
                        if(!ipv4Reg.hasMatch(value!)) {
                          return 'Please enter a correct ip';
                        }
                        return null;
                      },
                    ),
                  ),
                  /* PORT */
                  Container(
                    width: 220,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _port,
                      decoration: const InputDecoration(hintText: 'port'),
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  /* DATABASE */
                  Container(
                    width: 220,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _database,
                      decoration: const InputDecoration(hintText: 'database'),
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  /* USERNAME */
                  Container(
                    width: 220,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _username,
                      decoration: const InputDecoration(hintText: 'username'),
                      validator: (value){
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
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  /* CONNECT */
                  OutlinedButton(
                    child: const Text('Connect'),
                    onPressed: () async{
                      if(_formKey.currentState!.validate()) {
                        UserSettings.setIp(_ip.text);
                        UserSettings.setPort(int.parse(_port.text));
                        UserSettings.setDatabase(_database.text);
                        UserSettings.setUsername(_username.text);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Connecting ...'),
                            duration: Duration(seconds: 1),
                          )
                        );
                        try{
                          await interView.testConnection(_ip.text, int.parse(_port.text), _database.text, _username.text, _password.text);
                          interView.gotoMainScreen(context);
                        }
                        catch(e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$e'))
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ),
      )
    );
  }
}