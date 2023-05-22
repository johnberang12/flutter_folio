@Timeout(Duration(milliseconds: 500))
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late MockImageUploadRepository mockImageUploadRepository;

  setUp(() {
    mockImageUploadRepository = MockImageUploadRepository();
  });

  group('ImageUploadRepository class test', () {
    test('uploadFileImages should return expected list of URLs', () async {
      // arrange
      final testFiles = [File('path1'), File('path2'), File('path3')];
      const testPath = 'test/path';
      final expectedUrls = ['url1', 'url2', 'url3'];
      when(() => mockImageUploadRepository.uploadFileImages(
            files: any(named: 'files'),
            path: any(named: 'path'),
          )).thenAnswer((_) async => expectedUrls);

      // act
      final result = await mockImageUploadRepository.uploadFileImages(
        files: testFiles,
        path: testPath,
      );

      // assert
      expect(result, expectedUrls);
      verify(() => mockImageUploadRepository.uploadFileImages(
            files: testFiles,
            path: testPath,
          )).called(1);
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('deleteImages should delete expected list of URLs', () async {
      // arrange
      final testUrls = ['url1', 'url2', 'url3'];
      when(() => mockImageUploadRepository.deleteImages(any()))
          .thenAnswer((_) => Future.value());

      // act
      await mockImageUploadRepository.deleteImages(testUrls);

      // assert
      verify(() => mockImageUploadRepository.deleteImages(testUrls)).called(1);
    }, timeout: const Timeout(Duration(milliseconds: 500)));
  });
}
