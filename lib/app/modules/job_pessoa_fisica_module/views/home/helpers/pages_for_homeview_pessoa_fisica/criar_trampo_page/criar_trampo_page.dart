import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/trampos_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/pages_for_homeview_pessoa_fisica/criar_trampo_page/criar_trampo_helpers/criar_trampo_page_helpers.dart';

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
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _salarioController = TextEditingController();
  final TextEditingController _requisitosController = TextEditingController();
  final TextEditingController _exigenciasController = TextEditingController();
  final TextEditingController _valorizadoController = TextEditingController();
  final TextEditingController _benificiosController = TextEditingController();

  // Listas para armazenar as tags
  final List<String> _exigencias = [];
  final List<String> _valorizados = [];
  final List<String> _beneficios = [];
  final List<String> _requisitos = [];

  String? _tipoVagaSelecionado;
  String? _modalidadeSelecionada;
  bool _salarioACombinar = false;

  final List<String> _tiposVaga = [
    'Bico',
    'PJ',
    'CLT',
    'Freelancer',
    'Estágio',
    'Temporário',
    'Meio Período',
  ];

  final List<String> _modalidades = ['Presencial', 'Híbrido', 'Remoto'];

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  void _limparFormulario() {
    _descricaoController.clear();
    _telefoneController.clear();
    _tituloController.clear();
    _salarioController.clear();
    _exigenciasController.clear();
    _valorizadoController.clear();
    _benificiosController.clear();
    _requisitos.clear();
    setState(() {
      _tipoVagaSelecionado = null;
      _modalidadeSelecionada = null;
      _exigencias.clear();
      _valorizados.clear();
      _beneficios.clear();
    });
  }

  // Função para adicionar um item à lista
  void _adicionarItem(List<String> lista, TextEditingController controller) {
    String texto = controller.text.trim();
    if (texto.isNotEmpty && !lista.contains(texto)) {
      setState(() {
        lista.add(texto);
        controller.clear();
      });
    }
  }

  // Função para remover um item da lista
  void _removerItem(List<String> lista, int index) {
    setState(() {
      lista.removeAt(index);
    });
  }

  Widget _buildTagInput(
    String title,
    String hintText,
    TextEditingController controller,
    List<String> items,
    Function(List<String>, TextEditingController) onAdd,
    Function(List<String>, int) onDelete,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor:
                      isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                ),
                onFieldSubmitted: (_) => onAdd(items, controller),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => onAdd(items, controller),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 8),
        items.isNotEmpty
            ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      isDark
                          ? Colors.white.withAlpha(38)
                          : Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
                color:
                    isDark
                        ? Colors.white.withAlpha(15)
                        : Theme.of(context).colorScheme.surface,
              ),
              child: CriarTrampoPageHelpers.buildChips(
                items,
                (index) => onDelete(items, index),
              ),
            )
            : const SizedBox.shrink(),
        const SizedBox(height: 16),
      ],
    );
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
                    colors: [
                      Theme.of(context).colorScheme.primary.withAlpha(50),
                      Theme.of(context).colorScheme.primary,
                    ],
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
                child: Column(
                  children: [
                    Icon(
                      Icons.work_outline,
                      size: 40,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Criar Novo Trampo',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Preencha os dados abaixo',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withAlpha(190),
                      ),
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
                  border: Border.all(
                    color:
                        isDark
                            ? Colors.white.withAlpha(38)
                            : Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color:
                      isDark
                          ? Colors.white.withAlpha(15)
                          : Theme.of(context).colorScheme.surface,
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
                                  CriarTrampoPageHelpers.getIconForTipo(tipo),
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
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
                  'Modalidade de Trabalho',
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
                    value: _modalidadeSelecionada,
                    hint: const Text('Selecione a modalidade'),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    items:
                        _modalidades.map((String modalidade) {
                          return DropdownMenuItem<String>(
                            value: modalidade,
                            child: Row(
                              children: [
                                Icon(
                                  CriarTrampoPageHelpers.getIconForModalidade(
                                    modalidade,
                                  ),
                                  size: 20,
                                  color: const Color(0xFF6366F1),
                                ),
                                const SizedBox(width: 8),
                                Text(modalidade),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (String? novaModalidade) {
                      setState(() {
                        _modalidadeSelecionada = novaModalidade;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child: Text(
                  'Valor da Remuneração',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Switch para "A combinar"
              Row(
                children: [
                  Text(
                    'Valor a combinar',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: _salarioACombinar,
                    activeColor: const Color(0xFF6366F1),
                    onChanged: (value) {
                      setState(() {
                        _salarioACombinar = value;
                        if (value) {
                          // Limpa o campo de salário quando seleciona "A combinar"
                          _salarioController.clear();
                        }
                      });
                    },
                  ),
                ],
              ),

              if (!_salarioACombinar) ...[
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      // Prefixo de moeda
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
                            Icon(
                              Icons.attach_money,
                              color: const Color(0xFF6366F1),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'R\$',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Campo do salário
                      Expanded(
                        child: TextFormField(
                          controller: _salarioController,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            hintText: '0,00',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                          ),
                          validator:
                              _salarioACombinar
                                  ? null
                                  : (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Informe o valor da remuneração';
                                    }

                                    // Verifica se é um número válido
                                    try {
                                      // Substitui vírgula por ponto para permitir valor decimal
                                      final valorFormatado = value
                                          .replaceAll('.', '')
                                          .replaceAll(',', '.');
                                      final valor = double.parse(
                                        valorFormatado,
                                      );
                                      if (valor <= 0) {
                                        return 'O valor deve ser maior que zero';
                                      }
                                    } catch (e) {
                                      return 'Informe um valor válido';
                                    }
                                    return null;
                                  },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
              const SizedBox(height: 4),
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
                          Icon(Icons.phone, color: const Color(0xFF6366F1)),
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
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Vaga',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Campo Descrição
              TextFormField(
                controller:
                    _tituloController, // Note que aqui deveria ser _tituloController, não _descricaoController
                decoration: InputDecoration(
                  hintText: 'Digite a chamada da vaga',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor:
                      isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                maxLength: 100,
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe o título da vaga';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

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
                maxLength: 500,
                decoration: InputDecoration(
                  hintText:
                      'Descreva detalhadamente o trabalho, horários, etc.',
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
              const SizedBox(height: 8),
              _buildTagInput(
                'Requisitos',
                'Digite os requisitos e pressione adicionar',
                _requisitosController,
                _requisitos,
                _adicionarItem,
                _removerItem,
              ),
              _buildTagInput(
                'Exigências',
                'Digite uma exigência e pressione adicionar',
                _exigenciasController,
                _exigencias,
                _adicionarItem,
                _removerItem,
              ),

              _buildTagInput(
                'Valorizado',
                'O que é valorizado para a vaga?',
                _valorizadoController,
                _valorizados,
                _adicionarItem,
                _removerItem,
              ),

              _buildTagInput(
                'Benefícios',
                'Digite um benefício e pressione adicionar',
                _benificiosController,
                _beneficios,
                _adicionarItem,
                _removerItem,
              ),

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
                        side: const BorderSide(color: Color(0xFF6366F1)),
                      ),
                      child: const Text(
                        'Limpar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6366F1),
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
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            _tramposController.isLoading.value
                                ? null
                                : () async {
                                  if (_formKey.currentState!.validate() &&
                                      _tipoVagaSelecionado != null) {
                                    await _tramposController.createTrampo(
                                      descricao: _descricaoController.text,
                                      tipoVaga: _tipoVagaSelecionado!,
                                      telefone: _telefoneController.text,
                                      exigencias: List<String>.from(
                                        _exigencias,
                                      ), // Forçar cópia da lista
                                      valorizados: List<String>.from(
                                        _valorizados,
                                      ), // Forçar cópia da lista
                                      beneficios: List<String>.from(
                                        _beneficios,
                                      ), // Forçar cópia da lista
                                      requisitos: List<String>.from(
                                        _requisitos,
                                      ),
                                      titulo: _tituloController.text,
                                      modalidade:
                                          _modalidadeSelecionada ??
                                          'Presencial',
                                      salario:
                                          _salarioACombinar
                                              ? 'A combinar'
                                              : _salarioController.text,
                                      salarioACombinar: _salarioACombinar,
                                    );

                                    _limparFormulario();

                                    // Show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Trampo criado com sucesso!',
                                        ),
                                        backgroundColor: const Color(
                                          0xFF6366F1,
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  } else {
                                    // Show error if form is invalid or job type not selected
                                    if (_tipoVagaSelecionado == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Por favor, selecione o tipo de vaga',
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Por favor, verifique os campos obrigatórios',
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    }
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
}
