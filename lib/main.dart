import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sidebar/classes/City.dart';
import 'package:flutter_sidebar/detailPage.dart';

void main() {
  runApp(MyApp());
}

int b = 1;
int c = 1;
int elevation = 0;
int radius = 20;
City? _newCity;

bool theme = false;
bool isThemeSwitched = false;
bool isLangSwitched = false;

Color? backgroundColor;
Color? buttonColor;
Color? fontColor;

void checkTheme() {
  theme ? backgroundColor = Color(0xFF4A4A58) : backgroundColor = Color(0xFFD5D5E0);
  theme ? fontColor = Color(0xFFFFFFFF) : fontColor = Color(0xFF0B3E58);
  theme ? buttonColor = Color(0xFFD5D5E0) : buttonColor = Color(0xFF4A4A58);
  theme = !theme;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: buttonColor
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent
        ),
        child: MyHomePage(title: 'Flutter Demo Home Page'))
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool isCollapsed = true;
  bool lang = true;
  double? screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);



  @override
  void initState() {
    super.initState();
    checkTheme();
    setState(() {
      for (City city in cities) {
        city.getWeather();
      }
    });
  }

  List<City> cities = [new City('Минск'), new City('Пинск'), new City('Витебск'), new City('Брест'), new City('Гомель'), new City('Гродно')];

  Widget CityWidget(BuildContext context, int index){

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(cities[index])));
      },
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
                height: 200,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomLeft: Radius.circular(50), topLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                  color: buttonColor,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        cities[index].temp != null
                          ? Text(
                           '${cities[index].city}',
                            style: TextStyle(
                              fontSize: 35,
                              color: backgroundColor
                            ),
                          )
                          : Text('...'),
                        Image.network((cities[index].iconUri).toString())
                      ],
                    ),
                  ),
                ),
            ),
          ],
        )
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: !isCollapsed ? 10 : 0,
        toolbarHeight: 75,
        title: Text(
          'Погода',
          style: TextStyle(
            color: fontColor,
            fontSize: 20,
          ),
        ),
        actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Switch(
                  value: isThemeSwitched,
                  onChanged: (value) {
                    setState(() {
                      isThemeSwitched = value;
                      checkTheme();
                    });
                  },
                ),
                CupertinoButton(
                  child: Icon(
                    CupertinoIcons.add,
                    color: buttonColor,
                    size: 30,
                  ),
                  onPressed: (){
                    showDialog(context: context, builder: (BuildContext Context){
                      return AlertDialog(
                        title: Text('Добавить город'),
                        content: TextField(
                          onChanged: (String value){
                            _newCity = new City(value);
                          },
                        ),
                        actions: [
                          Container(
                            padding: EdgeInsets.all(15),
                            child: ElevatedButton(

                                onPressed: (){
                                  setState(() {
                                    cities.add(_newCity!);
                                  });
                                  Navigator.of(Context).pop();
                                },
                                child: Text('Добавить'),
                            ),
                          )
                        ],
                      );
                    });
                  }
                ),
              ],
            ),
          )
        ],
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: ListView.builder(
                itemCount: cities.length,
                itemBuilder: (context, index) => Dismissible(key: Key(cities[index].city), child: CityWidget(context, index), onDismissed: (direction){
                  setState(() {
                    cities.removeAt(index);
                  });
                },),
              ),
            ),
          ),
        ],
      )
    );
  }
}
