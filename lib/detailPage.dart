import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sidebar/main.dart';
import 'classes/City.dart';



bool _theme = theme;

class DetailPage extends StatefulWidget {

  City ?_city;
  DetailPage(City city){
    _city = city;
  }

  @override
  State<StatefulWidget> createState(){
    return _DetailPageState(_city!);
  }
}

class _DetailPageState extends State<DetailPage> {

  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  City ?_city;
  _DetailPageState(City city){
    _city = city;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          CupertinoButton(
            child: Icon(CupertinoIcons.refresh_circled_solid, size: 30, color: fontColor,),
            onPressed: (){
              setState(() {
                _city!.getWeather();
              });
            },
          )
        ],
        title: Text(_city!.city, style: TextStyle(color: fontColor),),
        backgroundColor: backgroundColor,
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              color: backgroundColor,
              padding: EdgeInsets.only(left: 25, right: 25, top: 50),
              child: Column(
                children: [
                  Icon(CupertinoIcons.thermometer_sun, size: 100, color: fontColor,),
                  SizedBox(height: 50,),
                  ListTile(
                    leading: Icon(CupertinoIcons.thermometer, color: fontColor,),
                    trailing: Text('${_city!.temp} \u00B0C', style: TextStyle(color: fontColor),),
                    title: Text('Температура', style: TextStyle(color: fontColor),),
                  ),
                  ListTile(
                    leading: Icon(Icons.person_outline_sharp, color: fontColor),
                    title: Text('Ощущается как', style: TextStyle(color: fontColor),),
                    trailing: Text('${_city!.feelsLike} \u00B0C', style: TextStyle(color: fontColor),),
                  )
                ],
              )
            ),
            Container(
              color: backgroundColor,
            ),
            Container(
              color: backgroundColor,
              child: Image.network((_city!.iconUri).toString()),
            ),
            Container(
              color: backgroundColor,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        backgroundColor: backgroundColor,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController!.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text(
                'Температура',
                style: TextStyle(
                  fontSize: 13
                ),
              ),
              icon: Icon(Icons.device_thermostat)
          ),
          BottomNavyBarItem(
              title: Text(
                'Ветер',
                style: TextStyle(
                    fontSize: 13
                ),
              ),
              icon: Icon(Icons.air)
          ),
          BottomNavyBarItem(
              title: Text(
                  'Облачность',
                style: TextStyle(
                    fontSize: 13
                ),
              ),
              icon: Icon(Icons.cloud_queue_rounded)
          ),
          BottomNavyBarItem(
              title: Text(
                  'Влажность',
                style: TextStyle(
                    fontSize: 13
                ),
              ),
              icon: Icon(CupertinoIcons.drop)
          ),
        ],
      ),
    );
  }
}
