import 'app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      runApp(
        BreakingBad(
          appRoute: AppRoute(),
        ),
      );
    },
    blocObserver: MyBlocObserver(),
  );
}

class BreakingBad extends StatelessWidget {
  final AppRoute appRoute;
  const BreakingBad({Key? key, required this.appRoute}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoute().generateRoute,
    );
  }
}
