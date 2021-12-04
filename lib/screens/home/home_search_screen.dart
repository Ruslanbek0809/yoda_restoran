import 'package:flutter/material.dart';
import 'package:yoda_res/utils/utils.dart';

class HomeSearchScreen extends SearchDelegate<String> {
  HomeSearchScreen();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        padding: EdgeInsets.only(right: 10),
        icon: Icon(
          Icons.clear,
          color: AppTheme.MAIN_DARK,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        size: 20,
        color: AppTheme.MAIN_DARK,
      ),
      onPressed: () {},
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(height: 0, width: 0);
  }

  @override
  String get searchFieldLabel => '';

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(body: Center());
    // ListView.builder(
    //   itemBuilder: (context, index) => ListTile(
    //     onTap: () {
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => ProductDetailScreen(
    //                     product: suggestionList[index],
    //                     market: market,
    //                   )));
    //     },
    //     title: RichText(
    //         text: TextSpan(
    //       text: vm.lang == 'en' && suggestionList[index].nameEn != null
    //           ? suggestionList[index].nameEn
    //           : vm.lang == 'ru' && suggestionList[index].nameRu != null
    //               ? suggestionList[index].nameRu
    //               : suggestionList[index].nameTm ?? '',
    //       style: TextStyle(
    //         color: Colors.black,
    //         fontSize: 18,
    //         fontFamily: GoogleFonts.poppins().fontFamily,
    //       ),
    //     )),
    //   ),
    //   itemCount: suggestionList.length,
    // );
  }
}
