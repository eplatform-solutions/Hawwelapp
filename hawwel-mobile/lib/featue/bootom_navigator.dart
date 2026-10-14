import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/featue/profail/data/cubit/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/welcomyou_screen_view.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/name_saved.dart';
import 'package:hawwel/featue/profail/profail_screen_view.dart';
import 'package:hawwel/featue/transaction_historu/data/cubit/cubit.dart';
import 'package:hawwel/featue/transaction_historu/transaction_haistoru_vew.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _page = 3;
  bool _cover = false;
  DateTime? _lastBackPressed;
  DateTime? _lastTransfersRefreshAt;

  final List<String> icons = [
    'asset/Vector (55).png',
    'asset/Vector (57).png',
    'asset/Vector (58).png',
    'asset/Vector (59).png',
  ];
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pages = [
      const Transactionhistory(),
      Profail(onViewTransactions: goToTransactionHistory),
      const Namesaved(),
      const Welcomyou(),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<Userinfogcubit>().fetchUserInfo();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    _refreshTransfersIfVisible();
  }

  void _refreshTransfersIfVisible({bool force = false}) {
    if (_page != 0) return;
    final now = DateTime.now();
    final recentlyRefreshed = _lastTransfersRefreshAt != null &&
        now.difference(_lastTransfersRefreshAt!) < const Duration(seconds: 2);
    if (!force && recentlyRefreshed) return;
    _lastTransfersRefreshAt = now;
    context.read<TransfersCubit>().fetchTransfers();
  }

  void _switchPage(int newPage) {
    if (newPage == _page) {
      if (newPage == 0) {
        _refreshTransfersIfVisible(force: true);
      }
      return;
    }
    setState(() { _cover = true; });
    Future.microtask(() {
      if (!mounted) return;
      setState(() { _page = newPage; });
      if (newPage == 0) {
        _refreshTransfersIfVisible(force: true);
      }
      Future.delayed(const Duration(milliseconds: 60), () {
        if (!mounted) return;
        setState(() { _cover = false; });
      });
    });
  }

  void goToPage(int visualIndex, bool isArabic) {
    final realIndex = isArabic ? visualIndex : icons.length - 1 - visualIndex;
    _switchPage(realIndex);
  }

  void goToTransactionHistory() => _switchPage(0);

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final branding = appBrandingNotifier.value;

    return SafeArea(
      top: false,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (_page != 3) {
              _switchPage(3);
              return;
            }
            final now = DateTime.now();
            if (_lastBackPressed == null ||
                now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
              _lastBackPressed = now;
              return;
            }
            SystemNavigator.pop();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: branding.screenBg,
            body: Stack(
              children: [
                pages[_page],
                if (_cover)
                  Positioned.fill(
                    child: ColoredBox(color: branding.screenBg),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _FloatingNavBar(
                    icons: icons,
                    currentPage: _page,
                    isArabic: isArabic,
                    onTap: (i) => goToPage(i, isArabic),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final List<String> icons;
  final int currentPage;
  final bool isArabic;
  final void Function(int) onTap;

  const _FloatingNavBar({
    required this.icons,
    required this.currentPage,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final navGrad = branding.buildNavBarGradient();
    final glowColor = branding.gradientStartColorValue;

    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 10),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: glowColor.withValues(alpha: 0.12),
            blurRadius: 60,
            offset: const Offset(0, 20),
            spreadRadius: -8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
            decoration: BoxDecoration(
              gradient: navGrad,
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Row(
              key: ValueKey('nav-$isArabic-$currentPage'),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(icons.length, (i) {
                final displayIndex = isArabic ? i : icons.length - 1 - i;
                final isActive = displayIndex == currentPage;
                return _NavItem(
                  iconPath: icons[displayIndex],
                  isActive: isActive,
                  activeColor: branding.navBarActiveIcon,
                  onTap: () => onTap(i),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String iconPath;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.iconPath,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: isActive ? 60.w : 50.w,
        height: 50.h,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 380),
              curve: Curves.easeOutCubic,
              width: isActive ? 60.w : 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.18)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
            if (isActive)
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: isActive ? 60.w : 50.w,
                    height: 50.h,
                  ),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: isActive ? 1.0 : 0.0),
                  duration: const Duration(milliseconds: 380),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    final scale = 1.0 + (value * 0.2);
                    return Transform.scale(
                      scale: scale,
                      child: Image.asset(
                        iconPath,
                        height: 22.h,
                        width: 22.w,
                        color: Color.lerp(
                          Colors.white.withValues(alpha: 0.5),
                          activeColor,
                          value,
                        ),
                      ),
                    );
                  },
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  margin: EdgeInsets.only(top: isActive ? 5.h : 0),
                  width: isActive ? 5.w : 0,
                  height: isActive ? 5.h : 0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: isActive
                      ? DecoratedBox(
                          decoration: BoxDecoration(
                            color: activeColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: activeColor.withValues(alpha: 0.6),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
