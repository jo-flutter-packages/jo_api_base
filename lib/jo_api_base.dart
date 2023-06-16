library jo_api_base;

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'config/enums.dart';
import 'config/query_model.dart';
import 'config/response_model.dart';

class Api {
  static String jwt = "";

  Map<String, String> imageHeader = {
    HttpHeaders.authorizationHeader: "Bearer $jwt",
    "Accept": "multipart/byteranges",
    "content-type": "image/jpeg; charset=utf-8",
  };

  Map<String, String> bearerHeader = {
    HttpHeaders.authorizationHeader: "Bearer $jwt",
    "Accept": "application/json",
    "content-type": "application/json; charset=utf-8",
  };

  Map<String, String> formDataHeader = {
    "Accept": "multipart/form-data",
    "content-type": "application/json; charset=utf-8",
  };

  Map<String, String> basicHeader = {
    HttpHeaders.authorizationHeader: "Bearer $jwt",
    "Accept": "application/json",
    "content-type": "application/json; charset=utf-8",
  };

  Map<String, String> emptyHeader = {};

  Map<String, String> headerGetter(HeaderEnum typeEnum) {
    switch (typeEnum) {
      case HeaderEnum.imageHeaderEnum:
        return imageHeader;
      case HeaderEnum.bearerHeaderEnum:
        return bearerHeader;
      case HeaderEnum.formDataHeaderEnum:
        return formDataHeader;
      case HeaderEnum.basicHeaderEnum:
        return basicHeader;
      case HeaderEnum.emptyHeaderEnum:
        return emptyHeader;
      default:
        return basicHeader;
    }
  }

  String generateQuery(List<QueryModel> queries) {
    String query = "";
    if (queries.isNotEmpty) {
      query += "?";
      for (var element in queries) {
        if (element.value.isNotEmpty) {
          String nm = element.name;
          String vl = element.value;
          query += "$nm=$vl&";
        }
      }
    }
    return query;
  }

  String urlGenerator(String url, List<QueryModel> query) {
    var queryPart = generateQuery(query);
    return "$url$queryPart";
  }

  responseGetter<T>(ResponseEnum typeEnum, http.Response response) {
    try {
      switch (typeEnum) {
        case ResponseEnum.responseModelEnum:
          String data = utf8.decode(response.bodyBytes);
          if (data.isEmpty) {
            return ResponseModel(
              statusCode: "555",
              isSuccess: false,
              data: null,
            );
          }
          return ResponseModel().fromJson(
            json.decode(data),
          );
        default:
          return response.bodyBytes;
      }
    } catch (e) {
      return ResponseModel(
          isSuccess: false,
          statusCode: "500",
          data: null,
          message: "خطایی در عملیات رخ داده است");
    }
  }

  responseDynamicGetter<T>(ResponseEnum typeEnum, Response<dynamic> response) {
    try {
      switch (typeEnum) {
        case ResponseEnum.responseModelEnum:
          return ResponseModel().fromJson(response.data);
        default:
          return response.data.bodyBytes;
      }
    } catch (e) {
      return ResponseModel(
          isSuccess: false,
          statusCode: "500",
          data: null,
          message: "خطایی در عملیات رخ داده است");
    }
  }

  Future<ResponseModel> httpGET<T>(
    String url,
    List<QueryModel> query,
    HeaderEnum headerType,
    ResponseEnum responseType,
  ) async {
    try {
      var response = await http.get(
        Uri.parse(urlGenerator(url, query)),
        headers: headerGetter(headerType),
      );
      return responseGetter<T>(responseType, response);
    } catch (e) {
      return ResponseModel(
          isSuccess: false,
          statusCode: "500",
          data: null,
          message: "خطایی در عملیات رخ داده است");
    }
  }

  Future<ResponseModel> httpDELETE<T>(
    String url,
    List<QueryModel> query,
    var body,
    HeaderEnum headerType,
    ResponseEnum responseType,
  ) async {
    try {
      var response = await http.delete(
        Uri.parse(urlGenerator(url, query)),
        headers: headerGetter(headerType),
        body: body,
      );
      return responseGetter<T>(responseType, response);
    } catch (e) {
      return ResponseModel(
          isSuccess: false,
          statusCode: "500",
          data: null,
          message: "خطایی در عملیات رخ داده است");
    }
  }

  Future<ResponseModel> httpPOST<T>(String urlPath, List<QueryModel> query,
      var body, HeaderEnum headerType, ResponseEnum responseType) async {
    try {
      var url = Uri.parse(urlGenerator(urlPath, query));
      var headers = headerGetter(headerType);
      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      return responseGetter<T>(responseType, response);
    } catch (e) {
      return ResponseModel(
          isSuccess: false,
          statusCode: "500",
          data: null,
          message: "خطایی در عملیات رخ داده است");
    }
  }

  Future<ResponseModel> httpPUT<T>(
    String url,
    List<QueryModel> query,
    var body,
    HeaderEnum headerType,
    ResponseEnum responseType,
  ) async {
    try {
      var response = await http.put(
        Uri.parse(urlGenerator(url, query)),
        headers: headerGetter(headerType),
        body: body,
      );
      return responseGetter<T>(responseType, response);
    } catch (e) {
      return ResponseModel(
          isSuccess: false,
          statusCode: "500",
          data: null,
          message: "خطایی در عملیات رخ داده است");
    }
  }

  Future<ResponseModel> httpPUTFILE<T>(
    String url,
    List<QueryModel> query,
    FormData body,
    ResponseEnum responseType,
  ) async {
    try {
      Dio dio = Dio();
      var response = await dio.put(
        urlGenerator(url, query),
        data: body,
      );
      return responseGetter<T>(responseType, response.data);
    } catch (e) {
      return ResponseModel(
          isSuccess: false,
          statusCode: "500",
          data: null,
          message: "خطایی در عملیات رخ داده است");
    }
  }

  Future<ResponseModel> httpPOSTFORM<T>(
    String url,
    List<QueryModel> query,
    FormData body,
    HeaderEnum headerType,
    ResponseEnum responseType,
  ) async {
    try {
      Dio dio = Dio();

      var response = await dio.post(urlGenerator(url, query),
          data: body,
          options: Options(
            headers: headerGetter(headerType),
          ));
      return responseDynamicGetter<T>(responseType, response);
    } catch (e) {
      return ResponseModel(
          isSuccess: false,
          statusCode: "500",
          data: null,
          message: "خطایی در عملیات رخ داده است");
    }
  }
}
