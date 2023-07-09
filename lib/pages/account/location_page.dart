
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_delivery_app/data/controllers/map_controller.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:food_delivery_app/widgets/app_icon.dart';
import 'package:food_delivery_app/widgets/big_text.dart';
import 'package:food_delivery_app/widgets/icon_and_text_widget.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../routes/route_helper.dart';
import '../../utils/colors.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    var adressController = TextEditingController();

    var mapController = MapController();
    var _ltLng = LatLng(0, 0);
    int _currIndex = 0;

    @override
    void initState() {
      super.initState();
      mapController.move(LatLng(34.87833, -1.315), 15);
    }

    final List<Marker> _markers = [Marker(
      width: 50.0,
      height: 50.0,
      point: LatLng(34.87833, -1.315),
      builder: (ctx) => const Icon(
        Icons.location_on_sharp,
        color: Colors.red,
      ),
    )];

    return Scaffold(
      body: GetBuilder<AddressController>(
        builder: (_addressController) {
          return SlidingUpPanel(
            minHeight: Dimensions.height20*14,
              maxHeight: Dimensions.screenHeight*0.8,
              panel: Column(
                children: [
                  Container(
                      height: 5,
                      margin: EdgeInsets.only(
                          top: Dimensions.height20,
                          bottom: Dimensions.height10),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.circular(Dimensions.raduis30)),
                      width: Dimensions.width20 * 5),
                  SizedBox(
                    height: Dimensions.height20 * 2,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: Dimensions.width20),
                            alignment: Alignment.bottomLeft,
                            child: BigText(text: "Delivery address"),
                          ),
                          SizedBox(
                            height: Dimensions.height10,
                          ),
                          Container(
                            margin:
                            EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 3,
                                      spreadRadius: 1,
                                      offset: Offset(1, 1),
                                      color: Colors.grey.withOpacity(0.2))
                                ],
                                borderRadius: BorderRadius.circular(Dimensions.raduis15)),
                            child: TextField(
                              obscureText: false,
                              controller: adressController,
                              decoration: InputDecoration(
                                  hintText: "Your address",
                                  prefixIcon: Icon(
                                    Icons.map,
                                    color: AppColors.yellowColor,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(Dimensions.raduis15),
                                      borderSide: BorderSide(width: 1.0, color: Colors.white)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(Dimensions.raduis15),
                                      borderSide: BorderSide(width: 1.0, color: Colors.white)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.raduis15),
                                  )),
                              onChanged: (text){
                                _addressController.getAddress(0,0, text,true);
                                print(_addressController.addresses.length);
                              },
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _addressController.addresses.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(_addressController.addresses[index].value ),
                                  onTap: () {
                                    adressController.text =
                                        _addressController.addresses[index].value;
                                    _currIndex = index;
                                  },
                                );
                              },
                            ),

                          SizedBox(
                            height: Dimensions.height20,
                          ),


                          GestureDetector(
                            onTap: () {
                              if(!_addressController.latlng.isEmpty) {
                                _addressController.getAddress(
                                    _addressController.latlng[_currIndex]
                                        .latitude,
                                    _addressController.latlng[_currIndex]
                                        .longitude, "", false);
                                Get.back();
                              }else {
                                _addressController.getAddress(_ltLng.latitude, _ltLng.longitude, '', false);
                                Get.back();
                              }
                            },
                            child: Container(
                              width: Dimensions.screenWidth / 2,
                              height: Dimensions.screenHeight / 13,
                              margin:
                                  EdgeInsets.only(bottom: Dimensions.height20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.raduis30),
                                  color: AppColors.mainColor),
                              child: Center(
                                child: BigText(
                                  text: "Save",
                                  size:
                                      Dimensions.font20 + Dimensions.font20 / 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                    ],
                      ),

                    ))],
              ),
              body: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                        center: LatLng(34.87833, -1.315),
                        zoom: 15,
                        onTap: (position, latLang) {
                          _addressController.getAddress(
                              latLang.latitude, latLang.longitude,"",false);
                          adressController.text = _addressController.address.value;
                          mapController.move(latLang, 15);
                          _markers.clear();
                          _markers.add(Marker(
                            width: 50.0,
                            height: 50.0,
                            point: latLang,
                            builder: (ctx) => Icon(
                              Icons.location_on_sharp,
                              color: Colors.red,
                            ),
                          ));
                          _ltLng = latLang;
                        }),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: _markers
                      )
                    ],
                  ),
                  Positioned(
                    top: Dimensions.height20*2,
                      left: Dimensions.width20*1.5,
                      child: GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: AppIcon(icon: Icons.arrow_back_ios_new,backgroundColor: AppColors.mainColor,)))
                ],
              ));
        },
      ),
    );
  }
}
