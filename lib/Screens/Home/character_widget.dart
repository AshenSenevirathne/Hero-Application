import 'package:flutter/material.dart';
import 'package:hero_application/Models/hero_model.dart';
import 'package:hero_application/Shared/styleguide.dart';
import 'package:hero_application/Screens/HeroDetails/hero_details.dart';

class CharacterWidget extends StatelessWidget {
  const CharacterWidget(
      {Key? key,
      required this.character,
      required this.pageController,
      required this.currentPage,
      required this.colors})
      : super(key: key);
  final HeroModel character;
  final PageController pageController;
  final int currentPage;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 350),
                pageBuilder: (context, _, __) =>
                    HeroDetailScreen(hero: character, colors: colors)));
      },
      child: AnimatedBuilder(
          animation: pageController,
          builder: (context, child) {
            double value = 1;
            if (pageController.position.haveDimensions) {
              value = (pageController.page! - currentPage);
              value = (1 - (value.abs() * 0.6)).clamp(0.0, 1.0);
            }

            return Stack(children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: CharacterCardBackgroundClipper(),
                  child: Hero(
                    tag: "background-${character.heroName}",
                    child: Container(
                      height: 0.55 * screenHeight,
                      width: 0.9 * screenWidth,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: colors, // character.colors,
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft)),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.1),
                child: Hero(
                  tag: "image-${character.heroName}",
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(character.imageUrl),
                    radius: screenHeight * 0.23 * value,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 48.0, right: 16.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Hero(
                      tag: "name-${character.heroName}",
                      child: Material(
                          color: Colors.transparent,
                          child: Container(
                              child: Text(character.heroName,
                                  style: AppTheme.heading))),
                    ),
                    Text("Tap to Read more", style: AppTheme.subHeading)
                  ],
                ),
              )
            ]);
          }),
    );
  }
}

class CharacterCardBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path clippedPath = Path();
    double curveDistance = 40;

    clippedPath.moveTo(0, size.height * 0.4);
    clippedPath.lineTo(0, size.height - curveDistance);
    clippedPath.quadraticBezierTo(
        1, size.height - 1, 0 + curveDistance, size.height);
    clippedPath.lineTo(size.width - curveDistance, size.height);
    clippedPath.quadraticBezierTo(size.width + 1, size.height - 1, size.width,
        size.height - curveDistance);
    clippedPath.lineTo(size.width, 0 + curveDistance);
    clippedPath.quadraticBezierTo(size.width - 1, 0,
        size.width - curveDistance - 5, 0 + curveDistance / 3);
    clippedPath.lineTo(curveDistance, size.height * 0.29);
    clippedPath.quadraticBezierTo(
        1, (size.height * 0.30) + 10, 0, size.height * 0.4);
    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
