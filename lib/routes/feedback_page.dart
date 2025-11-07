import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String? _avaliacaoSelecionada;
  final observacaoController = TextEditingController();
  bool _enviado = false;

  final List<Map<String, dynamic>> opcoes = [
    {'emoji': '😠', 'label': 'Péssima', 'value': 'péssima', 'color': Color(0xFFE54848)},
    {'emoji': '😕', 'label': 'Ruim', 'value': 'ruim', 'color': Color(0xFFFFA34D)},
    {'emoji': '😐', 'label': 'Neutra', 'value': 'regular', 'color': Color(0xFFFAB82A)},
    {'emoji': '🙂', 'label': 'Boa', 'value': 'boa', 'color': Color(0xFFADD76F)},
    {'emoji': '😍', 'label': 'Excelente', 'value': 'excelente', 'color': Color(0xFF569E4C)},
  ];

  Future<void> _enviarFeedback() async {
    if (_avaliacaoSelecionada == null) return;

    await FirebaseFirestore.instance.collection('feedbacks').add({
      'avaliacao': _avaliacaoSelecionada,
      'observacao': observacaoController.text.trim(),
      'dataAvaliacao': DateTime.now().toIso8601String(),
    });

    setState(() {
      _enviado = true;
      observacaoController.clear();
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _enviado = false;
      _avaliacaoSelecionada = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _enviado ? _buildMensagemConfirmacao() : _buildFormulario(context),
        ),
      ),
    );
  }

  Widget _buildFormulario(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isSmall = height < 700;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Como foi sua experiência no museu hoje?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: isSmall ? 20 : 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),

              // Emojis — distribuídos em grid 3 + 2
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 14,
                children: opcoes.map((op) {
                  final selecionado = _avaliacaoSelecionada == op['value'];
                  return GestureDetector(
                    onTap: () => setState(() => _avaliacaoSelecionada = op['value']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: selecionado
                            ? (op['color'] as Color).withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selecionado
                              ? (op['color'] as Color)
                              : Colors.grey.shade300,
                          width: selecionado ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(op['emoji'], style: const TextStyle(fontSize: 38)),
                          const SizedBox(height: 3),
                          Text(
                            op['label'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: selecionado
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: selecionado
                                  ? op['color']
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 22),

              // Campo de observação
              TextField(
                controller: observacaoController,
                maxLines: 3,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  labelText: "Deixe um comentário (opcional)",
                  alignLabelWithHint: true,
                  fillColor: const Color(0xFFF5F5F5),
                  filled: true,
                  labelStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF1B3B36)),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Botão
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _avaliacaoSelecionada == null ? null : _enviarFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B3B36),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Enviar avaliação",
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMensagemConfirmacao() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("🌿", style: TextStyle(fontSize: 70, color: Color(0xFFA4B097))),
            SizedBox(height: 16),
            Text(
              "Obrigado pela sua visita!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Sua opinião é muito importante para nós.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 14,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
