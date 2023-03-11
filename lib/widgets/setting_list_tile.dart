import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';

class SettingListTile extends StatefulWidget {
  const SettingListTile({
    super.key,
  });

  @override
  State<SettingListTile> createState() => _SettingListTileState();
}

class _SettingListTileState extends State<SettingListTile> {
  PhoneStateStatus phoneStateStatus = PhoneStateStatus.NOTHING;
  bool _autoCall = false;
  bool _granted = false;

  @override
  void initState() {
    super.initState();
    setStream();
  }

  void setStream() {
    PhoneState.phoneStateStream.listen((event) {
      setState(() {
        if (event != null) phoneStateStatus = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Automatic record all incoming calls'),
            value: _autoCall,
            onChanged: (value) async {
              setState(() => _autoCall = value);
              if (value) {
                var status = await Permission.phone.request();
                switch (status) {
                  case PermissionStatus.denied:
                  case PermissionStatus.permanentlyDenied:
                  case PermissionStatus.limited:
                  case PermissionStatus.restricted:
                    _granted = false;
                    break;
                  case PermissionStatus.granted:
                    _granted = true;
                }
              }
            },
          ),
          const SizedBox(
            height: 300,
          ),
          TextButton(
              onPressed: () {},
              child: _granted
                  ? Text('$phoneStateStatus')
                  : const Text('Permission denied')),
        ],
      ),
    );
  }
}
