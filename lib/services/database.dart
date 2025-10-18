import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== USERS ==========

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print("ERROR getting user data: $e");
      return null;
    }
  }

  // Update user data
  Future<bool> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
      return true;
    } catch (e) {
      print("ERROR updating user data: $e");
      return false;
    }
  }

  // ========== MENU ITEMS ==========

  // Get all menu items
  Stream<List<Map<String, dynamic>>> getMenuItems() {
    return _firestore
        .collection('menu_items')
        .where('available', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Add document ID to the data
        return data;
      }).toList();
    });
  }

  // Get menu items by category
  Stream<List<Map<String, dynamic>>> getMenuItemsByCategory(String category) {
    return _firestore
        .collection('menu_items')
        .where('category', isEqualTo: category)
        .where('available', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Get single menu item
  Future<Map<String, dynamic>?> getMenuItem(String itemId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('menu_items').doc(itemId).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      print("ERROR getting menu item: $e");
      return null;
    }
  }

  // ========== ORDERS ==========

  // Create new order
  Future<String?> createOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalPrice,
    required String deliveryAddress,
    String? phoneNumber,
  }) async {
    try {
      DocumentReference orderRef = await _firestore.collection('orders').add({
        'userId': userId,
        'items': items,
        'totalPrice': totalPrice,
        'deliveryAddress': deliveryAddress,
        'phoneNumber': phoneNumber,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("DEBUG: Order created with ID: ${orderRef.id}");
      return orderRef.id;
    } catch (e) {
      print("ERROR creating order: $e");
      return null;
    }
  }

  // Get user orders
  Stream<List<Map<String, dynamic>>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Get single order
  Future<Map<String, dynamic>?> getOrder(String orderId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      print("ERROR getting order: $e");
      return null;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("ERROR updating order status: $e");
      return false;
    }
  }
}