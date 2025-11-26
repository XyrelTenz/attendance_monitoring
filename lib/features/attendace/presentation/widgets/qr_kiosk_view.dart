import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrKioskView extends StatelessWidget {
  final String kioskId;
  final VoidCallback onSimulateIncomingScan; // For testing without a real phone

  const QrKioskView({
    super.key,
    required this.kioskId,
    required this.onSimulateIncomingScan,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "SCAN TO ENTER",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Use your Student App to scan",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 24),

            // The Generated QR Code
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: QrImageView(
                data:
                    kioskId, // The data hidden in the QR (e.g., "LIB-KIOSK-01")
                version: QrVersions.auto,
                size: 200.0,
                foregroundColor: Colors.black87,
              ),
            ),

            const SizedBox(height: 30),

            // Simulation Button (Since you don't have a real backend connecting the phone to this app yet)
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: onSimulateIncomingScan,
                icon: const Icon(Icons.phonelink_ring),
                label: const Text("SIMULATE STUDENT SCANNING"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade50,
                  foregroundColor: Colors.blue.shade800,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "(Click to test without a phone)",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
