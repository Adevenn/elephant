import 'package:flutter/material.dart';
import 'package:my_netia_client/View/Interfaces/interaction_to_view_controller.dart';
import '/Model/user_settings.dart';

class OptionScreen extends StatefulWidget {
  final InteractionToViewController interView;

  const OptionScreen({Key? key, required this.interView}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OptionState();
}

class _OptionState extends State<OptionScreen> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<bool>>(
        future:
            Future.wait([UserSettings.getReadOnly(), UserSettings.getTheme()]),
        builder: (BuildContext context, AsyncSnapshot<List<bool>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Read only :'),
                    Switch(
                      value: snapshot.data![0],
                      onChanged: (value) {
                        UserSettings.setReadOnly(value);
                        setState(() => {});
                      },
                    )
                  ],
                ),
                const Divider(
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bedtime),
                    Switch(
                      value: snapshot.data![1],
                      onChanged: (value) {
                        UserSettings.setTheme(value);
                        setState(() => {});
                      },
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                ElevatedButton(
                  onPressed: () => widget.interView.gotoLoginScreen(context),
                  child: const Text('Change Server'),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting ...'),
                  )
                ],
              ),
            );
          }
        });
  }
}
