part of '../../screens/home/index.dart';

class Localization extends StatefulWidget {
  @override
  _Localization createState() => _Localization();
}

class _Localization extends State<Localization> {
  bool loading = false;
  Set<Marker> marker = {};
  void getLocation() async {
    setState(() {
      loading = true;
    });
    Set<Marker> markerLocal = {};

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    Marker location = Marker(
        markerId: MarkerId('0'),
        position: LatLng(position.latitude, position.longitude));

    markerLocal.add(location);
    setState(() {
      marker = markerLocal;
    });
    setState(() {
      loading = false;
    });
    double latitude = position.latitude;
    double longitude = position.longitude;
    values.modifyLatitude(latitude);
    values.modifyLongitude(longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Obter localização',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Color(0xff537EFF),
      ),
      body: Column(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(-22.531011, -55.731530),
              zoom: 13.5,
            ),
            markers: marker,
          ),
          new Positioned(
              child: loading == true
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.red[800]),
                      ),
                    )
                  : Container()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getLocation();
        },
        child: Icon(Icons.add_location_alt),
      ),
    );
  }
}
