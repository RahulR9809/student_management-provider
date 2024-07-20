import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentapp_provider/db/db_functions.dart';
import 'package:studentapp_provider/model/model.dart';

class HomePageProvider extends ChangeNotifier {
  late DatabaseHelper databaseHelper;
  List<Student> students = [];
  List<Student> filteredStudents = [];
  bool noResult = false;
  String? profileImagePath;
  XFile? image;
  late Student currentStudent;

  HomePageProvider() {
    databaseHelper = DatabaseHelper();
    refreshStudentList();
  }

  Future<void> refreshStudentList() async {
    final studentList = await databaseHelper.getStudents();
    students = studentList;
    filteredStudents = List.from(students);
    noResult = false;
    notifyListeners();
  }

  Future<void> updateStudent(Student updatedStudent) async {
    await databaseHelper.updateStudent(updatedStudent);
    await refreshStudentList();
  }

  void filterStudents(String query) {
    final lowerCaseQuery = query.toLowerCase();
    if (lowerCaseQuery.isEmpty) {
      filteredStudents = List.from(students);
      noResult = false;
    } else {
      filteredStudents = students.where((student) {
        return student.name.toLowerCase().contains(lowerCaseQuery);
      }).toList();
      noResult = filteredStudents.isEmpty;
    }
    notifyListeners();
  }

  void setImage(XFile? img) {
    image = img;
    profileImagePath = img?.path;
    notifyListeners();
  }

  void clearImage() {
    image = null;
    profileImagePath = null;
    notifyListeners();
  }

  void setCurrentStudent(Student student) {
    currentStudent = student;
    profileImagePath = student.image;
    notifyListeners();
  }

  void clearCurrentStudent() {
    profileImagePath = null;
    notifyListeners();
  }
}
