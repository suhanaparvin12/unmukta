import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as IMG;
import 'package:safewomen/responsive/responsive.dart';
import 'package:share_plus/share_plus.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  Set<Marker> markers = Set(); //markers for google map
  final Completer<GoogleMapController> _controller = Completer();
  LatLng startLocation = LatLng(23.7149598, 86.9496803);

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print(error);
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  Uint8List? resizeImage(Uint8List data, width, height) {
    Uint8List? resizedData = data;
    IMG.Image? img = IMG.decodeImage(data);
    IMG.Image resized = IMG.copyResize(img!, width: width, height: height);
    resizedData = Uint8List.fromList(IMG.encodePng(resized));
    return resizedData;
  }

  Future<void> addCustomIcon() async {
    String imgurl = "https://cdn-icons-png.flaticon.com/512/2377/2377874.png";
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl))
        .buffer
        .asUint8List();

    Uint8List? smallimg = resizeImage(bytes, 170, 170);
    markers.add(Marker(
      markerId: MarkerId('getUserCurrentLocation'),
      position: startLocation,
      infoWindow: InfoWindow(
        title: 'Tap current location 📌',
        onTap: () {
          getUserCurrentLocation().then(
            (value) async {
              markers.add(
                Marker(
                  markerId: MarkerId('getUserCurrentLocation'),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: InfoWindow(
                    title: 'My current location 📌',
                    onTap: () async {
                      final location =
                          'https://www.google.com/maps/search/?api=1&query=${value.latitude}%2C${value.longitude}';
                      await Share.share('My current location : $location');
                    },
                  ),
                ),
              );
              CameraPosition cameraPosition = CameraPosition(
                zoom: 14.5,
                target: LatLng(value.latitude, value.longitude),
              );
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {});
            },
          );
        },
      ),
      icon: BitmapDescriptor.fromBytes(smallimg!), //Icon for Marker
    ));
    if (!mounted) return;
    setState(() {
      //refresh UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor:
                Theme.of(context).colorScheme.surfaceVariant,
            statusBarIconBrightness: Brightness.dark),
        leading: null,
        shadowColor: Colors.transparent,
        title: Text(
          'Current Location',
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Responsive(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: startLocation,
                zoom: 14.5,
              ),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.primary),
        width: 160,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                ),
                Text(
                  'Current location',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          onPressed: () {
            getUserCurrentLocation().then(
              (value) async {
                markers.add(
                  Marker(
                    markerId: MarkerId('getUserCurrentLocation'),
                    position: LatLng(value.latitude, value.longitude),
                    infoWindow: InfoWindow(
                      title: 'My current location 📌',
                      onTap: () async {
                        final location =
                            'https://www.google.com/maps/search/?api=1&query=${value.latitude}%2C${value.longitude}';
                        await Share.share('My current location : $location');
                      },
                    ),
                  ),
                );
                CameraPosition cameraPosition = CameraPosition(
                  zoom: 14.5,
                  target: LatLng(value.latitude, value.longitude),
                );
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition));
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }
}
