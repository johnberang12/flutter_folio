import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folio/src/common_widget/app_toast.dart';

import '../../account/presentation/account_screen.dart';
import '../../product/presentation/product_list/product_list_screen.dart';
import 'cupertino_home_scaffold.dart';
import 'tab_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabItem _currentTab = TabItem.home;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.home: (_) => const ProductListScreen(),
      TabItem.account: (_) => const AccountScreen(),
    };
  }

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem]?.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  bool _exit = false;
  Future<bool> onWillPop() async {
    final toast = AppToast();
    if (_exit) {
      if (kIsWeb) {
        return Future.value(false);
      } else {
        await SystemNavigator.pop();
      }
    } else {
      _exit = true;
      toast.showToast(msg: "Tap again to exit");
      Future.delayed(const Duration(milliseconds: 2500), () => _exit = false);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectedTab: _selectTab,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
