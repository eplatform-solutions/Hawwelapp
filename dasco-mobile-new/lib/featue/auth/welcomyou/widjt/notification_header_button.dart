import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/featue/auth/login/login_screen_view.dart';
import 'package:hawwel/featue/notifation/data/cubit/cubit.dart';
import 'package:hawwel/featue/notifation/data/cubit/cubit_mark.dart';
import 'package:hawwel/featue/notifation/data/cubit/cubit_marke_stat.dart';
import 'package:hawwel/featue/notifation/data/cubit/cubit_stat.dart';
import 'package:hawwel/featue/notifation/notifacation_view.dart';

class NotificationHeaderButton extends StatelessWidget {
  const NotificationHeaderButton({
    super.key,
    this.requireAuth = false,
  });

  /// When true, tapping opens login instead of notifications.
  final bool requireAuth;

  void _showBlockedDialog(BuildContext context, String message) {
    final branding = appBrandingNotifier.value;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            AppTranslations.getText(context, 'blocked_alert_title'),
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              color: branding.error,
              fontWeight: FontWeight.bold,
            ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Loginview()),
                  (route) => false,
                ),
                child: Text(
                  AppTranslations.getText(context, 'logout'),
                  style: GoogleFonts.cairo(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    HapticFeedback.selectionClick();
    if (requireAuth) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Loginview()),
      );
      return;
    }
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
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;

    return MultiBlocListener(
      listeners: [
        BlocListener<MarkAllReadCubit, MarkAllReadState>(
          listener: (context, state) {
            if (state is MarkAllReadFailure &&
                (state.error.contains('حظرك') || state.error.contains('401'))) {
              _showBlockedDialog(context, state.error);
            }
          },
        ),
        BlocListener<NotificationsCubit, NotificationsState>(
          listener: (context, state) {
            if (state is NotificationsFailure &&
                (state.error.contains('حظرك') || state.error.contains('401'))) {
              _showBlockedDialog(context, state.error);
            }
          },
        ),
      ],
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final unread = state is NotificationsSuccess ? state.unreadCount : 0;
          return GestureDetector(
            onTap: () => _onTap(context),
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
                  if (unread > 0 && !requireAuth)
                    Positioned(
                      top: 4.h,
                      right: 4.w,
                      child: Container(
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
    );
  }
}
