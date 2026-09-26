/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

/// Represents a user prompt and its orchestration through the system.
abstract class OrchestrationTask
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  OrchestrationTask._({
    this.id,
    required this.prompt,
    this.codeContext,
    this.geminiResponse,
    required this.status,
    this.skillName,
    this.skillInput,
    this.skillOutput,
    this.errorMessage,
    required this.createdAt,
    this.completedAt,
  });

  factory OrchestrationTask({
    int? id,
    required String prompt,
    String? codeContext,
    String? geminiResponse,
    required String status,
    String? skillName,
    String? skillInput,
    String? skillOutput,
    String? errorMessage,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _OrchestrationTaskImpl;

  factory OrchestrationTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrchestrationTask(
      id: jsonSerialization['id'] as int?,
      prompt: jsonSerialization['prompt'] as String,
      codeContext: jsonSerialization['codeContext'] as String?,
      geminiResponse: jsonSerialization['geminiResponse'] as String?,
      status: jsonSerialization['status'] as String,
      skillName: jsonSerialization['skillName'] as String?,
      skillInput: jsonSerialization['skillInput'] as String?,
      skillOutput: jsonSerialization['skillOutput'] as String?,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  static final t = OrchestrationTaskTable();

  static const db = OrchestrationTaskRepository._();

  @override
  int? id;

  /// The user's original prompt/instruction.
  String prompt;

  /// Optional code context provided alongside the prompt.
  String? codeContext;

  /// Raw response from Gemini API.
  String? geminiResponse;

  /// Current status: pending, calling_gemini, parsing, dispatching, running, complete, failed.
  String status;

  /// Name of the skill selected for execution.
  String? skillName;

  /// JSON-encoded input data for the skill.
  String? skillInput;

  /// JSON-encoded output from the skill execution.
  String? skillOutput;

  /// Error message if the task failed.
  String? errorMessage;

  /// Timestamp when the task was created.
  DateTime createdAt;

  /// Timestamp when the task completed or failed.
  DateTime? completedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [OrchestrationTask]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  OrchestrationTask copyWith({
    int? id,
    String? prompt,
    String? codeContext,
    String? geminiResponse,
    String? status,
    String? skillName,
    String? skillInput,
    String? skillOutput,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrchestrationTask',
      if (id != null) 'id': id,
      'prompt': prompt,
      if (codeContext != null) 'codeContext': codeContext,
      if (geminiResponse != null) 'geminiResponse': geminiResponse,
      'status': status,
      if (skillName != null) 'skillName': skillName,
      if (skillInput != null) 'skillInput': skillInput,
      if (skillOutput != null) 'skillOutput': skillOutput,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrchestrationTask',
      if (id != null) 'id': id,
      'prompt': prompt,
      if (codeContext != null) 'codeContext': codeContext,
      if (geminiResponse != null) 'geminiResponse': geminiResponse,
      'status': status,
      if (skillName != null) 'skillName': skillName,
      if (skillInput != null) 'skillInput': skillInput,
      if (skillOutput != null) 'skillOutput': skillOutput,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  static OrchestrationTaskInclude include() {
    return OrchestrationTaskInclude._();
  }

  static OrchestrationTaskIncludeList includeList({
    _is.WhereExpressionBuilder<OrchestrationTaskTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrchestrationTaskTable>? orderBy,
    _is.OrderByListBuilder<OrchestrationTaskTable>? orderByList,
    OrchestrationTaskInclude? include,
  }) {
    return OrchestrationTaskIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrchestrationTask.t),
      orderByList: orderByList?.call(OrchestrationTask.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrchestrationTaskImpl extends OrchestrationTask {
  _OrchestrationTaskImpl({
    int? id,
    required String prompt,
    String? codeContext,
    String? geminiResponse,
    required String status,
    String? skillName,
    String? skillInput,
    String? skillOutput,
    String? errorMessage,
    required DateTime createdAt,
    DateTime? completedAt,
  }) : super._(
         id: id,
         prompt: prompt,
         codeContext: codeContext,
         geminiResponse: geminiResponse,
         status: status,
         skillName: skillName,
         skillInput: skillInput,
         skillOutput: skillOutput,
         errorMessage: errorMessage,
         createdAt: createdAt,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [OrchestrationTask]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  OrchestrationTask copyWith({
    Object? id = _Undefined,
    String? prompt,
    Object? codeContext = _Undefined,
    Object? geminiResponse = _Undefined,
    String? status,
    Object? skillName = _Undefined,
    Object? skillInput = _Undefined,
    Object? skillOutput = _Undefined,
    Object? errorMessage = _Undefined,
    DateTime? createdAt,
    Object? completedAt = _Undefined,
  }) {
    return OrchestrationTask(
      id: id is int? ? id : this.id,
      prompt: prompt ?? this.prompt,
      codeContext: codeContext is String? ? codeContext : this.codeContext,
      geminiResponse: geminiResponse is String?
          ? geminiResponse
          : this.geminiResponse,
      status: status ?? this.status,
      skillName: skillName is String? ? skillName : this.skillName,
      skillInput: skillInput is String? ? skillInput : this.skillInput,
      skillOutput: skillOutput is String? ? skillOutput : this.skillOutput,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}

class OrchestrationTaskUpdateTable
    extends _is.UpdateTable<OrchestrationTaskTable> {
  OrchestrationTaskUpdateTable(super.table);

  _is.ColumnValue<String, String> prompt(String value) => _is.ColumnValue(
    table.prompt,
    value,
  );

  _is.ColumnValue<String, String> codeContext(String? value) => _is.ColumnValue(
    table.codeContext,
    value,
  );

  _is.ColumnValue<String, String> geminiResponse(String? value) =>
      _is.ColumnValue(
        table.geminiResponse,
        value,
      );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> skillName(String? value) => _is.ColumnValue(
    table.skillName,
    value,
  );

  _is.ColumnValue<String, String> skillInput(String? value) => _is.ColumnValue(
    table.skillInput,
    value,
  );

  _is.ColumnValue<String, String> skillOutput(String? value) => _is.ColumnValue(
    table.skillOutput,
    value,
  );

  _is.ColumnValue<String, String> errorMessage(String? value) =>
      _is.ColumnValue(
        table.errorMessage,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _is.ColumnValue(
        table.completedAt,
        value,
      );
}

class OrchestrationTaskTable extends _is.Table<int?> {
  OrchestrationTaskTable({super.tableRelation})
    : super(tableName: 'orchestration_tasks') {
    updateTable = OrchestrationTaskUpdateTable(this);
    prompt = _is.ColumnString(
      'prompt',
      this,
    );
    codeContext = _is.ColumnString(
      'codeContext',
      this,
    );
    geminiResponse = _is.ColumnString(
      'geminiResponse',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    skillName = _is.ColumnString(
      'skillName',
      this,
    );
    skillInput = _is.ColumnString(
      'skillInput',
      this,
    );
    skillOutput = _is.ColumnString(
      'skillOutput',
      this,
    );
    errorMessage = _is.ColumnString(
      'errorMessage',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    completedAt = _is.ColumnDateTime(
      'completedAt',
      this,
    );
  }

  late final OrchestrationTaskUpdateTable updateTable;

  /// The user's original prompt/instruction.
  late final _is.ColumnString prompt;

  /// Optional code context provided alongside the prompt.
  late final _is.ColumnString codeContext;

  /// Raw response from Gemini API.
  late final _is.ColumnString geminiResponse;

  /// Current status: pending, calling_gemini, parsing, dispatching, running, complete, failed.
  late final _is.ColumnString status;

  /// Name of the skill selected for execution.
  late final _is.ColumnString skillName;

  /// JSON-encoded input data for the skill.
  late final _is.ColumnString skillInput;

  /// JSON-encoded output from the skill execution.
  late final _is.ColumnString skillOutput;

  /// Error message if the task failed.
  late final _is.ColumnString errorMessage;

  /// Timestamp when the task was created.
  late final _is.ColumnDateTime createdAt;

  /// Timestamp when the task completed or failed.
  late final _is.ColumnDateTime completedAt;

  @override
  List<_is.Column> get columns => [
    id,
    prompt,
    codeContext,
    geminiResponse,
    status,
    skillName,
    skillInput,
    skillOutput,
    errorMessage,
    createdAt,
    completedAt,
  ];
}

class OrchestrationTaskInclude extends _is.IncludeObject {
  OrchestrationTaskInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => OrchestrationTask.t;
}

class OrchestrationTaskIncludeList extends _is.IncludeList {
  OrchestrationTaskIncludeList._({
    _is.WhereExpressionBuilder<OrchestrationTaskTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OrchestrationTask.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => OrchestrationTask.t;
}

class OrchestrationTaskRepository {
  const OrchestrationTaskRepository._();

  /// Returns a list of [OrchestrationTask]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<OrchestrationTask>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrchestrationTaskTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrchestrationTaskTable>? orderBy,
    _is.OrderByListBuilder<OrchestrationTaskTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OrchestrationTask>(
      where: where?.call(OrchestrationTask.t),
      orderBy: orderBy?.call(OrchestrationTask.t),
      orderByList: orderByList?.call(OrchestrationTask.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OrchestrationTask] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<OrchestrationTask?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrchestrationTaskTable>? where,
    int? offset,
    _is.OrderByBuilder<OrchestrationTaskTable>? orderBy,
    _is.OrderByListBuilder<OrchestrationTaskTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OrchestrationTask>(
      where: where?.call(OrchestrationTask.t),
      orderBy: orderBy?.call(OrchestrationTask.t),
      orderByList: orderByList?.call(OrchestrationTask.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OrchestrationTask] by its [id] or null if no such row exists.
  Future<OrchestrationTask?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OrchestrationTask>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OrchestrationTask]s in the list and returns the inserted rows.
  ///
  /// The returned [OrchestrationTask]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrchestrationTask>> insert(
    _is.DatabaseSession session,
    List<OrchestrationTask> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<OrchestrationTask>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [OrchestrationTask] and returns the inserted row.
  ///
  /// The returned [OrchestrationTask] will have its `id` field set.
  Future<OrchestrationTask> insertRow(
    _is.DatabaseSession session,
    OrchestrationTask row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<OrchestrationTask>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [OrchestrationTask]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [OrchestrationTask]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrchestrationTask>> upsert(
    _is.DatabaseSession session,
    List<OrchestrationTask> rows, {
    required _is.ColumnSelections<OrchestrationTaskTable> conflictColumns,
    _is.ColumnSelections<OrchestrationTaskTable>? updateColumns,
    _is.WhereExpressionBuilder<OrchestrationTaskTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<OrchestrationTask>(
      rows,
      conflictColumns: conflictColumns(OrchestrationTask.t),
      updateColumns: updateColumns?.call(OrchestrationTask.t),
      updateWhere: updateWhere?.call(OrchestrationTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [OrchestrationTask] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [OrchestrationTask] will have its `id` field set.
  Future<OrchestrationTask?> upsertRow(
    _is.DatabaseSession session,
    OrchestrationTask row, {
    required _is.ColumnSelections<OrchestrationTaskTable> conflictColumns,
    _is.ColumnSelections<OrchestrationTaskTable>? updateColumns,
    _is.WhereExpressionBuilder<OrchestrationTaskTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<OrchestrationTask>(
      row,
      conflictColumns: conflictColumns(OrchestrationTask.t),
      updateColumns: updateColumns?.call(OrchestrationTask.t),
      updateWhere: updateWhere?.call(OrchestrationTask.t),
      transaction: transaction,
    );
  }

  /// Updates all [OrchestrationTask]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrchestrationTask>> update(
    _is.DatabaseSession session,
    List<OrchestrationTask> rows, {
    _is.ColumnSelections<OrchestrationTaskTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<OrchestrationTask>(
      rows,
      columns: columns?.call(OrchestrationTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [OrchestrationTask]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OrchestrationTask> updateRow(
    _is.DatabaseSession session,
    OrchestrationTask row, {
    _is.ColumnSelections<OrchestrationTaskTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<OrchestrationTask>(
      row,
      columns: columns?.call(OrchestrationTask.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrchestrationTask] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OrchestrationTask?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<OrchestrationTaskUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<OrchestrationTask>(
      id,
      columnValues: columnValues(OrchestrationTask.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OrchestrationTask]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrchestrationTask>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<OrchestrationTaskUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<OrchestrationTaskTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrchestrationTaskTable>? orderBy,
    _is.OrderByListBuilder<OrchestrationTaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<OrchestrationTask>(
      columnValues: columnValues(OrchestrationTask.t.updateTable),
      where: where(OrchestrationTask.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrchestrationTask.t),
      orderByList: orderByList?.call(OrchestrationTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [OrchestrationTask]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrchestrationTask>> delete(
    _is.DatabaseSession session,
    List<OrchestrationTask> rows, {
    _is.OrderByBuilder<OrchestrationTaskTable>? orderBy,
    _is.OrderByListBuilder<OrchestrationTaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<OrchestrationTask>(
      rows,
      orderBy: orderBy?.call(OrchestrationTask.t),
      orderByList: orderByList?.call(OrchestrationTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [OrchestrationTask].
  Future<OrchestrationTask> deleteRow(
    _is.DatabaseSession session,
    OrchestrationTask row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OrchestrationTask>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrchestrationTask>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OrchestrationTaskTable> where,
    _is.OrderByBuilder<OrchestrationTaskTable>? orderBy,
    _is.OrderByListBuilder<OrchestrationTaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<OrchestrationTask>(
      where: where(OrchestrationTask.t),
      orderBy: orderBy?.call(OrchestrationTask.t),
      orderByList: orderByList?.call(OrchestrationTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrchestrationTaskTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<OrchestrationTask>(
      where: where?.call(OrchestrationTask.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OrchestrationTask] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OrchestrationTaskTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OrchestrationTask>(
      where: where(OrchestrationTask.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
