import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/data/models/trampos_model.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/trampos_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/helpers_pages/detalhes_vaga_page/detalhes_vagas_page.dart';

class SalvosPage extends StatelessWidget {
  const SalvosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TramposController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: const Text('Trampos Salvos')),
      body: Obx(() {
        final vagas = controller.vagasSalvas;
        if (vagas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 70,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nenhuma vaga salva',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: vagas.length,
          itemBuilder: (context, index) {
            final vaga = vagas[index];
            return ListTile(
              leading: Icon(
                Icons.bookmark,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(vaga['titulo'] ?? vaga['tipoVaga'] ?? 'Vaga'),
              // subtitle: Text(vaga['descricao'] ?? ''),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  controller.removerVagaSalva(
                    CreateTramposModel.fromJson(vaga).toEntity(),
                  );
                },
              ),
              onTap: () {
                Get.to(
                  () => DetalhesVagaPage(
                    vagaData: vaga,
                    vagaId: vaga['id'] ?? '',
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
