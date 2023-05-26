import 'package:flutter/material.dart';

//keys for testing
const kAccountIconTabKey = Key('account-icon-tab-key');
const kHomeIconTabKey = Key('home-icon-tab-key');

enum TabItem { home, account }

class TabItemData {
  const TabItemData({required this.label, required this.icon});

  final String label;
  final Widget icon;

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.home: const TabItemData(
        label: 'Home',
        icon: Icon(
          Icons.home,
          size: 25,
          key: kHomeIconTabKey,
        )),
    TabItem.account: const TabItemData(
      label: 'Account',
      icon: Icon(
        Icons.person,
        size: 25,
        key: kAccountIconTabKey,
      ),
    ),
  };
}
