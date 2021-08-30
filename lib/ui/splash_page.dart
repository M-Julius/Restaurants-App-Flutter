import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restaurant_submissions/common/navigation.dart';
import 'package:restaurant_submissions/ui/list_restaurant_page.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/splash_page';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    /// timer for after 3 seconds replace page
    Timer(Duration(seconds: 3),
        () => Navigation.replacement(ListRestaurantPage.routeName));

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/splash.svg',
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: MediaQuery.of(context).size.height * 0.50,
                ),
                Text(
                  'Restaurant App',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
