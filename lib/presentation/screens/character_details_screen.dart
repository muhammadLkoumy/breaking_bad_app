import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data/models/character.dart';
import '../../data/models/quote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;
  CharacterDetailsScreen({Key? key, required this.character}) : super(key: key);

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          '${character.nickname}',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        background: Hero(
          tag: character.charId.toString(),
          child: Image.network(
            '${character.image}',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _characterInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(
                color: MyColors.myWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: MyColors.myWhite,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(double width) {
    return Divider(
      color: MyColors.myYellow,
      endIndent: width,
      thickness: 2,
    );
  }

  List<Quote> quotes = [];

  Widget _checkIfQuotesAreLoaded(CharactersStates state) {
    if (state is QuotesLoaded) {
      quotes = state.quotes;
      return _displayRandomQuote();
    } else {
      return _buildProgressIndicator();
    }
  }

  Widget _displayRandomQuote() {
    if (quotes.isNotEmpty) {
      int randomQuoteIndex = Random()
          // this because next in can not be 0! and this happens when the list has one Item
          .nextInt(
              (quotes.length - 1) == 0 ? quotes.length : quotes.length - 1);
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 7.0,
                  color: Colors.white,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                FlickerAnimatedText(quotes[randomQuoteIndex].quote!),
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CharactersCubit.get(context).getCharQuotes(charName: character.name!);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _characterInfo('Job : ', character.jobs!.join(' / ')),
                      _buildDivider(width * .77),
                      _characterInfo(
                          'Seasons : ', character.appearance!.join(' / ')),
                      _buildDivider(width * .66),
                      _characterInfo('Status : ', character.deadOrAlive!),
                      _buildDivider(width * .71),
                      _characterInfo('Actor/Actress : ', character.realName!),
                      _buildDivider(width * .54),
                      _characterInfo('Birthday : ', character.birthday!),
                      _buildDivider(width * .67),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<CharactersCubit, CharactersStates>(
                        builder: (context, state) =>
                            _checkIfQuotesAreLoaded(state),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
