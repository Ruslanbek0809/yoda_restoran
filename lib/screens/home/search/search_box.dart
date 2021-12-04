import 'dart:async';

import 'package:belent_online/common/theme/theme.dart';

import '../../../common/utils.dart';
import '../../../providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  double get widthButtonCancel => _textController!.text.isEmpty ? 0 : 50;

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
    final currentLang = Provider.of<LangProvider>(context).currentLang;
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        decoration: InputDecoration(
          fillColor: AppTheme.ACCENT_COLOR,
          hintText: i18n(currentLang, ki18nSearchTitle),
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
