import 'package:e_base/colors.dart';
import 'package:e_base/common/widgets/loader.dart';
import 'package:e_base/common/widgets/main_drawer.dart';
import 'package:e_base/models/document_model.dart';
import 'package:e_base/repository/document_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../repository/auth_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});



  void createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);

    final errorModel =
        await ref.read(documentRepositoryProvider).createDocument(token);

    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackbar.showSnackBar(SnackBar(
        content: Text(errorModel.error!),
      ));
    }
  }

  void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: const Text('Documents'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () => createDocument(context, ref),
              icon: const Icon(
                Icons.add_rounded,
                size: 16,
              ),
              label: const Text(
                'New Document',
              ),
            ),
          ),

        ],
      ),
      body: FutureBuilder(
        future: ref
            .watch(documentRepositoryProvider)
            .getDocuments(ref.watch(userProvider)!.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text('Error occurred while fetching data'));
          }

          if (snapshot.data == null || snapshot.data!.error != null) {
            return const Center(
                child: Text('Error occurred in data retrieval'));
          }

          List<DocumentModel> documents = snapshot.data!.data;
          return Center(
            child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  DocumentModel document = snapshot.data!.data[index];
                  return InkWell(
                    onTap: () => navigateToDocument(context, document.id),
                    child: SizedBox(
                      height: 50,
                      child: Card(
                        child: Center(
                          child: Text(
                            document.title,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
