import '../Model/UserModel.dart';
import '../Service/GraphqlService/Graphql_Service.dart';

class UserController {
  final GraphQLService graphqlService;

  UserController(this.graphqlService);

  // Get All Users
  Future<UserModel?> fetchAllUsers() async {
    const String query = '''
      query {
        users {
          companyname
          createdAt
          email
          isActive
          passwordhash
          phonenumber
          roleId
          updatedAt
          userId
          username
        }
      }
    ''';

    final result = await graphqlService.performQuery(query);

    if (result.hasException) {
      print('GraphQL Exception: ${result.exception.toString()}');
      return null;
    }

    if (result.data == null || result.data!['users'] == null) {
      print('No data found');
      return null;
    }

    // Wrap the users list inside the "data" key to match your UserModel structure
    final Map<String, dynamic> wrappedData = {
      "data": {
        "users": result.data!['users']
      }
    };

    return UserModel.fromJson(wrappedData);
  }

  // Login User
  Future<Map<String, dynamic>> loginUser(String emailOrPhone, String password) async {
    const String mutation = '''
    mutation Login(\$emailOrPhone: String!, \$password: String!) {
      loginUser(emailOrPhone: \$emailOrPhone, password: \$password) {
        message
        success
        data {
          companyname
          createdAt
          email
          isActive
          passwordhash
          phonenumber
          roleId
          updatedAt
          userId
          username
        }
      }
    }
  ''';

    final variables = {
      "emailOrPhone": emailOrPhone,
      "password": password,
    };

    final result = await graphqlService.performMutation(mutation, variables: variables);

    if (result.hasException) {
      print("Login Error: ${result.exception.toString()}");
      return {
        'user': null,
        'message': "Something went wrong. Please try again later.",
      };
    }

    final loginData = result.data?['loginUser'];
    final userJson = loginData?['data'];
    final message = loginData?['message'] ?? "Login failed.";

    return {
      'user': userJson != null ? Users.fromJson(userJson) : null,
      'message': message,
    };
  }


  // User Register
  Future<Map<String, dynamic>> createUserWithResponse({
    required String companyName,
    required String email,
    required String phoneNumber,
    required String password,
    required int roleId,
    required bool isActive,
  }) async {
    const String mutation = '''
    mutation CreateUser(
      \$companyName: String!,
      \$email: String!,
      \$phoneNumber: String!,
      \$password: String!,
      \$roleId: Int!,
      \$isActive: Boolean!
    ) {
      createUser(
        companyName: \$companyName,
        email: \$email,
        phoneNumber: \$phoneNumber,
        password: \$password,
        roleId: \$roleId,
        isActive: \$isActive
      ) {
        message
        success
        data {
          companyname
          createdAt
          email
          isActive
          passwordhash
          phonenumber
          roleId
          updatedAt
          userId
          username
        }
      }
    }
  ''';

    final variables = {
      "companyName": companyName,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password,
      "roleId": roleId,
      "isActive": isActive,
    };

    final result = await graphqlService.performMutation(mutation, variables: variables);

    if (result.hasException) {
      print("Create User Error: ${result.exception.toString()}");
      return {"user": null, "message": "Something went wrong. Please try again."};
    }

    final responseData = result.data?['createUser'];
    final message = responseData?['message'];

    if (responseData == null || responseData['data'] == null) {
      print("Invalid user creation response");
      return {"user": null, "message": message ?? "Failed to register user."};
    }

    return {
      "user": Users.fromJson(responseData['data']),
      "message": message,
    };
  }


}

