import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../resources/constants/endpoints.dart';
import '../utils/functions.dart';
import 'api_service.dart';

class ApiClient {
  var headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  // Integration with the new comprehensive API service
  final ApiService _apiService = ApiService();

  Future<(bool, String)> getRequest(
    String endpoint, {
    required BuildContext context,
    String requestName = "",
    bool printResponseBody = false,
    bool isFetchMore = false,
  }) async {
    (bool, String) requestResponse = (false, "");
    try {
      final response = await http.get(
        Uri.parse(isFetchMore ? endpoint : '$basedURL/$endpoint'),
        headers: headerWithTokenMapFunc(),
      );
      if (!context.mounted) return (false, "Context not mounted");
      debugPrint("$requestName Status Code: ${response.statusCode}");
      if (printResponseBody) {
        debugPrint("$requestName Response body: ${response.body}");
      }
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        requestResponse = (true, response.body);
      } else if (response.statusCode == 401) {
        logoutAndClearHive(context: context);
        requestResponse = (false, decodedResponse["message"]);
      } else {
        requestResponse = (false, decodedResponse["message"]);
      }
    } on SocketException catch (_) {
      requestResponse = (false, "No Internet Connection");
    } catch (e) {
      debugPrint("$requestName Exception: ${e.toString()}");
      requestResponse = (false, "Something went wrong");
    }

    return requestResponse;
  }

  Future<(bool, String)> deleteRequest(
    String endpoint, {
    required BuildContext context,
    String requestName = "",
    bool printResponseBody = false,
  }) async {
    (bool, String) requestResponse = (false, "");
    try {
      final response = await http.delete(
        Uri.parse('$basedURL/$endpoint'),
        headers: headerWithTokenMapFunc(),
      );
      debugPrint("$requestName Status Code: ${response.statusCode}");
      if (printResponseBody) {
        debugPrint("$requestName Response body: ${response.body}");
      }
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        requestResponse = (true, response.body);
      } else if (response.statusCode == 401) {
        // logoutAndClearHive(context: context);
        requestResponse = (false, decodedResponse["message"]);
      } else {
        requestResponse = (false, decodedResponse["message"]);
      }
    } on SocketException catch (_) {
      requestResponse = (false, "No Internet Connection");
    } catch (e) {
      debugPrint("$requestName Exception: ${e.toString()}");
      requestResponse = (false, "Something went wrong");
    }

    return requestResponse;
  }

  Future<(bool, String)> postRequest(
    String endpoint, {
    required BuildContext context,
    required Map<String, dynamic> body,
    String sentToken = "",
    String requestName = "Post Request",
    bool printResponseBody = false,
  }) async {
    (bool, String) postResponse = (false, "");
    try {
      debugPrint("The URL is: $basedURL/$endpoint");
      final response = await http.post(Uri.parse("$basedURL/$endpoint"),
          headers: headerWithTokenMapFunc(sentToken: sentToken),
          body: json.encode(body));
      debugPrint("$requestName Status Code: ${response.statusCode}");
      if (printResponseBody) {
        debugPrint("$requestName Response body: ${response.body}");
      }
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        postResponse = (true, response.body);
      } else if (response.statusCode == 401) {
        debugPrint("Un authenticated");
        // logoutAndClearHive(context: context);
        postResponse = (false, decodedResponse["message"]);
      } else if (response.statusCode == 403) {
        postResponse = (false, "403");
        // popLoader(context: context);
        // showAppInBetaModeModal(context);
      } else {
        postResponse = (false, decodedResponse["message"]);
      }
    } on SocketException catch (_) {
      // popLoader(context: context);
      postResponse = (false, "No Internet Connection");
    } catch (e) {
      // popLoader(context: context);
      debugPrint("$requestName Exception::::: ${e.toString()}");
      postResponse = (false, "Something went wrong!");
    }
    return postResponse;
  }

  Future<(bool, String)> patchRequest(
    String endpoint, {
    required BuildContext context,
    required Map<String, dynamic> body,
    String requestName = "Patch Request",
    bool printResponseBody = false,
  }) async {
    (bool, String) postResponse = (false, "");
    try {
      debugPrint("The URL is: $basedURL/$endpoint");
      final response = await http.patch(Uri.parse("$basedURL/$endpoint"),
          headers: headerWithTokenMapFunc(), body: json.encode(body));
      if (!context.mounted) return (false, "Context not mounted");
      debugPrint("$requestName Status Code: ${response.statusCode}");
      if (printResponseBody) {
        debugPrint("$requestName Response body: ${response.body}");
      }
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        postResponse = (true, response.body);
      } else if (response.statusCode == 401) {
        debugPrint("Un authenticated");
        logoutAndClearHive(context: context);
        postResponse = (false, decodedResponse["message"]);
      } else if (response.statusCode == 403) {
        postResponse = (false, "403");
        popLoader(context: context);
      } else {
        postResponse = (false, decodedResponse["message"]);
      }
    } on SocketException catch (_) {
      popLoader(context: context);
      postResponse = (false, "No Internet Connection");
    } catch (e) {
      popLoader(context: context);
      debugPrint("$requestName Exception::::: ${e.toString()}");
      postResponse = (false, "Something went wrong!");
    }
    return postResponse;
  }

  Future<(bool, String)> putRequest(
    String endpoint, {
    required BuildContext context,
    required Map<dynamic, dynamic> body,
    String requestName = "Put Request",
    bool printResponseBody = false,
  }) async {
    (bool, String) putResponse = (false, "");
    try {
      final response = await http.put(Uri.parse("$basedURL/$endpoint"),
          headers: headerWithTokenMapFunc(), body: json.encode(body));
      if (!context.mounted) return (false, "Context not mounted");
      debugPrint("$requestName Status Code: ${response.statusCode}");
      if (printResponseBody) {
        debugPrint("$requestName Response body: ${response.body}");
      }
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        putResponse = (true, response.body);
      } else if (response.statusCode == 401) {
        logoutAndClearHive(context: context);
        putResponse = (false, decodedResponse["message"]);
      } else {
        putResponse = (false, decodedResponse["message"]);
      }
    } on SocketException catch (_) {
      putResponse = (false, "No Internet Connection");
    } catch (e) {
      debugPrint("$requestName Exception::::: ${e.toString()}");
      putResponse = (false, "Something went wrong");
    }
    return putResponse;
  }

  Future<(bool, String)> postFormDataRequest(
    String endpoint, {
    required BuildContext context,
    required Map<String, String> fields,
    File? file,
    String documentFieldName = "",
    String requestName = "Post Request",
    bool printResponseBody = false,
  }) async {
    (bool, String) postResponse = (false, "");
    try {
      // var header = {
      //   'Content-Type': 'multipart/form-data',
      //   'Authorization': "Bearer ${_hiveUserData?.token ?? ""}",
      // };

      final request = http.MultipartRequest(
        'Post',
        Uri.parse(endpoint),
      );
      request.headers.addAll(headerWithTokenAndFormDataMapFunc());
      request.fields.addAll(fields);

      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath(
            documentFieldName, file.path,
            contentType: MediaType('image', 'jpg'),
            filename: file.path.split(".").last));

        debugPrint("File Path added======");
      }

      await request.send().then((response) {
        response.stream.transform(utf8.decoder).listen((value) async {
          debugPrint("RESPONSE BODY::::$value");
          debugPrint("The status CODE ===== ${response.statusCode}");
          if (response.statusCode == 200 || response.statusCode == 201) {
            debugPrint("Document Uploaded============");
          } else {}
        });
      });
    } catch (e) {/* Intentionally left empty */}
    return postResponse;
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    bool isAuthorized = true,
  }) async {
    if (isAuthorized) {
      headers.addAll({'Authorization': 'Bearer ${getToken()}'});
    }
    final response = await http.get(
      Uri.parse('$basedURL/$endpoint'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      log(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map body,
    bool isAuthorized = true,
  }) async {
    if (isAuthorized) {
      headers.addAll({'Authorization': 'Bearer ${getToken()}'});
    }
    final response = await http.post(
      Uri.parse('$basedURL/$endpoint'),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }

  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    required List<File> files,
  }) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$basedURL/$endpoint'));

    headers.addAll({'Authorization': 'Bearer ${getToken()}'});

    request.headers.addAll(headers);

    // Add fields to the request
    request.fields.addAll(fields);

    // Add files to the request
    for (var file in files) {
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path,
            contentType: MediaType('image', 'png'),
            filename: file.path.split(".").last),
      );
    }

    // Send the request
    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post multipart data');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map body,
    bool isAuthorized = true,
  }) async {
    if (isAuthorized) {
      headers.addAll({'Authorization': 'Bearer ${getToken()}'});
    }
    final response = await http.put(
      Uri.parse('$basedURL/$endpoint'),
      headers: headers,
      body: json.encode(body),
    );

    debugPrint(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    required Map body,
    bool isAuthorized = true,
  }) async {
    if (isAuthorized) {
      headers.addAll({'Authorization': 'Bearer ${getToken()}'});
    }
    final response = await http.patch(
      Uri.parse('$basedURL/$endpoint'),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }
}

Map<String, String> headerMapFunc() {
  return {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };
}

Map<String, String> headerWithTokenAndFormDataMapFunc() {
  String token = getToken();
  return {
    "Accept": "application/json",
    'Content-Type': 'multipart/form-data',
    'Authorization': 'Bearer $token'
  };
}

Map<String, String> headerWithTokenMapFunc({String sentToken = ""}) {
  String token = sentToken.isEmpty ? getToken() : sentToken;
  // debugPrint("Token Retrieved in headerWithTokenMapFunc:::::::::::$token");
  return {
    "Accept": "application/json",
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
}

// Map<String, String> headerWithTokenNoContentTypeMapFunc(){
//   String token = getToken();
//   debugPrint("Token Retrieved in headerWithTokenMapFunc:::::::::::$token");
//   return {
//     "Accept": "application/json",
//     'Content-Type': 'application/json',
//     "X-Hashit-Api": xApiHeader,
//     'Authorization': 'Bearer $token'
//   };
// }
