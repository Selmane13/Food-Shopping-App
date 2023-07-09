import 'dart:convert';
import 'dart:ffi';

import 'package:food_delivery_app/data/repository/map_repo.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class AddressController extends GetxController {
  final MapRepo mapRepo;
  String _myCountry ="Algeria";
  String _myCity = "Tlemcen";
  RxString _address = RxString("");
  List<RxString> _suggestedAddresses = [];
  var _suggestedLocations = [];
  List<LatLng> _ltLng =[];

  List<LatLng> get latlng => _ltLng;
  RxString get address => _address;
  List<RxString> get addresses => _suggestedAddresses;
  String get myCountry => _myCountry;
  set setCountry(String country) {
    _myCountry = country;
  }
  String get myCity => _myCity;
  set setCity(String city) {
    _myCity = city;
  }

  AddressController({required this.mapRepo});

  Future<void> getAddress(double latitude,double longitude,String searchStr,bool geo) async {
    _suggestedLocations = [];
    _suggestedAddresses = [];
    _ltLng = [];
    Response response = await mapRepo.getAddress(latitude, longitude,searchStr,geo);
    if(response.statusCode == 200){
      final result = json.decode(json.encode(response.body));
      if(!geo) {
        _address.value = result['display_name'];
        print(result);
        _myCountry = result["address"]["country"];
        _myCity = result["address"]["state"];
      }else{

        _suggestedLocations = result;
        _suggestedLocations.forEach((element) {
          _suggestedAddresses.add(RxString(element['display_name']));
          _ltLng.add(LatLng(double.parse(element['lat']), double.parse(element['lon'])));
        });

      }


    }else{
      print(response.statusText);
      _suggestedAddresses = [];
    }
    update();
  }
}