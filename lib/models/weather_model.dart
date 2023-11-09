class Weather{

final String cityName;
final double temperature0;
final String mainCondition0;
final String dateTime0;
final double temperature1;
final String mainCondition1;
final String dateTime1;
final double temperature2;
final String mainCondition2;
final String dateTime2;
final double temperature3;
final String mainCondition3;
final String dateTime3;
final double temperature4;
final String mainCondition4;
final String dateTime4;
final double temperature5;
final String mainCondition5;
final String dateTime5;


Weather({
  required this.cityName,
  required this.temperature0,
  required this.mainCondition0,
  required this.dateTime0,
    required this.temperature1,
  required this.mainCondition1,
  required this.dateTime1,
    required this.temperature2,
  required this.mainCondition2,
  required this.dateTime2,
    required this.temperature3,
  required this.mainCondition3,
  required this.dateTime3,
    required this.temperature4,
  required this.mainCondition4,
  required this.dateTime4,
      required this.temperature5,
  required this.mainCondition5,
  required this.dateTime5,
  
  });


factory Weather.fromJson(Map<String, dynamic> json){
  return Weather(
    cityName: json['city']['name'],
    temperature0: json['list'][0]['main']['temp'],
    mainCondition0: json['list'][0]['weather'][0]['main'],
    dateTime0: json['list'][0]['dt_txt'],

        temperature1: json['list'][7]['main']['temp'],
    mainCondition1: json['list'][7]['weather'][0]['main'],
    dateTime1: json['list'][7]['dt_txt'],

        temperature2: json['list'][15]['main']['temp'],
    mainCondition2: json['list'][15]['weather'][0]['main'],
    dateTime2: json['list'][15]['dt_txt'],

        temperature3: json['list'][23]['main']['temp'],
    mainCondition3: json['list'][23]['weather'][0]['main'],
    dateTime3: json['list'][23]['dt_txt'],

        temperature4: json['list'][31]['main']['temp'],
    mainCondition4: json['list'][31]['weather'][0]['main'],
    dateTime4: json['list'][31]['dt_txt'],

            temperature5: json['list'][39]['main']['temp'],
    mainCondition5: json['list'][39]['weather'][0]['main'],
    dateTime5: json['list'][39]['dt_txt'],
    );
}

}