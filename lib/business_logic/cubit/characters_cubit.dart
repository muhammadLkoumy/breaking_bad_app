import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/character.dart';
import '../../data/models/quote.dart';
import '../../data/repository/characters_repository.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersStates> {
  final CharactersRepository charactersRepository;
  List<Character> characters = [];
  List<Quote> quotes = [];
  CharactersCubit({
    required this.charactersRepository,
  }) : super(CharactersInitial());

  static CharactersCubit get(context) => BlocProvider.of(context);

  void getAllCharacters() {
    charactersRepository.getAllCharacters().then((value) {
      characters = value;
      emit(CharactersLoaded(characters: characters));
    });
  }

  void getCharQuotes({required String charName}) {
    charactersRepository.getCharacterQuote(charName: charName).then((value) {
      quotes = value;
      emit(QuotesLoaded(quotes: quotes));
    });
  }
}
