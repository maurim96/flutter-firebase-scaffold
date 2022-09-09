import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:app/services/firebase_service.dart';

@module
abstract class AppModule {
  @preResolve
  Future<FirebaseService> get fireService => FirebaseService.init();

  @injectable
  FirebaseFirestore get store => FirebaseFirestore.instance;
}
