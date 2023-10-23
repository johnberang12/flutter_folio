// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/styles.dart';
import '../features/connectivity/no_internet_list_view_loader.dart';
import '../services/connectivity_service.dart';

//A type representing the itemBuilder
typedef ListCollectionItemBuilder<T> = Widget Function(T, int);
//A type representing the separatorBuilder
typedef ListCollectionSeparatorBuilder<T> = Widget Function(BuildContext, int);
//A type representing the loadingBuilder
typedef ListCollectionLoadingBuilder<T> = Widget Function(
    FirestoreQueryBuilderSnapshot<T>);
//A type representing the sort function
typedef ListCollectionSort<T> = int Function(
    QueryDocumentSnapshot<T>, QueryDocumentSnapshot<T>);

//* generic type widget that used to paginate and display any type of documents collection specifically from firestore
class ListCollectionBuilder<T> extends ConsumerStatefulWidget {
  const ListCollectionBuilder({
    super.key,
    required this.query,
    this.controller,
    this.sort,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.emptyWidget,
    this.padding,
    this.loadingDuration,
    required this.screenTitle,
    this.lastItem,
    this.pageSize = 10,
    required this.loadingBuilder,
    this.reverseItems = false,
    this.reverseListView = false,
  });
  final Query<T> query;
  final ScrollController? controller;
  final ListCollectionItemBuilder<T> itemBuilder;
  final ListCollectionSeparatorBuilder<T> separatorBuilder;
  final Widget? emptyWidget;
  final EdgeInsetsGeometry? padding;
  final int? loadingDuration;
  final String screenTitle;
  final Widget? lastItem;
  final int pageSize;
  final ListCollectionLoadingBuilder<T> loadingBuilder;
  final bool reverseItems;
  final bool reverseListView;
  final ListCollectionSort? sort;

  @override
  ConsumerState<ListCollectionBuilder<T>> createState() =>
      _ListCollectionBuilderState<T>();
}

class _ListCollectionBuilderState<T>
    extends ConsumerState<ListCollectionBuilder<T>> {
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    _loading = true;
    _setLoading();
  }

  Future<void> _setLoading() async {
    await Future.delayed(
        Duration(milliseconds: widget.loadingDuration ?? 1000));
    _loading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final connection = ref.watch(connectivityServiceProvider);
    return FirestoreQueryBuilder(
        query: widget.query,
        builder: (context, snapshot, _) {
          if (snapshot.isFetching || _loading) {
            return widget.loadingBuilder(snapshot);
          }
          if (snapshot.hasError) {
            debugPrint(
                'Snapshot error from ${widget.screenTitle}: ${snapshot.error.toString()}');
            return Center(
              child: Text(
                'Ooops! Somthing went wrong',
                style: Styles.k20Bold(context),
              ),
            );
          }
          if (snapshot.docs.isEmpty) {
            return Center(
                child: widget.emptyWidget ??
                    Text(
                      'No item found',
                      style: Styles.k20Grey(context),
                    ));
          }
          return ListView.separated(
            padding: widget.padding ?? const EdgeInsets.all(0),
            physics: const BouncingScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            reverse: widget.reverseListView,
            controller: widget.controller,
            itemCount: snapshot.docs.length + 1,
            separatorBuilder: widget.separatorBuilder,
            itemBuilder: (_, index) {
              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                // Tell FirestoreQueryBuilder to try to obtain more items.
                // It is safe to call this function from within the build method.
                if (connection) {
                  snapshot.fetchMore();
                }
              }
              final list = widget.reverseItems
                  ? snapshot.docs.reversed.toList()
                  : snapshot.docs;
              if (widget.sort != null) {
                list.sort(widget.sort);
              }
              if ((index == snapshot.docs.length)) {
                return widget.lastItem ?? const NoInternetListViewLoader();
              }
              final item = list[index].data();
              return widget.itemBuilder(item, index);
            },
          );
        });
  }
}
