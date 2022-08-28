import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:search_app/helpers/debouncer.dart';
import '../models/models.dart';

class MoviesProvider extends ChangeNotifier{
  final String _baseURL = 'api.themoviedb.org';
  final String _apiKey = '1865f43a0549ca50d341dd9ab8b29f49';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};
  int _popularPage = 0;
  
  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));
  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  MoviesProvider() {
    getDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData( String endPoint, [int page = 1]) async {
    final url = Uri.https(_baseURL, endPoint, {
        'api_key': _apiKey,
        'language': _language,
        'page': '$page'
      });
    final response = await http.get(url);
    return response.body;
  }

  getDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    print('informacion');
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseURL, '3/search/movie', {
        'api_key': _apiKey,
        'language': _language,
        'query': query,
    });
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      print('tenemos valor $value');
      final result = await searchMovies(value);
      _suggestionStreamController.add(result);
    };
    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
     });

     Future.delayed(const Duration(milliseconds: 300)).then((value) => timer.cancel());
  }
}
