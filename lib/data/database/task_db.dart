import 'package:drift/drift.dart';

@DataClassName('Task')
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(Constant(false))();
  BoolColumn get isFavourite => boolean().withDefault(Constant(false))();
  TextColumn get categoryId => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}