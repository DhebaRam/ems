import '../common/app_database/employee_database.dart';

abstract class EmployeeEvent {}

class LoadEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final EmployeesCompanion employee;

  AddEmployee(this.employee);
}

class UpdateEmployee extends EmployeeEvent {
  final EmployeesCompanion employee;

  UpdateEmployee(this.employee);
}

class DeleteEmployee extends EmployeeEvent {
  final int id;

  DeleteEmployee(this.id);
}

// import 'package:equatable/equatable.dart';
//
// abstract class EmsEvent extends Equatable {
//   const EmsEvent();
// }
//
// class AddEmployeeEvent extends EmsEvent{
//   final String name;
//
//   const AddEmployeeEvent(this.name);
//
//   @override
//   List<Object?> get props => [name];
// }