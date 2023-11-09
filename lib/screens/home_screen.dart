import 'package:e_base/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/auth_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state)=>null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColors,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_rounded,
                  color: kBlackColors,
                )),
            IconButton(
                onPressed: () =>signOut(ref),
                icon: const Icon(
                  Icons.logout_rounded,
                  color: kBlackColors,
                ))
          ],
        ),
        body: Center(child: SelectableText(ref.watch(userProvider)!.email)));
  }
}
