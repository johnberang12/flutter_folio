import 'package:flutter/material.dart';
import 'package:flutter_folio/src/constants/sizes.dart';
import 'package:flutter_folio/src/extensions/app_navigator.dart';

import '../../common_widget/primary_button.dart';
import '../../constants/styles.dart';
import '../routing/app_router/app_route.dart';

//button key for widget testing
const kGetStartedButtonKey = Key('get-started-button-key');

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Welcome to', style: Styles.k20Bold(context)),
            gapH16,
            Text('Flutter Folio', style: Styles.k32Bold(context)),
            gapH64,
            const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/my_profile.png')),
            gapH12,
            Text(
              'John Berang',
              style: Styles.k16Bold(context),
            ),
            const Text('Flutter Dev')
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        key: kGetStartedButtonKey,
        padding: const EdgeInsets.only(bottom: Sizes.p32, right: 16, left: 16),
        onPressed: () => context.appGoNamed(AppRoute.signin.name),
        loadingDuration: 3000,
        buttonTitle: "Get started",
      ),
    );
  }
}
