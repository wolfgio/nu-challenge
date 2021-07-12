import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/platform/scaffold_handler.dart';
import '../../../../customer/presentation/mobx/customer_store.dart';
import '../widgets/sliver_header.dart';

class HomeScreen extends StatefulWidget {
  final CustomerStore customerStore;
  final ScaffoldHandler scaffoldHandler;

  const HomeScreen({
    Key? key,
    required this.customerStore,
    required this.scaffoldHandler,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    await widget.customerStore.getCustomer().catchError((error) {
      if (error is ServerFailure) {
        return widget.scaffoldHandler.showErrorScaffold(message: error.message);
      }
      widget.scaffoldHandler.showErrorScaffold(message: error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: RefreshIndicator(
        onRefresh: () async => _fetchData(),
        child: CustomScrollView(
          slivers: [
            Observer(
              builder: (_) => SliverPersistentHeader(
                delegate: HomeSliverHeader(
                  customer: widget.customerStore.customer,
                  isLoading: widget.customerStore.isLoading,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, index) {
                  return Placeholder(fallbackHeight: 200);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
