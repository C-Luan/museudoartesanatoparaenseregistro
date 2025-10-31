import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String? _avaliacaoSelecionada;
  bool _enviado = false;

  final List<Map<String, dynamic>> opcoes = [
    {'emoji': '😠', 'label': 'Péssima', 'value': 'péssimo', 'color': Colors.redAccent},
    {'emoji': '😕', 'label': 'Ruim', 'value': 'ruim', 'color': Colors.orange},
    {'emoji': '😐', 'label': 'Neutra', 'value': 'regular', 'color': Colors.amber},
    {'emoji': '🙂', 'label': 'Boa', 'value': 'boa', 'color': Colors.lightGreen},
    {'emoji': '😍', 'label': 'Excelente', 'value': 'muito_bom', 'color': Colors.green},
  ];

  Future<void> _enviarFeedback() async {
    if (_avaliacaoSelecionada == null) return;

    await FirebaseFirestore.instance.collection('feedbacks').add({
      'avaliacao': _avaliacaoSelecionada,
      'dataAvaliacao': DateTime.now().toIso8601String(),
    });

    setState(() => _enviado = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feedback da Visita")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _enviado
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 80),
                    SizedBox(height: 16),
                    Text(
                      "Obrigado pela sua avaliação!",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Como foi sua experiência no museu hoje?",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      children: opcoes.map((op) {
                        final selecionado = _avaliacaoSelecionada == op['value'];
                        return GestureDetector(
                          onTap: () => setState(() => _avaliacaoSelecionada = op['value']),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: selecionado ? op['color'] : Colors.grey.shade200,
                                radius: 32,
                                child: Text(op['emoji'], style: const TextStyle(fontSize: 28)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                op['label'],
                                style: TextStyle(
                                  color: selecionado ? op['color'] : Colors.black54,
                                  fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _avaliacaoSelecionada == null ? null : _enviarFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667C73),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Enviar avaliação", style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
