import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigesapoldemo/provider/paciente_provider.dart';
import 'package:sigesapoldemo/screens/home_screen.dart';
import 'package:sigesapoldemo/screens/list_tiles_usuarios.dart';
import 'package:sigesapoldemo/screens/screen.dart';
import 'package:sigesapoldemo/screens/tts.dart';

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
        home: ListaPacientes()
      ),
    );
  }
}