import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tedbook/main.dart';
import 'package:tedbook/model/request/firebasetoken_request.dart';
import 'package:tedbook/model/request/login_request.dart';
import 'package:tedbook/model/request/put_order_request.dart';
import 'package:tedbook/model/response/login_response.dart';
import 'package:tedbook/model/response/order_response.dart';
import 'package:tedbook/model/response/verify_sms_response.dart';
import 'package:tedbook/pages/home/bloc/home_bloc.dart';
import 'package:tedbook/persistance/service_locator.dart';
import 'package:tedbook/persistance/user_data.dart';
import 'package:tedbook/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'exceptions.dart';

class ApiProvider {
  final Dio _dio = Dio();
  UserData _userData = getInstance();

  ApiProvider._() {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          debugLog(1);
          if (!options.path.contains("/refresh")) {
            debugLog(2);
            var token = await _userData.accessToken();
            debugLog(3);
            if (token?.isNotEmpty == true &&
                !options.headers.containsKey(HttpHeaders.authorizationHeader)) {
              debugLog(4);
              final tokenExpired = JwtDecoder.isExpired(token!);
              debugLog(5);

              if (tokenExpired) {
                debugLog(6);
                final token = await getAccessToken();
                debugLog(7);
                if (token == null) {
                  debugLog(8);
                  return;
                } else {
                  debugLog(9);
                  options.headers.putIfAbsent(
                      HttpHeaders.authorizationHeader, () => '$token');
                  debugLog(10);
                }
              } else {
                debugLog(11);
                options.headers.putIfAbsent(
                    HttpHeaders.authorizationHeader, () => '$token');
                debugLog(12);
              }
            }
          }
          options.headers.putIfAbsent(HttpHeaders.contentTypeHeader,
              () => 'application/json; charset=UTF-8');
          final preferences = await SharedPreferences.getInstance();
          final strLocale = preferences.getString('locale');
          options.headers["Accept-Language"] = strLocale ?? "uz";
          debugLog(
              "----------------------------------------------------------------\n\t\t\tRequest\n\tMethod: ${options.method}\n\tPath: ${options.path}\n\tHeader: ${options.headers}\n${options.data != null ? "\tBody: ${getBodyData(options.data)}\n" : ""}\n----------------------------------------------------------------------");
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          debugLog(
              "----------------------------------------------------------------\n\t\t\tResponse\n\tMethod: ${response.requestOptions.method}\n\tPath: ${response.requestOptions.path}\n\tStatusCode: ${response.statusCode}\n\tStatusMessage: ${response.statusMessage}\n\tHeader: ${response.requestOptions.headers}\n${response.data != null ? "\tBody: ${getBodyData(response.data)}\n" : ""}\n----------------------------------------------------------------------");
          return handler.next(response);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          debugLog("DioException $e");
          debugLog(
              "----------------------------------------------------------------\n\t\t\tError\n\tMethod: ${e.requestOptions.method}\n\tPath: ${e.requestOptions.path}\n\tStatusCode: ${e.response?.statusCode}\n\tStatusMessage: ${e.response?.statusMessage}\n\tHeader: ${e.requestOptions.headers}\n${e.requestOptions.data != null ? "\tBody: ${getBodyData(e.requestOptions.data)}\n" : ""}\n\tResponse body: ${e.response?.data}\n----------------------------------------------------------------------");

          if (e.response?.statusCode == HttpStatus.unauthorized) {
            return handler.next(e);
          } else {
            return handler.next(e);
          }
        },
      ),
    );
  }

  // Attention!!!
  // Don't use create or default constructor. Use getInstance() method to get ApiProvider object
  factory ApiProvider.create() => ApiProvider._();

  static const baseUrl = 'https://techdev.uz';
  // static const baseUrl = 'https://api.tedbookcrm.uz';

  static const authApi = '$baseUrl/auth';

  String getBodyData(dynamic data) {
    try {
      if (data is FormData) {
        return data.fields.toString();
      }
      return jsonEncode(data);
    } catch (e) {
      return data;
    }
  }

  bool _isRefreshing = false;
  final Queue<Completer<String>> _tokenRefreshQueue = Queue();

  Future<String?> getAccessToken() async {
    String? accessToken;
    if (_isRefreshing) {
      Completer<String> completer = Completer();
      _tokenRefreshQueue.add(completer);
      return completer.future;
    }
    _isRefreshing = true;
    try {
      String newToken = await refreshToken();
      accessToken = newToken;
      while (_tokenRefreshQueue.isNotEmpty) {
        _tokenRefreshQueue.removeFirst().complete(newToken);
      }
    } catch (error) {
      final context = MyApp.navigatorKey.currentContext;
      context?.read<HomeBloc>().add(LogoutEvent());
      while (_tokenRefreshQueue.isNotEmpty) {
        _tokenRefreshQueue.removeFirst().completeError(error);
      }
    } finally {
      _isRefreshing = false;
    }
    return accessToken;
  }

  Future refreshToken() async {
    debugLog("-------------------refreshToken-------------------");
    var res;
    try {
      var url = '$authApi/refresh';
      var refreshToken = await _userData.refreshToken();
      debugLog(refreshToken);
      final response =
          await _dio.post(url, data: {"refreshToken": refreshToken});
      debugLog(response.data);

      TokenData successResponse = TokenData.fromJson(response.data);
      if (successResponse.accessToken != null) {
        await _userData.saveAccessToken(successResponse.accessToken!);
        res = successResponse.accessToken;
      }
    } on FetchDataException {
      throw FetchDataException(message: "No Internet connection");
    }
    return res;
  }

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      debugLog("${request.toJson()}");

      final response = (await _dio.post(
        "$authApi/login",
        data: request.toJson(),
      ))
          .data;
      return LoginResponse.fromJson(response);
    } catch (e) {
      debugLog("FetchDataException: $e");
      throw FetchDataException(message: e);
    }
  }

  Future<dynamic> setFirebaseToken(FirebaseTokenRequest request) async {
    try {
      final response = (await _dio.post(
        "$baseUrl/api/v1/set-token",
        data: request.toJson(),
      ))
          .data;
      return response;
    } catch (e) {
      debugLog("FetchDataException: $e");
      throw FetchDataException(message: e);
    }
  }

  Future<OrderResponse> getOrders(String userId) async {
    try {
      final response =
          (await _dio.get("$baseUrl/api/v1/order/user/$userId")).data;
      return OrderResponse.fromJson(response);
    } catch (e) {
      debugLog("$e");
      throw FetchDataException(message: e);
    }
  }

  Future<dynamic> orderCompletion(
      {required String orderId, required PutOrderRequest request}) async {
    try {
      final response = (await _dio.put(
        "$baseUrl/api/v1/order/$orderId",
        data: request.toJson(),
      ))
          .data;
      return response;
    } catch (e) {
      debugLog("$e");
      throw FetchDataException(message: e);
    }
  }
}
