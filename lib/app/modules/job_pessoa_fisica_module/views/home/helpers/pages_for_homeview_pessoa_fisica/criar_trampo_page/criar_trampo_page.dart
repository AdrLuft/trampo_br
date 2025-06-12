import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/trampos_controller.dart';

class CriarPage extends StatefulWidget {
  const CriarPage({super.key});

  @override
  State<CriarPage> createState() => _CriarPageState();
}

class _CriarPageState extends State<CriarPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descricaoController = TextEditingController();
  final TramposController _tramposController = Get.find<TramposController>();
  final TextEditingController _telefoneController = TextEditingController();

  String? _tipoVagaSelecionado;

  final List<String> _tiposVaga = [
    'Bico',
    'PJ (Pessoa Jurídica)',
    'CLT (Consolidação das Leis do Trabalho)',
    'Freelancer',
    'Estágio',
    'Temporário',
    'Meio Período',
  ];

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  void _limparFormulario() {
    _descricaoController.clear();
    setState(() {
      _tipoVagaSelecionado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade400, Colors.teal.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(Icons.work_outline, size: 40, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      'Criar Novo Trampo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Preencha os dados abaixo',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Dropdown Tipo de Vaga
              Center(
                child: Text(
                  'Tipo de Vaga',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _tipoVagaSelecionado,
                    hint: const Text('Selecione o tipo de vaga'),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    items:
                        _tiposVaga.map((String tipo) {
                          return DropdownMenuItem<String>(
                            value: tipo,
                            child: Row(
                              children: [
                                Icon(
                                  _getIconForTipo(tipo),
                                  size: 20,
                                  color: Colors.teal,
                                ),
                                const SizedBox(width: 8),
                                Text(tipo),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (String? novoTipo) {
                      setState(() {
                        _tipoVagaSelecionado = novoTipo;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Contato',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                ),
                child: Row(
                  children: [
                    // Prefixo do país
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.phone, color: Colors.teal),
                          SizedBox(width: 4),
                          Text(
                            '+55',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Campo do telefone
                    Expanded(
                      child: TextFormField(
                        controller: _telefoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: '(00) 00000-0000',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe um telefone para contato';
                          }
                          // Remove caracteres não numéricos para validação
                          String numbersOnly = value.replaceAll(
                            RegExp(r'[^0-9]'),
                            '',
                          );
                          if (numbersOnly.length < 10 ||
                              numbersOnly.length > 11) {
                            return 'Telefone deve ter 10 ou 11 dígitos';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Campo Descrição
              Center(
                child: Text(
                  'Descrição da Vaga',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descricaoController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText:
                      'Descreva detalhadamente o trabalho, requisitos, valor, horários, etc.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor:
                      isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, descreva a vaga';
                  }
                  if (value.trim().length < 20) {
                    return 'Descrição deve ter pelo menos 20 caracteres';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _limparFormulario,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.teal),
                      ),
                      child: const Text(
                        'Limpar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            _tramposController.isLoading.value
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate() &&
                                      _tipoVagaSelecionado != null) {
                                    _tramposController.createTrampo(
                                      descricao: _descricaoController.text,
                                      tipoVaga: _tipoVagaSelecionado!,
                                      telefone: _telefoneController.text,
                                      createTrampoNome: '',
                                      email: '',
                                      userAddress: '',
                                    );
                                    _limparFormulario();
                                  } else if (_tipoVagaSelecionado == null) {
                                    Get.snackbar(
                                      'Atenção',
                                      'Selecione um tipo de vaga.',
                                    );
                                  }
                                },
                        child:
                            _tramposController.isLoading.value
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                )
                                : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_circle),
                                    SizedBox(width: 8),
                                    Text(
                                      'Criar Trampo',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForTipo(String tipo) {
    switch (tipo) {
      case 'Bico':
        return Icons.handyman;
      case 'PJ (Pessoa Jurídica)':
        return Icons.business;
      case 'CLT (Consolidação das Leis do Trabalho)':
        return Icons.work;
      case 'Freelancer':
        return Icons.laptop;
      case 'Estágio':
        return Icons.school;
      case 'Temporário':
        return Icons.schedule;
      case 'Meio Período':
        return Icons.access_time;
      default:
        return Icons.work_outline;
    }
  }
}
