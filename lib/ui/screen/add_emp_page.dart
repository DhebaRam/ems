import 'dart:developer';

import 'package:ems/bloc/ems_bloc.dart';
import 'package:ems/bloc/ems_event.dart';
import 'package:ems/common/base_components/base_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

import '../../common/app_database/employee_database.dart';
import '../../common/base_components/base_app_bar.dart';
import '../../common/base_components/base_colors.dart';
import '../../common/base_components/base_text.dart';
import '../../common/base_components/base_text_field.dart';
import '../../common/base_components/strings_class.dart';
import '../../common/utils/utils_function.dart';

import '../widget/calender_widget.dart';

class AddEmpPage extends StatefulWidget {
  final Employee? employee;
  final bool addEmpPage;

  const AddEmpPage({super.key, this.employee, this.addEmpPage = false});

  @override
  State<AddEmpPage> createState() => _AddEmpPageState();
}

class _AddEmpPageState extends State<AddEmpPage> {
  final _formKey = GlobalKey<FormState>(),
      _nameController = TextEditingController(),
      _roleController = TextEditingController(),
      _todayController = TextEditingController(),
      _noDateController = TextEditingController();
  String selectRole = '';
  List roleList = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner'
  ];

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      _nameController.text = widget.employee?.name ?? '';
      _roleController.text = widget.employee?.role ?? '';
      _todayController.text =
          formatDateFromString(widget.employee?.startDate.toString());
      _noDateController.text = widget.employee?.endDate != null
          ? formatDateFromString(widget.employee?.endDate.toString())
          : '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        centerTitle: false,
        backgroundColor: BaseColors.primaryColor,
        title: BaseText(
          value: widget.addEmpPage
              ? Strings.addEmployeeDetails
              : Strings.editEmployeeDetails,
          color: BaseColors.whiteColor,
          fontSize: 18,
        ),
        actions: [
          widget.addEmpPage
              ? const SizedBox.shrink()
              : IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  icon: SvgPicture.asset(BaseAssets.deleteIcon, height: 30),
                  onPressed: () {
                    _nameController.clear();
                    _roleController.clear();
                    _todayController.clear();
                    _noDateController.clear();
                  },
                ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              buildSizeHeight(mediaQueryWidth(context, 0.1)),
              BaseTextField(
                labelText: '',
                hintText: Strings.employeeName,
                controller: _nameController,
                validationMessage: 'Please Enter Employee',
                isName: true,
                maxLength: 50,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                textCapitalization: TextCapitalization.words,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SvgPicture.asset(BaseAssets.personIcon, height: 25),
                ),
              ),
              buildSizeHeight(mediaQueryWidth(context, 0.04)),
              BaseTextField(
                onTap: () => showRoleBottomSheet(),
                labelText: '',
                readOnly: true,
                hintText: Strings.selectRole,
                controller: _roleController,
                validationMessage: 'Please Enter Employee',
                isName: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SvgPicture.asset(BaseAssets.roleIcon, height: 25),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SvgPicture.asset(BaseAssets.arrowIcon, height: 15),
                ),
              ),
              buildSizeHeight(mediaQueryWidth(context, 0.04)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BaseTextField(
                      onTap: () {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0))),
                            insetPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            // Add padding for small margin around
                            child: CalendarDialog(
                              isToday: true,
                              lastDay: _noDateController.text.trim().isNotEmpty
                                  ? DateFormat(outFormat)
                                      .parse(_noDateController.text.trim())
                                  : null,
                              initialFocusedDay: _todayController.text
                                      .trim()
                                      .isNotEmpty
                                  ? DateFormat(outFormat)
                                      .parse(_todayController.text.trim())
                                  : _noDateController.text.trim().isNotEmpty
                                      ? DateFormat(outFormat)
                                          .parse(_noDateController.text.trim())
                                      : DateTime.now(),
                              onDaySelected: (selectedDay) {
                                // Handle the selected day here

                                _todayController.text = formatDateFromString(
                                    selectedDay.toString());
                                log("Selected Day: $selectedDay");
                                log("Selected Day: ${_todayController.text}");
                              },
                            ),
                          ),
                        );
                      },
                      readOnly: true,
                      labelText: '',
                      hintText: Strings.today,
                      controller: _todayController,
                      contentPadding: const EdgeInsets.only(
                        top: 18,
                        bottom: 18,
                        left: 0,
                        right: 0.0,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      validationMessage: 'Please Select Date',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SvgPicture.asset(BaseAssets.calenderIcon,
                            height: 25),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: SvgPicture.asset(BaseAssets.arrowRight, width: 30),
                  ),
                  Expanded(
                    child: BaseTextField(
                      onTap: () {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0))),
                            insetPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            // Add padding for small margin around
                            child: CalendarDialog(
                              firstDay: _todayController.text.trim().isNotEmpty
                                  ? DateFormat(outFormat)
                                      .parse(_todayController.text.trim())
                                  : null,
                              lastDay: null,
                              initialFocusedDay: _noDateController.text
                                      .trim()
                                      .isNotEmpty
                                  ? DateFormat(outFormat)
                                      .parse(_noDateController.text.trim())
                                  : _todayController.text.trim().isNotEmpty
                                      ? DateFormat(outFormat)
                                          .parse(_todayController.text.trim())
                                      : DateTime.now(),
                              onDaySelected: (selectedDay) {
                                // Handle the selected day here
                                if (selectedDay != null) {
                                  _noDateController.text = formatDateFromString(
                                      selectedDay.toString());
                                } else {
                                  _noDateController.text = '';
                                }
                                print("Selected Day: $selectedDay");
                              },
                            ),
                          ),
                        );
                      },
                      readOnly: true,
                      labelText: '',
                      hintText: Strings.noDate,
                      controller: _noDateController,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      validationMessage: 'Please Select Data',
                      isRequired: false,
                      contentPadding: const EdgeInsets.only(
                        top: 18,
                        bottom: 18,
                        left: 0,
                        right: 0.0,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SvgPicture.asset(BaseAssets.calenderIcon,
                            height: 25),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 5, color: BaseColors.dividerColor),
          const SizedBox(height: 10),
          // Bottom Action Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 80,
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    backgroundColor: BaseColors.secondaryColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close dialog on Save click
                  },
                  child: const BaseText(
                      value: 'Cancel',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      textAlign: TextAlign.center,
                      color: BaseColors.primaryColor),
                ),
              ),
              buildSizeWidth(mediaQueryWidth(context, 0.02)),
              SizedBox(
                width: 80,
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    backgroundColor: BaseColors.primaryColor,
                  ),
                  onPressed: () {
                    final employeeBloc = context.read<EmployeeBloc>();
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState!.save();
                    DateTime startDate = DateTime.parse(formatDateFromString(
                        _todayController.text.trim(),
                        input: outFormat,
                        output: inFormat));
                    DateTime? endDate;
                    if (_noDateController.text.trim() != '' ||
                        _noDateController.text.trim().isNotEmpty) {
                      endDate = DateTime.parse(formatDateFromString(
                          _noDateController.text.trim(),
                          input: outFormat,
                          output: inFormat));
                    } else {
                      endDate = null;
                    }
                    if (_nameController.text.trim().isNotEmpty &&
                        _roleController.text.trim().isNotEmpty &&
                        _todayController.text.trim().toString() != null) {
                      if (widget.addEmpPage) {
                        final employee = EmployeesCompanion(
                          name: drift.Value.ofNullable(
                              _nameController.text.trim()),
                          role: drift.Value.ofNullable(
                              _roleController.text.trim()),
                          startDate: drift.Value.ofNullable(startDate),
                          endDate: drift.Value.absentIfNull(endDate),
                        );
                        employeeBloc.add(AddEmployee(employee));
                      } else {
                        final employee = EmployeesCompanion(
                          id: drift.Value.ofNullable(widget.employee!.id),
                          name: drift.Value.ofNullable(
                              _nameController.text.trim()),
                          role: drift.Value.ofNullable(
                              _roleController.text.trim()),
                          startDate: drift.Value.ofNullable(startDate),
                          endDate: drift.Value(endDate),
                        );
                        employeeBloc.add(UpdateEmployee(employee));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please complete all fields.")));
                    }
                    // BlocProvider.of<EmsBloc>(context).add(const AddEmployeeEvent('Test'));
                    Navigator.pop(context); // Close dialog on Save click
                  },
                  child: const BaseText(
                      value: 'Save',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      textAlign: TextAlign.center,
                      color: BaseColors.whiteColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  showRoleBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: roleList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: BaseText(
                  value: '${roleList[index]}',
                  textAlign: TextAlign.center,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                onTap: () {
                  _roleController.text = roleList[index];
                  Navigator.of(context).pop();
                },
              );
            });
      },
    );
  }
}
