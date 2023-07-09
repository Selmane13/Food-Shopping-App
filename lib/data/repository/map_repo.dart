import 'package:food_delivery_app/data/api/api_maps.dart';
import 'package:get/get.dart';

class MapRepo extends GetxService{
  final ApiMaps apiMaps;

  MapRepo({required this.apiMaps});

  Future<Response> getAddress(double latitude,double longitude,String searchStr,bool geo) async {
    return await apiMaps.getData(latitude, longitude,searchStr,geo);
  }
}