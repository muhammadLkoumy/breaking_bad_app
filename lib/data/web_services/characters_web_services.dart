import '../../constants/strings.dart';
import 'package:dio/dio.dart';

class CharactersWebServices {
  late Dio dio;

  BaseOptions baseOptions = BaseOptions(
    baseUrl: baseUrl,
    receiveDataWhenStatusError: true,
    connectTimeout: 20 * 1000,
    receiveTimeout: 20 * 1000,
  );

  CharactersWebServices() {
    dio = Dio(baseOptions);
  }

  Future<List<dynamic>> getAllCharacters() async {
    try {
      Response response = await dio.get('characters');
      return response.data;
    } catch (error) {
      return [];
    }
  }

  Future<List<dynamic>> getCharacterQuote({
    required String charName,
  }) async {
    try {
      Response response = await dio.get(
        'quote',
        queryParameters: {
          'author': charName,
        },
      );
      return response.data;
    } catch (error) {
      return [];
    }
  }
}
