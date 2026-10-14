import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stylish_pull_to_refresh/stylish_pull_to_refresh.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/country_defaults_helper.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit/cubit_stat.dart';
import 'package:hawwel/constans/falidator.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/style.dart';
import 'package:hawwel/featue/auth/login/widjt/snack_bara.dart';
import 'package:hawwel/featue/auth/login/widjt/textfildlogin.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/cubit/cubit.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/cubit/cubit_stat.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/data_edit_information/cubit/cubit.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/data_edit_information/cubit/cubit_state.dart';
import 'package:hawwel/featue/sender_information/data/repo/cubit/cubit.dart';
import 'package:hawwel/featue/sender_information/data/repo/cubit/cubit_state.dart';

class Namesaved extends StatefulWidget {
  const Namesaved({super.key});

  @override
  State<Namesaved> createState() => _NamesavedState();
}

class _NamesavedState extends State<Namesaved> {
  final TextEditingController search = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late Country selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = CountryDefaultsHelper.defaultPhonePickerCountry();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncPhoneCountryFromApi());
    context.read<ReceiversDisplayCubit>().getAllReceiversDisplay();
  }

  void _syncPhoneCountryFromApi() {
    if (!mounted) return;
    final countriesState = context.read<CountriesCubit>().state;
    if (countriesState is! CountriesSuccess) return;
    final synced = CountryDefaultsHelper.defaultPhonePickerCountry(
      preferredApiCountryCode: countriesState.selected.code,
    );
    if (selectedCountry.countryCode == synced.countryCode) return;
    setState(() => selectedCountry = synced);
  }

  String buildFullPhoneNumber({
    required String phone,
    required Country country,
  }) {
    return buildPhoneNumberWithCountryCode(
      phone: phone,
      phoneCode: country.phoneCode,
    );
  }

  // ─── Country Picker ────────────────────────────────────────────────────────
  void _showCountryPicker(BuildContext context, [StateSetter? setParent]) {
    final branding = appBrandingNotifier.value;
    final List<Country> all = CountryService().getAll();
    List<Country> filtered = List.from(all);
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: branding.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          return SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.8,
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Container(
                  width: 40.w,
                  height: 4,
                  decoration: BoxDecoration(
                    color: branding.hintText.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                    decoration: InputDecoration(
                      hintText: AppTranslations.getText(ctx, 'search_country'),
                      prefixIcon: const Icon(Icons.search_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    onChanged: (val) {
                      setSheet(() {
                        filtered = all.where((c) {
                          final name =
                              CountryDefaultsHelper.localizedCountryName(
                                ctx,
                                c.countryCode,
                                fallback: c.name,
                              );
                          return name.toLowerCase().contains(
                                val.toLowerCase(),
                              ) ||
                              c.phoneCode.contains(val);
                        }).toList();
                      });
                    },
                  ),
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final c = filtered[i];
                      final name =
                          CountryDefaultsHelper.localizedCountryName(
                            ctx,
                            c.countryCode,
                            fallback: c.name,
                          );
                      return ListTile(
                        leading: CountryDefaultsHelper.countryFlag(
                          c.countryCode,
                          size: 22,
                        ),
                        title: Text(
                          name,
                          style: GoogleFonts.cairo(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Text(
                          '+${c.phoneCode}',
                          textDirection: TextDirection.ltr,
                          style: GoogleFonts.cairo(
                            color: branding.hintText,
                            fontSize: 13.sp,
                          ),
                        ),
                        onTap: () {
                          if (setParent != null) {
                            setParent(() => selectedCountry = c);
                          } else {
                            setState(() => selectedCountry = c);
                          }
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Edit Dialog ───────────────────────────────────────────────────────────
  void _showEditDialog(BuildContext context, dynamic receiver) {
    final branding = appBrandingNotifier.value;
    final cubit = context.read<UpdateReceiverCubit>();
    final List<Country> all = CountryService().getAll();
    String fullPhone = (receiver.mobilePhone ?? '')
        .replaceAll('+', '')
        .replaceAll(' ', '');
    final sorted = List<Country>.from(all)
      ..sort((a, b) => b.phoneCode.length.compareTo(a.phoneCode.length));

    Country? detected;
    for (final c in sorted) {
      if (fullPhone.startsWith(c.phoneCode)) {
        detected = c;
        cubit.phoneController.text = fullPhone.substring(c.phoneCode.length);
        break;
      }
    }
    if (detected != null) {
      setState(() => selectedCountry = detected!);
    } else {
      cubit.phoneController.text = fullPhone;
    }
    cubit.nameController.text = receiver.fullName ?? '';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          backgroundColor: branding.screenBg,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            AppTranslations.getText(ctx, 'edit name'),
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldCustom(
                  controller: cubit.nameController,
                  hintText: AppTranslations.getText(ctx, 'full_name'),
                  type: TextInputType.text,
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showCountryPicker(ctx, setDialog),
                      child: Container(
                        height: 50.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: branding.inputBorder,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: branding.iconPrimary.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CountryDefaultsHelper.countryFlag(
                              selectedCountry.countryCode,
                              size: 18.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '+${selectedCountry.phoneCode}',
                              textDirection: TextDirection.ltr,
                              style: GoogleFonts.cairo(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: branding.primaryText,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: branding.hintText,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextFieldCustom(
                        controller: cubit.phoneController,
                        hintText: AppTranslations.getText(ctx, 'phone_number'),
                        type: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                AppTranslations.getText(ctx, 'cancel'),
                style: GoogleFonts.cairo(
                  color: branding.hintText,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(
              width: 110.w,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: branding.iconPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onPressed: () async {
                  final isValid = await validatePhoneWithCountry(
                    phone: cubit.phoneController.text,
                    countryCode: selectedCountry.countryCode,
                  );
                  if (!dialogCtx.mounted) return;
                  if (!isValid) return;
                  final full = buildFullPhoneNumber(
                    phone: cubit.phoneController.text,
                    country: selectedCountry,
                  );
                  cubit.updateReceiverData(
                    receiver.id.toString(),
                    mobilePhone: full,
                  );
                  Navigator.pop(dialogCtx);
                },
                child: Text(
                  AppTranslations.getText(ctx, 'save'),
                  style: GoogleFonts.cairo(
                    color: branding.buttonText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Delete Dialog ─────────────────────────────────────────────────────────
  void _showDeleteDialog(BuildContext context, dynamic r, bool isArabic) {
    final branding = appBrandingNotifier.value;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: child,
        ),
      ),
      pageBuilder: (dlg, _, __) => StatefulBuilder(
        builder: (ctx, setDlg) {
          bool isLoading = false;
          return AlertDialog(
            backgroundColor: branding.screenBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            contentPadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
            content: StatefulBuilder(
              builder: (ctx2, setDlg2) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56.r,
                      height: 56.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: branding.error.withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: branding.error,
                        size: 28,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      isArabic ? 'تأكيد الحذف' : 'Confirm Delete',
                      style: GoogleFonts.cairo(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: branding.primaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      isArabic
                          ? 'هل أنت متأكد من رغبتك في حذف هذا المستلم؟'
                          : 'Are you sure you want to delete this receiver?',
                      style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        color: branding.secondaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 22.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: isLoading ? null : () => Navigator.pop(dlg),
                            child: Container(
                              height: 44.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: branding.hintText.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                                color: branding.inputBorder.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  isArabic ? 'إلغاء' : 'Cancel',
                                  style: GoogleFonts.cairo(
                                    fontSize: 14.sp,
                                    color: branding.hintText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: isLoading
                                ? null
                                : () async {
                                    setDlg2(() => isLoading = true);
                                    final nav = Navigator.of(dlg);
                                    await context
                                        .read<UpdateReceiverCubit>()
                                        .deleteReceiverData(r.id.toString());
                                    if (!mounted) return;
                                    nav.pop();
                                  },
                            child: Container(
                              height: 44.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: isLoading
                                    ? branding.error.withValues(alpha: 0.6)
                                    : branding.error,
                              ),
                              child: Center(
                                child: isLoading
                                    ? SizedBox(
                                        width: 20.r,
                                        height: 20.r,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        isArabic ? 'حذف' : 'Delete',
                                        style: GoogleFonts.cairo(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ─── Shimmer ───────────────────────────────────────────────────────────────
  Widget _buildShimmerList(dynamic branding) {
    return Shimmer.fromColors(
      baseColor: branding.inputBorder,
      highlightColor: branding.screenBg,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 5,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, __) => _ShimmerReceiverCard(branding: branding),
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: BlocConsumer<ReceiversCubit, ReceiversState>(
        listener: (context, state) {
          if (state is ReceiversSuccess) {
            _snack(
              context,
              branding.success,
              state.message,
              AppImages.doneimage,
            );
            context.read<ReceiversDisplayCubit>().getAllReceiversDisplay();
          } else if (state is ReceiversFailure) {
            _snack(
              context,
              branding.iconPrimary,
              state.error,
              AppImages.eerorrimage,
            );
          }
        },
        builder: (context, addState) {
          return Scaffold(
            backgroundColor: branding.screenBg,
            body: Column(
              children: [
                // ── Header ───────────────────────────────────
                _buildHeader(context, branding, isArabic),

                // ── Body ─────────────────────────────────────
                Expanded(
                  child: StylishPullToRefresh(
                    style: Style.audioWave,
                    size: 100,
                    onRefresh: () async {
                      await context
                          .read<ReceiversDisplayCubit>()
                          .getAllReceiversDisplay();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: EdgeInsets.only(
                        left: 18.w,
                        right: 18.w,
                        top: 20.h,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 32.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search
                          _buildSearchField(context, branding, isArabic),
                          SizedBox(height: 20.h),

                          // Receivers list
                          BlocListener<
                            UpdateReceiverCubit,
                            UpdateReceiverState
                          >(
                            listener: (ctx, state) {
                              if (state is UpdateReceiverSuccess) {
                                _snack(
                                  ctx,
                                  branding.success,
                                  state.message,
                                  AppImages.doneimage,
                                );
                                ctx
                                    .read<ReceiversDisplayCubit>()
                                    .getAllReceiversDisplay();
                              } else if (state is UpdateReceiverFailure) {
                                _snack(
                                  ctx,
                                  branding.iconPrimary,
                                  state.error,
                                  AppImages.eerorrimage,
                                );
                              }
                            },
                            child:
                                BlocBuilder<
                                  ReceiversDisplayCubit,
                                  ReceiversDisplayState
                                >(
                                  builder: (ctx, state) {
                                    if (state is ReceiversDisplayLoading) {
                                      return _buildShimmerList(branding);
                                    }
                                    if (state is ReceiversDisplayFailure) {
                                      return _buildError(branding, state.error);
                                    }
                                    if (state is ReceiversDisplaySuccess) {
                                      final list = state.receivers;
                                      if (list.isEmpty) {
                                        return _buildEmpty(
                                          context,
                                          branding,
                                          isArabic,
                                        );
                                      }
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemCount: list.length,
                                        separatorBuilder: (_, __) =>
                                            SizedBox(height: 12.h),
                                        itemBuilder: (ctx, i) {
                                          final r = list[i];
                                          final trimmed = r.fullName.trim();
                                          final initials = trimmed
                                              .split(' ')
                                              .take(2)
                                              .map(
                                                (w) => w.isNotEmpty
                                                    ? w[0].toUpperCase()
                                                    : '',
                                              )
                                              .join();

                                          return _ReceiverCard(
                                            branding: branding,
                                            isArabic: isArabic,
                                            initials: initials,
                                            fullName: r.fullName,
                                            phone: r.mobilePhone,
                                            onEdit: () =>
                                                _showEditDialog(context, r),
                                            onDelete: () => _showDeleteDialog(
                                              context,
                                              r,
                                              isArabic,
                                            ),
                                          );
                                        },
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                          ),

                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────
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
          child: Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: branding.buttonText.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bookmarks_rounded,
                  color: branding.buttonText,
                  size: 20,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTranslations.getText(context, 'Saved names'),
                      style: GoogleFonts.cairo(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w700,
                        color: branding.buttonText,
                      ),
                    ),
                    Text(
                      AppTranslations.getText(context, 'saved_receivers'),
                      style: GoogleFonts.cairo(
                        fontSize: 12.sp,
                        color: branding.buttonText.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // ── زر إضافة ──────────────────────────────────
              GestureDetector(
                onTap: () => _showAddDialog(context, branding, isArabic),
                child: Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: branding.buttonText.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: branding.buttonText.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: branding.buttonText,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Search ────────────────────────────────────────────────────────────────
  Widget _buildSearchField(
    BuildContext context,
    dynamic branding,
    bool isArabic,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: branding.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: branding.iconPrimary.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: branding.badge.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFieldCustom(
        controller: search,
        validator: (_) => null,
        hintText: AppTranslations.getText(context, 'search'),
        type: TextInputType.text,
        hintStyle: AppStyle.meduim16grey,
        onChanged: (val) =>
            context.read<ReceiversDisplayCubit>().filterReceivers(val),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: branding.hintText,
          size: 20,
        ),
      ),
    );
  }

  // ─── Add Dialog ────────────────────────────────────────────────────────────
  void _showAddDialog(BuildContext context, dynamic branding, bool isArabic) {
    // مسح الحقول عند الفتح
    context.read<ReceiversCubit>().fullNameController.clear();
    context.read<ReceiversCubit>().mobilePhoneController.clear();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 380),
      transitionBuilder: (_, anim, __, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeIn),
          child: ScaleTransition(scale: curved, child: child),
        );
      },
      pageBuilder: (dialogCtx, _, __) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          backgroundColor: branding.screenBg,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.r),
          ),
          // ── العنوان ────────────────────────────────────────
          title: Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  gradient: branding.buildHeaderGradient(),
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: const Icon(
                  Icons.person_add_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                AppTranslations.getText(ctx, 'add_new_recipient'),
                style: GoogleFonts.cairo(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: branding.primaryText,
                ),
              ),
            ],
          ),
          // ── المحتوى ────────────────────────────────────────
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 4.h),
                  // حقل الاسم
                  TextFieldCustom(
                    validator: (v) => validateFullName(v, ctx),
                    controller: ctx.read<ReceiversCubit>().fullNameController,
                    hintText: AppTranslations.getText(ctx, 'name'),
                    type: TextInputType.name,
                    hintStyle: AppStyle.meduim16grey,
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: branding.iconPrimary,
                      size: 18,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // الهاتف + الدولة
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showCountryPicker(ctx, setDialog),
                        child: Container(
                          height: 50.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: branding.inputBorder,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: branding.iconPrimary.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CountryDefaultsHelper.countryFlag(
                                selectedCountry.countryCode,
                                size: 16.sp,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                '+${selectedCountry.phoneCode}',
                                textDirection: TextDirection.ltr,
                                style: GoogleFonts.cairo(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: branding.primaryText,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                size: 18,
                                color: branding.hintText,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextFieldCustom(
                          validator: (v) => validatePhoneNumber(v, ctx),
                          controller: ctx
                              .read<ReceiversCubit>()
                              .mobilePhoneController,
                          hintText: AppTranslations.getText(
                            ctx,
                            'phone_number1',
                          ),
                          type: TextInputType.phone,
                          hintStyle: AppStyle.meduim16grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
          // ── الأزرار ────────────────────────────────────────
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                AppTranslations.getText(ctx, 'cancel'),
                style: GoogleFonts.cairo(
                  color: branding.hintText,
                  fontSize: 14.sp,
                ),
              ),
            ),
            BlocBuilder<ReceiversCubit, ReceiversState>(
              builder: (ctx, addState) => SizedBox(
                width: 110.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final rawPhone = ctx
                        .read<ReceiversCubit>()
                        .mobilePhoneController
                        .text;
                    final invalidMsg = AppTranslations.getTextStatic(
                      ctx,
                      'mobile_number_invalid',
                    );
                    final existsMsg = AppTranslations.getTextStatic(
                      ctx,
                      'phone_already_exists',
                    );
                    final displayState = ctx
                        .read<ReceiversDisplayCubit>()
                        .state;
                    final receiversCubit = ctx.read<ReceiversCubit>();
                    final br = appBrandingNotifier.value;

                    final dialogNavigator = Navigator.of(dialogCtx);

                    final isValid = await validatePhoneWithCountry(
                      phone: rawPhone,
                      countryCode: selectedCountry.countryCode,
                    );
                    if (!mounted) return;

                    if (!isValid) {
                      dialogNavigator.pop();
                      _snack(
                        this.context,
                        br.iconPrimary,
                        invalidMsg,
                        AppImages.eerorrimage,
                      );
                      return;
                    }

                    final full = buildFullPhoneNumber(
                      phone: rawPhone,
                      country: selectedCountry,
                    );

                    if (displayState is ReceiversDisplaySuccess) {
                      if (displayState.receivers.any(
                        (r) => r.mobilePhone == full,
                      )) {
                        dialogNavigator.pop();
                        _snack(
                          this.context,
                          br.iconPrimary,
                          existsMsg,
                          AppImages.eerorrimage,
                        );
                        return;
                      }
                    }

                    receiversCubit.addReceiver(mobilePhone: full);
                    receiversCubit.fullNameController.clear();
                    receiversCubit.mobilePhoneController.clear();
                    dialogNavigator.pop();
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: branding.buildHeaderGradient(),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Container(
                      height: 42.h,
                      alignment: Alignment.center,
                      child: addState is ReceiversLoading
                          ? SizedBox(
                              width: 18.r,
                              height: 18.r,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: branding.buttonText,
                              ),
                            )
                          : Text(
                              AppTranslations.getText(ctx, 'add_receiver'),
                              style: GoogleFonts.cairo(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: branding.buttonText,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Empty & Error states ──────────────────────────────────────────────────
  Widget _buildEmpty(BuildContext context, dynamic branding, bool isArabic) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon container ───────────────────────────────
            Container(
              width: 110.r,
              height: 110.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    branding.iconPrimary.withValues(alpha: 0.12),
                    branding.badge.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: branding.iconPrimary.withValues(alpha: 0.18),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.people_outline_rounded,
                size: 46,
                color: branding.iconPrimary.withValues(alpha: 0.6),
              ),
            ),

            SizedBox(height: 24.h),

            // ── Title ────────────────────────────────────────
            Text(
              isArabic ? 'لا يوجد مستلمون محفوظون' : 'No saved receivers yet',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: branding.primaryText,
              ),
            ),

            SizedBox(height: 10.h),

            // ── Subtitle ─────────────────────────────────────
            Text(
              isArabic
                  ? 'يمكنك إضافة مستلمين بسهولة\nبالضغط على زر + في الأعلى'
                  : 'You can add receivers easily\nby tapping the + button above',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 13.sp,
                color: branding.secondaryText,
                height: 1.7,
              ),
            ),

            SizedBox(height: 28.h),

            // ── CTA button ───────────────────────────────────
            GestureDetector(
              onTap: () => _showAddDialog(context, branding, isArabic),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 13.h),
                decoration: BoxDecoration(
                  gradient: branding.buildHeaderGradient(),
                  borderRadius: BorderRadius.circular(50.r),
                  boxShadow: [
                    BoxShadow(
                      color: branding.iconPrimary.withValues(alpha: 0.28),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      color: branding.buttonText,
                      size: 20,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      isArabic ? 'إضافة مستلم' : 'Add Receiver',
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: branding.buttonText,
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

  Widget _buildError(dynamic branding, String error) {
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
              onTap: () => context
                  .read<ReceiversDisplayCubit>()
                  .getAllReceiversDisplay(),
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

  void _snack(BuildContext context, Color bg, String msg, String img) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        content: CustomSnackBar(
          backgroundColor: bg,
          message: msg,
          imagePath: img,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Receiver Card
// ═══════════════════════════════════════════════════════════════════════════
class _ReceiverCard extends StatelessWidget {
  final dynamic branding;
  final bool isArabic;
  final String initials;
  final String fullName;
  final String phone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ReceiverCard({
    required this.branding,
    required this.isArabic,
    required this.initials,
    required this.fullName,
    required this.phone,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: branding.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: branding.cardBorder.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: branding.badge.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onLongPress: onEdit,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 46.r,
                height: 46.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      branding.gradientStartColorValue,
                      branding.gradientEndColorValue,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: branding.iconPrimary.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: GoogleFonts.cairo(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: GoogleFonts.cairo(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: branding.primaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (phone.trim().isNotEmpty) ...[
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 12,
                            color: branding.hintText,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            phone,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.cairo(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: branding.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionBtn(
                    icon: Icons.edit_rounded,
                    color: branding.iconPrimary,
                    bg: branding.iconPrimary.withValues(alpha: 0.1),
                    onTap: onEdit,
                  ),
                  SizedBox(width: 8.w),
                  _ActionBtn(
                    icon: Icons.delete_outline_rounded,
                    color: branding.error,
                    bg: branding.error.withValues(alpha: 0.1),
                    onTap: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34.r,
        height: 34.r,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: color, size: 17),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Shimmer skeleton
// ═══════════════════════════════════════════════════════════════════════════
class _ShimmerReceiverCard extends StatelessWidget {
  final dynamic branding;
  const _ShimmerReceiverCard({required this.branding});

  @override
  Widget build(BuildContext context) {
    final base = branding.inputBorder;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(shape: BoxShape.circle, color: base),
          ),
          SizedBox(width: 12.w),
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
                SizedBox(height: 7.h),
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
          Row(
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
