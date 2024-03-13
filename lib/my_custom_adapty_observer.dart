import 'dart:developer';
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adapty_ui_flutter/adapty_ui_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCustomAdaptyObserver implements AdaptyUIObserver {
  @override
  void paywallViewDidPerformAction(
      AdaptyUIView view, AdaptyUIAction action) async {
    log('paywallViewPerformedAction'); // This is not showing in the console. So, I'm assuming this is not even called?
    switch (action.type) {
      case AdaptyUIActionType.close:
        log('Close button pressed');
        await view.dismiss();
        break;
      case AdaptyUIActionType.androidSystemBack:
        log('Android back button pressed');
        await view.dismiss();
        break;
      case AdaptyUIActionType.openUrl:
        log('Opening URL: ${action.value}');
        if (action.value != null) openURL(Uri.parse(action.value!));
        break;
      case AdaptyUIActionType.custom:
        log('custom: ${action.value}');
        break;
    }
  }

  @override
  void paywallViewDidSelectProduct(
      AdaptyUIView view, AdaptyPaywallProduct product) {
    log('paywallViewDidSelectProduct');
  }

  @override
  void paywallViewDidStartPurchase(
      AdaptyUIView view, AdaptyPaywallProduct product) {
    log('paywallViewDidStartPurchase');
  }

  @override
  void paywallViewDidCancelPurchase(
      AdaptyUIView view, AdaptyPaywallProduct product) {
    log('paywallViewDidCancelPurchase');
  }

  @override
  void paywallViewDidFinishPurchase(
      AdaptyUIView view, AdaptyPaywallProduct product, AdaptyProfile profile) {
    log('paywallViewDidFinishPurchase');

    if (profile.accessLevels['premium']?.isActive ?? false) {
      log('PURCHASE SUCCESSFUL. ${product.localizedTitle} is now active.');
    } else {
      log('PURCHASE FAILED');
    }

    view.dismiss();
  }

  @override
  void paywallViewDidFailPurchase(
      AdaptyUIView view, AdaptyPaywallProduct product, AdaptyError error) {
    log('paywallViewDidFailPurchase');
  }

  @override
  void paywallViewDidFinishRestore(AdaptyUIView view, AdaptyProfile profile) {
    log('paywallViewDidFinishRestore');
  }

  @override
  void paywallViewDidFailRestore(AdaptyUIView view, AdaptyError error) {
    log('paywallViewDidFailRestore');
  }

  @override
  void paywallViewDidFailRendering(AdaptyUIView view, AdaptyError error) {
    log('paywallViewDidFailRendering');
  }

  @override
  void paywallViewDidFailLoadingProducts(AdaptyUIView view, AdaptyError error) {
    log('paywallViewDidFailLoadingProducts');
  }

  Future<void> openURL(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void paywallViewDidStartRestore(AdaptyUIView view) {
    // TODO: implement paywallViewDidStartRestore
  }
}
