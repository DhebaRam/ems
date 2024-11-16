
import '../common/app_database/employee_database.dart';

abstract class EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> currentEmployees;
  final List<Employee> previousEmployees;

  EmployeeLoaded(this.currentEmployees, this.previousEmployees);
}

class EmployeeError extends EmployeeState {
  final String message;

  EmployeeError(this.message);
}
// import 'package:equatable/equatable.dart';
//
// class EmsState extends Equatable {
//   const EmsState({this.empList = const []});
//
//   final List<String> empList;
//
//   @override
//   List<Object> get props => [empList];
//
//   EmsState copyWith({List<String>? empList}) {
//     return EmsState(
//       empList: empList ?? this.empList,
//     );
//   }
// }
