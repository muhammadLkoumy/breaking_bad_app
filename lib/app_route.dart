import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_logic/cubit/characters_cubit.dart';
import 'constants/strings.dart';
import 'data/models/character.dart';
import 'data/repository/characters_repository.dart';
import 'data/web_services/characters_web_services.dart';
import 'presentation/screens/character_details_screen.dart';
import 'presentation/screens/characters_screen.dart';

class AppRoute {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;

  AppRoute() {
    charactersRepository = CharactersRepository(CharactersWebServices());
    charactersCubit =
        CharactersCubit(charactersRepository: charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => CharactersCubit(
              charactersRepository: charactersRepository,
            ),
            child: const CharactersScreen(),
          ),
        );
      case characterDetailsScreen:
        final character = settings.arguments as Character;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                CharactersCubit(charactersRepository: charactersRepository),
            child: CharacterDetailsScreen(
              character: character,
            ),
          ),
        );
    }
    return null;
  }
}
