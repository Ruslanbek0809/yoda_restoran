import 'package:flutter/material.dart';
import 'package:yoda_res/widgets/widgets.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> animation;
  bool monhani = true;

  late ScrollController _scrollController;

  @override
  void initState() {
    animController = AnimationController(
      duration: Duration(microseconds: 300000),
      vsync: this,
    );
    animation = Tween<double>(begin: 150.0, end: 0.0).animate(animController)
      ..addListener(() {
        setState(() {});
      });

    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset.toInt() >= 283 && monhani == true) {
          setState(() {
            animController.forward();
            monhani = false;
          });
        } else if (_scrollController.offset.toInt() <= 283) {
          animController.reverse();
          monhani = true;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            bottom: PreferredSize(
              child: Container(
                color: Colors.orange,
              ),
              preferredSize: Size(0, 60),
            ),
            pinned: true,
            expandedHeight: 400,
            automaticallyImplyLeading: true,
            primary: false,
            flexibleSpace: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    height: 400,
                    width: 450,
                    decoration: BoxDecoration(
                      // color: Colors.green,
                      image: DecorationImage(
                          image: AssetImage('assets/burgerlist.jpg'),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(animation.value),
                          topRight: Radius.circular(animation.value)),
                    ),
                  ),
                  bottom: -1,
                  left: 0,
                  right: 0,
                ),
              ],
            ),
          ),
          // SliverList(
          //   delegate: SliverChildListDelegate([
          //     Column(
          //       children: <Widget>[
          //         Container(
          //           height: MediaQuery.of(context).size.height - 100,
          //           width: double.infinity,
          //           alignment: Alignment.center,
          //           decoration: BoxDecoration(
          //             color: Colors.red,
          //             borderRadius: BorderRadius.only(
          //                 topLeft: Radius.circular(animation.value)),
          //           ),
          //         ),
          //         Container(
          //           height: MediaQuery.of(context).size.height - 100,
          //           width: double.infinity,
          //           alignment: Alignment.center,
          //           color: Colors.green,
          //         ),
          //         Container(
          //           height: MediaQuery.of(context).size.height - 100,
          //           width: double.infinity,
          //           alignment: Alignment.center,
          //           color: Colors.amber,
          //         ),
          //       ],
          //     )
          //   ]),
          // ),
        ],
      ),
    );
  }
}
