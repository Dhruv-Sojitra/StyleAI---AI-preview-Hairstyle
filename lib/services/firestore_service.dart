import 'package:ai_hairstyle_preview_app/models/generation_result_model.dart';
import 'package:ai_hairstyle_preview_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, uid);
    }
    return null;
  }

  Future<void> saveGenerationResult(GenerationResult result) async {
    await _firestore.collection('history').doc(result.id).set(result.toMap());
  }

  Stream<List<GenerationResult>> getUserHistory(String userId) {
    return _firestore
        .collection('history')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => GenerationResult.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> deleteHistoryItem(String id) async {
    await _firestore.collection('history').doc(id).delete();
  }

  Future<void> toggleFavorite(String historyId, bool currentStatus) async {
    await _firestore.collection('history').doc(historyId).update({
      'isFavorite': !currentStatus,
    });
  }

  Future<void> submitFeedback(String userId, String message) async {
    await _firestore.collection('feedback').add({
      'userId': userId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
