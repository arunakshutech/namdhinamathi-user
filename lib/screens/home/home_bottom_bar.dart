import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_app/models/app_settings_model.dart';
import 'package:news_app/screens/home/home_view.dart';

// Bottom Tabs
final Map<int, List> homeTabs = {
  1: ['home', FeatherIcons.home],
  2: ['videos', FeatherIcons.playCircle],
  3: ['podcasts', LineIcons.microphone],
  4: ['categories', FeatherIcons.grid],
  5: ['profile', FeatherIcons.user],
};

final navBarIndexProvider = StateProvider<int>((ref) => 0);

class BottomBar extends ConsumerWidget {
  const BottomBar({super.key, required this.settings});

  final AppSettingsModel settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navBarIndexProvider);
    // final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final double osSepciicHeight = 20;
    final double height = kBottomNavigationBarHeight + osSepciicHeight;
    final double letterSpacing = -0.2;

    final tabs = _getTabs(settings);

    return Container(
      height: height,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 0.5, color: Colors.orange))),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 215, 232, 252),
        iconSize: 25,
        elevation: 0,
        currentIndex: currentIndex,
        unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: letterSpacing),
        selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: letterSpacing),
        selectedFontSize: 13,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          ref.read(navBarIndexProvider.notifier).state = index;
          if (_shouldAnimate(currentIndex, index)) {
            ref.read(homeTabControllerProvider.notifier).state.animateToPage(
                index,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeIn);
          } else {
            ref
                .read(homeTabControllerProvider.notifier)
                .state
                .jumpToPage(index);
          }
        },
        items: tabs.entries.map((e) {
          return BottomNavigationBarItem(
            icon: Icon(e.value[1]),
            label: "${e.value[0]}".tr(),
          );
        }).toList(),
      ),
    );
  }

  bool _shouldAnimate(int currentIndex, int newIndex) {
    int dif = currentIndex - newIndex;
    if (dif > 1 || dif < -1) {
      return false;
    } else {
      return true;
    }
  }

  Map<int, List> _getTabs(AppSettingsModel settings) {
    final Map<int, List> tabs = homeTabs;
    bool audioTabEnabled = settings.audioTab ?? false;
    bool videoTabEnabled = settings.videoTab ?? false;

    if (!audioTabEnabled && !videoTabEnabled) {
      tabs.remove(2);
      tabs.remove(3);
    } else if (!videoTabEnabled) {
      tabs.remove(2);
    } else if (!audioTabEnabled) {
      tabs.remove(3);
    }

    return tabs;
  }
}
