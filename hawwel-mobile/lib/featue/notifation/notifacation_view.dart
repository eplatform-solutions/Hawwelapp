import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/widgets/app_back_button.dart';
import 'package:hawwel/constans/transfer_status_theme.dart';
import 'package:hawwel/featue/notifation/data/cubit/cubit.dart';
import 'package:hawwel/featue/notifation/data/cubit/cubit_stat.dart';
import 'package:hawwel/featue/notifation/notification_navigation.dart';
import 'package:hawwel/featue/notifation/widjt/notfaction_container.dart';

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
    final rawBody = notification.body ?? "";
    String body = AppTranslations.getText(context, rawBody);
    final data = notification.data;
    if (data == null) return body;
    body = body.replaceAll('{{amount}}', data.amount?.toString() ?? "");
    body = body.replaceAll('{{paid}}', data.paid?.toString() ?? "");
    body = body.replaceAll('{{currencyName}}', data.symbol ?? "");
    body = body.replaceAll('{{address}}', data.address ?? "");
    body = body.replaceAll('{{network}}', data.network ?? "");
    body = body.replaceAll('{{symbol}}', data.symbol ?? "");
    if (body.contains('{{reasonClause}}')) {
      final reason = (data.decisionReason ?? '').toString().trim();
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      final reasonClause = reason.isEmpty
          ? ''
          : (isArabic ? ' السبب: $reason.' : ' Reason: $reason.');
      body = body.replaceAll('{{reasonClause}}', reasonClause);
    }
    if (rawBody.contains("external_payment_deposit_notice") ||
        rawBody.contains("Amount deposited")) {
      return AppTranslations.getTextStatic(context, 'notification_deposit_message')
          .replaceAll('{{amount}}', data.amount?.toString() ?? "")
          .replaceAll('{{currencyName}}', data.symbol ?? "")
          .replaceAll('{{address}}', data.address ?? "")
          .replaceAll('{{network}}', data.network ?? "");
    }
    return body;
  }

  void _showTransferNotFoundMessage(BuildContext context) {
    final branding = appBrandingNotifier.value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: branding.iconPrimary,
        content: Text(
          AppTranslations.getText(context, 'notification_order_not_found'),
        ),
      ),
    );
  }

  Future<void> _onNotificationTap(
    BuildContext context,
    dynamic notification,
  ) async {
    HapticFeedback.selectionClick();
    final payload = <String, dynamic>{
      'title': notification.title,
      'body': notification.body,
      'data': {
        'transferId': notification.data?.transferId,
        'status': notification.data?.status,
        // KYC decisions carry a kycId instead of a transferId; without it
        // every KYC notification tap ended in "order not found".
        'kycId': notification.data?.kycId,
        'blockingReason': notification.data?.blockingReason,
        'rejectionReason': notification.data?.rejectionReason,
        'removeVerifyingReason': notification.data?.removeVerifyingReason,
      },
    };
    final opened = await NotificationNavigation.openFromNotificationData(
      context,
      payload,
    );
    if (!opened && context.mounted) {
      _showTransferNotFoundMessage(context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
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
                  leading: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: AppBackButton(),
                  ),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: branding.buildHeaderGradient(),
                    ),
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                          child: Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.notifications_rounded,
                                    color: branding.buttonText,
                                    size: 22.sp,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  AppTranslations.getText(
                                    context,
                                    'notifications',
                                  ),
                                  style: GoogleFonts.cairo(
                                    fontSize: 17.sp,
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
                ),

                // ── List ──────────────────────────────────────────
                BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) {
                    if (state is NotificationsLoading) {
                      return SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: branding.accent,
                          ),
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
                      final notifications = state.notifications;

                      if (notifications.isEmpty) {
                        return SliverFillRemaining(
                          child: _EmptyState(
                            icon: Icons.notifications_none_rounded,
                            message: AppTranslations.getText(
                              context,
                              'no_notifications',
                            ),
                            branding: branding,
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // loader at end
                            if (index >= notifications.length) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: branding.accent,
                                  ),
                                ),
                              );
                            }

                            final n = notifications[index];
                            final visual = resolveNotificationVisual(
                              branding: branding,
                              status: n.data?.status,
                              title: n.title,
                              body: n.body,
                            );

                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: Duration(
                                milliseconds: 300 + (index * 40).clamp(0, 400),
                              ),
                              curve: Curves.easeOut,
                              builder: (_, value, child) => Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, (1 - value) * 20),
                                  child: child,
                                ),
                              ),
                              child: NotificationCard(
                                onTap: () => _onNotificationTap(context, n),
                                title: AppTranslations.getText(
                                  context,
                                  n.title,
                                ),
                                body: _formatNotificationBody(n),
                                time: _timeAgo(n.createdAt),
                                color: visual.accentColor,
                                statusIcon: visual.icon,
                                statusIconColor: visual.iconColor,
                                statusIconBgColor: visual.iconBackground,
                                isRead: n.isRead,
                              ),
                            );
                          },
                          childCount: state.hasMore
                              ? notifications.length + 1
                              : notifications.length,
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
