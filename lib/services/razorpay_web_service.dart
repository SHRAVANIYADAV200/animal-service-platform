import 'dart:js' as js;

class RazorpayWebService {
  static void openCheckout({
    required Map<String, dynamic> options,
    required Function(String paymentId, String orderId, String signature) onSuccess,
    required Function() onDismiss,
  }) {
    js.context.callMethod('openRazorpay', [
      js.JsObject.jsify(options),
      js.allowInterop(onSuccess),
      js.allowInterop(onDismiss),
    ]);
  }
}
