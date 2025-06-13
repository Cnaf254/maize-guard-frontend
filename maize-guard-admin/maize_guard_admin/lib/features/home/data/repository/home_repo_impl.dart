import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:maize_guard_admin/core/error/failure.dart';
import 'package:maize_guard_admin/core/network/network_info.dart';
import 'package:maize_guard_admin/features/home/domain/entities/entity.dart';
import 'package:maize_guard_admin/features/home/domain/repository/home_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constant/api_constant.dart';

class HomeRepoImpl implements HomeRepository {
  final SharedPreferences sharedPreferences;
  final NetworkInfo networkInfo;
  final http.Client client;
  HomeRepoImpl({
    required this.client,
    required this.networkInfo,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, void>> addExpert({required Expert expert}) async {
    if (await networkInfo.isConnected) {
      var token = sharedPreferences.getString("token");
      expert.phone = "+251${expert.phone.substring(1)}";
      print(expert.toJson());
      final response = await client.post(
        Uri.parse("${ApiConstant.baseUrl}/register/expert"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: expert.toJson(),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        sharedPreferences.setString('phone', expert.phone);
        return Future.value(Right(null));
      } else {
        return Future.value(
            Left(ServerFailure(message: "Registration failed")));
      }
    } else {
      return Future.value(
          Left(ServerFailure(message: "No internet connection")));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpert({required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        var token = sharedPreferences.getString("token");
        final response = await client.delete(
          Uri.parse("${ApiConstant.baseUrl}/admin/user/$id"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          return Right(null);
        } else if (response.statusCode == 401) {
          return Left(ServerFailure(message: "Unauthorized"));
        } else if (response.statusCode == 403) {
          return Left(ServerFailure(message: "Forbidden"));
        } else if (response.statusCode == 404) {
          return Left(ServerFailure(message: "Not Found"));
        }
        return Left(ServerFailure(message: "Failed to delete expert"));
      } else {
        return Left(ServerFailure(message: "No Internet Connection!"));
      }
    } catch (e) {
      print(e.toString());
      return Left(ServerFailure(message: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, List<Expert>>> getExperts() async {
    try {
      if (await networkInfo.isConnected) {
        var token = sharedPreferences.getString("token");
        print("token:$token");
        final response = await client.get(
          Uri.parse("${ApiConstant.baseUrl}/admin/user"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final List<Expert> experts = [];
          final List<dynamic> data = json.decode(response.body)["users"];
          for (var item in data) {
            item["phone"] = item["phone"].replaceFirst("+251", "0");
            experts.add(Expert.fromMap(item));
          }

          return Right(experts);
        } else if (response.statusCode == 401) {
          return Left(ServerFailure(message: "Unauthorized"));
        } else if (response.statusCode == 403) {
          return Left(ServerFailure(message: "Forbidden"));
        } else if (response.statusCode == 404) {
          return Left(ServerFailure(message: "Not Found"));
        }
        return Right([]);
      } else {
        return Left(ServerFailure(message: "No Internet Connection!"));
      }
    } catch (e) {
      print(e.toString());
      return Left(ServerFailure(message: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, void>> updateExpert({required Expert expert}) async {
    try {
      if (await networkInfo.isConnected) {
        var token = sharedPreferences.getString("token");
        var id = expert.id;
        print("id: $id");
        print("expert: ${expert.toJson()}");
        final response = await client.put(
          Uri.parse("${ApiConstant.baseUrl}/admin/user/$id"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: expert.toJson(),
        );
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          return Right(null);
        } else if (response.statusCode == 401) {
          return Left(ServerFailure(message: "Unauthorized"));
        } else if (response.statusCode == 403) {
          return Left(ServerFailure(message: "Forbidden"));
        } else if (response.statusCode == 404) {
          return Left(ServerFailure(message: "Not Found"));
        }
        return Left(ServerFailure(message: "Failed to update expert"));
      } else {
        return Left(ServerFailure(message: "No Internet Connection!"));
      }
    } catch (e) {
      print(e.toString());
      return Left(ServerFailure(message: "An error occurred"));
    }
  }
}
