import '../../constants/my_colors.dart';
import '../../constants/strings.dart';
import '../../data/models/character.dart';
import 'package:flutter/material.dart';

class CharacterItem extends StatelessWidget {
  const CharacterItem({Key? key, required this.character}) : super(key: key);
  final Character character;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: MyColors.myWhite, borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, characterDetailsScreen,
              arguments: character);
        },
        child: GridTile(
          child: Hero(
            tag: character.charId.toString(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: MyColors.myGrey,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/loading.gif',
                image: '${character.image}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          footer: Container(
            color: Colors.black.withOpacity(0.7),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${character.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
