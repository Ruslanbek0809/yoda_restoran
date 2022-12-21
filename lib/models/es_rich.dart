import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'es_rich.g.dart';

@JsonSerializable(includeIfNull: true)
class EsRich {
  EsRich({
    this.id,
    this.richText,
    this.reachRes,
    this.restaurant,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'reachText')
  final String? richText;

  @JsonKey(name: 'reachRes')
  final int? reachRes;

  @JsonKey(name: 'restaurant')
  final Restaurant? restaurant;

  factory EsRich.fromJson(Map<String, dynamic> json) => _$EsRichFromJson(json);

  Map<String, dynamic> toJson() => _$EsRichToJson(this);
}
