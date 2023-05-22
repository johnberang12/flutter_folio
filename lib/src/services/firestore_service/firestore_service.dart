// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_service.g.dart';

//* this class contains the APIs that are responsible for persisting and fetching data from firestore
//* all repositories that needs to talk to the firstore database have to use these APIs

typedef BatchBuilder<T> = Future<void> Function(WriteBatch batch);

//to unit test this, we have to inject the class with FakeFirebaseFirestore from the fake_cloud_firestore package.
//for simplicity i only wrote the api the this app needs. But we can write more api's here if needed like
// getDocument, getCollection, collectionStream and the like.
//*unit test done
class FirestoreService {
  FirestoreService({
    required this.db,
  });
  final FirebaseFirestore db;

  //* used to add and update data in the database
  Future<void> setData(
      {required String path,
      required Map<String, dynamic> data,
      SetOptions? setOptions}) async {
    final reference = db.doc(path);
    await reference.set(data, setOptions);
  }

  Future<void> deleteData({required String path}) async {
    final reference = db.doc(path);
    await reference.delete();
  }

  Query<T> collectionQuery<T>({
    required String path,
    required T Function(DocumentSnapshot<Map<String, dynamic>> snapshot,
            SnapshotOptions? options)
        fromMap,
    required Map<String, Object?> Function(T, SetOptions? options) toMap,
    Query<T> Function(Query<T>? query)? queryBuilder,
  }) {
    Query<T> query = db
        .collection(path)
        .withConverter<T>(fromFirestore: fromMap, toFirestore: toMap);
    if (queryBuilder != null) {
      return query = queryBuilder(query);
    } else {
      return query;
    }
  }

  Stream<T> documentStream<T>(
      {required String path,
      required T Function(Map<String, dynamic>? data) builder}) {
    final reference = db.doc(path);
    final snapshots = reference.snapshots();
    return snapshots
        .map((snapshot) => builder(snapshot.data() as Map<String, dynamic>));
  }
}

@Riverpod(keepAlive: true)
FirebaseFirestore firestore(FirestoreRef ref) {
  return FirebaseFirestore.instance;
}

@Riverpod(keepAlive: true)
FirestoreService firestoreService(FirestoreServiceRef ref) {
  return FirestoreService(db: ref.watch(firestoreProvider));
}
