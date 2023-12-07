import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../colors.dart';
import '../../repository/auth_repository.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(

        children:  <Widget>[
         const  DrawerHeader(child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget> [
                Icon(Icons.add,),
                Text('test')
              ],
            ),
          )),
          IconButton(
              onPressed: () => signOut(ref),
              icon: const Icon(
                Icons.logout_rounded,
                color: kBlackColor,
              ))
        ],
      ),
    );
  }
}
