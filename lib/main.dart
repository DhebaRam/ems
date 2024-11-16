import 'package:drift/native.dart';
import 'package:ems/ui/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'bloc/ems_bloc.dart';
import 'bloc/ems_event.dart';
import 'common/app_database/employee_database.dart';

void main() {
  // final database = EmployeeDatabase(NativeDatabase.memory());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final EmployeeDatabase database;
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmployeeBloc(EmployeeDatabase(NativeDatabase.memory()))
        ..add(LoadEmployees()),
      child: GestureDetector(onTap: () {
        if (FocusManager.instance.primaryFocus!.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      }, child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EMS App',
            theme: ThemeData(
                primarySwatch: Colors.indigo, canvasColor: Colors.transparent),
            //Our only screen/page we have
            home: const HomePage(),
          );
        },
      )),
    );
  }
}
