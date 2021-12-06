import 'package:chatbot/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatbot/services/database_service.dart';

void main() async {
  await initServices();
  runApp(const Home());
}

Future<void> initServices() async {
  await Get.putAsync(() => DatabaseService().init());
}