import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'employee_database.g.dart';


@DataClassName('Employee')
class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get role => text().withLength(min: 1, max: 50)();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
}

@DriftDatabase(tables: [Employees])
class EmployeeDatabase extends _$EmployeeDatabase {
  EmployeeDatabase(QueryExecutor e) : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Employee>> getCurrentEmployees() async =>
    await (select(employees)..where((tbl) => tbl.endDate.isNull())).get();

  Future<List<Employee>> getPreviousEmployees() async {
    print(await select(employees).get());
    return (select(employees)..where((tbl) => tbl.endDate.isNotNull())).get();
  }

  Future<int> addEmployee(EmployeesCompanion employee) async=> await into(employees).insert(employee);

  Future<bool> updateEmployee(EmployeesCompanion employee) => update(employees).replace(employee);

  Future<int> deleteEmployee(int id) => (delete(employees)..where((tbl) => tbl.id.equals(id))).go();
}

// Function to initialize the database with a persistent file-based storage
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'employee_database.sqlite'));
    return NativeDatabase(file);
  });
}
