import 'package:flutter/material.dart';

class Options extends StatefulWidget{
  final BuildContext context;
  const Options(this.context, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OptionState();
}

class _OptionState extends State<Options>{
  static bool _themeIsDark = false;
  static bool _isReadOnly = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Read only :"),
            Switch(
              value: _isReadOnly,
              onChanged: (value){
                setState(() => _isReadOnly = value);
              }
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
              value: _themeIsDark,
              onChanged: (value) {
                setState(() {
                  _themeIsDark = value;
                });
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
          onPressed: () { },
          child: const Text("Change Server"),
        ),
      ],
    );
  }
}