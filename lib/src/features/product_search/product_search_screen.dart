import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/alert_dialogs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/styles.dart';

class ProductSearchScreen extends SearchDelegate<String> {
  ProductSearchScreen({required this.ref})
      : super(
          searchFieldLabel: "Search...",
          textInputAction: TextInputAction.search,
        );

  final WidgetRef ref;

  @override
  void showResults(BuildContext context) async {
    super.showResults(context);
    FocusScope.of(context).unfocus();
    submitSearch(context);
  }

  Future<void> submitSearch(BuildContext context) async => showAlertDialog(
      context: context,
      title: 'Unimplemented',
      content:
          'Since firestore doesnt have a built-in full-text-search, we need to use third party search feature like algolia. And Algolia is very easy to implement as it is already a firebase extension.');

//* list of build actions
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () => showResults(context),
          icon: const Icon(Icons.search)),
      if (query.isNotEmpty) ...[
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
      ]
    ];
  }

//* leading widget
  @override
  Widget? buildLeading(BuildContext context) =>
      Consumer(builder: (context, ref, _) {
        return Row(
          children: [
            IconButton(
                onPressed: () => close(context, query),
                icon: const Icon(Icons.arrow_back)),
          ],
        );
      });

//*return search results screen here
  @override
  Widget buildResults(BuildContext context) => const SizedBox();

//* return search suggestions here
  @override
  Widget buildSuggestions(BuildContext context) =>
      Center(child: Text("Search item", style: Styles.k20Grey(context)));
}
