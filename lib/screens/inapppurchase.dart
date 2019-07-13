import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mind_detox/main.dart';

const List<String> _kProductIds = <String>['MonthlySubscriptionOffer'];

class InAppPurchase extends StatefulWidget {
  @override
  _InAppPurchase createState() => _InAppPurchase();
}

class _InAppPurchase extends State<InAppPurchase> {
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
  Widget price;
  Widget confirm;

  @override
  void initState() {
    print("NOT CHECKED LOAD IN APP PURCHASE SCREEN");
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
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

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stack = [];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          children: [
            _buildConnectionCheckTile(),
            _buildProductList(),
            // _buildConsumableBox(),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError),
      ));
    }
    if (_purchasePending) {
      stack.add(
        Stack(
          children: [
            new Opacity(
              opacity: 0.3,
              child: const ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            new Center(
              child: new CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AppStore',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: stack,
      ),
    );
  }

  Card _buildConnectionCheckTile() {
    if (_loading) {
      return Card(child: ListTile(title: const Text('Trying to connect...')));
    }
    // final Widget storeHeader = ListTile(
    //   leading: Icon(_isAvailable ? Icons.check : Icons.block,
    //       color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
    //   title: Text(
    //       'The store is ' + (_isAvailable ? 'available' : 'unavailable') + '.'),
    // );
    final List<Widget> children = <Widget>[];

    if (!_isAvailable) {
      children.addAll([
        Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text(
              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Card _buildProductList() {
    if (_loading) {
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching products...'))));
    }
    if (!_isAvailable) {
      return Card();
    }
    final ListTile productHeader = ListTile(
        title: Text('Products for Sale',
            style: Theme.of(context).textTheme.headline));
    List<Widget> productList = <Widget>[];
    if (!_notFoundIds.isEmpty) {
      productList.add(ListTile(
          // title: Text('[${_notFoundIds.join(", ")}] not found',
          title: Text('No Products Found',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: Text('No Products Found')));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verity the purchase data.
    Map<String, PurchaseDetails> purchases =
        Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(_products.map(
      (ProductDetails productDetails) {
        print('___SKPRODUCT___');
        print(productDetails.skProduct.introductoryPrice.toString());
        // print()
        PurchaseDetails previousPurchase = purchases[productDetails.id];
        confirm = previousPurchase != null
            ? Text('PURCHASED')
            : FlatButton(
                child: Text(
                  'CLICK TO CONIRM',
                  style: TextStyle(color: Colors.black),
                ),
                color: Color(0xFFC1CAD4),
                textColor: Colors.white,
                onPressed: () {
                  PurchaseParam purchaseParam = PurchaseParam(
                      productDetails: productDetails,);
                  // if (productDetails.id == _kConsumableId) {
                  //   _connection.buyConsumable(
                  //       purchaseParam: purchaseParam,
                  //       autoConsume: kAutoConsume || Platform.isIOS);
                  // } else {
                  _connection.buyNonConsumable(purchaseParam: purchaseParam);
                  // }
                },
              );
        price = previousPurchase != null
            ? Icon(Icons.check)
            : FlatButton(
                child: Text(
                  productDetails.price + '/' + 'MONTH',
                  style: TextStyle(color: Colors.black),
                ),
                color: Color(0xFFC1CAD4),
                textColor: Colors.white,
                onPressed: () {
                  // PurchaseParam purchaseParam = PurchaseParam(
                  //     productDetails: productDetails,
                  //     applicationUserName: null,
                  //     sandboxTesting: true);
                  // // if (productDetails.id == _kConsumableId) {
                  // //   _connection.buyConsumable(
                  // //       purchaseParam: purchaseParam,
                  // //       autoConsume: kAutoConsume || Platform.isIOS);
                  // // } else {
                  // _connection.buyNonConsumable(purchaseParam: purchaseParam);
                  // // }
                },
              );
        return ListTile(
          leading: Image.asset('images/icon3.png'),
          title: Text(
            productDetails.title,
          ),
          subtitle: Text(productDetails.description),
        );
      },
    ));

    List<Widget> listCards = productList +
        [Divider()] +
        [policyCard()] +
        [Divider()] +
        priceCard() +
        [Divider()] +
        [confirm];

    return Card(color: Color(0xFFC1CAD4), child: Column(children: listCards));
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Widget policyCard() {
    return ListTile(
      leading: Text(
        'POLICY',
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w100),
      ),
      title: Text(
        'No commitment. Cancel anytime in Settings at least a day before each renewal date. Plan automatically renews until cacelled',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  List<Widget> priceCard() {
    List<Widget> listPrice = List();
    listPrice.add(ListTile(
      leading: Text(
        'Price',
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w100),
      ),
      title: Text(
        '1 WEEK TRIAL',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: Text('FREE'),
    ));
    listPrice.add(ListTile(
        leading: Text(
          '',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w100),
        ),
        title: Text(
          'STARTING PRICE',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: price));
    return listPrice;
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // prefs.setBool('subscribed', true);
    prefs.setBool('checked', true);
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => MyApp());
    Navigator.pushReplacement(context, route);
    // Navigator.pop(context);
    setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    });
    // }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  static ListTile buildListCard(ListTile innerTile) =>
      ListTile(title: Card(child: innerTile));

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
          }
        }
        // if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
        // } else if (Platform.isAndroid) {
        //   if (!kAutoConsume && purchaseDetails.productID == _kConsumableId) {
        //     InAppPurchaseConnection.instance.consumePurchase(purchaseDetails);
        //   }
        // }
      }
    });
  }
}
