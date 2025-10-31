import 'package:cloud_firestore/cloud_firestore.dart';

class VisitorService {
  static Future<void> registrarVisitante(
    String nome,
    String nacionalidade,
    String estado,
    String cidade,
    int acompanhantes,
    String email,
    String telefone,
  ) async {
    await FirebaseFirestore.instance.collection('visitantes').add({
      'nome': nome,
      'nacionalidade': nacionalidade,
      'estado': estado,
      'cidade': cidade,
      'acompanhantes': acompanhantes,
      'email': email,
      'telefone': telefone,
      'dataEntrada': DateTime.now().toIso8601String(),
    });
  }
}
