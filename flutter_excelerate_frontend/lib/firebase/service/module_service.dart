import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/module_model.dart';

class ModuleService {
  ModuleService._();

  static final ModuleService instance = ModuleService._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _moduleCollection(
    String programId,
  ) {
    return _firestore
        .collection('programs')
        .doc(programId)
        .collection('modules');
  }

  Future<void> addModule({
    required String programId,
    required ModuleModel module,
  }) async {
    await _moduleCollection(programId).add({
      ...module.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<ModuleModel>> modulesStream(String programId) {
    return _moduleCollection(programId)
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ModuleModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> updateModule({
    required String programId,
    required ModuleModel module,
  }) async {
    await _moduleCollection(programId).doc(module.id).update({
      ...module.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteModule({
    required String programId,
    required String moduleId,
  }) async {
    await _moduleCollection(programId).doc(moduleId).delete();
  }
}
