class WeatherRA{

final String cityName;
final double temperature;
final String mainCondition;

WeatherRA({
  required this.cityName,
  required this.temperature,
  required this.mainCondition});


factory WeatherRA.fromJson(Map<String, dynamic> json){
  return WeatherRA(
    cityName: json['name'],
    temperature: json['main']['temp'].toDouble(),
    mainCondition: json['weather'][0]['main'],
    );
}

}