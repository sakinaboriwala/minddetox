import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mind_detox/screens/auth.dart';
import 'package:mind_detox/screens/home.dart';
import 'package:mind_detox/screens/inapppurchase.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() => runApp(MyApp());

const List<String> _kProductIds = <String>['MonthlySubscriptionOffer'];

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  // List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError = null;
  bool loggedIn = false;
  bool loggedInFb = false;
  bool checked = false;
  bool subscribed = false;
  // bool checked = false;
  static final Map<int, Color> color = {
    50: Color.fromRGBO(193, 202, 212, .1),
    100: Color.fromRGBO(193, 202, 212, .2),
    200: Color.fromRGBO(193, 202, 212, .3),
    300: Color.fromRGBO(193, 202, 212, .4),
    400: Color.fromRGBO(193, 202, 212, .5),
    500: Color.fromRGBO(193, 202, 212, .6),
    600: Color.fromRGBO(193, 202, 212, .7),
    700: Color.fromRGBO(193, 202, 212, .8),
    800: Color.fromRGBO(193, 202, 212, .9),
    900: Color.fromRGBO(193, 202, 212, 1),
  };

  checkIfPurchased() {
    Map<String, PurchaseDetails> purchases =
        Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    _products.forEach((productDetails) {
      PurchaseDetails previousPurchase = purchases[productDetails.id];
      if (previousPurchase != null) {
        setState(() {
          subscribed = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // Stream purchaseUpdated =
    //     InAppPurchaseConnection.instance.purchaseUpdatedStream;
    // _subscription = purchaseUpdated.listen((purchaseDetailsList) {
    //   _listenToPurchaseUpdated(purchaseDetailsList);
    // }, onDone: () {
    //   _subscription.cancel();
    // }, onError: (error) {
    //   // handle error here.
    // });
    checkLoggedIn();
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        // _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        // _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        // _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
        await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }
    // List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      // _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  checkLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedIn =
          prefs.getBool('loggedIn') != null ? prefs.getBool('loggedIn') : false;
      loggedInFb = prefs.getBool('loggedInFb') != null
          ? prefs.getBool('loggedInFb')
          : false;
      checked =
          prefs.getBool('checked') != null ? prefs.getBool('checked') : false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  final MaterialColor colorCustom = MaterialColor(0xFFC1CAD4, color);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: colorCustom,
            fontFamily: 'Lato',
            canvasColor: colorCustom),
        home: checked || subscribed
            ? !loggedIn && !loggedInFb 
                ? AuthenticationScreen()
                : HomeScreen()
            : InAppPurchase()
          // home: InAppPurchase(),
        // home: HomeScreen(),
        );
  }
}
