import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SizedBox(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/bsb_logo.png'),
            Text(
              'Checking Authentication',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.pink,
            ),
          ],
        )),
      ),
    );
  }
}
