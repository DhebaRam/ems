
import 'package:bloc/bloc.dart';

import '../common/app_database/employee_database.dart';
import 'ems_event.dart';
import 'ems_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeDatabase database;

  EmployeeBloc(this.database) : super(EmployeeLoading()) {
    on<LoadEmployees>((event, emit) async {
      try {
        final currentEmployees = await database.getCurrentEmployees();
        final previousEmployees = await database.getPreviousEmployees();
        emit(EmployeeLoaded(currentEmployees, previousEmployees));
      } catch (e) {
        emit(EmployeeError("Failed to load employees"));
      }
    });

    on<AddEmployee>((event, emit) async {
      await database.addEmployee(event.employee);
      add(LoadEmployees());  // Refresh list
    });

    on<UpdateEmployee>((event, emit) async {
      await database.updateEmployee(event.employee);
      add(LoadEmployees());  // Refresh list
    });

    on<DeleteEmployee>((event, emit) async {
      await database.deleteEmployee(event.id);
      add(LoadEmployees());  // Refresh list
    });
  }
}


// import 'package:ems/bloc/ems_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'ems_event.dart';
//
// class EmsBloc extends Bloc<EmsEvent, EmsState> {
//   final List<String> empList = [];
//
//   EmsBloc() : super(const EmsState()) {
//     on<AddEmployeeEvent>(_addEmployee);
//     // on<AddEmployeeEvent>(_addEmployee);
//   }
//
//   void _addEmployee(AddEmployeeEvent event, Emitter<EmsState> emit) {
//     empList.add(event.name);
//     emit(state.copyWith(empList: List.from(empList)));
//   }
// }
