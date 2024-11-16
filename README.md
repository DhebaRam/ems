# ems

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



Make Sure build_runner and drift_dev Are Installed Confirm that the build_runner and drift_dev packages are added in pubspec.yaml under dev_dependencies:

dev_dependencies:
build_runner: ^2.1.7
drift_dev: ^2.0.0


=> Run the Build Runner Command Open your terminal, navigate to your project directory, and run the following command:

-> flutter pub run build_runner build ///command

=> Clean Build Runner Cache (if Needed) If the file still isn’t generated, try cleaning up the cache and regenerating the file:

-> flutter pub run build_runner clean ///command
-> flutter pub run build_runner build ///command


Check for Errors in employee_database.dart Ensure there are no syntax errors in employee_database.dart, as errors can prevent build_runner from generating the .g.dart files.

Check for Code Generation Conflicts If there are other code generators (like json_serializable, freezed, etc.) that might be causing conflicts, consider running:

-> flutter pub run build_runner build --delete-conflicting-outputs ///command