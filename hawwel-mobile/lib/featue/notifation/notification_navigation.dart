import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/localization/langhelper.dart';
import 'package:hawwel/featue/idintity_veryfation/idinty_verv.dart';
import 'package:hawwel/featue/profail/block.dart';
import 'package:hawwel/constans/transfer_status_theme.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_ressponse_transfer.dart'
    as transfer_response;
import 'package:hawwel/featue/transaction_historu/data/model.dart';
import 'package:hawwel/featue/transaction_historu/widjt/detals_osta.dart';
import 'package:hawwel/featue/transfer_execution/page_view.dart';
import 'package:hawwel/featue/support_chat/support_chat_view.dart';

class NotificationNavigation {
  static Map<String, dynamic> normalizedPayload(Map<String, dynamic> raw) {
    if (raw['data'] is String) {
      try {
        final decoded = jsonDecode(raw['data'] as String);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {}
    }
    if (raw['data'] is Map) {
      return Map<String, dynamic>.from(raw['data'] as Map);
    }
    return Map<String, dynamic>.from(raw);
  }

  static Future<TransferModel?> fetchTransferById(String transferId) async {
    final id = transferId.trim();
    if (id.isEmpty) return null;

    final api = ApiService(dio: Dio());
    for (var page = 1; page <= 6; page++) {
      final response = await api.get(
        endpoint:
            '/transfers/all-transfers-inside-the-page?pageNumber=$page&pageSize=50',
      );
      final groups = response.data['data']?['transfers'];
      if (groups is! List) return null;

      for (final group in groups) {
        if (group is! Map) continue;
        final transfers = group['transfers'];
        if (transfers is! List) continue;
        for (final transfer in transfers) {
          if (transfer is! Map) continue;
          final map = Map<String, dynamic>.from(transfer);
          final itemId = map['_id']?.toString() ?? '';
          final transferNumber = map['transferNumber']?.toString() ?? '';
          if (itemId == id || transferNumber == id) {
            return TransferModel.fromJson(map);
          }
        }
      }

      if (groups.length < 50) break;
    }
    return null;
  }

  static Future<bool> openFromNotificationData(
    BuildContext context,
    Map<String, dynamic> rawData, {
    bool allowAwaitingPaymentRoute = true,
  }) async {
    final navigator = Navigator.of(context);
    final isAr = LangHelper.isArabic(context);
    final data = normalizedPayload(rawData);

    if ((data['type'] ?? '').toString() == 'chat_message') {
      await navigator.push(
        MaterialPageRoute(
          settings: const RouteSettings(name: SupportChatView.routeName),
          builder: (_) => const SupportChatView(),
        ),
      );
      return true;
    }

    final kycId = (data['kycId'] ?? '').toString().trim();
    if (kycId.isNotEmpty) {
      await _openKycScreen(navigator, context, data);
      return true;
    }

    final transferId = (data['transferId'] ?? data['_id'] ?? data['id'] ?? '')
        .toString()
        .trim();
    if (transferId.isEmpty) return false;

    final transfer = await fetchTransferById(transferId);
    if (transfer == null) return false;

    final status = normalizeTransferStatus(transfer.status);
    if (allowAwaitingPaymentRoute && isAwaitingPaymentStatus(status)) {
      final transferResponse = _toTransferResponse(transfer, isAr);
      await navigator.push(
        MaterialPageRoute(
          builder: (_) => ConfermScreen(transfer: transferResponse),
        ),
      );
      return true;
    }

    await navigator.push(
      MaterialPageRoute(builder: (_) => _buildDetailsScreen(transfer, isAr)),
    );
    return true;
  }

  // Routes a KYC decision notification to the screen where the user can act
  // on it: the upload wizard when documents are wanted, otherwise the status
  // page with the admin's reason.
  static Future<void> _openKycScreen(
    NavigatorState navigator,
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final status = (data['status'] ?? '').toString().trim();
    if (status == 'cancel-blocked') {
      await navigator.push(MaterialPageRoute(builder: (_) => idintyview()));
      return;
    }
    String reason = '';
    for (final key in const [
      'blockingReason',
      'rejectionReason',
      'removeVerifyingReason',
    ]) {
      final value = (data[key] ?? '').toString().trim();
      if (value.isNotEmpty) {
        reason = value;
        break;
      }
    }
    if (reason.isEmpty && status != 'verified' && context.mounted) {
      reason = AppTranslations.getTextStatic(context, 'kyc_no_reason');
    }
    await navigator.push(
      MaterialPageRoute(
        builder: (_) => KycStatusPage(
          status: status.isEmpty ? 'under-review' : status,
          reason: reason,
        ),
      ),
    );
  }

  static transfer_response.TransferResponseModel _toTransferResponse(
    TransferModel transfer,
    bool isAr,
  ) {
    final wallets = transfer.blockchainWallets
        .map(
          (wallet) => transfer_response.BlockchainWalletModel(
            network: wallet.network,
            address: wallet.address,
            createdAt: wallet.createdAt,
          ),
        )
        .toList();
    return transfer_response.TransferResponseModel(
      id: transfer.id,
      receiver: transfer_response.ReceiverModel(
        fullName: transfer.receiver.fullName,
        mobilePhone: transfer.receiver.mobilePhone,
      ),
      sender: transfer_response.SenderModel(
        id: '',
        name: '',
        nickname: '',
        fatherName: '',
        mobilePhone: '',
        email: '',
      ),
      fromCountry: '',
      toCountry: '',
      city: isAr ? transfer.cityAr : transfer.cityEn,
      area: isAr ? transfer.areaAr : transfer.areaEn,
      amount: transfer.amount,
      total: transfer.total,
      fee: transfer.fee,
      rate: transfer.rate,
      currencyName: transfer.currencyName,
      symbol: transfer.symbol,
      status: transfer.status,
      expirationAt: transfer.expirationAt,
      createdAt: transfer.createdAt,
      transferNumber: transfer.transferNumber,
      paymentMethod: transfer_response.PaymentMethodResponseModel(
        id: transfer.paymentMethod.id,
        name: isAr
            ? transfer.paymentMethod.nameAr
            : transfer.paymentMethod.nameEn,
        symbol: transfer.paymentMethod.symbol,
        logoPath: transfer.paymentMethod.logoPath,
      ),
      blockchainWallets: wallets,
    );
  }

  static Widget _buildDetailsScreen(TransferModel transfer, bool isAr) {
    final netAmount = transfer.amount - (transfer.amount * transfer.fee / 100);
    return Detalestranzationosta(
      fee: transfer.fee.toString(),
      total: transfer.amount.toString(),
      transferamount: netAmount.toStringAsFixed(2),
      stat: transfer.status,
      Area: isAr ? transfer.areaAr : transfer.areaEn,
      City: isAr ? transfer.cityAr : transfer.cityEn,
      currency: transfer.symbol,
      amount: transfer.amount,
      isReceived: false,
      senderName: transfer.receiver.fullName,
      senderPhone: transfer.receiver.mobilePhone,
      receiverName: transfer.receiver.fullName,
      receiverPhone: transfer.receiver.mobilePhone,
      paymentMethodName: isAr
          ? transfer.paymentMethod.nameAr
          : transfer.paymentMethod.nameEn,
      paymentMethodLogo: transfer.paymentMethod.logoPath,
      createdAt: _formatDate(transfer.createdAt),
      transferNumber: transfer.transferNumber.toString(),
      paymentProofNote: transfer.paymentProofNote,
      paymentProofImagePath: transfer.paymentProofImagePath,
      receivingPlaceImagePath: transfer.receivingPlaceImagePath,
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
