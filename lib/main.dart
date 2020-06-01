import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'homepage.dart';
import 'phno.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'MITS staff Attendance',
      routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => MyHome(),
        '/loginpage': (BuildContext context) => MyApp(),
        '/firstpage': (BuildContext context) => LoginPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyApps(title: 'MITS staff Attendance')
     
    );
    
  }
}
class MyApps extends StatefulWidget {  
  MyApps({Key key, this.title}) : super(key: key);  
  final String title;  
  
  @override  
  _MyAppsState createState() => _MyAppsState();  
}  
  
class _MyAppsState extends State<MyApps> {  
  // 2. created object of localauthentication class  
  final LocalAuthentication _localAuthentication = LocalAuthentication();  
  // 3. variable for track whether your device support local authentication means  
  //    have fingerprint or face recognization sensor or not  
  bool _hasFingerPrintSupport = false;  
  // 4. we will set state whether user authorized or not  
  String _authorizedOrNot = "Not Authorized";  
  // 5. list of avalable biometric authentication supports of your device will be saved in this array  
  List<BiometricType> _availableBuimetricType = List<BiometricType>();  
  
  Future<void> _getBiometricsSupport() async {  
    // 6. this method checks whether your device has biometric support or not  
    bool hasFingerPrintSupport = false;  
    try {  
      hasFingerPrintSupport = await _localAuthentication.canCheckBiometrics;  
    } catch (e) {  
      print(e);  
    }  
    if (!mounted) return;  
    setState(() {  
      _hasFingerPrintSupport = hasFingerPrintSupport;  
    });  
  }  
  
  Future<void> _getAvailableSupport() async {  
    // 7. this method fetches all the available biometric supports of the device  
    List<BiometricType> availableBuimetricType = List<BiometricType>();  
    try {  
      availableBuimetricType =  
          await _localAuthentication.getAvailableBiometrics();  
    } catch (e) {  
      print(e);  
    }  
    if (!mounted) return;  
    setState(() {  
      _availableBuimetricType = availableBuimetricType;  
    });  
  }  
  
  Future<void> _authenticateMe() async {  
    // 8. this method opens a dialog for fingerprint authentication.  
    //    we do not need to create a dialog nut it popsup from device natively.  
    bool authenticated = false;  
    try {  
      authenticated = await _localAuthentication.authenticateWithBiometrics(  
        localizedReason: "Authenticate for Testing", // message for dialog  
        useErrorDialogs: true,// show error in dialog  
        stickyAuth: true,// native process  
      );  
    } catch (e) {  
      print(e);  
    }  
    if (!mounted) return;  
    setState(() {  
      authenticated ? Navigator.of(context).pushReplacementNamed('/firstpage') : Navigator.of(context).pushReplacementNamed('/loginpage');  
    });  
  }  
  
  @override  
  void initState() {  
    _getBiometricsSupport();  
    _getAvailableSupport();  
    super.initState();  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: Text(widget.title),  
      ),  
      body: Center(  
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,  
          children: <Widget>[  
           // Text("Has FingerPrint Support : $_hasFingerPrintSupport"),  
           // Text(  
              //  "List of Biometrics Support: ${_availableBuimetricType.toString()}"),  
          //  Text("Authorized : $_authorizedOrNot"),  
            RaisedButton(  
              child: Text("Verify it's you"), 
              textColor: Colors.white,
              elevation: 10,
              shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
             ),
              color: Colors.red,
              onPressed: _authenticateMe,  
            ),  
          ],  
        ),  
      ),  
    );  
  }  
}  
