import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/utils/utils.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int activeIndex = 0;
  int selectedCatId = 0;
  int selectedSubCatId = 0;
  int selectedCatIndex = 0;
  int page = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.MAIN,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppTheme.WHITE,
          body: Column(
            children: <Widget>[
              _buildAppBar(),
              // search and filter, sort
              Expanded(
                child: NestedScrollView(
                  controller: _scrollController,
                  floatHeaderSlivers: true,
                  physics: NeverScrollableScrollPhysics(),
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      //search
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return _buildPostsCat();
                        }, childCount: 1),
                      ),
                      //filter and sort
                      SliverPersistentHeader(
                        pinned: true,
                        floating: true,
                        delegate: ContestTabHeader(
                          subCategory: _buildPostsSubCat(),
                          size: 45.h,
                        ),
                      ),
                    ];
                  },
                  body: PostsWidget(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //       color: AppColors.SHADOW.withOpacity(0.25),
        //       offset: const Offset(1.1, 1.1),
        //       blurRadius: 6.0),
        // ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 8.h, right: 8.h),
        child: Row(
          children: <Widget>[
            // backButton
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back,
                    size: 28.h,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Post diskount title',
                  style: TextStyle(
                    fontSize: 25.h,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.MAIN,
                  ),
                ),
              ),
            ),
            //searchButton
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  // Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(8.h),
                  child: Icon(
                    Icons.sort,
                    size: 28.h,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsCat() {
    List<PostCat> postCats = [
      PostCat(1, 'Hey', 'assets/placeholder.jpg', [
        PostSubCat(1, 'SubHey'),
        PostSubCat(2, 'SubBey'),
      ]),
      PostCat(2, 'Bey', 'assets/placeholder.jpg', [
        PostSubCat(1, 'SubHey'),
        PostSubCat(2, 'SubBey'),
      ]),
    ];

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: postCats.mapIndexed((newsTitle, pos) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              width: selectedCatId == postCats[pos].id ? 115.h : 123.h,
              height: selectedCatId == postCats[pos].id ? 96.h : 110.h,
              margin: EdgeInsets.fromLTRB(5.h, 7.h, 5.h, 7.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: selectedCatId == postCats[pos].id
                    ? AppTheme.MAIN
                    : Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: selectedCatId == postCats[pos].id
                          ? AppTheme.MAIN.withOpacity(0.6)
                          : Colors.grey.withOpacity(0.6),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 5.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedCatId = postCats[pos].id;
                      selectedSubCatId = postCats[pos].subcats[0].id;
                      selectedCatIndex = pos;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 2.5.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: postCats[pos].image,
                          width: 70.h,
                          height: 62.h,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Image.asset(
                              'assets/placeholder.jpg',
                              width: 70.h,
                              height: 62.h,
                              fit: BoxFit.fill),
                          errorWidget: (context, url, error) {
                            return const Center(
                              child: Icon(
                                Icons.refresh,
                                color: Colors.black12,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                          height:
                              selectedCatId == postCats[pos].id ? 2.5.h : 5.h),
                      Text(
                        postCats[pos].name,
                        style: TextStyle(
                          fontSize:
                              selectedCatId == postCats[pos].id ? 14.7.h : 15.h,
                          fontWeight: FontWeight.w600,
                          color: selectedCatId == postCats[pos].id
                              ? Colors.white
                              : AppTheme.MAIN,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPostsSubCat() {
    List<PostSubCat> postSubCats = [
      PostSubCat(1, 'SubHey'),
      PostSubCat(2, 'SubBey'),
    ];
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: postSubCats.mapIndexed((subCat, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5.h, vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: selectedSubCatId == subCat.id
                    ? AppTheme.MAIN
                    : Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 4.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    // you should request from here
                    setState(() {
                      selectedSubCatId = subCat.id;
                    });
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 18.h),
                    child: Text(
                      subCat.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 15.h,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600,
                        color: selectedSubCatId == subCat.id
                            ? Colors.white
                            : AppTheme.MAIN,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader({
    required this.subCategory,
    required this.size,
  });
  final Widget subCategory;
  final double size;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return subCategory;
  }

  @override
  double get maxExtent => size;

  @override
  double get minExtent => size;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class PostsWidget extends StatelessWidget {
  List<PostCat> postCats = [
    PostCat(1, 'Hey', 'assets/placeholder.jpg', [
      PostSubCat(1, 'SubHey'),
      PostSubCat(2, 'SubBey'),
    ]),
    PostCat(2, 'Bey', 'assets/placeholder.jpg', [
      PostSubCat(1, 'SubHey'),
      PostSubCat(2, 'SubBey'),
    ]),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 2.h),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 2,
        itemBuilder: (BuildContext context, int pos) {
          return Container(
            height: 140.h,
            width: 1.sw,
            margin: EdgeInsets.all(5.h),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Container(
                  height: 140.h,
                  width: 0.35.sw - 10.h,
                  //margin: EdgeInsets.only(right: 5),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: postCats[pos].image,
                      placeholder: (context, url) => Image.asset(
                          'assets/placeholder.jpg',
                          fit: BoxFit.cover),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return const Center(
                          child: Icon(
                            Icons.refresh,
                            color: Colors.black12,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(7.h),
                  width: 0.65.sw - 10.h,
                  height: 140.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postCats[pos].name,
                        maxLines: 5,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black54.withOpacity(0.8),
                          fontSize: 15.h,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // date
                          Text(
                            '2021',
                            style: TextStyle(
                              color: Colors.black54.withOpacity(0.6),
                              fontWeight: FontWeight.w600,
                              fontSize: 13.h,
                            ),
                          ),
                          Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PostCat {
  final int id;
  final String name;
  final String image;
  final List<PostSubCat> subcats;
  PostCat(this.id, this.name, this.image, this.subcats);
}

class PostSubCat {
  final int id;
  final String name;
  PostSubCat(this.id, this.name);
}
