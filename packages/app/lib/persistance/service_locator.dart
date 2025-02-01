import 'package:tedbook/main.dart';
import 'package:tedbook/persistance/remote/api_provider.dart';
import 'package:tedbook/persistance/user_data.dart';

setupLocator() {
  getIt.registerSingleton<UserData>(UserData.create());
  getIt.registerSingleton<ApiProvider>(ApiProvider.create());
}

T getInstance<T extends Object>({
  String? instanceName,
  dynamic param1,
  dynamic param2,
  Type? type,
}) =>
    getIt.get<T>(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
      type: type,
    );
