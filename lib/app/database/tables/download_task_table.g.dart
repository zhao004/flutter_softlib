// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task_table.dart';

// ignore_for_file: type=lint
mixin _$DownloadTaskDaoMixin on DatabaseAccessor<AppDatabase> {
  $DownloadTasksTable get downloadTasks => attachedDatabase.downloadTasks;
  DownloadTaskDaoManager get managers => DownloadTaskDaoManager(this);
}

class DownloadTaskDaoManager {
  final _$DownloadTaskDaoMixin _db;
  DownloadTaskDaoManager(this._db);
  $$DownloadTasksTableTableManager get downloadTasks =>
      $$DownloadTasksTableTableManager(_db.attachedDatabase, _db.downloadTasks);
}
