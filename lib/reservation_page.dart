import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  // props date selected
  DateTime dateSelected = DateTime.now();

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
              child: Text('Clinick App'),
            ),
            ListTile(
              title: const Text('Accueil'),
              onTap: () {
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
                },
              ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Medecin'),
      ),
      body: Center(
        child: Column(
          children: [
            CalendarAgenda(
              // couleur : #58b4d7
              backgroundColor: const Color(0xFF58b4d7),
              locale: 'fr',
              fullCalendar: true,
              fullCalendarScroll: FullCalendarScroll.horizontal,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 0)),
              lastDate: DateTime.now().add(const Duration(days: 40)),
              onDateSelected: (date) {
                dateSelected = date;
                // recharger le state pour changer la couleur des créneaux
                context.read<ApplicationState>().notifyListeners();
              },
            ),
            Consumer<ApplicationState>(
              builder: (context, state, child) {
                return Visibility(
                  visible: state.selectedDoctor != null,
                  // afficher les infos du medecin selectionné
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                        style: const TextStyle(fontSize: 20),
                        '${state.selectedDoctor!.name} ${state.selectedDoctor!.prenom} - ${state.selectedDoctor!.fonction}'),
                  ),
                );
              },
            ),
            // widget de scroll vertical pour des créneaux toute les 30 min de 8h à 20h
            Expanded(
              child: ListView.builder(
                itemCount: 25,
                itemBuilder: (context, index) {
                  // utiliser le state pour changer la couleur si le créneau est deja pris
                  String time =
                      '${8 + index ~/ 2}:${index % 2 == 0 ? '00' : '30'}';
                  return Consumer<ApplicationState>(
                      builder: (context, state, child) {
                    return Card(
                      // changer la couleur au changement de date ou si le créneau est deja pris
                      color: state.isReserved(time, dateSelected)
                          ? Colors.red
                          : Colors.white,
                      child: ListTile(
                        title: Text(
                          time,
                          style: const TextStyle(fontSize: 20),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // faire une verif si le créneau est deja bien ou non
                          if (state.isReserved(time, dateSelected)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ce créneau est déjà pris'),
                              ),
                            );
                            return;
                          }
                          context.push('/reservation');
                        },
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
