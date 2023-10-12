import 'package:hive/hive.dart';

part 'hive_story.g.dart';

@HiveType(typeId: 7)
class HiveStory {
  HiveStory({
    this.id,
    this.deadline,
  });

  @HiveField(0)
  final int? id;

  @HiveField(1)
  final DateTime? deadline;
}
