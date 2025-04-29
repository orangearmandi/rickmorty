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
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;
  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getCharacters(page: page);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        apiProvider.getCharacters(page: page);
        page++;
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Rick and Morty")),
      //    body: Center(child: ElevatedButton(onPres|sed:(){context.go('/character');} , child: Text('go to character')),),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child:
            !apiProvider.character.isNotEmpty
                ? Center(child: CircularProgressIndicator())
                : Center(
                  child: CharacterList(
                    apiProvider: apiProvider,
                    scrollController: scrollController,
                    isLoading: isLoading,
                  ),
                ),
      ),
    );
  }
}

class CharacterList extends StatelessWidget {
  const CharacterList({
    super.key,
    required this.apiProvider,
    required this.scrollController,
    required this.isLoading,
  });
  final ApiProvider? apiProvider; // Optional: Pass the provider as a parameter
  final ScrollController scrollController;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount:
          isLoading
              ? context.read<ApiProvider>().character.length + 2
              : context.read<ApiProvider>().character.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index < context.read<ApiProvider>().character.length) {
          final character = context.read<ApiProvider>().character[index];
          return GestureDetector(
            onTap: () {
              context.go('/character', extra: character);
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
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
