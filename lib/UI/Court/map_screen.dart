import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  const MapPage({super.key,});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? googleMapController;
   LatLng? _currentPosition;
  final LatLng center = const LatLng(21.04840, 105.77403);
  List<LatLng> polylineCoordinates = [];
  // double lat = currentPosition.latitude.toDouble();
  // final LatLng center = const LatLng(, 105.78341);
  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  _checkLocationPermission() async {
    final PermissionStatus status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      getCurentPosition();
    } else if (status.isDenied) {
      // Yêu cầu quyền truy cập vị trí
      final result = await Permission.locationWhenInUse.request();
      if (result.isGranted) {
        getCurentPosition();
      }
    }
  }
  
  Future<void> getDirections() async {
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${center.latitude},${center.longitude}&key=AIzaSyCh1u8s4L2ztgOZgK5tWy0dYrRTTlgAKJE';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var routes = jsonResponse['routes'][0];
      var legs = routes['legs'][0];
      var steps = legs['steps'];

      polylineCoordinates.clear();
      for (var step in steps) {
        var startLatLng = _convertToLatLng(_decodePoly(step['polyline']['points'])[0]);
        var endLatLng = _convertToLatLng(_decodePoly(step['polyline']['points']).last);
        polylineCoordinates.add(startLatLng as LatLng);
        polylineCoordinates.add(endLatLng as LatLng);
      }
      setState(() {});
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = [];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List.filled(list.length, 0, growable: true);
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (5 * shift);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negative then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = result >> 1;
      lList[index] = result1;
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  getCurentPosition() async {
    //permission
    //LocationPermission permission = await Geolocator.checkPermission();
     //final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    try {
      Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _currentPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
      });
    } catch (e) {
      print(e);
    }
      
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: MarkerId("currentLocation"),
        position: _currentPosition!,
        infoWindow: InfoWindow(title: "Your Location"),
      ),
      Marker(
        markerId: MarkerId("destinationLocation"),
        position: center,
        infoWindow: InfoWindow(title: "Destination"),
      ),
    };
  }

  @override
  void dispose() {
    // TODO: implement dispose
    googleMapController?.dispose();
    super.dispose();
  }
  @override
  void initState() {
     //getCurentPosition();
     _checkLocationPermission();
    // TODO: implement initState
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: IconButton(onPressed: , icon: Icon(Icons.arrow_back_ios_new))
      ),
      body: _currentPosition != null ? GoogleMap(
        markers:  _createMarkers(), //!= null
            // ? <Marker>[
            //     Marker(
            //       markerId: MarkerId("1"),
            //       position: _currentPosition!,
            //       infoWindow: InfoWindow(
            //         title: 'Vị trí hiện tại',
            //       ),
            //     ),
            //   ].toSet()
            // : Set<Marker>(),
        onMapCreated: onMapCreated,
        //polylines: {Polyline(polylineId: PolylineId('route'), points: polylineCoordinates, color: Colors.blue, width: 5)},
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 15.0,)) : Center(child: CircularProgressIndicator())
    );
  }
}

