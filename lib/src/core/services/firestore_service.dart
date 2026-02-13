import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- CREATE / SET ---
  /// ใช้สำหรับสร้างหรือทับข้อมูลเอกสาร (Document)
  Future<void> set({
    required String path,
    required Map<String, dynamic> data,
    bool merge =
        true, // ค่าเริ่มต้นให้ Merge เพื่อไม่ให้ลบ Field อื่นที่ไม่ได้ส่งไป
  }) async {
    await _db.doc(path).set(data, SetOptions(merge: merge));
  }

  /// ใช้สำหรับสร้างเอกสารใหม่ใน Collection โดยให้ Firestore Generate ID ให้โดยอัตโนมัติ
  Future<String> add({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    final docRef = await _db.collection(collectionPath).add(data);
    return docRef.id;
  }

  // --- READ ---
  /// ดึงข้อมูล 1 เอกสาร และแปลงเป็น Model T
  Future<T?> get<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String id) builder,
  }) async {
    final snap = await _db.doc(path).get();
    return snap.exists ? builder(snap.data()!, snap.id) : null;
  }

  /// ดึงข้อมูลรายการ (List) ทั้งหมดจาก Collection หรือ Query
  Future<List<T>> getCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String id) builder,
    Query Function(Query query)? queryBuilder,
  }) async {
    Query query = _db.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = await query.get();
    return snapshots.docs
        .map((doc) => builder(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  /// ดึงข้อมูลแบบ Real-time Stream (เหมาะกับแอปที่ต้องการอัปเดตทันที)
  Stream<List<T>> streamCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String id) builder,
    Query Function(Query query)? queryBuilder,
  }) {
    Query query = _db.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => builder(doc.data() as Map<String, dynamic>, doc.id))
          .toList(),
    );
  }

  // --- UPDATE ---
  /// อัปเดตเฉพาะบาง Field ในเอกสาร (หากไม่มีเอกสารอยู่จะ Error)
  Future<void> update({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    await _db.doc(path).update(data);
  }

  // --- DELETE ---
  /// ลบเอกสารตาม Path ที่ระบุ
  Future<void> delete({required String path}) async {
    await _db.doc(path).delete();
  }
}
