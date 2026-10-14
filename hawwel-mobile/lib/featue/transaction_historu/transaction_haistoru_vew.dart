import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/constans/localization/lang_cubit.dart';
import 'package:usdt/constans/localization/langhelper.dart';
import 'package:usdt/featue/transaction_historu/data/cubit/cubit.dart';
import 'package:usdt/featue/transaction_historu/data/cubit/cubit_state.dart';
import 'package:usdt/featue/transaction_historu/widjt/detals_osta.dart';
import 'package:stylish_pull_to_refresh/stylish_pull_to_refresh.dart';
import 'package:usdt/constans/app_branding.dart';

class Transactionhistory extends StatefulWidget {
  const Transactionhistory({super.key});

  @override
  State<Transactionhistory> createState() => _TransactionhistoryState();
}

class _TransactionhistoryState extends State<Transactionhistory> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<TransfersCubit>().fetchTransfers();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<TransfersCubit>().fetchTransfers(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic =
        context.watch<LanguageCubit>().state == Language.arabic;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: Column(
          children: [
            // â”€â”€ Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            _buildHeader(context, branding, isArabic),

            // â”€â”€ Body â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Expanded(
              child: BlocBuilder<TransfersCubit, TransfersState>(
                builder: (context, state) {
                  // Loading shimmer
                  if (state is TransfersLoading &&
                      context.read<TransfersCubit>().allData.isEmpty) {
                    return _buildShimmer(branding);
                  }

                  // Error
                  if (state is TransfersFailure) {
                    return _buildError(context, branding, state.error);
                  }

                  // Success
                  if (state is TransfersSuccess) {
                    final data = state.data;

                    if (data.isEmpty) {
                      return _buildEmpty(context, branding, isArabic);
                    }

                    return StylishPullToRefresh(
                      style: Style.paperPlane,
                      color: branding.screenBg,
                      size: 100,
                      onRefresh: () async {
                        await context.read<TransfersCubit>().fetchTransfers();
                      },
                      child: ListView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
                        children: [
                          ...data.map(
                            (group) => _buildDateGroup(
                              context,
                              branding,
                              isArabic,
                              group,
                            ),
                          ),

                          // Pagination
                          if (state.hasMore)
                            _buildPaginationShimmer(branding)
                          else
                            Padding(
                              padding: EdgeInsets.only(top: 20.h, bottom: 8.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40.w,
                                    height: 1,
                                    color: branding.hintText.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                    ),
                                    child: Text(
                                      AppTranslations.getText(
                                        context,
                                        'no_more_results',
                                      ),
                                      style: GoogleFonts.cairo(
                                        fontSize: 13.sp,
                                        color: branding.hintText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 40.w,
                                    height: 1,
                                    color: branding.hintText.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Header
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildHeader(BuildContext context, dynamic branding, bool isArabic) {
    return Container(
      decoration: BoxDecoration(
        gradient: branding.buildHeaderGradient(),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: branding.badge.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                children: [
                  Container(
                    width: 38.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: branding.buttonText.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: branding.buttonText,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    AppTranslations.getText(context, "Transaction"),
                    style: GoogleFonts.cairo(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: branding.buttonText,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                AppTranslations.getText(
                  context,
                  'Transfers via intermediaries',
                ),
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: branding.buttonText.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Date Group
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildDateGroup(
    BuildContext context,
    dynamic branding,
    bool isArabic,
    dynamic group,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        // Date label pill
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: branding.badge.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: branding.badge.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 12,
                color: branding.badge,
              ),
              SizedBox(width: 6.w),
              Text(
                group.date,
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: branding.badge,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        // Cards
        ...group.transfers.map<Widget>((transfer) {
          final currency = transfer.symbol;
          final imagePath = currency == 'USDC'
              ? AppImages.usdt
              : AppImages.usdc;
          final paymentMethodName = transfer.paymentMethod is String
              ? transfer.paymentMethod
              : LangHelper.isArabic(context)
              ? transfer.paymentMethod.nameAr
              : transfer.paymentMethod.nameEn;

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _TransactionCard(
              transfer: transfer,
              currency: currency,
              imagePath: imagePath,
              paymentMethodName: paymentMethodName,
              isArabic: isArabic,
              branding: branding,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Detalestranzationosta(
                      fee: transfer.fee.toString(),
                      total: transfer.amount.toString(),
                      transferamount:
                          "${(transfer.amount - (transfer.amount * transfer.fee / 100)).toStringAsFixed(2)}",
                      stat: transfer.status,
                      Area: LangHelper.isArabic(context)
                          ? transfer.areaAr
                          : transfer.areaEn,
                      City: LangHelper.isArabic(context)
                          ? transfer.cityAr
                          : transfer.cityEn,
                      currency: currency,
                      amount: transfer.amount,
                      isReceived: false,
                      senderName: transfer.receiver.fullName,
                      senderPhone: transfer.receiver.mobilePhone,
                      receiverName: transfer.receiver.fullName,
                      receiverPhone: transfer.receiver.mobilePhone,
                      paymentMethodName: LangHelper.isArabic(context)
                          ? transfer.paymentMethod.nameAr
                          : transfer.paymentMethod.nameEn,
                      paymentMethodLogo: transfer.paymentMethod.logoPath,
                      createdAt: _formatDate(transfer.createdAt.toString()),
                      transferNumber: transfer.transferNumber.toString(),
                      paymentProofNote: transfer.paymentProofNote,
                      paymentProofImagePath: transfer.paymentProofImagePath,
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Shimmer â€“ initial load
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildShimmer(dynamic branding) {
    return Shimmer.fromColors(
      baseColor: branding.inputBorder,
      highlightColor: branding.screenBg,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 32.h),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.only(bottom: 14.h),
          child: _ShimmerCard(branding: branding),
        ),
      ),
    );
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Shimmer â€“ pagination
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildPaginationShimmer(dynamic branding) {
    return Shimmer.fromColors(
      baseColor: branding.inputBorder,
      highlightColor: branding.screenBg,
      child: Column(
        children: List.generate(
          2,
          (_) => Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: _ShimmerCard(branding: branding),
          ),
        ),
      ),
    );
  }

  // Empty state
  Widget _buildEmpty(BuildContext context, dynamic branding, bool isArabic) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: branding.badge.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 36,
              color: branding.badge.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            isArabic ? 'لا توجد طلبات' : 'No transactions yet',
            style: GoogleFonts.cairo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: branding.hintText,
            ),
          ),
        ],
      ),
    );
  }

  // Error state
  Widget _buildError(BuildContext context, dynamic branding, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: branding.error.withValues(alpha: 0.08),
                border: Border.all(
                  color: branding.error.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 38,
                color: branding.error.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 14.sp,
                color: branding.secondaryText,
                height: 1.6,
              ),
            ),
            SizedBox(height: 22.h),
            GestureDetector(
              onTap: () => context.read<TransfersCubit>().fetchTransfers(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(
                    color: branding.iconPrimary.withValues(alpha: 0.5),
                  ),
                  color: branding.iconPrimary.withValues(alpha: 0.07),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      size: 18,
                      color: branding.iconPrimary,
                    ),
                    SizedBox(width: 7.w),
                    Text(
                      AppTranslations.getText(context, 'retry'),
                      style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: branding.iconPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso);
      return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')} '
          '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
// Transaction Card
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class _TransactionCard extends StatelessWidget {
  final dynamic transfer;
  final String currency;
  final String imagePath;
  final String paymentMethodName;
  final bool isArabic;
  final dynamic branding;
  final VoidCallback onTap;

  const _TransactionCard({
    required this.transfer,
    required this.currency,
    required this.imagePath,
    required this.paymentMethodName,
    required this.isArabic,
    required this.branding,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(transfer.status, branding);
    final statusLabel = AppTranslations.transferStatusLabel(
      context,
      transfer.status,
    );
    final netAmount = (transfer.amount - (transfer.amount * transfer.fee / 100))
        .toStringAsFixed(2);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: branding.cardBg,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: branding.badge.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: branding.cardBorder.withValues(alpha: 0.6),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              children: [
                // â”€â”€ Top row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon + currency badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 48.r,
                          height: 48.r,
                          decoration: BoxDecoration(
                            gradient: branding.buildHeaderGradient(),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          right: -4,
                          child: Container(
                            width: 20.r,
                            height: 20.r,
                            decoration: BoxDecoration(
                              color: branding.screenBg,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: branding.cardBorder,
                                width: 1.5,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(imagePath, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 12.w),

                    // Name + via
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transfer.receiver.fullName,
                            style: GoogleFonts.cairo(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: branding.primaryText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              Icon(
                                Icons.swap_horiz_rounded,
                                size: 13,
                                color: branding.hintText,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                paymentMethodName,
                                style: GoogleFonts.cairo(
                                  fontSize: 12.sp,
                                  color: branding.hintText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Amount column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '-${transfer.amount} $currency',
                          style: GoogleFonts.cairo(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: branding.iconPrimary,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          '\$$netAmount',
                          style: GoogleFonts.cairo(
                            fontSize: 12.sp,
                            color: branding.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // â”€â”€ Divider â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                Container(
                  height: 1,
                  color: branding.cardBorder.withValues(alpha: 0.4),
                ),

                SizedBox(height: 10.h),

                // â”€â”€ Bottom row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                Row(
                  children: [
                    // Transfer number
                    Icon(Icons.tag_rounded, size: 13, color: branding.hintText),
                    SizedBox(width: 4.w),
                    Text(
                      '#${transfer.transferNumber}',
                      style: GoogleFonts.cairo(
                        fontSize: 12.sp,
                        color: branding.hintText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Spacer(),

                    // Status badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            statusLabel,
                            style: GoogleFonts.cairo(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8.w),

                    // Arrow
                    Icon(
                      isArabic
                          ? Icons.arrow_back_ios_new_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: branding.hintText.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status, dynamic branding) {
    switch (status.trim().toLowerCase()) {
      case 'full-paid':
      case 'compleated':
      case 'completed':
      case 'received':
      case 'is-received':
      case 'is_received':
        return branding.success;
      case 'partial-paid':
      case 'under-paid':
        return const Color(0xFF2196F3);
      case 'preparing-address':
      case 'preparing_address':
      case 'address-preparing':
      case 'pending':
      case 'can-receive':
      case 'can_receive':
      case 'ready-to-receive':
      case 'ready_to_receive':
        return const Color(0xFFFFA726);
      case 'rejected':
      case 'cancelled':
        return branding.error;
      default:
        return branding.hintText;
    }
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
// Shimmer Card Skeleton
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class _ShimmerCard extends StatelessWidget {
  final dynamic branding;
  const _ShimmerCard({required this.branding});

  @override
  Widget build(BuildContext context) {
    final base = branding.inputBorder;
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon placeholder
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              SizedBox(width: 12.w),
              // Text lines
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14.h,
                      width: 130.w,
                      decoration: BoxDecoration(
                        color: base,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 11.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        color: base,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
              ),
              // Amount placeholder
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 14.h,
                    width: 70.w,
                    decoration: BoxDecoration(
                      color: base,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 11.h,
                    width: 45.w,
                    decoration: BoxDecoration(
                      color: base,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 1, color: base),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 11.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              Container(
                height: 22.h,
                width: 70.w,
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
