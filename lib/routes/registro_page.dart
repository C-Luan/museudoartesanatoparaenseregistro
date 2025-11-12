import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../services/visitor_service.dart'; // Mantido, assumindo que esta classe existe
import 'package:flutter/services.dart';
class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  String? nacionalidade = 'Brasileiro'; // Ajustado para 'Brasileiro'
  String estado = 'Pará'; // Simulação do valor inicial
  String cidade = 'Belém'; // Simulação do valor inicial
  int acompanhantes = 0;
  final int capacidadeMaxima = 1000;
  final int publicoAtual = 550; // Simulação do público atual

final List<String> paisesComBandeiras = [
  '🇧🇷 Brasil',
  '🇺🇸 Estados Unidos',
  '🇬🇧 Reino Unido',
  '🇫🇷 França',
  '🇩🇪 Alemanha',
  '🇨🇦 Canadá',
  '🇮🇹 Itália',
  '🇯🇵 Japão',
  '🇨🇳 China',
  '🇪🇸 Espanha',
  '🇦🇷 Argentina',
  '🇲🇽 México',
  '🇵🇹 Portugal',
  '🇨🇭 Suíça',
  '🇸🇪 Suécia',
  '🇳🇴 Noruega',
  '🇩🇰 Dinamarca',
  '🇫🇮 Finlândia',
  '🇦🇺 Austrália',
  '🇳🇿 Nova Zelândia',
  '🇮🇳 Índia',
  '🇮🇩 Indonésia',
  '🇸🇬 Singapura',
  '🇿🇦 África do Sul',
  '🇰🇷 Coreia do Sul',
  '🇷🇺 Rússia',
  '🇺🇦 Ucrânia',
  '🇮🇪 Irlanda',
  '🇳🇱 Países Baixos',
  '🇧🇪 Bélgica',
  '🇱🇺 Luxemburgo',
  '🇵🇱 Polônia',
  '🇨🇿 República Tcheca',
  '🇸🇰 Eslováquia',
  '🇭🇺 Hungria',
  '🇷🇴 Romênia',
  '🇧🇬 Bulgária',
  '🇷🇸 Sérvia',
  '🇭🇷 Croácia',
  '🇧🇦 Bósnia e Herzegovina',
  '🇸🇮 Eslovênia',
  '🇲🇰 Macedônia do Norte',
  '🇲🇹 Malta',
  '🇨🇾 Chipre',
  '🇹🇷 Turquia',
  '🇮🇱 Israel',
  '🇵🇸 Palestina',
  '🇸🇾 Síria',
  '🇮🇶 Iraque',
  '🇮🇷 Irã',
  '🇸🇦 Arábia Saudita',
  '🇦🇪 Emirados Árabes Unidos',
  '🇶🇦 Catar',
  '🇰🇼 Kuwait',
  '🇧🇭 Bahrein',
  '🇴🇲 Omã',
  '🇾🇪 Iêmen',
  '🇪🇬 Egito',
  '🇲🇦 Marrocos',
  '🇩🇿 Argélia',
  '🇹🇳 Tunísia',
  '🇱🇾 Líbia',
  '🇳🇬 Nigéria',
  '🇬🇭 Gana',
  '🇨🇮 Costa do Marfim',
  '🇸🇳 Senegal',
  '🇰🇪 Quênia',
  '🇪🇹 Etiópia',
  '🇹🇿 Tanzânia',
  '🇲🇿 Moçambique',
  '🇦🇴 Angola',
  '🇨🇩 República Democrática do Congo',
  '🇨🇲 Camarões',
  '🇿🇼 Zimbábue',
  '🇿🇲 Zâmbia',
  '🇺🇬 Uganda',
  '🇷🇼 Ruanda',
  '🇧🇼 Botsuana',
  '🇳🇦 Namíbia',
  '🇲🇼 Malawi',
  '🇲🇬 Madagascar',
  '🇸🇨 Seicheles',
  '🇨🇻 Cabo Verde',
  '🇹🇱 Timor-Leste',
  '🇵🇭 Filipinas',
  '🇹🇭 Tailândia',
  '🇻🇳 Vietnã',
  '🇲🇾 Malásia',
  '🇸🇻 El Salvador',
  '🇨🇷 Costa Rica',
  '🇵🇦 Panamá',
  '🇨🇱 Chile',
  '🇵🇪 Peru',
  '🇨🇴 Colômbia',
  '🇪🇨 Equador',
  '🇧🇴 Bolívia',
  '🇵🇾 Paraguai',
  '🇺🇾 Uruguai',
  '🇻🇪 Venezuela',
  '🇨🇺 Cuba',
  '🇩🇴 República Dominicana',
  '🇭🇹 Haiti',
  '🇬🇹 Guatemala',
  '🇭🇳 Honduras',
  '🇳🇮 Nicarágua',
  '🇧🇸 Bahamas',
  '🇧🇧 Barbados',
  '🇹🇹 Trinidad e Tobago',
  '🇧🇿 Belize',
  '🇸🇷 Suriname',
  '🇬🇾 Guiana',
  '🇫🇯 Fiji',
  '🇹🇴 Tonga',
  '🇼🇸 Samoa',
  '🇻🇺 Vanuatu',
  '🇰🇮 Kiribati',
  '🇹🇻 Tuvalu',
  '🇳🇷 Nauru',
  '🇲🇭 Ilhas Marshall',
  '🇸🇧 Ilhas Salomão',
  '🇵🇬 Papua-Nova Guiné',
  '🇲🇨 Mônaco',
  '🇱🇮 Liechtenstein',
  '🇦🇩 Andorra',
  '🇻🇦 Vaticano',
  '🇸🇲 San Marino',
  '🇱🇧 Líbano',
  '🇱🇦 Laos',
  '🇰🇭 Camboja',
  '🇲🇲 Myanmar',
  '🇳🇵 Nepal',
  '🇧🇹 Butão',
  '🇧🇳 Brunei',
  '🇲🇳 Mongólia',
  '🇰🇿 Cazaquistão',
  '🇺🇿 Uzbequistão',
  '🇹🇯 Tadjiquistão',
  '🇰🇬 Quirguistão',
  '🇦🇿 Azerbaijão',
  '🇬🇪 Geórgia',
  '🇦🇲 Armênia',
];


  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    super.dispose();
  }

  // Função auxiliar para o estilo dos campos de texto (TextFormField e Dropdown)
  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      hintText: label == "Nome Completo" ? "Digite seu nome completo" : null,
      prefixIcon: icon != null
          ? Icon(icon, color: Colors.grey.shade600, size: 20)
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF667C73), width: 2),
      ),
      // Remover labelText dentro do dropdown_search, se estiver usando um prefixIcon
      labelStyle: TextStyle(color: Colors.grey.shade600),
    );
  }

  // Cabeçalho de controle de visitação
  Widget _buildVisitionControlHeader() {
    double ocupacaoPercentual = publicoAtual / capacidadeMaxima;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: Colors.white, // Fundo branco do card principal
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ícone do museu (simulado)
              const Icon(
                Icons.account_balance,
                color: Colors.black54,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "Museu do Artesanato Paraense",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            "Controle de Visitação",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Text(
            "Registro de Visitantes",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          // Card de Público Atual
          // Card(
          //   elevation: 0,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(10),
          //     side: BorderSide(color: Colors.grey.shade300),
          //   ),
          //   margin: EdgeInsets.zero,
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             const Text(
          //               "Público atual",
          //               style: TextStyle(fontSize: 16, color: Colors.black87),
          //             ),
          //             Text(
          //               "$publicoAtual / $capacidadeMaxima",
          //               style: const TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ],
          //         ),
          //         const SizedBox(height: 10),
          //         LinearProgressIndicator(
          //           value: ocupacaoPercentual,
          //           backgroundColor: Colors.grey.shade200,
          //           valueColor: AlwaysStoppedAnimation<Color>(
          //             ocupacaoPercentual > 0.8
          //                 ? Colors.redAccent
          //                 : const Color(0xFF667C73),
          //           ),
          //           minHeight: 8,
          //           borderRadius: BorderRadius.circular(4),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
// Campo de acompanhantes digitável, numérico e responsivo
Widget _buildAcompanhantesCounter() {
  return LayoutBuilder(
    builder: (context, constraints) {
      bool isSmallScreen = constraints.maxWidth < 400;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Número de acompanhantes",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                // Botão de diminuir
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (acompanhantes > 0) acompanhantes--;
                    });
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  color:
                      acompanhantes > 0 ? Colors.redAccent : Colors.grey.shade400,
                  iconSize: 30,
                ),

                // Campo numérico
                Expanded(
                  child: TextFormField(
                    key: ValueKey(acompanhantes),
                    textAlign: TextAlign.center,
                    controller: TextEditingController(
                        text: acompanhantes.toString()), // Atualiza valor
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xFF667C73), width: 2),
                      ),
                    ),
                    inputFormatters: [
                      // Permite apenas números
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      setState(() {
                        acompanhantes = int.tryParse(value) ?? 0;
                      });
                    },
                    validator: (value) {
                      final n = int.tryParse(value ?? '');
                      if (n == null || n < 0) {
                        return 'Informe um número válido';
                      }
                      return null;
                    },
                  ),
                ),

                // Botão de aumentar
                IconButton(
                  onPressed: () {
                    setState(() => acompanhantes++);
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.green,
                  iconSize: 30,
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0), // Cor de fundo mais clara
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildVisitionControlHeader(),
              // Card de Registro de Nova Entrada
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    // Mantido o borderSide para dar o efeito de container da imagem
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Registrar Nova Entrada",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Nome
                          TextFormField(
                            controller: nomeController,
                            decoration: _inputDecoration("Nome Completo"),
                            validator: (v) => v!.isEmpty
                                ? "Informe o nome do visitante"
                                : null,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),

                          // Nacionalidade
                          DropdownSearch<String>(
                            items: (filter, infiniteScrollProps) => paisesComBandeiras,
                            selectedItem: nacionalidade,
                            onChanged: (value) =>
                                setState(() => nacionalidade = value),
                            popupProps: const PopupProps.modalBottomSheet(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  labelText: "Pesquisar país",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              showSelectedItems: true,
                            ),
                            //   dropdownDecoratorProps: DropDownDecoratorProps(
                            //     dropdownSearchDecoration: _inputDecoration(
                            //       "Nacionalidade",
                            //     ),
                            //   ),
                            //   validator: (v) => (v == null || v.isEmpty)
                            //       ? "Selecione um país"
                            //       : null,
                          ),
                          const SizedBox(height: 16),

                          if (nacionalidade == "Brasileiro") ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Estado (Metade da tela)
                                Expanded(
                                  child: DropdownSearch<String>(
                                    items: (filter, infiniteScrollProps) => [
                                      'Pará',
                                      'São Paulo',
                                      'Rio de Janeiro',
                                      'Outro',
                                    ],
                                    selectedItem: estado,
                                    onChanged: (v) =>
                                        setState(() => estado = v ?? ''),
                             
                                    popupProps: const PopupProps.menu(
                                      showSearchBox: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Cidade (Metade da tela)
                                Expanded(
                                  child: TextFormField(
                                    initialValue: cidade,
                                    decoration: _inputDecoration("Cidade"),
                                    onChanged: (v) => cidade = v,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Número de acompanhantes
                          _buildAcompanhantesCounter(),
                          const SizedBox(height: 16),

                          // E-mail (Opcional)
                          TextFormField(
                            controller: emailController,
                            decoration: _inputDecoration("Email (Opcional)"),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),

                          // Telefone (Opcional)
                          TextFormField(
                            controller: telefoneController,
                            decoration: _inputDecoration("Telefone (Opcional)"),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 30),

                          // Botão Registrar Entrada
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              // Removido o ícone para replicar o design
                              // icon: const Icon(Icons.check_circle_outline, size: 24),
                              child: const Text(
                                "Registrar entrada",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFF333333,
                                ), // Cor escura do design
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 3,
                              ),
                              onPressed: () async {
                                // Lógica de registro mantida
                                if (_formKey.currentState!.validate()) {
                                  await VisitorService.registrarVisitante(
                                    nomeController.text,
                                    nacionalidade ?? '',
                                    estado,
                                    cidade,
                                    acompanhantes,
                                    emailController.text,
                                    telefoneController.text,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Visitante registrado com sucesso!",
                                      ),
                                    ),
                                  );
                                  _formKey.currentState!.reset();
                                  setState(() {
                                    nacionalidade = 'Brasileiro';
                                    acompanhantes = 0;
                                    // Manter estado e cidade como padrão ou limpar
                                    estado = 'Pará';
                                    cidade = 'Belém';
                                    nomeController.clear();
                                    emailController.clear();
                                    telefoneController.clear();
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
