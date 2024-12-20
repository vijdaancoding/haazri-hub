import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';  // Import the package

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  late WebViewController _webviewController;

  @override
  void initState() {
    super.initState();
    // Initialize WebView platform for desktop
    WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Image'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show the WebView dialog to capture the image
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Capture Image'),
                  content: Container(
                    height: 400,
                    width: 600,
                    child: WebView(
                      initialUrl: 'file://${Uri.base.path}/assets/capture_screen.html', // Load HTML file from assets
                      javascriptMode: JavascriptMode.unrestricted,  // Enable JavaScript for the HTML file
                      onWebViewCreated: (WebViewController webViewController) {
                        _webviewController = webViewController; // Store the controller
                      },
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();  // Close the dialog
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Open Webcam'),
        ),
      ),
    );
  }
}