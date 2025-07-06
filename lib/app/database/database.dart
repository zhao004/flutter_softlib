import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_softlib/app/database/tables/download_task_table.dart';
import 'package:path_provider/path_provider.dart';

import '../config.dart';

part 'database.g.dart';

@DriftDatabase(tables: [DownloadTasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      logger.i(
        '数据库准备打开:'
        '${details.versionBefore} -> '
        '${details.versionNow}',
      );
    },
    onUpgrade: (migrator, from, to) async {
      logger.i('数据库升级: $from -> $to');
    },
    onCreate: (migrator) async {
      logger.i('创建数据库表...');
      await migrator.createAll();
    },
  );

  /// 打开数据库连接
  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      return driftDatabase(
        name: 'app_database',
        native: const DriftNativeOptions(
          databaseDirectory: getApplicationSupportDirectory,
        ),
      );
    }, openImmediately: true);
  }
}
