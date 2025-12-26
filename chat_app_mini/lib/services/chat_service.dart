import 'package:chat_app_mini/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ===================== USERS =====================
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _fireStore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        user['uid'] = doc.id;
        return user;
      }).toList();
    });
  }

  // ===================== SEND MESSAGE =====================
  Future<void> sendMessage(String receiverId, String message) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("User not authenticated");
      }

      final Timestamp timestamp = Timestamp.now();

      Message newMessage = Message(
        senderId: currentUser.uid,
        senderEmail: currentUser.email ?? '',
        receiverId: receiverId,
        message: message,
        timestamp: timestamp,
      );

      List<String> ids = [currentUser.uid, receiverId]..sort();
      String chatRoomId = ids.join('_');

      await _fireStore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("message")
          .add(newMessage.toMap());

    } on FirebaseException catch (e) {
      print("sendMessage Firebase error: ${e.code}");
      rethrow;
    } catch (e) {
      print("sendMessage error: $e");
      rethrow;
    }
  }

  // ===================== GET MESSAGES =====================
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId]..sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("message")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // ===================== DELETE MESSAGE =====================
  Future<void> deleteMessage({
    required String userId,
    required String otherUserId,
    required String messageId,
  }) async {
    try {
      List<String> ids = [userId, otherUserId]..sort();
      String chatRoomId = ids.join("_");

      await _fireStore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("message")
          .doc(messageId)
          .delete();

    } on FirebaseException catch (e) {
      print("deleteMessage Firebase error: ${e.code}");
      rethrow;
    } catch (e) {
      print("deleteMessage error: $e");
      rethrow;
    }
  }
}