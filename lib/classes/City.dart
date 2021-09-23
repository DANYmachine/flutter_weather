import 'dart:convert';
import 'package:http/http.dart' as http;

class City{

  var city;
  var temp;
  var feelsLike;
  var description;
  var currently;
  var humidity;
  var windVelocity;
  var iconCode;

  var longitude;
  var latitude;
  String ?iconUri;

  City(String city){
    this.city = city;
    getWeather();
  }

  Future getWeather() async {
    final apiKey = 'ad99d7c281100e1114cf19f0d30deb14';
    final weatherService = 'http://api.openweathermap.org';
    Uri str;
    str = Uri.parse('$weatherService/data/2.5/weather?q=$city&appid=$apiKey');
    http.Response response = await http.get(str);
    var results = jsonDecode(response.body);

    this.temp = (results['main']['temp'] - 273).toString();
    this.temp = temp.substring(0, 4);
    this.feelsLike = (results['main']['feels_like'] - 273).toString();
    this.feelsLike = feelsLike.substring(0,4);
    this.description = results['weather'][0]['description'];
    this.currently = results['weather'][0]['main'];
    this.humidity = results['main']['humidity'];
    this.windVelocity = results['wind']['speed'];
    this.iconCode = results['weather'][0]['icon'];
    this.longitude = results['coord']['lon'];
    this.latitude = results['coord']['lat'];

    iconUri = "http://openweathermap.org/img/wn/$iconCode@2x.png";
  }
}