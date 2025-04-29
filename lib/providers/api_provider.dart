import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rickmorty/models/character_model.dart';
import 'package:rickmorty/models/episode_model.dart';

class ApiProvider with ChangeNotifier {
  final url = 'rickandmortyapi.com';

  List<Character> character = [];
  List<Episode> episode = [];

  Future<void> getCharacters({required int page}) async {
    final result = await http.get(
      Uri.https(url, "/api/character", {'page': page.toString()}),
    );
    // final characterResponse = CharacterResponse.fromJson(result.body);
    final response = characterResponseFromJson(result.body);
    character.addAll(response.results!);
    notifyListeners();
  }

  Future<List<Episode>> getEpisodes(Character character) async {
    episode = [];
    for (var i = 0; i < character.episode!.length; i++) {
      final result = await http.get(Uri.parse(character.episode![i]));
      final response = EpisodeFromJson(result.body);
      episode.add(response);
      notifyListeners();
    }
    return episode;
  }
}
