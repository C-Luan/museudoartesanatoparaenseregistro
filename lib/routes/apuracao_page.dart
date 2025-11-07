import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:intl/intl.dart';

class ApuracaoPage extends StatefulWidget {
  const ApuracaoPage({super.key});

  @override
  State<ApuracaoPage> createState() => _ApuracaoPageState();
}

class _ApuracaoPageState extends State<ApuracaoPage> {
  final _formKey = GlobalKey<FormState>();

  String? empreendedorSelecionado;
  String? empreendedorId;
  bool _cadastrandoNovo = false;

  String nomeNovoEmpreendedor = '';
  String barraca = '';

  final dataController = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  final pecasVendidasController = TextEditingController();
  final totalVendasController = TextEditingController();
  final pecasEncomendadasController = TextEditingController();
  final totalEncomendadoController = TextEditingController();

  Future<List<Map<String, dynamic>>> _buscarEmpreendedores() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('empreendedores')
          .orderBy('nome')
          .get();

      return snapshot.docs.map((d) {
        final data = d.data();
        return {
          'id': d.id,
          'nome': (data['nome'] ?? '').toString(),
          'barraca': (data['barraca'] ?? '').toString(),
        };
      }).toList();
    } catch (e) {
      debugPrint('Erro ao buscar empreendedores: $e');
      return [];
    }
  }

  Future<void> _salvarApuracao() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (_cadastrandoNovo) {
        final novo = await FirebaseFirestore.instance
            .collection('empreendedores')
            .add({'nome': nomeNovoEmpreendedor, 'barraca': barraca});
        empreendedorId = novo.id;
        empreendedorSelecionado = nomeNovoEmpreendedor;
      }

      // 🕒 Converter data digitada (dd/MM/yyyy) → Timestamp
      DateTime dataApuracao;
      try {
        dataApuracao = DateFormat('dd/MM/yyyy').parse(dataController.text);
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Formato de data inválido. Use dd/MM/yyyy."),
          ),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('apuracoes').add({
        'empreendedorId': empreendedorId,
        'empreendedorNome': empreendedorSelecionado ?? nomeNovoEmpreendedor,
        'data': Timestamp.fromDate(dataApuracao), // 🔥 agora como Timestamp
        'pecasVendidas': int.tryParse(pecasVendidasController.text) ?? 0,
        'totalVendas': _parseMoney(totalVendasController.text),
        'totalEncomendado': _parseMoney(totalEncomendadoController.text),
        'pecasEncomendadas':
            int.tryParse(pecasEncomendadasController.text) ?? 0,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Apuração registrada com sucesso!")),
      );

      _formKey.currentState!.reset();
      setState(() {
        empreendedorSelecionado = null;
        empreendedorId = null;
        _cadastrandoNovo = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao salvar: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF3D3D3D),
        automaticallyImplyLeading: false,
        elevation: 0.5,
        title: Row(
          children: const [
            Icon(Icons.store, color: Color(0xFF4F3222)),
            SizedBox(width: 8),
            Text(
              "Museu do Artesanato Paraense",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF3D3D3D),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9).withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.person_outline, color: Color(0xFF3D3D3D)),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Apuração de Vendas",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF3D3D3D),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Registre os dados de vendas e encomendas do dia.",
                style: TextStyle(fontSize: 14, color: Color(0xFF3D3D3D)),
              ),
              const SizedBox(height: 24),

              // --- Empreendedor ---
              Container(
                decoration: _cardDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Empreendedor(a)"),
                    const SizedBox(height: 12),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _buscarEmpreendedores(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final empreendedores = snapshot.data!;
                        return DropdownButtonFormField<String>(
                          decoration: _inputDecoration("Selecione ou cadastre"),
                          value: empreendedorSelecionado,
                          items: [
                            ...empreendedores.map(
                              (e) => DropdownMenuItem(
                                value: e['nome'],
                                child: Text(
                                  "${e['nome']} - Barraca ${e['barraca']}",
                                ),
                              ),
                            ),
                            const DropdownMenuItem(
                              value: 'novo',
                              child: Text("Cadastrar novo empreendedor"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == 'novo') {
                              setState(() {
                                _cadastrandoNovo = true;
                                empreendedorSelecionado = null;
                              });
                            } else {
                              setState(() {
                                empreendedorSelecionado = value;
                                _cadastrandoNovo = false;
                              });
                            }
                          },
                        );
                      },
                    ),
                    if (_cadastrandoNovo) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: _inputDecoration(
                                "Nome do Empreendedor",
                              ),
                              onChanged: (v) => nomeNovoEmpreendedor = v,
                              validator: (v) => _cadastrandoNovo && v!.isEmpty
                                  ? "Informe o nome"
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              decoration: _inputDecoration("Nº da Barraca"),
                              onChanged: (v) => barraca = v,
                              validator: (v) => _cadastrandoNovo && v!.isEmpty
                                  ? "Informe a barraca"
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- Data (digitável) ---
              _sectionCard(
                "Data da Apuração",

                TextFormField(
                  controller: dataController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    MaskedInputFormatter('##/##/####'), // 🧩 Máscara da data
                  ],
                  decoration: _inputDecoration("Data da Apuração (dd/mm/aaaa)"),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Informe a data";
                    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                    if (!regex.hasMatch(v))
                      return "Formato inválido (use dd/mm/aaaa)";
                    try {
                      DateFormat('dd/MM/yyyy').parseStrict(v);
                      return null;
                    } catch (_) {
                      return "Data inválida";
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),

              // --- Vendas ---
              _sectionCard(
                "Vendas do Dia",
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: pecasVendidasController,
                        decoration: _inputDecoration("Nº de peças vendidas"),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: totalVendasController,
                        decoration: _inputDecoration("Total apurado (R\$)"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CurrencyInputFormatter(
                            leadingSymbol: '',
                            thousandSeparator: ThousandSeparator.Period,
                            mantissaLength: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- Encomendas ---
              _sectionCard(
                "Encomendas",
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: pecasEncomendadasController,
                        decoration: _inputDecoration(
                          "Nº de peças encomendadas",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: totalEncomendadoController,
                        decoration: _inputDecoration("Total apurado (R\$)"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CurrencyInputFormatter(
                            leadingSymbol: '',
                            thousandSeparator: ThousandSeparator.Period,
                            mantissaLength: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    "Salvar Apuração",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F3222),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _salvarApuracao,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Conversor de moeda BR → double
  double _parseMoney(String value) {
    final clean = value
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .replaceAll('R\$', '')
        .trim();
    return double.tryParse(clean) ?? 0.0;
  }

  // Reuso de UI
  Widget _sectionCard(String title, Widget child) => Container(
    decoration: _cardDecoration(),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_sectionTitle(title), const SizedBox(height: 12), child],
    ),
  );

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    border: Border.all(color: const Color(0xFFD9D9D9)),
    borderRadius: BorderRadius.circular(12),
  );

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xFF3D3D3D),
      fontSize: 16,
    ),
  );

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Color(0xFF3D3D3D), fontSize: 14),
    filled: true,
    fillColor: const Color(0xFFD9D9D9),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF4F3222)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
  );
}
