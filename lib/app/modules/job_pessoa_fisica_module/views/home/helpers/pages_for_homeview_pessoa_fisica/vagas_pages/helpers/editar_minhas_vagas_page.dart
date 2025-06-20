import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditarMinhasVagasPage extends StatefulWidget {
  final Map<String, dynamic> vagaData;
  final String vagaId;
  final Function() onSave;

  const EditarMinhasVagasPage({
    super.key,
    required this.vagaData,
    required this.vagaId,
    required this.onSave,
  });

  @override
  State<EditarMinhasVagasPage> createState() => _EditarVagaPageState();
}

class _EditarVagaPageState extends State<EditarMinhasVagasPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late String _status;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.vagaData['titulo']);
    _descricaoController = TextEditingController(
      text: widget.vagaData['descricao'],
    );
    _status = widget.vagaData['status'] ?? 'Disponível';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _salvarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Atualizar os dados no Firestore
        await FirebaseFirestore.instance
            .collection('Trampos')
            .doc(widget.vagaId)
            .update({
              'titulo': _tituloController.text,
              'descricao': _descricaoController.text,
              'status': _status,
              'updateDate': Timestamp.now(),
            });

        Get.snackbar(
          'Sucesso',
          'Vaga atualizada com sucesso!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Chamar o callback de atualização
        widget.onSave();

        // Voltar para a tela anterior
        Get.back();
      } catch (e) {
        Get.snackbar(
          'Erro',
          'Não foi possível atualizar a vaga: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Vaga'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Título
                      TextFormField(
                        controller: _tituloController,
                        decoration: InputDecoration(
                          labelText: 'Título',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: isDark ? Colors.grey[800] : Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira um título';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Descrição
                      TextFormField(
                        controller: _descricaoController,
                        decoration: InputDecoration(
                          labelText: 'Descrição',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: isDark ? Colors.grey[800] : Colors.white,
                          filled: true,
                        ),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma descrição';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Status
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: isDark ? Colors.grey[800] : Colors.white,
                          filled: true,
                        ),
                        value: _status,
                        items:
                            ['Disponível', 'Ocupado', 'Finalizado']
                                .map(
                                  (status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _status = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Botão de salvar
                      ElevatedButton(
                        onPressed: _salvarAlteracoes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Salvar Alterações',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
