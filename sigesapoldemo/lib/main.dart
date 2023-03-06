import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigesapoldemo/provider/paciente_provider.dart';
import 'package:sigesapoldemo/screens/home_page.dart';
import 'package:sigesapoldemo/screens/tts_package_demo.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (_) =>  PacienteProvider() ),
      ],
      child: MaterialApp(
        title: 'Material App',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: HomePage()
      ),
    );
  }
}