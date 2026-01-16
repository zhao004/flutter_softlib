// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DownloadTasksTable extends DownloadTasks
    with TableInfo<$DownloadTasksTable, DownloadTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _appIdMeta = const VerificationMeta('appId');
  @override
  late final GeneratedColumn<String> appId = GeneratedColumn<String>(
    'app_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _appNameMeta = const VerificationMeta(
    'appName',
  );
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
    'app_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appSizeMeta = const VerificationMeta(
    'appSize',
  );
  @override
  late final GeneratedColumn<String> appSize = GeneratedColumn<String>(
    'app_size',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appIconMeta = const VerificationMeta(
    'appIcon',
  );
  @override
  late final GeneratedColumn<String> appIcon = GeneratedColumn<String>(
    'app_icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createTimeMeta = const VerificationMeta(
    'createTime',
  );
  @override
  late final GeneratedColumn<DateTime> createTime = GeneratedColumn<DateTime>(
    'create_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    appId,
    taskId,
    appName,
    appSize,
    appIcon,
    createTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'download_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<DownloadTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('app_id')) {
      context.handle(
        _appIdMeta,
        appId.isAcceptableOrUnknown(data['app_id']!, _appIdMeta),
      );
    } else if (isInserting) {
      context.missing(_appIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('app_name')) {
      context.handle(
        _appNameMeta,
        appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta),
      );
    } else if (isInserting) {
      context.missing(_appNameMeta);
    }
    if (data.containsKey('app_size')) {
      context.handle(
        _appSizeMeta,
        appSize.isAcceptableOrUnknown(data['app_size']!, _appSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_appSizeMeta);
    }
    if (data.containsKey('app_icon')) {
      context.handle(
        _appIconMeta,
        appIcon.isAcceptableOrUnknown(data['app_icon']!, _appIconMeta),
      );
    } else if (isInserting) {
      context.missing(_appIconMeta);
    }
    if (data.containsKey('create_time')) {
      context.handle(
        _createTimeMeta,
        createTime.isAcceptableOrUnknown(data['create_time']!, _createTimeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      appId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      appName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_name'],
      )!,
      appSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_size'],
      )!,
      appIcon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_icon'],
      )!,
      createTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}create_time'],
      )!,
    );
  }

  @override
  $DownloadTasksTable createAlias(String alias) {
    return $DownloadTasksTable(attachedDatabase, alias);
  }
}

class DownloadTask extends DataClass implements Insertable<DownloadTask> {
  final int id;
  final String appId;
  final String taskId;
  final String appName;
  final String appSize;
  final String appIcon;
  final DateTime createTime;
  const DownloadTask({
    required this.id,
    required this.appId,
    required this.taskId,
    required this.appName,
    required this.appSize,
    required this.appIcon,
    required this.createTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['app_id'] = Variable<String>(appId);
    map['task_id'] = Variable<String>(taskId);
    map['app_name'] = Variable<String>(appName);
    map['app_size'] = Variable<String>(appSize);
    map['app_icon'] = Variable<String>(appIcon);
    map['create_time'] = Variable<DateTime>(createTime);
    return map;
  }

  DownloadTasksCompanion toCompanion(bool nullToAbsent) {
    return DownloadTasksCompanion(
      id: Value(id),
      appId: Value(appId),
      taskId: Value(taskId),
      appName: Value(appName),
      appSize: Value(appSize),
      appIcon: Value(appIcon),
      createTime: Value(createTime),
    );
  }

  factory DownloadTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadTask(
      id: serializer.fromJson<int>(json['id']),
      appId: serializer.fromJson<String>(json['appId']),
      taskId: serializer.fromJson<String>(json['taskId']),
      appName: serializer.fromJson<String>(json['appName']),
      appSize: serializer.fromJson<String>(json['appSize']),
      appIcon: serializer.fromJson<String>(json['appIcon']),
      createTime: serializer.fromJson<DateTime>(json['createTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'appId': serializer.toJson<String>(appId),
      'taskId': serializer.toJson<String>(taskId),
      'appName': serializer.toJson<String>(appName),
      'appSize': serializer.toJson<String>(appSize),
      'appIcon': serializer.toJson<String>(appIcon),
      'createTime': serializer.toJson<DateTime>(createTime),
    };
  }

  DownloadTask copyWith({
    int? id,
    String? appId,
    String? taskId,
    String? appName,
    String? appSize,
    String? appIcon,
    DateTime? createTime,
  }) => DownloadTask(
    id: id ?? this.id,
    appId: appId ?? this.appId,
    taskId: taskId ?? this.taskId,
    appName: appName ?? this.appName,
    appSize: appSize ?? this.appSize,
    appIcon: appIcon ?? this.appIcon,
    createTime: createTime ?? this.createTime,
  );
  DownloadTask copyWithCompanion(DownloadTasksCompanion data) {
    return DownloadTask(
      id: data.id.present ? data.id.value : this.id,
      appId: data.appId.present ? data.appId.value : this.appId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      appName: data.appName.present ? data.appName.value : this.appName,
      appSize: data.appSize.present ? data.appSize.value : this.appSize,
      appIcon: data.appIcon.present ? data.appIcon.value : this.appIcon,
      createTime: data.createTime.present
          ? data.createTime.value
          : this.createTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadTask(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('taskId: $taskId, ')
          ..write('appName: $appName, ')
          ..write('appSize: $appSize, ')
          ..write('appIcon: $appIcon, ')
          ..write('createTime: $createTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, appId, taskId, appName, appSize, appIcon, createTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadTask &&
          other.id == this.id &&
          other.appId == this.appId &&
          other.taskId == this.taskId &&
          other.appName == this.appName &&
          other.appSize == this.appSize &&
          other.appIcon == this.appIcon &&
          other.createTime == this.createTime);
}

class DownloadTasksCompanion extends UpdateCompanion<DownloadTask> {
  final Value<int> id;
  final Value<String> appId;
  final Value<String> taskId;
  final Value<String> appName;
  final Value<String> appSize;
  final Value<String> appIcon;
  final Value<DateTime> createTime;
  const DownloadTasksCompanion({
    this.id = const Value.absent(),
    this.appId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.appName = const Value.absent(),
    this.appSize = const Value.absent(),
    this.appIcon = const Value.absent(),
    this.createTime = const Value.absent(),
  });
  DownloadTasksCompanion.insert({
    this.id = const Value.absent(),
    required String appId,
    required String taskId,
    required String appName,
    required String appSize,
    required String appIcon,
    this.createTime = const Value.absent(),
  }) : appId = Value(appId),
       taskId = Value(taskId),
       appName = Value(appName),
       appSize = Value(appSize),
       appIcon = Value(appIcon);
  static Insertable<DownloadTask> custom({
    Expression<int>? id,
    Expression<String>? appId,
    Expression<String>? taskId,
    Expression<String>? appName,
    Expression<String>? appSize,
    Expression<String>? appIcon,
    Expression<DateTime>? createTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appId != null) 'app_id': appId,
      if (taskId != null) 'task_id': taskId,
      if (appName != null) 'app_name': appName,
      if (appSize != null) 'app_size': appSize,
      if (appIcon != null) 'app_icon': appIcon,
      if (createTime != null) 'create_time': createTime,
    });
  }

  DownloadTasksCompanion copyWith({
    Value<int>? id,
    Value<String>? appId,
    Value<String>? taskId,
    Value<String>? appName,
    Value<String>? appSize,
    Value<String>? appIcon,
    Value<DateTime>? createTime,
  }) {
    return DownloadTasksCompanion(
      id: id ?? this.id,
      appId: appId ?? this.appId,
      taskId: taskId ?? this.taskId,
      appName: appName ?? this.appName,
      appSize: appSize ?? this.appSize,
      appIcon: appIcon ?? this.appIcon,
      createTime: createTime ?? this.createTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (appId.present) {
      map['app_id'] = Variable<String>(appId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (appSize.present) {
      map['app_size'] = Variable<String>(appSize.value);
    }
    if (appIcon.present) {
      map['app_icon'] = Variable<String>(appIcon.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<DateTime>(createTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadTasksCompanion(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('taskId: $taskId, ')
          ..write('appName: $appName, ')
          ..write('appSize: $appSize, ')
          ..write('appIcon: $appIcon, ')
          ..write('createTime: $createTime')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DownloadTasksTable downloadTasks = $DownloadTasksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [downloadTasks];
}

typedef $$DownloadTasksTableCreateCompanionBuilder =
    DownloadTasksCompanion Function({
      Value<int> id,
      required String appId,
      required String taskId,
      required String appName,
      required String appSize,
      required String appIcon,
      Value<DateTime> createTime,
    });
typedef $$DownloadTasksTableUpdateCompanionBuilder =
    DownloadTasksCompanion Function({
      Value<int> id,
      Value<String> appId,
      Value<String> taskId,
      Value<String> appName,
      Value<String> appSize,
      Value<String> appIcon,
      Value<DateTime> createTime,
    });

class $$DownloadTasksTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadTasksTable> {
  $$DownloadTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appId => $composableBuilder(
    column: $table.appId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appSize => $composableBuilder(
    column: $table.appSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appIcon => $composableBuilder(
    column: $table.appIcon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createTime => $composableBuilder(
    column: $table.createTime,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DownloadTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadTasksTable> {
  $$DownloadTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appId => $composableBuilder(
    column: $table.appId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appSize => $composableBuilder(
    column: $table.appSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appIcon => $composableBuilder(
    column: $table.appIcon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createTime => $composableBuilder(
    column: $table.createTime,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DownloadTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadTasksTable> {
  $$DownloadTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get appId =>
      $composableBuilder(column: $table.appId, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get appName =>
      $composableBuilder(column: $table.appName, builder: (column) => column);

  GeneratedColumn<String> get appSize =>
      $composableBuilder(column: $table.appSize, builder: (column) => column);

  GeneratedColumn<String> get appIcon =>
      $composableBuilder(column: $table.appIcon, builder: (column) => column);

  GeneratedColumn<DateTime> get createTime => $composableBuilder(
    column: $table.createTime,
    builder: (column) => column,
  );
}

class $$DownloadTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadTasksTable,
          DownloadTask,
          $$DownloadTasksTableFilterComposer,
          $$DownloadTasksTableOrderingComposer,
          $$DownloadTasksTableAnnotationComposer,
          $$DownloadTasksTableCreateCompanionBuilder,
          $$DownloadTasksTableUpdateCompanionBuilder,
          (
            DownloadTask,
            BaseReferences<_$AppDatabase, $DownloadTasksTable, DownloadTask>,
          ),
          DownloadTask,
          PrefetchHooks Function()
        > {
  $$DownloadTasksTableTableManager(_$AppDatabase db, $DownloadTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> appId = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> appName = const Value.absent(),
                Value<String> appSize = const Value.absent(),
                Value<String> appIcon = const Value.absent(),
                Value<DateTime> createTime = const Value.absent(),
              }) => DownloadTasksCompanion(
                id: id,
                appId: appId,
                taskId: taskId,
                appName: appName,
                appSize: appSize,
                appIcon: appIcon,
                createTime: createTime,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String appId,
                required String taskId,
                required String appName,
                required String appSize,
                required String appIcon,
                Value<DateTime> createTime = const Value.absent(),
              }) => DownloadTasksCompanion.insert(
                id: id,
                appId: appId,
                taskId: taskId,
                appName: appName,
                appSize: appSize,
                appIcon: appIcon,
                createTime: createTime,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DownloadTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadTasksTable,
      DownloadTask,
      $$DownloadTasksTableFilterComposer,
      $$DownloadTasksTableOrderingComposer,
      $$DownloadTasksTableAnnotationComposer,
      $$DownloadTasksTableCreateCompanionBuilder,
      $$DownloadTasksTableUpdateCompanionBuilder,
      (
        DownloadTask,
        BaseReferences<_$AppDatabase, $DownloadTasksTable, DownloadTask>,
      ),
      DownloadTask,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DownloadTasksTableTableManager get downloadTasks =>
      $$DownloadTasksTableTableManager(_db, _db.downloadTasks);
}
