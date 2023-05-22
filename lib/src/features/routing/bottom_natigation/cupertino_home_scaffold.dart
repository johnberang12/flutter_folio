import 'package:flutter/cupertino.dart';

import '../../../constants/sizes.dart';
import 'tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key? key,
    required this.currentTab,
    required this.onSelectedTab,
    required this.widgetBuilders,
    required this.navigatorKeys,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) => CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          height: Sizes.p48,
          iconSize: Sizes.p16,
          items: [
            _buildItem(TabItem.home),
            _buildItem(TabItem.account),
          ],
          onTap: (index) => onSelectedTab(TabItem.values[index]),
        ),
        tabBuilder: (context, index) {
          final item = TabItem.values[index];
          return CupertinoTabView(
            navigatorKey: navigatorKeys[item],
            builder: (context) => widgetBuilders[item]!(context),
          );
        },
      );

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    // final color =
    //     currentTab == tabItem ? AppColors.primaryHue : AppColors.black40;

    return BottomNavigationBarItem(
      icon: itemData!.icon,
      label: itemData.label,
    );
  }
}
