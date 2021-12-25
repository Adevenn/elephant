import 'package:flutter/material.dart';
import 'package:my_netia_client/View/Interfaces/interaction_to_controller.dart';
import '/Model/user_settings.dart';

class OptionScreen extends StatefulWidget{

  final InteractionToController interController;

  const OptionScreen({Key? key, required this.interController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OptionState();
}

class _OptionState extends State<OptionScreen>{

  late bool theme;
  late bool isReadOnly;

  @override
  void initState() {
    super.initState();
    defaultValues();
  }

  Future<void> defaultValues() async{
    theme = await UserSettings.getTheme();
    isReadOnly = await UserSettings.getReadOnly();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Read only :'),
            Switch(
              value: isReadOnly,
              onChanged: (value) async {
                await UserSettings.setReadOnly(value);
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
              value: theme,
              onChanged: (value) async {
                await UserSettings.setTheme(value);
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
          onPressed: () => widget.interController.gotoLoginScreen(context),
          child: const Text('Change Server'),
        ),
      ],
    );
  }
}