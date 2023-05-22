import 'package:cloud_firestore/cloud_firestore.dart';

class FakeQuerySnapshot<T> extends QuerySnapshot<T> {
  @override
  List<DocumentChange<T>> get docChanges => throw UnimplementedError();

  @override
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  int get size => throw UnimplementedError();

  @override
  List<QueryDocumentSnapshot<T>> get docs => throw UnimplementedError();
  // Leave the rest of the methods unimplemented.
}

// ignore: subtype_of_sealed_class
class FakeQuery<T> extends Query<T> {
  @override
  AggregateQuery count() {
    throw UnimplementedError();
  }

  @override
  Query<T> endAt(Iterable<Object?> values) {
    throw UnimplementedError();
  }

  @override
  Query<T> endAtDocument(DocumentSnapshot<Object?> documentSnapshot) {
    throw UnimplementedError();
  }

  @override
  Query<T> endBefore(Iterable<Object?> values) {
    throw UnimplementedError();
  }

  @override
  Query<T> endBeforeDocument(DocumentSnapshot<Object?> documentSnapshot) {
    throw UnimplementedError();
  }

  @override
  FirebaseFirestore get firestore => throw UnimplementedError();

  @override
  Query<T> limit(int limit) {
    throw UnimplementedError();
  }

  @override
  Query<T> limitToLast(int limit) {
    throw UnimplementedError();
  }

  @override
  Query<T> orderBy(Object field, {bool descending = false}) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> get parameters => throw UnimplementedError();

  @override
  Stream<QuerySnapshot<T>> snapshots({bool includeMetadataChanges = false}) {
    throw UnimplementedError();
  }

  @override
  Query<T> startAfter(Iterable<Object?> values) {
    throw UnimplementedError();
  }

  @override
  Query<T> startAfterDocument(DocumentSnapshot<Object?> documentSnapshot) {
    throw UnimplementedError();
  }

  @override
  Query<T> startAt(Iterable<Object?> values) {
    throw UnimplementedError();
  }

  @override
  Query<T> startAtDocument(DocumentSnapshot<Object?> documentSnapshot) {
    throw UnimplementedError();
  }

  @override
  Query<T> where(Object field,
      {Object? isEqualTo,
      Object? isNotEqualTo,
      Object? isLessThan,
      Object? isLessThanOrEqualTo,
      Object? isGreaterThan,
      Object? isGreaterThanOrEqualTo,
      Object? arrayContains,
      Iterable<Object?>? arrayContainsAny,
      Iterable<Object?>? whereIn,
      Iterable<Object?>? whereNotIn,
      bool? isNull}) {
    throw UnimplementedError();
  }

  @override
  Future<QuerySnapshot<T>> get([GetOptions? options]) {
    throw UnimplementedError();
  }

  @override
  // ignore: avoid_shadowing_type_parameters
  Query<T> withConverter<T>(
      {required FromFirestore<T> fromFirestore,
      required ToFirestore<T> toFirestore}) {
    throw UnimplementedError();
  }
  // Leave the rest of the methods unimplemented.
}
