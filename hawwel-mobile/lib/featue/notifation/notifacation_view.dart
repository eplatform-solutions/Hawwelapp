import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/notifation/data/cubit/cubit.dart';
import 'package:usdt/featue/notifation/data/cubit/cubit_stat.dart';
import 'package:usdt/featue/notifation/widjt/notfaction_container.dart';
import 'package:usdt/featue/transfer_execution/stat_paid_mor.dart';
import 'package:usdt/featue/transfer_execution/state_sacssuse.dart';
import 'package:usdt/featue/transfer_execution/state_view.dart';

class Notifation extends StatefulWidget {
  const Notifation({super.key});

  @override
  State<Notifation> createState() => _NotifationState();
}

class _NotifationState extends State<Notifation>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));

    _scrollController = ScrollController();
    context.read<NotificationsCubit>().fetchNotifications();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<NotificationsCubit>().fetchNotifications(loadMore: true);
      }
    });

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Color notificationColor(String? status) {
    final branding = appBrandingNotifier.value;
    switch (status) {
      case 'full-paid':
        return branding.gradientEndColorValue;
      case 'under-paid':
        return branding.divider;
      case 'cancelled':
        return branding.iconPrimary;
      default:
        return branding.divider;
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) {
      return '${AppTranslations.getText(context, 'since')} ${diff.inMinutes} ${AppTranslations.getText(context, 'minutes')}';
    } else if (diff.inHours < 24) {
      return '${AppTranslations.getText(context, 'since')} ${diff.inHours} ${AppTranslations.getText(context, 'hours')}';
    } else {
      return '${AppTranslations.getText(context, 'since')} ${diff.inDays} ${AppTranslations.getText(context, 'days')}';
    }
  }

  String _formatNotificationBody(dynamic notification) {
    String body = notification.body ?? "";
    final data = notification.data;
    if (data == null) return body;
    body = body.replaceAll('{{amount}}', data.amount?.toString() ?? "");
    body = body.replaceAll('{{currencyName}}', data.symbol ?? "");
    body = body.replaceAll('{{address}}', data.address ?? "");
    body = body.replaceAll('{{network}}', data.network ?? "");
    body = body.replaceAll('{{symbol}}', data.symbol ?? "");
    if (body.contains("Amount Deposit")) {
      final bool isArabic =
          Localizations.localeOf(context).languageCode == 'ar';
      if (isArabic) {
        return "تم إيداع ${data.amount}${data.symbol} على شبكة ${data.network} في المحفظة ${data.address}";
      }
    }
    return body;
  }

  void _onNotificationTap(BuildContext context, dynamic notification) {
    HapticFeedback.selectionClick();
    final bool isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    final route = PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, a1, __) {
        if (notification.data?.status == "full-paid") {
          return paidsacssus(
            paid: notification.data!.paid,
            symbol: notification.data!.symbol,
            country: isArabic
                ? notification.data!.areaAr
                : notification.data!.areaEn,
            city: isArabic
                ? notification.data!.cityAr
                : notification.data!.cityEn,
            name: notification.data!.fullName,
          );
        }
        return statepademor(
          symbol: notification.data!.symbol,
          exstaamount: (int.parse(notification.data!.amount) -
                  int.parse(notification.data!.paid))
              .toString(),
        );
      },
      transitionsBuilder: (_, a1, __, child) => FadeTransition(
        opacity: a1,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: a1, curve: Curves.easeOut)),
          child: child,
        ),
      ),
    );
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic =
        Localizations.localeOf(context).languageCode == 'ar';
    final branding = appBrandingNotifier.value;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Gradient App Bar ──────────────────────────────
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 110.h,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isArabic
                            ? Icons.arrow_forward_ios_rounded
                            : Icons.arrow_back_ios_new_rounded,
                        size: 16.sp,
                        color: branding.buttonText,
                      ),
                    ),
                  ),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: branding.buildHeaderGradient(),
                    ),
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.r),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_rounded,
                                  color: branding.buttonText,
                                  size: 24.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                AppTranslations.getText(
                                    context, 'notifications'),
                                style: GoogleFonts.cairo(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: branding.buttonText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── List ──────────────────────────────────────────
                BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) {
                    if (state is NotificationsLoading) {
                      return SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                              color: branding.accent),
                        ),
                      );
                    }

                    if (state is NotificationsFailure) {
                      return SliverFillRemaining(
                        child: _EmptyState(
                          icon: Icons.wifi_off_rounded,
                          message: state.error,
                          branding: branding,
                        ),
                      );
                    }

                    if (state is NotificationsSuccess) {
                      if (state.notifications.isEmpty) {
                        return SliverFillRemaining(
                          child: _EmptyState(
                            icon: Icons.notifications_none_rounded,
                            message: AppTranslations.getText(
                                context, 'no_notifications'),
                            branding: branding,
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // loader at end
                            if (index >= state.notifications.length) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: branding.accent),
                                ),
                              );
                            }

                            final n = state.notifications[index];

                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: Duration(
                                  milliseconds: 300 + (index * 40).clamp(0, 400)),
                              curve: Curves.easeOut,
                              builder: (_, value, child) => Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, (1 - value) * 20),
                                  child: child,
                                ),
                              ),
                              child: NotificationCard(
                                onTap: () =>
                                    _onNotificationTap(context, n),
                                title: AppTranslations.getText(
                                    context, n.title),
                                body: _formatNotificationBody(n),
                                time: _timeAgo(n.createdAt),
                                color: notificationColor(
                                    n.data?.status),
                              ),
                            );
                          },
                          childCount: state.hasMore
                              ? state.notifications.length + 1
                              : state.notifications.length,
                        ),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox());
                  },
                ),

                SliverToBoxAdapter(child: SizedBox(height: 32.h)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Empty / Error state ────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.message,
    required this.branding,
  });
  final IconData icon;
  final String message;
  final AppBrandingConfig branding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: branding.accent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36.sp, color: branding.accent),
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 14.sp,
              color: branding.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}