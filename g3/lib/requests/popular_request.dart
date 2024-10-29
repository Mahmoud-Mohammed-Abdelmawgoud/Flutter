import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/popular_info_model.dart';

class PopularRequest {
  static void getPopularInfo({
    required int id,
    required Function(PopularInfoModel) onSuccess,
    required Function(int error) onError,
  }) async {
    // Define headers for the request
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // Construct the URL with the provided ID and API key
    final Uri uri = Uri.parse(
        'https://api.themoviedb.org/3/person/$id?api_key=2dfe23358236069710a379edd4c65a6b');

    try {
      // Make the GET request
      final response = await http.get(uri, headers: headers);

      // Check the response status code
      if (response.statusCode == 200) {
        // Decode the response body
        Map<String, dynamic> decoded = json.decode(response.body);

        // Convert the decoded JSON to PopularInfoModel
        PopularInfoModel popularInfoModel = PopularInfoModel.fromJson(decoded);

        // Call the success callback
        onSuccess(popularInfoModel);
      } else {
        // Call the error callback with the status code
        onError(response.statusCode);
      }
    } catch (e) {
      // Call the error callback with a custom error code
      onError(-1);
    }
  }
}
