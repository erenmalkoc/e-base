import 'dart:async';

import 'package:e_base/colors.dart';
import 'package:e_base/common/widgets/custom_fab.dart';
import 'package:e_base/common/widgets/loader.dart';
import 'package:e_base/models/document_model.dart';
import 'package:e_base/repository/auth_repository.dart';
import 'package:e_base/repository/document_repository.dart';
import 'package:e_base/repository/socket_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../common/widgets/action_button.dart';
import '../models/error_model.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;

  const DocumentScreen({super.key, required this.id});

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController =
      TextEditingController(text: 'Untitled Document');

  quill.QuillController? _controller;

  ErrorModel? errorModel;

  SocketRepository socketRepository = SocketRepository();

  @override
  void initState() {
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();
    socketRepository.changeListener((data) {
      _controller?.document.toDelta().toJson();
    });

    Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        'delta': _controller!.document.toDelta(),
        'room': widget.id,
      });
    });
  }

  fetchDocumentData() async {
    errorModel = await ref
        .read(documentRepositoryProvider)
        .getDocumentById(ref.read(userProvider)!.token, widget.id);
    if (errorModel!.data != null) {
      titleController.text = (errorModel!.data as DocumentModel).title;
      _controller = quill.QuillController(
        document: errorModel!.data.content.isEmpty
            ? quill.Document()
            : quill.Document.fromJson(errorModel!.data.content),
        selection: const TextSelection.collapsed(offset: 0),
      );
      setState(() {});
    }
    _controller!.document.changes.listen((event) {
      // if (event.source == quill.Document.) {
      //   Map<String, dynamic> map = {
      //     'delta': event.change,
      //     'room': widget.id,
      //   };
      //   socketRepository.typing(map);
      // }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateTitle(
        token: ref.read(userProvider)!.token, id: widget.id, title: title);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Loader(),
      );
    }
    return Scaffold(
      floatingActionButton: const CustomFab(),
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                        text: 'http://localhost:3000/#/document/${widget.id}'))
                    .then(
                  (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'soon...',
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete_rounded,
                size: 16,
              ),
              label: const Text(
                'Delete',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                        text: 'http://localhost:3000/#/document/${widget.id}'))
                    .then(
                  (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'soon',
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.edit,
                size: 16,
              ),
              label: const Text(
                'Request edit access',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                        text: 'http://localhost:3000/#/document/${widget.id}'))
                    .then(
                  (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Link copied!',
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.lock,
                size: 16,
              ),
              label: const Text(
                'Share',
              ),
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Routemaster.of(context).replace('/');
                  },
                  child: const Icon(
                    Icons.description_rounded,
                    size: 30,
                    color: Colors.deepPurpleAccent,
                  )),
              const SizedBox(width: 10),
              SizedBox(
                width: 180,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kBlueColor,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 100),
                  ),
                  onSubmitted: (value) => updateTitle(ref, value),
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: kGreyColor,
                width: 0.1,
              ),
            ),
          ),
        ),
      ),
      body: quill.QuillEditorProvider(
        editorConfigurations: quill.QuillEditorConfigurations(
          controller: _controller!,
          sharedConfigurations: const quill.QuillSharedConfigurations(
            locale: Locale('en'),
          ),
        ),
      
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
             quill.QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: _controller!,
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('tr'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SizedBox(
                  width: 750,
                  child: Card(
                    color: kWhiteColor,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: quill.QuillEditor.basic(   configurations: QuillEditorConfigurations(
                        controller: _controller!,
                        readOnly: false,
                        sharedConfigurations: const QuillSharedConfigurations(
                          locale: Locale('tr'),
                        ),)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
