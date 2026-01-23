import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/analysis_history.dart';
import '../models/analysis_response.dart';

/// Service for managing analysis history in Firestore
class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user ID
  String? get _userId => _auth.currentUser?.uid;

  /// Collection reference for user's history
  CollectionReference get _historyCollection => 
      _firestore.collection('history');

  /// Save a new analysis to history
  Future<String?> saveAnalysis({
    required String mode,
    required String reportText,
    required AnalysisResponse response,
  }) async {
    if (_userId == null) {
      print('DEBUG History Save: No user logged in');
      return null;
    }

    try {
      print('DEBUG History Save: Saving for user $_userId');
      final docRef = await _historyCollection.add({
        'userId': _userId,
        'mode': mode,
        'reportText': reportText,
        'response': response.toJson(),
        'timestamp': FieldValue.serverTimestamp(),
        'reportPreview': reportText.length > 100 
            ? '${reportText.substring(0, 100)}...' 
            : reportText,
      });
      print('DEBUG History Save: Saved with ID ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error saving to history: $e');
      return null;
    }
  }

  /// Get user's analysis history ordered by timestamp (newest first)
  Future<List<AnalysisHistory>> getHistory() async {
    if (_userId == null) {
      print('DEBUG History: No user logged in');
      return [];
    }

    try {
      print('DEBUG History: Fetching for user $_userId');
      
      // Simple query without ordering (to avoid index requirement)
      // We'll sort in memory instead
      final snapshot = await _historyCollection
          .where('userId', isEqualTo: _userId)
          .limit(50)
          .get();

      print('DEBUG History: Found ${snapshot.docs.length} documents');

      final items = snapshot.docs
          .map((doc) => AnalysisHistory.fromFirestore(doc))
          .toList();
      
      // Sort in memory by timestamp (newest first)
      items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      return items;
    } catch (e) {
      print('Error fetching history: $e');
      return [];
    }
  }

  /// Get a single analysis by ID
  Future<AnalysisHistory?> getAnalysis(String id) async {
    try {
      final doc = await _historyCollection.doc(id).get();
      if (!doc.exists) return null;
      return AnalysisHistory.fromFirestore(doc);
    } catch (e) {
      print('Error fetching analysis: $e');
      return null;
    }
  }

  /// Delete a specific analysis
  Future<bool> deleteAnalysis(String id) async {
    try {
      await _historyCollection.doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting analysis: $e');
      return false;
    }
  }

  /// Clear all history for current user
  Future<bool> clearHistory() async {
    if (_userId == null) return false;

    try {
      final batch = _firestore.batch();
      final snapshot = await _historyCollection
          .where('userId', isEqualTo: _userId)
          .get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return true;
    } catch (e) {
      print('Error clearing history: $e');
      return false;
    }
  }
}
