import 'package:college_project/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StudentResultScreen extends StatefulWidget {
  @override
  _StudentResultScreenState createState() => _StudentResultScreenState();
}

class _StudentResultScreenState extends State<StudentResultScreen> {
  void openResultWebView() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultWebViewScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Result',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColor.whiteColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColor.primaryColor,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.network(
                      'https://upload.wikimedia.org/wikipedia/en/1/11/VNSGU_logo.png',
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'VNSGU Results',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(height: 1, color: AppColor.greyColor),
                    SizedBox(height: 16),
                    Text(
                      'Veer Narmad South Gujarat University (VNSGU) is a public university located in Surat, Gujarat, India. It offers a variety of undergraduate and postgraduate courses across different disciplines.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.textColor,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: openResultWebView,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'CHECK RESULT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Official University Results Portal',
                style: TextStyle(
                  color: AppColor.greyColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultWebViewScreen extends StatefulWidget {
  @override
  _ResultWebViewScreenState createState() => _ResultWebViewScreenState();
}

class _ResultWebViewScreenState extends State<ResultWebViewScreen> {
  final String url = 'https://vnsgu.net/';
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VNSGU Results',
          style: TextStyle(color: AppColor.whiteColor),
        ),
        backgroundColor: AppColor.primaryColor,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading && !_hasError)
            Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ),
            ),
          if (_hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      color: AppColor.errorColor, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Failed to load page',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.errorColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _controller.reload();
                    },
                    child: Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
