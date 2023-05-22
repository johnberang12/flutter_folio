//an auto dispose custom controller.
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'custom_controller.g.dart';

// @riverpod
// class ImageEditingController<T> extends _$ImageEditingController {
//   @override
//   build() {}

// }

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomController<T> extends StateNotifier<List<T>> {
  CustomController() : super([]);
  List<T> get value => state;

  int get length => state.length;

  void addItem(T item) {
    state = [...state, item];
  }

  void addAll(List<T> items) {
    state = [...state, ...items];
  }

  void replace(T item) {
    state = [item];
  }

  void removeItem(T removeItem) {
    state = [
      for (final item in state)
        if (item != removeItem) item,
    ];
  }

  //  custom removeAt method
  T removeAt(int index) {
    final item = state[index];
    state = [
      ...state.sublist(0, index),
      ...state.sublist(index + 1),
    ];
    return item;
  }

  // custom insert method
  void insert(int index, T item) {
    state = [
      ...state.sublist(0, index),
      item,
      ...state.sublist(index),
    ];
  }

  void removeDuplicates() {
    state = <T>{...state}.toList();
  }

  void clear() {
    state = [];
  }
}
