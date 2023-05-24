import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:live_graph_plotter/pages/graph_plot.dart';

RealTimeGraphRendererState realTimeGraphRendererState =
    RealTimeGraphRendererState();

String getCurrentDate() {
  var now = DateTime.now();
  var formatter = DateFormat(' MMMM d, y');
  return formatter.format(now);
}

String getCurrentHrsSeconds() {
  var now = DateTime.now();
  var formatter = DateFormat('HH:mm:ss');
  return formatter.format(now);
}

void heartAlerts(int bpm) async {
  print("Heart function called");
  if (bpm <= 40 && bpm >= 120) {
    uploadAlertToFirebase(bpm, 'heart');
  }
}

void tempAlerts(var tmp) {
  if (tmp > 38) {
    uploadAlertToFirebase(tmp, 'tmp');
  }
}

void satAlerts(var sat) {
  if (sat < 92) {
    uploadAlertToFirebase(sat, 'sat');
  }
}

uploadAlertToFirebase(var data, var type) async {
  print("alerts provoked");
  final user = FirebaseAuth.instance.currentUser;
  try {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .collection("Nodes")
        .doc(5166519.toString())
        .collection(getCurrentDate())
        .doc('Alerts')
        .collection('Alert')
        .doc()
        .set({
      'time_stamp': getCurrentHrsSeconds(),
      'data': data,
      'type': type,
    }).then((value) => {
              print("alerts saved"),
            });
  } catch (error) {
    print(error);
  }
}
