import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/program_model.dart';

class ProgramService {
  ProgramService._();
  static final ProgramService instance = ProgramService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _programs =>
      _firestore.collection('programs');

  Future<void> addProgram({required ProgramModel program}) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("No admin is logged in.");
    }

    await _programs.add({
      ...program.toMap(),
      'createdBy': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<ProgramModel>> programsStream() {
    return _programs
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProgramModel.fromFirestore(doc))
              .toList(),
        );
  }

  Stream<List<ProgramModel>> publishedProgramsStream() {
    return _programs.where('isPublished', isEqualTo: true).snapshots().map((
      snapshot,
    ) {
      final programs = snapshot.docs
          .map((doc) => ProgramModel.fromFirestore(doc))
          .toList();
      programs.sort((a, b) {
        final aDate = a.createdAt?.toDate() ?? DateTime(0);
        final bDate = b.createdAt?.toDate() ?? DateTime(0);
        return bDate.compareTo(aDate);
      });
      return programs;
    });
  }

  Future<void> deleteProgram(String id) async {
    await _programs.doc(id).delete();
  }

  Future<void> updateProgram(ProgramModel program) async {
    await _programs.doc(program.id).update({
      ...program.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
