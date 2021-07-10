const String getCustomerQuery = r'''
  query GetCustomer {
    viewer {
      id
      name
      balance
    }
  }
''';
