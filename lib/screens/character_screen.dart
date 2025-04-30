import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickmorty/models/character_model.dart';
import 'package:rickmorty/providers/api_provider.dart';

class CharacterScreen extends StatelessWidget {
  final Character character;

  const CharacterScreen({super.key, required this.character});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text(character.name!)),
      body: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(character.image!),
                ),
                const SizedBox(height: 20),
                Text(
                  character.name!,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  character.status!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    children: [
                      cardData(character.species!, "Species"),
                      cardData(character.gender!, "gender"),
                      cardData(character.origin!.name!, "Origin Universe"),
                    ],
                  ),
                  EpisodeList(character: character as Character, size: size),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardData(String text1, String text2) {
    return Expanded(
      child: Card(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text2,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              text1,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}

class EpisodeList extends StatefulWidget {
  final Character character;
  final Size size;
  const EpisodeList({super.key, required this.character, required this.size});
  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  @override
  void initState() {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getEpisodes(widget.character);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    return SizedBox(
      height: widget.size.height * 0.4,
      child: ListView.builder(
        itemCount: apiProvider.episode.length,
        itemBuilder: (context, index) {
          final episode = apiProvider.episode[index];
          return Card(
            child: ListTile(
              title: Text(episode.name!),
              subtitle: Text(episode.airDate!),
              trailing: Text(episode.episode!),
            ),
          );
        },
      ),
    );
  }
}
