import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rickmorty/providers/api_provider.dart';
import 'package:rickmorty/util/assets_images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getCharacters();
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Rick and Morty")),
      //    body: Center(child: ElevatedButton(onPressed:(){context.go('/character');} , child: Text('go to character')),),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child:
            !apiProvider.character.isNotEmpty
                ? Center(child: CircularProgressIndicator())
                : Center(child: CharacterList()),
      ),
    );
  }
}

class CharacterList extends StatelessWidget {
  const CharacterList({super.key, this.apiProvider});
  final ApiProvider? apiProvider; // Optional: Pass the provider as a parameter
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: context.read<ApiProvider>().character.length,
      itemBuilder: (context, index) {
        final character = context.read<ApiProvider>().character[index];
        return GestureDetector(
          onTap: () {
            context.go('/character/');
          },
          child: Card(
            child: Column(
              children: [
                FadeInImage(
                  placeholder: AssetImage(portalgif),
                  image: NetworkImage(character.image as String),
                ),

                Text(character.name as String),
              ],
            ),
          ),
        );
      },
    );
  }
}
