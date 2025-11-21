import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teeklit/domain/model/teekle/workout_response.dart';

class WorkoutApiService {
  final String baseUrl = 'https://api.odcloud.kr/api/';

  Future<WorkoutResponse> fetchWorkouts({
    int page = 1,
    int perPage = 10,
  }) async {
    final uri = Uri.https('api.odcloud.kr', '/api/15084814/v1/uddi:3f8d6b98-0082-4792-92a8-90d40ecc4bce',
      {
        'page': '$page',
        'perPage': '$perPage',
        'serviceKey': 'w/MELd9XyVg3L/HyIxqjQP1Rz+krtzKZiQhzPVvgs5qVWS4VGDCgfyQBOngPo/wAk9vQTIEn5YIZBWM85+m0oA=='  //TODO. 서비스키 어디에 놓을지?
      }
    );
    final response = await http.get(uri);
    
    if(response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return WorkoutResponse.fromJson(jsonMap);
    } else {
      throw Exception('운동 영상 불러오기 실패: ${response.statusCode}');
    }
  }
}
