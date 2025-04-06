import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
import '../models/menu_item.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Menu Operations
  Future<List<MenuItem>> getMenuItems() async {
    try {
      final snapshot = await _firestore.collection(menuCollectionPath).get();
      return snapshot.docs.map((doc) => MenuItem.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch menu items: $e');
    }
  }

  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(menuCollectionPath)
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => MenuItem.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch $category items: $e');
    }
  }

  // User Operations
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Order Operations
  Future<void> placeOrder(Map<String, dynamic> orderData) async {
    try {
      await _firestore.collection(ordersCollectionPath).add(orderData);
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }

  // Chat Operations
  Stream<QuerySnapshot> getChatMessages(String userId) {
    return _firestore
        .collection(chatsCollectionPath)
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> sendMessage(String userId, String message) async {
    await _firestore
        .collection(chatsCollectionPath)
        .doc(userId)
        .collection('messages')
        .add({
      'text': message,
      'sender': _auth.currentUser?.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}