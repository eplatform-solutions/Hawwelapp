import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/constans/localization/lang_cubit.dart';
import 'package:usdt/featue/auth/login/login_screen_view.dart';
import 'package:usdt/featue/notifation/data/cubit/cubit.dart';
import 'package:usdt/featue/notifation/data/cubit/cubit_mark.dart';
import 'package:usdt/featue/notifation/data/cubit/cubit_marke_stat.dart';
import 'package:usdt/featue/notifation/data/cubit/cubit_stat.dart';
import 'package:usdt/featue/notifation/notifacation_view.dart';

class notfactionicon extends StatelessWidget {
  const notfactionicon({super.key});

  void _showBlockedDialog(BuildContext context, String message) {
    final branding = appBrandingNotifier.value;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            AppTranslations.getText(context, "blocked_alert_title"),
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(color: branding.error, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(fontSize: 15),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: branding.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Loginview()),
                  (route) => false,
                ),
                child: Text(
                  AppTranslations.getText(context, "logout"),
                  style: GoogleFonts.cairo(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;

    return MultiBlocListener(
      listeners: [
        BlocListener<MarkAllReadCubit, MarkAllReadState>(
          listener: (context, state) {
            if (state is MarkAllReadFailure &&
                (state.error.contains("حظرك") || state.error.contains("401"))) {
              _showBlockedDialog(context, state.error);
            }
          },
        ),
        BlocListener<NotificationsCubit, NotificationsState>(
          listener: (context, state) {
            if (state is NotificationsFailure &&
                (state.error.contains("حظرك") || state.error.contains("401"))) {
              _showBlockedDialog(context, state.error);
            }
          },
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Language toggle ──────────────────────────────────────────
          BlocBuilder<LanguageCubit, Language>(
            builder: (context, langState) {
              final isAr = langState == Language.arabic;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.read<LanguageCubit>().toggleLanguage();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  height: 36.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isAr ? '🇸🇦' : '🇺🇸',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(width: 5.w),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          isAr ? 'AR' : 'EN',
                          key: ValueKey(langState),
                          style: GoogleFonts.cairo(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: branding.buttonText,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(width: 10.w),

          // ── Notification bell ────────────────────────────────────────
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              final unread = state is NotificationsSuccess ? state.unreadCount : 0;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.read<MarkAllReadCubit>().markAllRead();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, a1, __) => const Notifation(),
                      transitionsBuilder: (_, a1, __, child) => FadeTransition(
                        opacity: a1,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 36.h,
                  width: 36.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        unread > 0
                            ? Icons.notifications_rounded
                            : Icons.notifications_none_rounded,
                        size: 20.sp,
                        color: branding.buttonText,
                      ),
                      if (unread > 0)
                        Positioned(
                          top: 4.h,
                          right: 4.w,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            constraints: BoxConstraints(
                              minWidth: 14.w,
                              minHeight: 14.h,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            decoration: BoxDecoration(
                              color: branding.error,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.6),
                                width: 1.2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                unread > 99 ? '99+' : '$unread',
                                style: GoogleFonts.cairo(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}