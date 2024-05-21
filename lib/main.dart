import 'package:flutter/material.dart';
import 'package:wear_counter/screens/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wear_counter/shared/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _permissionsGranted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _permissionsGranted
              ? const Home()
              : _buildPermissionDeniedScreen(),
    );
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    if (statuses[Permission.camera] == PermissionStatus.permanentlyDenied ||
        statuses[Permission.storage] == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }

    setState(() {
      _permissionsGranted =
          statuses[Permission.camera] == PermissionStatus.granted &&
              statuses[Permission.storage] == PermissionStatus.granted;
      _isLoading = false;
    });
  }

  Widget _buildPermissionDeniedScreen() {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Permissions are required to use this app.",
              style: TextStyle(fontSize: 20, color: Colors.white54),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(tileColor),
              ),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                _requestPermissions();
              },
              child: const Text("Grant Permissions"),
            ),
          ],
        ),
      ),
    );
  }
}
