

import 'package:flutter/cupertino.dart';



class PacienteProvider with ChangeNotifier {

  String _newOption="0";  //! DEBO SETEAR EL TEXTO DEL TICKET ANTES Q SE REDIBUJE POR COMPLETO 
                            //! EN EL 1er BUILD ..... Usar Widget Builder para fixear el problema

  String get newOption => _newOption;
  
  set newOption( String valor ){
    _newOption = valor;
    notifyListeners();
  }

  String _pacienteActualEstado="0"; 

  String get pacienteActualEstado => _pacienteActualEstado;
  
  set pacienteActualEstado( String valor ){
    _pacienteActualEstado = valor;
    notifyListeners();
  }


}