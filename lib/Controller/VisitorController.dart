import '../Model/SingleVisitorModel.dart';
import '../Model/VisitorModel.dart';
import '../Service/GraphqlService/Graphql_Service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class VisitorController {
  final GraphQLService graphqlService;

  VisitorController(this.graphqlService);

  // Create Visitor Mutation
  Future<Visitors?> createVisitor({
    required String visitorName,
    required String phone,
    required String purpose,
    required String meetingPerson,
    String? personImageUrl,
    String? idProofImageUrl,
    required String intime,
    required int userId,
  }) async {
    const String mutation = r'''
      mutation CreateVisitor(
        $visitorName: String!,
        $phone: String!,
        $purpose: String!,
        $meetingPerson: String!,
        $personImageUrl: String,
        $idProofImageUrl: String,
        $intime: String!,
        $userId: Int!
      ) {
        createVisitor(
          visitorName: $visitorName,
          phone: $phone,
          purpose: $purpose,
          meetingPerson: $meetingPerson,
          personImageUrl: $personImageUrl,
          idProofImageUrl: $idProofImageUrl,
          intime: $intime,
          userId: $userId
        ) {
          message
          success
          data {
            checkedby
            createdat
            idproofimageurl
            intime
            meetingperson
            outtime
            personimageurl
            phone
            purpose
            updatedat
            updatedby
            visitorid
            visitorname
          }
        }
      }
    ''';

    final variables = {
      "visitorName": visitorName,
      "phone": phone,
      "purpose": purpose,
      "meetingPerson": meetingPerson,
      "personImageUrl": personImageUrl,
      "idProofImageUrl": idProofImageUrl,
      "intime": intime,
      "userId": userId,
    };

    try {
      final QueryResult result = await graphqlService.performMutation(
        mutation,
        variables: variables,
      );

      if (result.hasException) {
        print("GraphQL exception: ${result.exception.toString()}");
        return null;
      }

      final visitorResponse = result.data?['createVisitor'];
      if (visitorResponse != null && visitorResponse['success'] == true) {
        final visitorJson = visitorResponse['data'];
        return Visitors.fromJson(visitorJson);
      } else {
        print("Mutation failed: ${visitorResponse?['message']}");
        return null;
      }
    } catch (e) {
      print("Exception in createVisitor: $e");
      return null;
    }
  }


  // Fetch Visitors Query
  Future<List<Visitors>?> fetchVisitors() async {
    const String query = r'''
      query {
        visitors {
        checkedby
        createdat
        idproofimageurl
        intime
        meetingperson
        outtime
        personimageurl
        phone
        purpose
        updatedat
        updatedby
        visitorid
        visitorname
      }
    }
    ''';

    try {
      final QueryResult result = await graphqlService.performQuery(query);

      if (result.hasException) {
        print("GraphQL exception: ${result.exception.toString()}");
        return null;
      }

      final visitorsResponse = result.data?['visitors'];
      if (visitorsResponse != null) {
        final List<Visitors> visitorsList =
        (visitorsResponse as List)
            .map((visitorJson) => Visitors.fromJson(visitorJson))
            .toList();
        return visitorsList;
      } else {
        print("No visitors data found.");
        return null;
      }
    } catch (e) {
      print("Exception in fetchVisitors: $e");
      return null;
    }
  }

  Future<VisitorInfo?> getVisitorById(int visitorId) async {
    const String query = r'''
    query GetVisitorDetails($visitorId: Int!) {
      visitorDetails(visitorId: $visitorId) {
        message
        success
        data {
          checkedby
          createdat
          idproofimageurl
          intime
          meetingperson
          outtime
          personimageurl
          phone
          purpose
          updatedat
          updatedby
          visitorid
          visitorname
        }
      }
    }
  ''';

    final variables = {"visitorId": visitorId};

    try {
      final QueryResult result = await graphqlService.performQuery(
        query,
        variables: variables,
      );

      if (result.hasException) {
        print("GraphQL exception: ${result.exception.toString()}");
        return null;
      }

      final data = result.data?['visitorDetails'];
      if (data != null && data['success'] == true) {
        final visitorInfoJson = data['data'];
        return VisitorInfo.fromJson(visitorInfoJson);
      } else {
        print("Query failed: ${data?['message']}");
        return null;
      }
    } catch (e) {
      print("Exception in getVisitorById: $e");
      return null;
    }
  }

  Future<Visitors?> updateVisitorOutTime({
    required int userId,
    required int visitorId,
    required String outTime,
  }) async {
    const String mutation = r'''
  mutation UpdateVisitorOutTime($userId: Int!, $visitorId: Int!, $outTime: String!) {
    updateVisitorOutTime(userId: $userId, visitorId: $visitorId, outTime: $outTime) {
      message
      success
      data {
        checkedby
        createdat
        idproofimageurl
        intime
        meetingperson
        outtime
        personimageurl
        phone
        purpose
        updatedat
        updatedby
        visitorid
        visitorname
      }
    }
  }
  ''';

    final variables = {
      "userId": userId,
      "visitorId": visitorId,
      "outTime": outTime,
    };

    try {
      final QueryResult result = await graphqlService.performMutation(
        mutation,
        variables: variables,
      );

      if (result.hasException) {
        print("GraphQL exception: ${result.exception.toString()}");
        return null;
      }

      final response = result.data?['updateVisitorOutTime'];
      if (response != null && response['success'] == true) {
        final visitorJson = response['data'];
        return Visitors.fromJson(visitorJson);
      } else {
        print("Mutation failed: ${response?['message']}");
        return null;
      }
    } catch (e) {
      print("Exception in updateVisitorOutTime: $e");
      return null;
    }
  }


}
