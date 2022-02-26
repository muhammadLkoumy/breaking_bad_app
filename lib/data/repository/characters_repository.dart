import '../models/quote.dart';

import '../models/character.dart';
import '../web_services/characters_web_services.dart';

class CharactersRepository {
  final CharactersWebServices charactersWebServices;

  CharactersRepository(this.charactersWebServices);

  Future<List<Character>> getAllCharacters() async {
    final characters = await charactersWebServices.getAllCharacters();
    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }

  Future<List<Quote>> getCharacterQuote({
    required String charName,
  }) async {
    final quotes =
        await charactersWebServices.getCharacterQuote(charName: charName);
    return quotes.map((quote) => Quote.fromJson(quote)).toList();
  }
}
