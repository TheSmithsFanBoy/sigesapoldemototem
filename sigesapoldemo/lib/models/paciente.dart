class Pacientes {
  List<Paciente>? results;

  Pacientes({this.results});

  Pacientes.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Paciente>[];
      json['results'].forEach((v) {
        results!.add(new Paciente.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Paciente {
  String? id;
  String? nombre;
  String? paterno;
  String? materno;
  String? descripcionTv;
  String? consultorio;
  late int idAsegurado;
  String? ticket;
  String? ticketTv;
  String? tipo;
  String? estadoLlamada;

  Paciente(
      {this.id,
      this.nombre,
      this.paterno,
      this.materno,
      this.descripcionTv,
      this.consultorio,
      required this.idAsegurado,
      this.ticket,
      this.ticketTv,
      this.tipo,
      this.estadoLlamada});

  Paciente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    paterno = json['paterno'];
    materno = json['materno'];
    descripcionTv = json['descripcion_tv'];
    consultorio = json['consultorio'];
    idAsegurado = json['id_asegurado'];
    ticket = json['ticket'];
    ticketTv = json['ticket_tv'];
    tipo = json['tipo'];
    estadoLlamada = json['estado_llamada'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    data['paterno'] = this.paterno;
    data['materno'] = this.materno;
    data['descripcion_tv'] = this.descripcionTv;
    data['consultorio'] = this.consultorio;
    data['id_asegurado'] = this.idAsegurado;
    data['ticket'] = this.ticket;
    data['ticket_tv'] = this.ticketTv;
    data['tipo'] = this.tipo;
    data['estado_llamada'] = this.estadoLlamada;
    return data;
  }
}