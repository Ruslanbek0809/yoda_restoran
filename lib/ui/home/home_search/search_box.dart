import 'dart:async';
import 'package:flutter/material.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBox extends StatefulWidget {
  final bool autoFocus;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Function()? onCancel;
  final Function(String value)? onChanged;
  final Function(String value)? onSubmitted;

  SearchBox({
    Key? key,
    this.focusNode,
    this.onCancel,
    this.onChanged,
    this.controller,
    this.onSubmitted,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController? _textController;

  String _oldSearchText = '';
  Timer? _debounceQuery;

  Function(String value)? get onChanged => widget.onChanged;

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController(text: '');
    _textController!.addListener(_onSearchTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _textController!.dispose();
    }
    super.dispose();
  }

  void _onSearchTextChange() {
    if (_oldSearchText != _textController!.text) {
      if (_textController!.text.isEmpty) {
        _oldSearchText = _textController!.text;
        setState(() {});
        widget.onChanged?.call(_textController!.text);
        return;
      }

      if (_debounceQuery?.isActive ?? false) _debounceQuery!.cancel();
      _debounceQuery = Timer(const Duration(milliseconds: 800), () {
        _oldSearchText = _textController!.text;
        widget.onChanged?.call(_textController!.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final currentLang = Provider.of<LangProvider>(context).currentLang;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.WHITE,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      margin: EdgeInsets.symmetric(vertical: 5.h),
      child: TextField(
        style: TextStyle(
          fontSize: 18.sp,
          color: AppTheme.MAIN_DARK,
        ),
        decoration: InputDecoration(
          fillColor: AppTheme.WHITE,
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
        ),
        controller: _textController,
        autofocus: widget.autoFocus,
        focusNode: widget.focusNode,
        onSubmitted: (value) => widget.onSubmitted?.call(value),
      ),
    );
  }
}
