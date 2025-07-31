import 'package:flutter/material.dart';
import 'package:gomin_jungdok_mobile/profile/data/static/agreement_text.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({super.key});

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('약관 동의')),
      body: ListView(
        children: agreementList.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(
                entry.key,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.grey[100],
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
