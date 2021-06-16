import 'package:flutter/material.dart';
import 'package:hero_application/Models/hero_model.dart';
import 'package:hero_application/Shared/styleguide.dart';
import 'package:hero_application/Screens/HeroDetails/hero_details.dart';

class SearchModal extends StatefulWidget {
  const SearchModal({Key? key, required this.heroList, required this.colors})
      : super(key: key);

  final List<HeroModel> heroList;
  final List<Color> colors;

  @override
  _SearchModalState createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  List fiterHeros = [];

  @override
  void initState() {
    setState(() {
      fiterHeros = widget.heroList;
    });
    super.initState();
  }

  void _filterHeros(value) {
    setState(() {
      fiterHeros = widget.heroList
          .where((hero) =>
              hero.heroName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white),
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Text('Search Hero...',
                style: AppTheme.heading
                    .copyWith(color: Colors.black, fontSize: 28.0)),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
              child: TextField(
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    labelText: 'Enter Search Text',
                    hintText: 'Enter Search Text',
                    filled: true),
                onChanged: (value) {
                  _filterHeros(value);
                },
              ),
            ),
            Expanded(
                child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                for (var i = 0; i < fiterHeros.length; i++)
                  Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 5.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(fiterHeros[i].imageUrl),
                          radius: 30.0,
                        ),
                        title: Text(
                          fiterHeros[i].heroName,
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text('Tap to read more ...',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700)),
                        onTap: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 350),
                                  pageBuilder: (context, _, __) =>
                                      HeroDetailScreen(
                                          hero: fiterHeros[i],
                                          colors: widget.colors)));
                        },
                      ))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
