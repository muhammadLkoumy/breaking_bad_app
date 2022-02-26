import 'package:flutter_offline/flutter_offline.dart';

import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data/models/character.dart';
import '../widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<Character> allCharacters = [];
  List<Character> searchedCharacters = [];
  final _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    CharactersCubit.get(context).getAllCharacters();
    super.initState();
  }

  Widget _buildSearchWidget() {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Find a character...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          fontSize: 18,
          color: MyColors.myGrey,
        ),
      ),
      style: const TextStyle(
        fontSize: 18,
        color: MyColors.myGrey,
      ),
      cursorColor: MyColors.myGrey,
      controller: _searchController,
      onChanged: (searchedCharacter) {
        _buildSearchList(searchedCharacter);
      },
    );
  }

  void _buildSearchList(searchedCharacter) {
    searchedCharacters = allCharacters
        .where((character) =>
            character.name!.toLowerCase().startsWith(searchedCharacter))
        .toList();
    setState(() {});
  }

  List<Widget> _buildActionsWidgets() {
    if (isSearching) {
      return [
        IconButton(
          onPressed: () {
            if (_searchController.text.isEmpty) {
              setState(() {
                Navigator.pop(context);
              });
            } else {
              _clearSearch();
            }
          },
          icon: const Icon(
            Icons.clear,
            color: MyColors.myGrey,
          ),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearching,
          icon: const Icon(
            Icons.search,
            color: MyColors.myGrey,
          ),
        ),
      ];
    }
  }

  void _startSearching() {
    ModalRoute.of(context)!.addLocalHistoryEntry(
      LocalHistoryEntry(
        onRemove: _stopSearching,
      ),
    );
    setState(() {
      isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();
    setState(() {
      isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
  }

  Widget _buildBloc() {
    return BlocBuilder<CharactersCubit, CharactersStates>(
        builder: (context, state) {
      if (state is CharactersLoaded) {
        allCharacters = (state).characters;
        return _buildLoadedCharacters();
      } else {
        return _buildProgressIndicator();
      }
    });
  }

  Widget _buildLoadedCharacters() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: _buildAllCharactersList(),
      ),
    );
  }

  Widget _buildAllCharactersList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _searchController.text.isEmpty
          ? allCharacters.length
          : searchedCharacters.length,
      itemBuilder: (context, index) => CharacterItem(
        character: _searchController.text.isEmpty
            ? allCharacters[index]
            : searchedCharacters[index],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Transform.translate(
      offset: const Offset(-60, 0),
      child: const Text(
        'Characters',
        style: TextStyle(color: MyColors.myGrey, fontSize: 18),
      ),
    );
  }

  Widget _buildNoInternetWidget() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_internet.png',
              fit: BoxFit.cover,
              width: width * .85,
              height: height * .35,
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'No internet  ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                  ),
                  const TextSpan(
                    text: '🙄',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        leading: isSearching
            ? const BackButton(color: MyColors.myGrey)
            : Container(),
        title: isSearching ? _buildSearchWidget() : _buildAppBarTitle(),
        actions: _buildActionsWidgets(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            if (allCharacters.isEmpty) {
              CharactersCubit.get(context).getAllCharacters();
            }
            return _buildBloc();
          } else {
            return _buildNoInternetWidget();
          }
        },
        child: _buildProgressIndicator(),
      ),
    );
  }
}
