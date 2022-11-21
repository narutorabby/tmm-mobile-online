import 'package:dio/dio.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/services/helpers.dart';

class ApiManager {
  late BasicResponse basicResponse;

  Future<BasicResponse> apiCall(method, url, params, inputData) async {

    Dio dio = Dio();
    // dio.options.baseUrl = "http://192.168.0.100/track-my-money/track-my-money/public/api/";
    dio.options.baseUrl = "https://trackmymoney.xyz/api/";
    var token = await Helpers.getToken();
    dio.options.headers = {
      'Authorization': token,
      'Content-type': "application/json; charset=UTF-8",
      'Accept': "application/json",
    };

    bool internet = await Helpers.checkConnectivity();
    if(!internet){
      return BasicResponse(response: "error", message: "No internet connection", data: null);
    }
    try{
      late Response response;
      if(method == "GET"){
        response = await dio.get(url, queryParameters: params);
      }
      else if(method == "POST"){
        response = await dio.post(url, data: inputData, queryParameters: params);
      }
      else if(method == "DELETE"){
        response = await dio.delete(url, data: inputData, queryParameters: params);
      }
      basicResponse = BasicResponse(
          response: response.data["response"],
          message: response.data["message"],
          data: response.data["data"]
      );
      return basicResponse;
    }
    on DioError catch(e){
      print(e);
      return BasicResponse(response: "error", message: "Something went wrong", data: null);
    }
  }
}