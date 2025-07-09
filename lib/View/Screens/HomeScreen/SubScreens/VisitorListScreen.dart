import 'package:flutter/material.dart';
import '../../../../Configuration/Graphql_Config.dart';
import '../../../../Controller/VisitorController.dart';
import '../../../../Model/VisitorModel.dart';
import '../../../../Service/GraphqlService/Graphql_Service.dart';
import 'VisitorCard.dart';

class VisitorListScreen extends StatefulWidget {
  const VisitorListScreen({super.key});

  @override
  _VisitorListScreenState createState() => _VisitorListScreenState();
}

class _VisitorListScreenState extends State<VisitorListScreen> {
  late final VisitorController visitorController;
  List<Visitors> visitors = [];

  @override
  void initState() {
    super.initState();

    // Use the centralized GraphQLClient from GraphQLConfig
    final graphqlService = GraphQLService(GraphQLConfig().client.value);
    visitorController = VisitorController(graphqlService);

    fetchVisitors();
  }

  // Fetch visitors dynamically from GraphQL
  Future<void> fetchVisitors() async {
    List<Visitors>? fetchedVisitors = await visitorController.fetchVisitors();
    if (fetchedVisitors != null) {
      setState(() {
        visitors = fetchedVisitors;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visitor List')),
      body:
          visitors.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: visitors.length,
                itemBuilder: (context, index) {
                  final visitor = visitors[index];
                  return VisitorCard(
                    visitor: visitor,
                  );
                },
              ),
    );
  }
}
