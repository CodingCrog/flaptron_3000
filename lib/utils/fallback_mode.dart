import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NomoFallbackQRCodeDialog extends StatelessWidget {
  const NomoFallbackQRCodeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        height: 500,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade600,
              offset: const Offset(0, 5),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: "http://nomo.app/webon/${Uri.base.host}",
              size: 160,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'Attention:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You are currently displaying a WebOn outside your NOMO App. Please download the NOMO App here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xFFbca570)),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.white.withOpacity(0.55)),
                )),
                elevation: WidgetStateProperty.all(5),
              ),
              onPressed: () async {
                final downloadUrl = "http://nomo.app/webon/${Uri.base.host}";
                if (await canLaunch(downloadUrl)) {
                  await launch(downloadUrl);
                } else {
                  throw 'Could not launch $downloadUrl';
                }
              },
              child: const Text(
                'Download NOMO App',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
