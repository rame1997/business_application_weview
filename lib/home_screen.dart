// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class MyHomePage extends StatefulWidget {
//
//
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
//
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView(); // <<== THIS
//     super.initState();
//     // Enable hybrid composition.
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: WebView(
//           javascriptMode: JavascriptMode.unrestricted,
//           initialUrl: 'https://ps.wedeliverapp.com/company/login',
//           onWebViewCreated: (WebViewController webViewController) {
//           },
//           navigationDelegate: (NavigationRequest request) {
//             if (request.url.contains("mailto:")) {
//               _launchURL(request.url);
//               return NavigationDecision.prevent;
//             } else if (request.url.contains("tel:")) {
//               _launchURL(request.url);
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//
//         ),
//       ),
//     );
//
//   }
//   _launchURL(url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }
//
//
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

late WebViewController controllerGlobal;

Future<bool> _exitApp(BuildContext context) async {
  if (await controllerGlobal.canGoBack()) {
    print("onwill goback");
    controllerGlobal.goBack();
  } else {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('هل تود الخروج ؟'),
            actions: [
              TextButton(
                onPressed: ()
                => Navigator.of(context, rootNavigator: true).pop('dialog'),
                    //Navigator.pop(context, false), // passing false
                child: Text('لا',style: TextStyle(
                  color: Colors.black
                ),),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // passing true
                child: Text('نعم',style: TextStyle(
          color: Colors.red
          ),),
              ),
            ],
          );
        }).then((exit) {
      if (exit == null) return;
      if (exit) {
        SystemNavigator.pop();
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');
       // Navigator.pop(context);
      }
    });
    Scaffold.of(context).showSnackBar(
      const SnackBar(content: Text("No back history item")),
    );
    return Future.value(false);
  }
  return Future.value(false);
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  late WebViewController _webViewController;

  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView(); // <<== THIS
    super.initState();
    // Enable hybrid composition.
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        bottomSheet:NavigationControls(_controller.future,),
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        //   title: NavigationControls(_controller.future,),
        // ),
        body: Padding(
          padding: const EdgeInsets.only(top: 37),
          child: Builder(builder: (BuildContext context) {
            return WebView(
              initialUrl: 'https://ps.wedeliverapp.com/company/login',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
                // CookieManager().getCookies(url: url)
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.contains("mailto:")) {
                  _launchURL(request.url);
                  return NavigationDecision.prevent;
                } else if (request.url.contains("tel:")) {
                  _launchURL(request.url);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
              },
            );
          }),
        ),
      ),
    );
  }
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        controllerGlobal = controller!;

        return Row(
          children: <Widget>[
            // InkWell(
            //  // icon: const Icon(Icons.arrow_back_ios),
            //   onTap: !webViewReady
            //       ? null
            //       : () async {
            //     if (await controller.canGoBack()) {
            //       controller.goBack();
            //     } else {
            //       Scaffold.of(context).showSnackBar(
            //         const SnackBar(content: Text("No back history item")),
            //       );
            //       return;
            //     }
            //   },
            // ),
            // InkWell(
            //   //icon: const Icon(Icons.arrow_forward_ios),
            //   onTap: !webViewReady
            //       ? null
            //       : () async {
            //     if (await controller.canGoForward()) {
            //       controller.goForward();
            //     } else {
            //       Scaffold.of(context).showSnackBar(
            //         const SnackBar(
            //             content: Text("No forward history item")),
            //       );
            //       return;
            //     }
            //   },
            // ),

          ],
        );
      },
    );
  }
}