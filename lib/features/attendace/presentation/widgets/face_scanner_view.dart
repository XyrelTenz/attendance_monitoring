import 'package:flutter/material.dart';

class FaceScannerView extends StatelessWidget {
  final VoidCallback onSimulateScan;

  const FaceScannerView({super.key, required this.onSimulateScan});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Responsive Container for Desktop
        AspectRatio(
          aspectRatio: 4 / 3, // Standard camera aspect ratio
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueAccent, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Placeholder for Camera Feed
                const Icon(
                  Icons.videocam_off_outlined,
                  size: 80,
                  color: Colors.white24,
                ),

                // Simulated Face Overlay
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                // Scanning Animation Line
                Positioned(
                  top: 80,
                  child: Container(
                    width: 240,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      boxShadow: [BoxShadow(color: Colors.red, blurRadius: 10)],
                    ),
                  ),
                ),

                const Positioned(
                  bottom: 20,
                  child: Text(
                    "Looking for face...",
                    style: TextStyle(
                      color: Colors.white70,
                      letterSpacing: 1.2,
                      fontFamily: 'Monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: onSimulateScan,
            icon: const Icon(Icons.face_retouching_natural),
            label: const Text("SIMULATE FACE DETECTED"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }
}
