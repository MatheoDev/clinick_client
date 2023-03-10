import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:clinick_client/booking.dart';
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
            if (context.watch<ApplicationState>().loggedIn)
              ListTile(
                title: const Text('Mes rendez-vous'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/rdv');
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
                title: const Text('Se d??connecter'),
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
                // recharger le state pour changer la couleur des cr??neaux
                context.read<ApplicationState>().notifyListeners();
              },
            ),
            Consumer<ApplicationState>(
              builder: (context, state, child) {
                return Visibility(
                  visible: state.selectedDoctor != null,
                  // afficher les infos du medecin selectionn??
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                        style: const TextStyle(fontSize: 20),
                        '${state.selectedDoctor!.name} ${state.selectedDoctor!.prenom} - ${state.selectedDoctor!.fonction}'),
                  ),
                );
              },
            ),
            // widget de scroll vertical pour des cr??neaux toute les 30 min de 8h ?? 20h
            Expanded(
              child: ListView.builder(
                itemCount: 25,
                itemBuilder: (context, index) {
                  // utiliser le state pour changer la couleur si le cr??neau est deja pris
                  String time =
                      '${8 + index ~/ 2}:${index % 2 == 0 ? '00' : '30'}';
                  return Consumer<ApplicationState>(
                      builder: (context, state, child) {
                    return Card(
                      // changer la couleur au changement de date ou si le cr??neau est deja pris
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
                          // faire une verif si le cr??neau est deja bien ou non
                          if (state.isReserved(time, dateSelected)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ce cr??neau est d??j?? pris'),
                              ),
                            );
                            return;
                          }

                          // AlertDialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Confirmation'),
                                content: const Text(
                                    'Voulez-vous r??server ce cr??neau ?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // ajouter la reservation
                                      DateTime date = DateTime(
                                        dateSelected.year,
                                        dateSelected.month,
                                        dateSelected.day,
                                        int.parse(time.split(':')[0]),
                                        int.parse(time.split(':')[1]),
                                      );
                                      // user connect??
                                      String? user = FirebaseAuth
                                          .instance.currentUser!.displayName;
                                      Booking booking = Booking(
                                          date: date,
                                          doctor: state.selectedDoctor!,
                                          patient: user.toString(),
                                          type: 'Visite');
                                      state.addBooking(booking);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('R??servation confirm??e'),
                                        ),
                                      );

                                      context.push('/');
                                    },
                                    child: const Text('Confirmer'),
                                  ),
                                ],
                              );
                            },
                          );
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
