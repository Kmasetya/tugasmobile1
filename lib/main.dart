import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const VolumeApp());
}

class VolumeApp extends StatelessWidget {
  const VolumeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VolumePage(),
    );
  }
}

class VolumePage extends StatefulWidget {
  const VolumePage({Key? key}) : super(key: key);

  @override
  State<VolumePage> createState() => _VolumePageState();
}

class _VolumePageState extends State<VolumePage> {
  String selectedShape = "Kubus";

  final TextEditingController sisiController = TextEditingController();
  final TextEditingController jariController = TextEditingController();
  final TextEditingController tinggiController = TextEditingController();

  double? hasil;

  void hitungVolume() {
    setState(() {
      if (selectedShape == "Kubus") {
        double s = double.tryParse(sisiController.text) ?? 0;
        hasil = pow(s, 3).toDouble();
      }
      else if (selectedShape == "Tabung") {
        double r = double.tryParse(jariController.text) ?? 0;
        double t = double.tryParse(tinggiController.text) ?? 0;
        hasil = pi * pow(r, 2) * t;
      }
      else if (selectedShape == "Bola") {
        double r = double.tryParse(jariController.text) ?? 0;
        hasil = 4 / 3 * pi * pow(r, 3);
      }
    });
  }

  void resetForm() {
    sisiController.clear();
    jariController.clear();
    tinggiController.clear();
    setState(() {
      hasil = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalkulator Volume Bangun Ruang"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedShape,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Pilih Bangun Ruang",
                ),
                items: const [
                  DropdownMenuItem(value: "Kubus", child: Text("Kubus")),
                  DropdownMenuItem(value: "Tabung", child: Text("Tabung")),
                  DropdownMenuItem(value: "Bola", child: Text("Bola")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedShape = value!;
                    resetForm();
                  });
                },
              ),
              const SizedBox(height: 20),

              if (selectedShape == "Kubus")
                TextField(
                  controller: sisiController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Masukkan panjang sisi",
                    border: OutlineInputBorder(),
                  ),
                ),

              if (selectedShape == "Tabung") ...[
                TextField(
                  controller: jariController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Masukkan jari-jari",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: tinggiController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Masukkan tinggi",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              if (selectedShape == "Bola")
                TextField(
                  controller: jariController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Masukkan jari-jari",
                    border: OutlineInputBorder(),
                  ),
                ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: hitungVolume,
                      child: const Text("Hitung"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: resetForm,
                      child: const Text("Reset"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              if (hasil != null)
                Text(
                  "Volume: ${hasil!.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}