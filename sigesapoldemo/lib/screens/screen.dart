import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sigesapoldemo/models/paciente.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sigesapoldemo/provider/paciente_provider.dart';
import 'package:soundpool/soundpool.dart';

  class ListaPacientes extends StatefulWidget {
    const ListaPacientes({super.key});

    @override
    ListaPacientesState createState() => ListaPacientesState();
  }

  class ListaPacientesState extends State<ListaPacientes> {
    List<Paciente> _pacientes = [];

    TextEditingController _tvController = TextEditingController();
    TextEditingController _areaController = TextEditingController();
    Timer? _timer;
    Soundpool? _soundpool;
    int? _soundId;
    double _volume = 1.0;
    FlutterTts flutterTts = FlutterTts();  
    bool _botonPresionado = false;
    String newOption = '';
    bool isPlaying = true;
    List<Widget> actions = [];
    bool alreadyDelayed= false; //*

    Future<void> reproducirSonidoPitido() async {
      if (_soundpool != null) { //* SoundPool pckage
        if (_soundId != null) {
          await _soundpool!.stop(_soundId!);
        }
        ByteData soundData = await rootBundle.load("assets/beep.mp3");
        _soundId = await _soundpool!.load(soundData);
        _soundpool!.play(_soundId!, repeat: 0);
      }
    }
    
    //* TTS pckage
    Future<void> actualizarEstadoLlamada(String id, String tipo) async {
                        //! Setear url 
      final url = Uri.parse('http://urlserver/actualizar_estado_llamada/$id/$tipo');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar el estado de la llamada');
      }
    }

    Future<void> reproducirPacienteNombres(String mensajeVoz) async {
      
        if (mensajeVoz != null && mensajeVoz.isNotEmpty) {
        flutterTts.setLanguage('es-ES');
        await flutterTts.awaitSpeakCompletion(true); //! AWAIT DEL TTS
        await flutterTts.speak(mensajeVoz);
        flutterTts.setCompletionHandler(() {
          final pacProvider = Provider.of<PacienteProvider>(context, listen: false);
          actions = [];
          if (pacProvider.pacienteActualEstado == "0") {
            print(pacProvider.pacienteActualEstado);
              actions.add(Container(
              padding: EdgeInsets.all(10),
              child: Text(
                pacProvider.newOption,
              ),
            ));
          }
          
        });
        
      }
    }
    
   

    @override
    void initState() {
      super.initState();
      print("---------------------initStateee------------------------");
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        //if (_botonPresionado) {
        //  _obtenerPacientesDesdeApi();
        //  setState(() {});
        //}
        Future.delayed(const Duration(milliseconds: 500), () {
          _obtenerPacientesDesdeApi();
          _obtenerPacientes();
          //setState(() {});
        });
      });
    }

    @override
    void dispose() {
      super.dispose();
      _timer?.cancel();
    }

    Future<List<Paciente>> _obtenerPacientesDesdeApi() async {
      final tv = _tvController.text;
      final area = _areaController.text;
      //https://my-json-server.typicode.com/TheSmithsFanBoy/api_sigesapol/db
                //? http://urlserver/listar_clientes/$tv/$area
      final url = Uri.parse('https://my-json-server.typicode.com/TheSmithsFanBoy/api_sigesapol/db');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        _pacientes.clear();
        final responseJson = Pacientes.fromJson(decodedData);
        _pacientes.addAll(responseJson.results!);

        return responseJson.results!;

      } else {
        throw Exception('Failed');
      }
    }


    Future<void> _obtenerPacientes() async {
      final pacProvider = Provider.of<PacienteProvider>(context, listen: false);

      try {
        for (final paciente in _pacientes) {

          if (paciente.estadoLlamada == "0") {
            pacProvider.pacienteActualEstado = paciente.estadoLlamada!;
          }
           

          if(isPlaying = true){
            String texto = ''; 
            String nuevo = '';
            

            final consultorio = paciente.descripcionTv ?? paciente.consultorio;
            final pacienteOTicket = paciente.idAsegurado > 0
                            ? '${paciente.nombre} ${paciente.paterno} ${paciente.materno}' : paciente.ticket;
            final pacienteOTicketVoz = paciente.idAsegurado > 0 ? '${paciente.nombre} ${paciente.paterno} ${paciente.materno}':  paciente.ticketTv;

            if (paciente.estadoLlamada == '0') {
              //await actualizarEstadoLlamada(paciente.id, paciente.tipo); //! en esa petición ... se haria el seteo del paciente.estadoLlamada = 1 ???

              if (paciente.idAsegurado > 0) {
                texto = "Paciente $pacienteOTicketVoz, acercarse al $consultorio";
                print(texto);
              } else {
                texto = "Ticket $pacienteOTicketVoz, acercarse al $consultorio";
                print(texto);
              }
              const texto2 = "pitido-sonido";

              await Future.delayed(const Duration(milliseconds: 2000)); //Pausa de 1 segundo  //*Beep
              await reproducirPacienteNombres(texto2);

              //await reproducirSonidoPitido();        
              //await Future.delayed(const Duration(milliseconds: 1000)); //Pausa de 1 segundo  //* TTS
              await reproducirPacienteNombres(texto);


                print('reproducir nombre');
              //await Future.delayed(const Duration(milliseconds: 9000)); //Pausa de 1 segundo
              
              nuevo = "SI";
            }
            
            

            if (nuevo == "SI") {
              if (paciente.tipo == "tickets") {
                 newOption = '$pacienteOTicket:  ${paciente.consultorio}';
                  
                  if (paciente.estadoLlamada == "0") {
                    pacProvider.newOption = newOption;
                  }

              } else if (paciente.tipo == "citas"){
                newOption = '$pacienteOTicket : ${paciente.consultorio}';
                 if (paciente.estadoLlamada == "0") {
                    pacProvider.newOption = newOption;
                  }

              }
            } else {
              if (paciente.tipo == "tickets") {
                 newOption = '$pacienteOTicket : ${paciente.consultorio}';
                  if (paciente.estadoLlamada == "0") {
                    pacProvider.newOption = newOption;
                  }

              } else if (paciente.tipo == "citas"){
                newOption = '$pacienteOTicket : ${paciente.consultorio}';
                 if (paciente.estadoLlamada == "0") {
                    pacProvider.newOption = newOption;
                  }

              }
            }
            //! Falta usar provider para pintar un Text(newOption) ... abajo del boton
            //setState(() {});
            texto = '';
            nuevo = '';
            //setState(() {});
            isPlaying = false;

          }
          
        }
      } catch(e) { //!
        throw Exception('Error $e');
      }
    }


    @override
    Widget build(BuildContext context) {
      print('---------------------------build-------------------------------------');

      final pacProvider = Provider.of<PacienteProvider>(context);
      

      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                TextFormField(
                  controller: _tvController,
                  decoration: InputDecoration(labelText: 'TV'),
                ),
                TextFormField(
                  controller: _areaController,
                  decoration: InputDecoration(labelText: 'Área'),
                ),
                ElevatedButton(
                  onPressed: (){
                    _botonPresionado = true;
                    _obtenerPacientes();
                  },
                  child: Text('Obtener pacientes'),
                ),
                Center(child: Row(children: actions,)),
                Expanded(
                  child: FutureBuilder(
                    future: _obtenerPacientesDesdeApi(),
                    builder: (context, AsyncSnapshot<List<Paciente>> snapshot) { 

                      if(!snapshot.hasData){
                        return Center(child: CircularProgressIndicator());
                      } else {
                          return ListView.builder(
                        itemCount: _pacientes.length,
                        itemBuilder: (context, index) {
                          final paciente = _pacientes[index];
                          final pacienteColor = _pacientes[index].estadoLlamada;
                          return ListTile(
                            title: Text('${paciente.nombre} ${paciente.paterno}'),
                              subtitle: Text(
                                'Estado de llamada - > ${paciente.estadoLlamada!}',
                                style: TextStyle(
                                  color: pacienteColor == "0"   ? Colors.green : Colors.red
                                ),
                              ),
                            );
                          },
                        );
                      }
                      
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }