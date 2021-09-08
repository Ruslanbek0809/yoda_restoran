import 'dart:math';

import 'package:flutter/material.dart';

class CustomSliverAppbar extends StatefulWidget {
  @override
  _CustomSliverAppbarState createState() => _CustomSliverAppbarState();
}

class _CustomSliverAppbarState extends State<CustomSliverAppbar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(
                "WhatsApp type sliver appbar",
              ),
              centerTitle: true,
              pinned: true,
              floating: true,
              bottom: TabBar(
                  indicatorColor: Colors.black,
                  labelPadding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  controller: _tabController,
                  tabs: [
                    Container(
                      height: 50,
                      color: Colors.red,
                      child: Text("TAB A"),
                    ),
                    Container(
                      height: 50,
                      color: Colors.blue,
                      child: Text("TAB B"),
                    ),
                  ]),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            TabA(),
            const Center(
              child: Text('Display Tab 2',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class TabA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (context, child) => Divider(
          height: 1,
        ),
        padding: EdgeInsets.all(0.0),
        itemCount: 30,
        itemBuilder: (context, i) {
          return Container(
            height: 100,
            width: double.infinity,
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          );
        },
      ),
    );
  }
}
