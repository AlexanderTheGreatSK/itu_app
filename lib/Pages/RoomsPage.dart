import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

class MyRoomsPage extends StatefulWidget {
  const MyRoomsPage({super.key});

  @override
  State<MyRoomsPage> createState() => _MyRoomsPageState();
}

class _MyRoomsPageState extends State<MyRoomsPage> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMore(MediaQuery.of(context).size),
    );
  }

  Widget _buildMore(Size size) {
    var h = 220.0;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: HexagonWidget.pointy(
                  height: h,
                  child: InkWell(
                    onTap: () {
                      const snackBar = SnackBar(content: Text('Living room'));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/nashhouse-6656c.appspot.com/o/rooms%2F1.png?alt=media&token=bffe8928-ee44-4938-9bf0-3e56b7754920", fit: BoxFit.fitHeight),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: HexagonWidget.pointy(
                  height: h,
                  child: InkWell(
                    onTap: () {},
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/nashhouse-6656c.appspot.com/o/rooms%2F2.png?alt=media&token=a7f4626e-2b9d-40f4-acd9-c95c42452121", fit: BoxFit.fitHeight),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: HexagonWidget.pointy(
                  height: h,
                  child: InkWell(
                    onTap: () {},
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/nashhouse-6656c.appspot.com/o/rooms%2F3.png?alt=media&token=888fdd79-9da8-4aaa-a304-a2b608e7577e", fit: BoxFit.fitHeight),
                ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: HexagonWidget.pointy(
                  height: h,
                  child: InkWell(
                    onTap: () {},
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/nashhouse-6656c.appspot.com/o/rooms%2F4.png?alt=media&token=cac0881e-7534-4a8f-b08f-1e8e2568ba0e", fit: BoxFit.fitHeight),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: HexagonWidget.pointy(
                  height: h,
                  child: InkWell(
                    onTap: () {},
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/nashhouse-6656c.appspot.com/o/rooms%2F5.png?alt=media&token=ffd74039-2499-4854-8f33-1f6e9791e376", fit: BoxFit.fitHeight),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}