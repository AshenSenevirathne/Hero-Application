import 'package:flutter/material.dart';
import 'package:hero_application/Models/hero_model.dart';
import 'package:hero_application/Shared/styleguide.dart';

class HeroMoreDetailsWidget extends StatefulWidget {
  const HeroMoreDetailsWidget({
    Key? key,
    required this.hero,
  }) : super(key: key);

  final HeroModel hero;

  @override
  _HeroMoreDetailsWidget createState() => _HeroMoreDetailsWidget();
}

class _HeroMoreDetailsWidget extends State<HeroMoreDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 24.0,
              ),
              Text(" Born: ", style: AppTheme.subHeading),
              Text(widget.hero.bornDate.toString().substring(0, 10),
                  style: AppTheme.normalTextStyle),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 24.0,
              ),
              Text(" Country: ", style: AppTheme.subHeading),
              Text(
                  widget.hero.citizenship
                      .substring(0, widget.hero.citizenship.indexOf('(')),
                  style: AppTheme.normalTextStyle),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 24.0,
              ),
              Text(" Domain: ", style: AppTheme.subHeading),
              Text(widget.hero.domain, style: AppTheme.normalTextStyle),
            ],
          ),
          SizedBox(height: 30),
          Text(widget.hero.biography, style: AppTheme.normalTextStyle),
        ],
      ),
    );
  }
}
