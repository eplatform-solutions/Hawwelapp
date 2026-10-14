import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/widgets/app_back_button.dart';
import 'package:hawwel/featue/support_chat/data/cubite/cubite.dart';
import 'package:hawwel/featue/support_chat/data/cubite/cubite_state.dart';
import 'package:hawwel/featue/support_chat/data/model.dart';

class SupportChatView extends StatefulWidget {
  const SupportChatView({super.key});

  // Used by CurrentRouteObserver so the floating chat button can hide
  // itself while the user is already on this screen.
  static const routeName = '/support-chat';

  @override
  State<SupportChatView> createState() => _SupportChatViewState();
}

class _SupportChatViewState extends State<SupportChatView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().connect();
  }

  @override
  void dispose() {
    context.read<ChatCubit>().disconnectSocket();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;
    context.read<ChatCubit>().sendMessage(text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: branding.buildHeaderGradient(),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
                  child: Row(
                    children: [
                      AppBackButton(onTap: () => Navigator.pop(context)),
                      Expanded(
                        child: Text(
                          AppTranslations.getText(context, 'chat_with_support'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: branding.buttonText,
                          ),
                        ),
                      ),
                      SizedBox(width: 38.w),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is ChatLoaded) _scrollToBottom();
                },
                builder: (context, state) {
                  if (state is ChatConnecting || state is ChatInitial) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: branding.accent),
                          SizedBox(height: 14.h),
                          Text(
                            AppTranslations.getText(context, 'chat_connecting'),
                            style: GoogleFonts.cairo(
                              fontSize: 13.sp,
                              color: branding.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ChatError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wifi_off_rounded,
                              color: branding.error, size: 36.sp),
                          SizedBox(height: 10.h),
                          Text(
                            AppTranslations.getText(context, 'chat_error'),
                            style: GoogleFonts.cairo(
                              fontSize: 13.sp,
                              color: branding.secondaryText,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          TextButton(
                            onPressed: () => context.read<ChatCubit>().connect(),
                            child: Text(
                              AppTranslations.getText(context, 'Refresh'),
                              style: GoogleFonts.cairo(
                                color: branding.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final loaded = state as ChatLoaded;
                  if (loaded.messages.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          AppTranslations.getText(context, 'chat_empty_state'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 13.sp,
                            color: branding.secondaryText,
                          ),
                        ),
                      ),
                    );
                  }

                  if (loaded.messages.length != _lastMessageCount) {
                    _lastMessageCount = loaded.messages.length;
                    _scrollToBottom();
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    itemCount: loaded.messages.length,
                    itemBuilder: (context, index) {
                      final msg = loaded.messages[index];
                      final bool isMine = msg.senderType == 'customer';
                      return _MessageBubble(
                        message: msg,
                        isMine: isMine,
                        branding: branding,
                      );
                    },
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: branding.inputBg,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(color: branding.inputBorder),
                        ),
                        child: TextField(
                          controller: _messageController,
                          textDirection:
                              isArabic ? TextDirection.rtl : TextDirection.ltr,
                          style: GoogleFonts.cairo(
                            fontSize: 13.5.sp,
                            color: branding.inputText,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                AppTranslations.getText(context, 'type_a_message'),
                            hintStyle: GoogleFonts.cairo(
                              fontSize: 13.sp,
                              color: branding.hintText,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 10.h),
                          ),
                          onSubmitted: (_) => _send(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: _send,
                      child: Container(
                        width: 42.r,
                        height: 42.r,
                        decoration: BoxDecoration(
                          gradient: branding.buildHeaderGradient(),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isArabic ? Icons.send_rounded : Icons.send_rounded,
                          color: Colors.white,
                          size: 18.sp,
                        ),
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
}

class _MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMine;
  final AppBrandingConfig branding;

  const _MessageBubble({
    required this.message,
    required this.isMine,
    required this.branding,
  });

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.72.sw),
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
        decoration: BoxDecoration(
          gradient: isMine ? branding.buildHeaderGradient() : null,
          color: isMine ? null : branding.cardBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.r),
            topRight: Radius.circular(14.r),
            bottomLeft: Radius.circular(isMine ? 14.r : 4.r),
            bottomRight: Radius.circular(isMine ? 4.r : 14.r),
          ),
          border: isMine ? null : Border.all(color: branding.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isMine && message.senderName != null) ...[
              Text(
                message.senderName!,
                style: GoogleFonts.cairo(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: branding.accent,
                ),
              ),
              SizedBox(height: 2.h),
            ],
            Text(
              message.body,
              style: GoogleFonts.cairo(
                fontSize: 13.5.sp,
                height: 1.5,
                color: isMine ? Colors.white : branding.primaryText,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.createdAt),
                  style: GoogleFonts.cairo(
                    fontSize: 10.sp,
                    color: isMine
                        ? Colors.white.withValues(alpha: 0.75)
                        : branding.hintText,
                  ),
                ),
                // Delivery state for the customer's own messages:
                // ✓ delivered to support, ✓✓ read by support.
                if (isMine) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
                    size: 13.sp,
                    color: message.isRead
                        ? const Color(0xFF7FE3FF)
                        : Colors.white.withValues(alpha: 0.75),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
