@Timeout(Duration(milliseconds: 500))
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_folio/src/services/firestore_service/firestore_service.dart';

import '../../fakes/test_data.dart';

void main() {
  late FirebaseFirestore fakeFirebaseFirestore;
  late FirestoreService firestoreService;
  setUp(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(db: fakeFirebaseFirestore);
  });

  group('FirestoreService test', () {
    test('setData method should add data to a given path', () async {
      const String path = 'testPath/testId';
      Map<String, dynamic> data = {'id': 'testId', 'key': 'value'};

      await firestoreService.setData(path: path, data: data);

      // Verify that the data has been set in the path
      var snapshot = await fakeFirebaseFirestore.doc(path).get();
      expect(snapshot.data(), equals(data));
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('deleteData method should delete data at a given path', () async {
      const String path = 'testPath/testId';
      Map<String, dynamic> data = {'id': 'testId', 'key': 'value'};

      // Initially add the data
      await firestoreService.setData(path: path, data: data);

      // Now delete the data
      await firestoreService.deleteData(path: path);

      // Verify that the data has been deleted from the path
      var snapshot = await fakeFirebaseFirestore.doc(path).get();
      expect(snapshot.exists, false);
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('expect to return the collection', () async {
      final testCollection = [
        TestData(id: 'id100'),
        TestData(id: 'id101'),
        TestData(id: 'id102')
      ];
//add data to the fake firestore
      for (var i = 0; i < testCollection.length; i++) {
        final path = 'testDatas/id10$i';
        await firestoreService.setData(
            path: path, data: testCollection[i].toMap());
      }
// create a query to the collection path where the data has been saved
      final Query<TestData> result = firestoreService.collectionQuery(
          path: 'testDatas',
          fromMap: ((snapshot, options) => TestData.fromMap(snapshot.data()!)),
          toMap: ((testData, options) => testData.toMap()));
      //expect that the result is of type Query<TestData>
      expect(result, isA<Query<TestData>>());

//query the data saved in the testDatas collection
      final data = await result.get().then((snapshot) {
        final result =
            snapshot.docs.map((snapshot) => snapshot.data()).toList();

        return result;
      });
      //compare that the result queried by the collectionQuery function is the same as the data that was saved.
      //make sure  that the TestData class has an equality operator to compare very field or the class
      expect(data, testCollection);
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('expect to return last document in the stream', () async {
      final testCollection = [
        TestData(id: 'id100'),
        TestData(id: 'id101'),
        TestData(id: 'id102')
      ];

      for (var i = 0; i < testCollection.length; i++) {
        final path = 'testDatas/id10$i';
        await firestoreService.setData(
            path: path, data: testCollection[i].toMap());
      }

      // Assuming the documents are ordered by their paths, the last document path will be 'testDatas/id102'
      final Stream<TestData> result = firestoreService.documentStream(
        path: 'testDatas/id102',
        builder: (data) => TestData.fromMap(data!),
      );

      // expectLater allows you to evaluate a Stream
      await expectLater(
        result,
        emits(testCollection.last), // expect it to emit last test data
      );
    }, timeout: const Timeout(Duration(milliseconds: 500)));
  });
}
