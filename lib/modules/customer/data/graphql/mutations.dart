const String purchaseProductMutation = r'''
  mutation PurchaseProduct($productId: ID!) {
    purchase(offerId: $productId) {
      success
      errorMessage
      customer {
        id
        name
        balance
      }
    }
  }
''';
