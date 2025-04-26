import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rickmorty/models/character_model.dart';

class ApiProvider with ChangeNotifier{
  final url = 'rickandmortyapi.com';

  List<Character> character = [];

  Future<void> getCharacters() async {
    final result   = await http.get(Uri.https(url,"/api/character"));
    final response =  characterResponseFromJson(result.body);
    character.addAll(response.results!);
  }

}