import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class ClassmentPage extends StatelessWidget {
  const ClassmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('PME App'),
            ),
            ListTile(
              title: const Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
                context.push('/');
              },
            ),
            if (context.watch<ApplicationState>().loggedIn)
              ListTile(
                title: const Text('Profil'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/profile');
                },
              ),
            if (context.watch<ApplicationState>().loggedIn)
              ListTile(
                title: const Text('Classement'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            if (!context.watch<ApplicationState>().loggedIn)
              ListTile(
                title: const Text('Se connecter'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/sign-in');
                },
              ),
            if (!context.watch<ApplicationState>().loggedIn)
              ListTile(
                title: const Text('S\'inscrire'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/sign-up');
                },
              ),
            if (context.watch<ApplicationState>().loggedIn)
              ListTile(
                title: const Text('Se déconnecter'),
                onTap: () {
                  Navigator.pop(context);
                  FirebaseAuth.instance.signOut();
                  context.push('/');
                },
              ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Classement'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(height: 8),
          // faire des cards avec les produits vendu par le user
          // for (var product in context.watch<ApplicationState>().getProducts)
          //   Card(
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: <Widget>[
          //         ListTile(
          //           leading: const Icon(Icons.album),
          //           title: Text(product.name),
          //           subtitle: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               // Text('${product.product} | ${product.amount}€'),
          //               // Text('${product.client}'),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}
