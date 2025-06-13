import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:maize_guard_admin/core/constant/api_constant.dart';
import 'package:maize_guard_admin/core/error/failure.dart';
import 'package:maize_guard_admin/core/network/network_info.dart';
import 'package:maize_guard_admin/features/auth/domain/entities/entities.dart';
import 'package:maize_guard_admin/features/auth/domain/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthRepoImpl implements AuthRepository {
  final SharedPreferences sharedPreferences;
  final NetworkInfo networkInfo;
  final http.Client client;
  AuthRepoImpl({
    required this.sharedPreferences,
    required this.networkInfo,
    required this.client,
  });

  @override
  Future<Either<Failure, String>> isLoggedIn() async {
    if (await networkInfo.isConnected) {
      String? token = sharedPreferences.getString('token');
      if (token != null) {
        return Future.value(Right(token));
      } else {
        return Future.value(Left(ServerFailure(message: "Login first")));
      }
    } else {
      return Future.value(
          Left(ServerFailure(message: "No internet connection")));
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    if (await networkInfo.isConnected) {
      sharedPreferences.remove('token');
      return Future.value(Right(null));
    } else {
      return Future.value(
          Left(ServerFailure(message: "No internet connection")));
    }
  }

  @override
  Future<Either<Failure, String>> login(
      {required String phone, required String password}) async {
    try {
      if (await networkInfo.isConnected) {
        phone = "+251${phone.substring(1)}";
        print("${ApiConstant.baseUrl}/login");
        final response = await client.post(
          Uri.parse("${ApiConstant.baseUrl}/login"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'phone': phone,
            'password': password,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> responseBody = jsonDecode(response.body);
          if (responseBody["user"]["role"] != "admin") {
            return Future.value(Left(ServerFailure(message: "Not an admin")));
          }

          final token = jsonDecode(response.body)['token'];

          if (token == null) {
            return Future.value(Left(ServerFailure(message: "Login failed")));
          }
          await sharedPreferences.setString('token', token);
          await sharedPreferences.setString('phone', phone);
          return Future.value(Right(token));
        } else {
          return Future.value(Left(ServerFailure(message: "Login failed")));
        }
      } else {
        return Future.value(
            Left(ServerFailure(message: "No internet connection")));
      }
    } catch (e) {
      print(e.toString());
      return Future.value(Left(ServerFailure(message: "Login failed")));
    }
  }

  @override
  Future<Either<Failure, void>> registerAdmin(User user) async {
    if (await networkInfo.isConnected) {
      user.phone = "+251${user.phone.substring(1)}";
      var token = sharedPreferences.getString("token");
      print(user.toJson());
      final response = await client.post(
        Uri.parse("${ApiConstant.baseUrl}/register/admin"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: user.toJson(),
      );
      print(response.statusCode);
      print(response.body);
      var body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Future.value(Right(null));
      } else {
        return Future.value(Left(ServerFailure(message: body["message"])));
      }
    } else {
      return Future.value(
          Left(ServerFailure(message: "No internet connection")));
    }
  }
}
