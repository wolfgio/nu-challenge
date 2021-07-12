const String getProductsQuery = r'''
  query GetProducts {
    viewer {
      offers {
        id
        price
        product {
          name
          description
          image
        }
      }
    }
  }
''';
