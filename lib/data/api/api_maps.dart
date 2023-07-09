import 'package:get/get.dart';

class ApiMaps extends GetConnect implements GetxService{
  late final String apiKey;

  ApiMaps() {
    timeout = const Duration(seconds: 30);
    apiKey = 'pk.017caf08728fa0b8bba186cd8577f741';
  }

  Future<Response> getData(double latitude, double longitude,String searchStr,bool geo) async {
    try{
      String getUrl;
      if(geo){
        getUrl = "https://eu1.locationiq.com/v1/search?key=$apiKey&q=$searchStr&format=json";
      }else {
        getUrl = "https://eu1.locationiq.com/v1/reverse?key=$apiKey&lat=$latitude&lon=$longitude&format=json";
      }
      Response response = await get(getUrl);
      return response;
    }catch(e){
      return Response(statusCode: 1,statusText: e.toString());
    }
  }

}