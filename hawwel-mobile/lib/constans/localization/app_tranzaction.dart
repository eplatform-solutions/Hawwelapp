import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/constans/localization/lang_cubit.dart';

class AppTranslations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Welcome Screen
      "Conversion methods": "Conversion methods",
      "welcome_title": "Welcome you",
      "send_amount_label": "Amount to send",
      "send_to": "Send to",
      "send_from": "Send from",
      "turkey": "Turkey",
      "select_city": "Select city",
      "select_area": "Select area",
      "transfer_methods": "Transfer methods",
      "transfer_option_sham_cash": "Sham Cash",
      "transfer_option_al_haram": "Al Haram",
      "transfer_option_hand_to_hand": "Hand delivery",
      "transfer_option_al_fouad": "Al Fouad",
      "receiver_gets": "Receiver gets",
      "you_send": "You send",
      "transfer_label": "Transfer",
      "fees_label": "Fees",
      "transfer_fee_label": "Transfer fee",
      "rate_summary_label": "Exchange rate",
      "total_amount": "Total amount",
      "send_transfer_cta": "Send your orders",
      "home": "Home",
      "transactions": "Transactions",
      "settings": "Settings",
      "clients": "Clients",

      // Login Screen
      "login_title": "Login",
      "welcome_back": "Welcome back!",
      "username": "Username",
      "phone": "Phone number",
      "password": "Password",
      "forgot_password": "? Forgot password",
      "login_button": "Login",
      "invalid_phone_credentials":
          "Sorry, phone number or password is incorrect.",
      "invalid_email_credentials": "Sorry, email or password is incorrect.",
      "register_now": "Register now",
      "dont_have_account": "Don't have an account?",
      "already_have_account": "Already have an account?",
      "login_now": "Login",
      "phone_already_registered": "This phone number is already registered",
      "session_expired_login_again":
          "Your session has expired. Please log in again.",
      "session_start_failed":
          "Could not start your session. Please log in again.",

      // Register Screen
      "create_account": "Create new account",
      "name": "Name",
      "surname": "Surname",
      "country": "Country",
      "email": "Email",
      "resend_after": "Resend after {seconds} seconds",
      "request_verification": "Request verification",
      "verification_code": "Enter verification code",
      "phone_number": "Phone number:",
      "confirm_mobile_title": "Confirm mobile number",
      "confirm_mobile_subtitle":
          "Enter the code sent to your phone to complete registration.",
      "confirm_registration": "Confirm",

      // Payment Screens
      "payment": "Payment",
      "confirm_payment_details": "Confirm payment details",
      "email_phone_hint": "Email, phone number",
      "phone_or_name_hint": "Phone number or name",
      "enter_beneficiary_info": "Enter your beneficiary information",
      "write_paste_for_transaction": "Write or paste for your transaction",
      "send": "Send",
      "enter_amount_to_send": "Enter amount to send",
      "sending": "Sending",
      "next": "Next",

      // Payment instructions
      "payment_instructions": "Payment instructions",
      "total_balance": "Total request amount",
      "increase_balance": "Add external payment amount",
      "send_money": "Send",

      // Support chat
      "chat_with_support": "Chat with support",
      "type_a_message": "Type a message",
      "chat_connecting": "Connecting...",
      "chat_error": "Couldn't connect. Please try again.",
      "chat_empty_state": "Send a message and our support team will reply here.",

      // Technical Support
      "technical_support": "Technical support",
      "faq": "Frequently asked questions",
      "how_to_send_money": "How to submit an order",
      "how_to_send_money_desc":
          "You can go to the main interface and fill in the information",
      "how_to_increase_balance": "How to add external payment amount",
      "how_to_increase_balance_desc":
          "Go to the payment instructions section for external payment steps",
      "how_to_deposit": "How to complete external payment",
      "how_to_deposit_desc":
          "Go to the external payment instructions and choose the currency and network type",
      "sending_instructions": "Sending instructions",
      "step_1_select_recipient": "Select recipient",
      "step_2_enter_amount": "Enter amount",
      "step_3_confirm_operation": "Confirm operation",
      "contact_us": "Contact us",
      "contact_whatsapp": "WhatsApp",
      "contact_telegram": "Telegram",
      "support_floating_chat_hint":
          "Use the floating buttons to open WhatsApp or Telegram.",

      // Saved Names
      "saved_names": "Saved names",
      "search": "Search",
      "add_new_user": "Add new user",

      // Deposit Money
      "deposit_money": "Complete external payment",
      "select_currency": "Select currency",
      "select_network": "Select network",

      // Profile
      "account_number": "Account number : {number}",
      "view_transactions": "View transactions",
      "verified": "Verified",
      "level": "Level",
      "profile": "Profile",
      "change_password": "Change password",
      "enable_two_factor": "Enable two-factor authentication",
      "logout": "Logout",
      "delete_account_submit_request": "Submit account deletion request",
      "delete_account_request_received":
          "Your account deletion request has been received. Our team will review and process it according to our Privacy Policy and compliance requirements.",
      "delete_account_request_already_pending":
          "An account deletion request is already pending.",
      "delete_account_request_failed":
          "We could not submit your deletion request right now. Please try again later or use the account deletion page.",
      "delete_account_web_fallback": "Use account deletion page",

      // Forgot Password
      "reset_password": "Reset password",
      "forgot_password_question": "Forgot your password?",
      "enter_email": "Enter email",

      // Common
      "retry": "Retry",
      "change_language": "Change language",
      "submit": "Submit",
      "cancel": "Cancel",
      "confirm": "Confirm",
      "back": "Back",
      "save": "Save",
      "delete": "Delete",
      "edit": "Edit",

      // OTP & Verification
      "verification": "Verification",
      "enter_verification_code": "Enter verification code",
      "resend_code": "Resend code",
      "New user": "?New user",

      // Transaction History
      "transaction_history": "Transaction history",
      "beneficiary": "Beneficiary",
      "current_balance": "Current request amount",

      // Notifications
      "notifications": "Notifications",
      "no_notifications": "No notifications for today",
      "Order Process": "Order Process",
      "Order Payment Proof": "Order Payment Proof",
      "Transfer Ready": "Transfer Ready",
      "Transfer Received": "Transfer Received",
      "Transfer Cancelled": "Transfer Cancelled",
      "Transfer Disputed": "Transfer Disputed",
      "Transfer Underpaid": "Transfer Underpaid",
      "Transfer Overpaid": "Transfer Overpaid",
      "notification_preparing_address":
          "We are preparing the delivery address for your transfer.",
      "notification_can_receive":
          "Your transfer is ready - you can now receive it. Please bring your ID.",
      "notification_received": "Your transfer has been received successfully.",
      "notification_cancelled":
          "Your transfer has been cancelled. Contact support for more details.",
      "notification_dispute":
          "Your transfer has been flagged for review by our team. We will contact you shortly.",
      "notification_underpaid_deposit":
          "We received {{paid}} {{symbol}}, less than the {{amount}} {{symbol}} requested. Your transfer's value is now based on the amount actually received.",
      "notification_overpaid_deposit":
          "We received {{paid}} {{symbol}}, more than the {{amount}} {{symbol}} requested. Your transfer will be delivered based on the full amount received.",
      "KYC Approved": "KYC Approved",
      "KYC Rejected": "KYC Rejected",
      "KYC Blocked": "KYC Blocked",
      "KYC Unblocked": "KYC Unblocked",
      "KYC Verification Removed": "KYC Verification Removed",
      "Account Blocked": "Account Blocked",
      "Account Unblocked": "Account Unblocked",
      "notification_kyc_approved":
          "Your identity verification (KYC) has been approved.",
      "notification_kyc_rejected":
          "Your identity verification (KYC) was rejected.{{reasonClause}} Please resubmit your documents.",
      "notification_kyc_blocked":
          "Your identity verification (KYC) has been blocked.{{reasonClause}} Contact support for more details.",
      "notification_kyc_unblocked":
          "Your identity verification (KYC) block has been lifted. Please resubmit your documents to continue verification.",
      "notification_kyc_remove_verified":
          "Your identity verification (KYC) approval has been withdrawn.{{reasonClause}} Please resubmit your documents.",
      "notification_account_blocked":
          "Your account has been blocked.{{reasonClause}} Contact support for more details.",
      "notification_account_unblocked":
          "Your account has been unblocked. You can now use the app normally.",
      "Payment proof was added to your order by admin.":
          "Payment proof was added to your order by admin.",
      "external_payment_deposit_notice":
          "External payment received: {{amount}} {{currencyName}} at external payment address: {{address}} on network: {{network}}",
      "notification_deposit_message":
          "External payment received: {{amount}} {{currencyName}} at address: {{address}} on network: {{network}}",
      "notification_order_not_found":
          "Unable to open order details for this notification",
      "order_details_section": "Order details",
      "payment_notice_title": "Payment notice",
      "order_share_privacy_note":
          "Do not share order details except with the beneficiary",
      "delivery_identity_note": "Delivery is completed after identity verification",
      "secure_account_notice": "Secure account",
      "external_payment_disclaimer":
          "Send the amount from your own wallet or exchange account to the address shown. It is issued for this transfer only. Hawwel App holds that amount until your transfer is delivered; it does not operate as a bank or an exchange and does not offer an account balance.",

      // Address
      "address": "Address",
      "enter_address": "Enter address",

      // Identity Verification
      "identity_verification": "Identity verification",

      // Register Screen
      "name_hint": "Name",
      "surname_hint": "last name",
      "country_hint": "Country",
      "email_hint": "Email",

      // Address
      "address_hint": "Address",

      // Copy to clipboard
      "copied_to_clipboard": "Copied to clipboard",

      // Payment Done
      "payment_completed": "Payment completed",
      "you_paid": "You paid",

      // Confirm Password
      "new_password": "New password",
      "new_password_title": "New password",
      "enter_new_password": "Enter new password",
      "confirm_password": "Confirm password",
      "at_least_8_chars": "At least 8 characters",

      // Review Transaction
      "review_transaction": "Review transaction instructions",

      // Load File
      "go_to_home": "Go to home page",
      "complete_verification": "Complete process",

      // Sender Information
      "sender_data": "Sender data",
      "delivery_information": "Delivery information",
      "full_name": "Full name",
      "recipient_phone": "Recipient phone number",
      "saved_receivers": "Saved receivers",
      "add_receiver": "Add",
      "payment_method": "Payment method",
      "transaction_details": "Transaction details",
      "area_label": "Area",
      "phone_label": "Phone number",
      "transfer_amount": "Transfer amount:",
      "send_amount": "Send amount",

      // Review Transaction
      "recipient_receives": "Recipient receives",
      "beneficiary_data": "Beneficiary data",
      "confirm_send": "Confirm send",

      // Identity Verification
      "identity_verification_title": "Identity verification",
      "not_verified_yet": "Not verified yet, please complete",
      "steps_to_complete_transfers": "steps to complete orders",
      "identity_information": "Identity information",
      "uploading_now": "Uploading now",
      "upload_completed": "Upload completed",
      "upload_documents_residence": "Upload documents (Residence)",

      // OTP
      "Register now": "Register now",
      "request_new_code": "Request new code",
      "If you do not receive the verification code":
          "?If you do not receive the verification code",
      "please_resend_after_seconds": "Please resend after {seconds} seconds",
      "resend": "Resend",
      "enter_verification_code_hint": "Enter verification code",
      "phone_number_hint": "Phone number",
      "password_hint": "Password",
      "confirm_password_hint": "Confirm password",

      // Notifications
      "transfer_completed": "Order completed 🔄",
      "minutes_ago": "{minutes} minutes ago 🕒",
      "Saved names": "Saved names",
      "Internal transfers": "Internal orders",
      "Transfers via intermediaries": "Orders via intermediaries",
      "Received": "Received",
      "It was sent": "It was sent",
      "Receipt from": "Receipt from",
      "Send to": "Send to",
      "Saving information": "Saving information",
      'Share information': 'Share information',
      "transfer_status_pending": "Pending",
      "transfer_status_full_paid": "Paid in full",
      "transfer_status_under_paid": "Underpaid",
      "transfer_status_over_paid": "Overpaid",
      "transfer_status_cancelled": "Cancelled",
      "transfer_status_expired": "Expired",
      "transfer_status_completed": "Completed",
      "transfer_status_preparing_address": "Address is being prepared",
      "transfer_status_can_receive": "You can receive",
      "transfer_status_received": "Received",
      "transfer_status_dispute": "Disputed",
      "requested_amount_label": "Requested amount",
      "actually_paid_amount_label": "Actually received",
      "transfer_admin_note": "Note",
      "receiving_place_image": "Receiving place",
      "payment_proof_image": "Proof of receipt",
      "Order Receiving Place": "Order Receiving Place",
      "Receiving place image was added to your order by admin.":
          "A receiving place image was added to your order by admin.",
      "transfer_proof_photo": "Image:",
      "image_load_error": "Could not load image",
      "pdf_transfer_proof_title": "Order payment proof",
      "pdf_transfer_number_line": "Order number: {number}",
      "pdf_summary_total": "Total",
      "pdf_summary_transfer_amount": "Order amount",
      "pdf_summary_currency": "Currency",
      "pdf_section_transfer_details": "Order details",
      "pdf_section_recipient_details": "Recipient details",
      "pdf_label_created_at": "Created at",
      "pdf_label_transfer_number": "Order number",
      "pdf_label_amount": "Amount",
      "pdf_label_fee": "Fee",
      "pdf_label_payment_method": "Payment method",
      "pdf_label_receiver_name": "Recipient name",
      "pdf_label_receiver_phone": "Recipient phone",
      "pdf_label_city": "City",
      "pdf_label_area": "Area",
      "pdf_footer_generated":
          "This file was generated automatically by the Hawwel app.",
      "share_transfer_image": "Share transfer image",
      "pdf_share_subject": "Transfer notice {number}",
      "pdf_filename": "hawwel_transfer_notice_{number}.pdf",
      "pdf_title": "Transfer notice",
      "pdf_section_recipient": "Recipient",
      "pdf_label_net_amount": "Net amount",
      "pdf_label_receiving_place_image": "Receiving place",
      "pdf_label_proof_image": "Proof of receipt",
      "pdf_section_photos": "Attached photos",
      "pdf_status_hint": "Current order status: {status}",
      "pdf_admin_note_heading": "Admin note",
      "Created": "Created",
      "Reference request": "Reference request",
      "Enter your beneficiary information":
          "Enter your beneficiary information",
      "Write, paste for your transaction": "Write, paste for your transaction.",
      "Choose a region": "Choose a region",
      "Choose a city": "Choose a city",
      "choose_governorate": "Choose governorate",
      "choose_city_final": "Choose city",
      "Transaction": "Transaction",
      "Identity verification": "Identity verification",
      "Not yet verified, please complete": "Not yet verified, please complete",
      "Steps to complete orders": "Steps to complete orders",
      "Identity Information": "Identity Information",
      "Required Documents": "Required Documents",
      "National ID / Passport": "National ID / Passport",
      "Selfie with ID": "Selfie with ID",
      "Proof of address": "Proof of address",
      "Upload Documents": "Upload Documents",
      "Review": "Review",
      "Step 2 of 3": "Step 2 of 3",
      "Tap to upload document": "Tap to upload document",
      "PDF, JPG, PNG supported": "PDF, JPG, PNG supported",
      "Choose File": "Choose File",
      "Tap to change file": "Tap to change file",
      "Upload Tips": "Upload Tips",
      "Good lighting is important": "Good lighting is important",
      "Make sure the full document is visible":
          "Make sure the full document is visible",
      "Use a high-quality image": "Use a high-quality image",
      "Please wait a moment": "Please wait a moment",
      "Documents uploaded successfully": "Documents uploaded successfully",
      "Uploading documents (residence permit)":
          "Uploading documents (residence permit)",
      "Loaded": "Loaded",
      "Change language": "Change language",
      "new user": "new user",
      "add_new_recipient": "Add new recipient",
      ".Write, paste for your transaction":
          ".Write, paste for your transaction",
      "current balance": "Current request amount",
      "otp": "send code",
      "enterotp ": "enter otp",
      // Order Confirmation Screen
      "transfer_details": "Order Details",
      "transfer_amount1": "Order amount",
      "recipient": "Recipient:",
      "total_amount1": ":Total Amount",
      "send_button": "Send Order",
      "recipient_name": "Recipient Name",
      "received_amount_label": "Received amount:",
      "phone_number1": "Phone Number",
      "currency_rate": "Currency Rate",
      "city": "City:",
      "Verification": "Verification",
      "Pickup location": "Pickup location:",
      "recipient receives": "Recipient receives:",
      "transfer_time": "Order Time",
      "exchange_rate": ": Exchange Rate",
      "note": "Note",
      "Only one": "Only one",
      "external_address_one_time":
          "This external payment address is for this request only, and can be used once.",
      "external_payment_fee_notice":
          "Note: an operation fee of {feeAmount} {symbol} applies to this transfer.",
      "Scan QR to copy address": "Scan the QR to fill in the address and amount",
      "copy": "copy",
      "sharing": "sharing",
      "amount_to_send": "Amount to send",
      "external_payment_address": "To the following external payment address",
      "Choose the network": "Choose the network",
      "When paying, select the network.": "When paying, select the network.",
      "you only, and at the same exchange rate specified for the transfer.":
          "you only, and at the same exchange rate specified for the order",
      "If a lesser or greater amount is received, the value of the received amount will be transferred from":
          "If a lesser or greater amount is received, the value of the received amount will be transferred from",
      "external_payment_full_amount":
          "Please ensure the full amount is sent to the external payment address.",
      "To complete the transfer, please pay the amount due in digital dollars.":
          "To complete the order, please pay the amount due in digital dollars.",
      "Transfer number": "Reference Number",
      "Please pay to complete your order!":
          "Please pay to complete your order!",
      "transfer confirmation": "order confirmation",
      "Click here to learn about payment methods":
          "Click here to learn about payment methods",
      "external_payment_requirement":
          "Before confirming the request, you must be able to complete payment using your external payment provider.",
      "The transfer will be paid using the chosen digital currency.":
          "The order will be paid using the chosen digital currency",
      "confirmation_message":
          "The order is processed by us within 24 hours. The beneficiary then receives a text message with the notification number. The order can then be collected from Al-Haram offices.",
      "warning":
          "To complete the order, you must enter a valid tracking number. Please ensure you have entered it correctly.",
      "confirm_transfer": "Confirm Order",
      "send_amount_secondary_label": "2 USD (Digital)",
      "send_amount_tertiary_label": "202 USD (Digital)",
      "syp_2300": "SYP 2,300.00",
      "rate_conversion_label": "1 USD (Digital) = SYP 11500",
      "al_haram": "Al-Haram",
      "beirut": "Beirut",
      "within_24_hours": "Within 24 Hours",
      "Email": "Email",
      "Phone number or email": "Phone number or email",
      "Deactivate": "Deactivate",
      "Do you want to activate the service via phone number or email?":
          "Do you want to activate the service via phone number or email?",
      "two_factor_intro_phone":
          "Enable two-factor authentication: a verification code will be sent to your mobile number on every login.",
      "two_factor_enabled_phone_confirmation":
          "Two-factor authentication is on. A code will be sent to your mobile number on every login.",
      "two_factor_disabled_confirmation":
          "Two-factor authentication has been turned off.",
      "Enter old password": "Enter old password",
      "under-review": "  under review ",
      "rejected": "❌  rejected",
      "blocked": "blocked",
      "cancel-blocked": "Resubmission required",
      "remove-verified": "Re-verification required",
      "edit information": "edit information",
      "Choose country": "Choose country",
      "Are you sure you want to log out?": "Are you sure you want to log out?",
      "log out?": "log out",
      "otpedit": "enter otp",
      "back to profail": "back to profile",
      "please_enter_your_email": "please_enter_your_email",
      "please_enter_your_passowrd": "please_enter_your_passowrd",
      "please_enter_valid_email": "please_enter_valid_email",
      "mobile_number_error1": "mobile_number_error1",
      "enter_otp": "enter_otp",
      "mobile_number_required": "Please enter your phone number",
      "mobile_number_invalid": "Invalid phone number",

      "otp_required": "Please enter the verification code",

      "password_required": "Please enter your password",
      "password_min_length": "Password must be at least 8 characters",
      "password_uppercase":
          "Password must contain at least one uppercase letter",
      "password_lowercase":
          "Password must contain at least one lowercase letter",
      "password_number": "Password must contain at least one number",
      "password_symbol": "Password must contain at least one symbol",
      "password_requirements_hint":
          "Must be at least 8 characters, including an uppercase letter, a lowercase letter, a number, and a symbol.",

      "email_required": "Please enter your email",
      "email_invalid": "Please enter a valid email address",

      "full_name_required": "Please enter your full name",
      "full_name_invalid": "Name must contain letters only",

      "field_required": "This field is required",
      "country_required": "Please select a country",
      "total amount": ": total amount",
      "external_payment_amount_notice":
          "Complete the exact external payment amount. If the received amount differs, we will process only the actual quantity received at the agreed exchange rate.",
      'no_more_results': 'No more results',
      "via": "via",
      'No more results': 'No results',
      "Resend after": "Resend after",
      "seconds": "seconds",
      "Area": "Area:",
      "city1": "City",
      "fees_label1": "Fees",
      "The cash will be sent to": "The cash will be sent to",
      "you’ve paid": "you’ve paid",
      "if you want to take back the balance":
          "if you want to take back the balance",
      "Please contact technical support.": "Please contact technical support.",
      "you’ve sent an extra amount of the transfer amount.":
          "you’ve sent an extra amount ",
      "extra amount of the transfer balance.":
          "extra amount of the transfer balance.",
      "The balance cannot be refunded if it is":
          "The balance could’nt be take back if it is",
      "Balance less than 1": "Balance less than 1",
      "verification_request_under_review":
          "Verification request is under review",
      "Please enter all fields": "Please enter all fields",

      "Transfer Process": "Order Process",
      'days': 'days',
      'hours': 'hours',
      'minutes': 'minutes',
      'since': 'since',
      "select_file_first": "Please select a file first",
      "loading_now": "Loading now...",
      "upload_note": "Please upload the document as a PDF or JPEG",
      "otp_sent_success": "Verification code sent successfully",
      "search_country": "Search for a country",

      "undefined": "undefined",
      "The balance paid is insufficient": "The balance paid is ",
      "The balance paid is insufficient2": "The balance paid is insufficient",
      "insufficient": "insufficient",
      "password_mismatch": "Passwords do not match",
      "did_not_receive_code": "Didn't receive the code?",
      "The title has been copied": "The title has been copied",
      "amount_must_be_greater_than_15": "Amount must be greater than 15\$",
      "enter phone": "enter phone",
      "The amount is less than the minimum for this method":
          "The amount is less than the minimum for this method",
      "The amount exceeds the maximum for this method":
          "The amount exceeds the maximum for this method",
      "edit name": "edit name",
      "blocked_alert_title": "Block Alert",
      "Blocked account": "Blocked account",
      "Verification status": "Verification status",
      "the reason:": "the reason:",
      "Ok": "Ok",
      "payment_method_not_active": "Payment method is not active",
      "kyc_verified_message": "Your request has been verified",
      "kyc_not_verified": "Not verified",
      "kyc_no_reason": "No reason was provided",
      "kyc_status_rejected_title": "Verification request rejected",
      "kyc_status_under_review_title": "Under review",
      "kyc_status_verified_title": "Identity verified",
      "kyc_status_unknown_title": "Unknown status",
      "kyc_resubmit_button": "Resubmit documents",
      "identity_verification_blocked": "Identity verification is blocked - contact support",
      "kyc_required_title": "Identity verification required",
      "kyc_first_image_label": "First identity image",
      "kyc_second_image_label": "Second identity image",
      "select_first_kyc_image": "Please upload the first identity image",
      "select_second_kyc_image": "Please upload the second identity image",
      "kyc_two_images_required": "Two identity images are required",
      "phone_already_exists": "This number is already saved",
      "payment_success": "Payment successful",
      "done": "Done",
      "payment_pickup_address_within_hours":
          "You will receive the pickup address within 3 hours.",
    },
    'ar': {
      "payment_success": "تمت عملية الدفع بنجاح",
      "done": "تمت بنجاح",
      "payment_pickup_address_within_hours":
          "سيتم تزويدك بعنوان الاستلام خلال ٣ ساعات",
      "phone_already_exists": "هذا الرقم محفوظ سابقاً",
      "kyc_verified_message": "تم التحقق من طلبك",
      "kyc_not_verified": "غير موثّق",
      "kyc_no_reason": "لم يتم إرسال سبب",
      "kyc_status_rejected_title": "طلب التحقق مرفوض",
      "kyc_status_under_review_title": "قيد المراجعة",
      "kyc_status_verified_title": "تم التحقق من الهوية",
      "kyc_status_unknown_title": "حالة غير معروفة",
      "kyc_resubmit_button": "إعادة رفع المستندات",
      "identity_verification_blocked": "التحقق من الهوية محظور - تواصل مع الدعم",
      "kyc_required_title": "التحقق من الهوية مطلوب",
      "kyc_first_image_label": "الصورة الأولى للهوية",
      "kyc_second_image_label": "الصورة الثانية للهوية",
      "select_first_kyc_image": "يرجى رفع الصورة الأولى للهوية",
      "select_second_kyc_image": "يرجى رفع الصورة الثانية للهوية",
      "kyc_two_images_required": "مطلوب صورتان للهوية",
      "payment_method_not_active": "طريقة الدفع غير مفعلة",

      "Ok": "حسنا",
      "the reason:": "السبب:",
      "Verification status": "حالة التحقق",
      "Blocked account": "الحساب محظور",
      'No more results': 'لا يوجد نتائج',
      "The amount exceeds the maximum for this method":
          "الحد الاعلى من الارسال بهذه الطريقة",
      "The amount is less than the minimum for this method":
          "الحد الادنى من الارسال بهذه الطريقة",
      "enter phone": "أدخل الرقم",
      "amount_must_be_greater_than_15": "يجب أن يكون المبلغ أكبر من \$15",
      "The title has been copied": "تم نسخ العنوان",
      "did_not_receive_code": "لم تتلقَ رمز التحقق؟",
      "password_mismatch": "كلمتا المرور غير متطابقتين",
      "The balance paid is insufficient2":
          "إن قيمة الرصيد الذي تم دفعه غير كافية",
      "insufficient": "غير كافية",
      "The balance paid is insufficient": "إن قيمة الرصيد الذي تم دفعه ",
      "undefined": "غير محدد",
      "search_country": "أبحث عن بلدك",
      "otp_sent_success": "تم إرسال رمز التحقق بنجاح",
      "upload_note": "ملاحظة : يرجى تحميل المستند PDF أو JPEG",
      "loading_now": "يتم التحميل الآن",
      "select_file_first": "يرجى اختيار ملف أولاً",
      'days': 'يوم',
      'hours': 'ساعة',
      'minutes': 'دقيقة',
      'since': 'منذ',
      "Transfer Process": " عملية  طلب",
      "transfer_process": "عملية  طلب",

      "deposit_notification":
          "تم استلام دفع خارجي: {amount} في عنوان الدفع الخارجي: {address} على شبكة {network}",

      "Please enter all fields": "الرجاء إدخال جميع الحقول",
      "verification_request_under_review": "طلب التحقق قيد المراجعة",
      "Balance less than 1": "الرصيد أقل من 1 دولار",
      "The balance cannot be refunded if it is":
          "لا يمكن استرداد الرصيد في حال كان",
      "extra amount of the transfer balance.": "الرصيد الزائد عن كمية  طلبك هو",
      "you’ve sent an extra amount of the transfer amount.":
          "لقد أرسلت رصيد زائد عن كمية طلبك",
      "Please contact technical support.": "يرجى التواصل مع الدعم الفني",

      "if you want to take back the balance":
          "في حال أردت استرداد الرصيد الزائد ",
      "you’ve paid": " لقد دفعت: ",
      "The cash will be sent to": "سيتم إرسال الكمية إلى ",
      "fees_label1": "الرسوم",
      "city1": "المدينة",
      "Area": "المنطقة:",
      "seconds": "ثانية",
      "Resend after": "أعد الإرسال بعد",
      "via": "عبر",
      'no_more_results': 'لا مزيد من النتائج',
      "external_payment_amount_notice":
          "يرجى إتمام مبلغ الدفع الخارجي بالضبط. في حال وصول مبلغ أقل أو أكثر، سيتم معالجة الكمية المستلمة فعليًا فقط وفق سعر الصرف المتفق عليه.",
      "total amount": ": مجموع الدفع",
      "mobile_number_required": "الرجاء إدخال رقم الهاتف",
      "mobile_number_invalid": "رقم الهاتف غير صحيح",

      "otp_required": "الرجاء إدخال رمز التحقق",

      "password_required": "الرجاء إدخال كلمة المرور",
      "password_min_length": "يجب أن تكون كلمة المرور 8 محارف على الأقل",
      "password_uppercase":
          "يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل",
      "password_lowercase":
          "يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل",
      "password_number": "يجب أن تحتوي كلمة المرور على رقم واحد على الأقل",
      "password_symbol": "يجب أن تحتوي كلمة المرور على رمز واحد على الأقل ",
      "password_requirements_hint":
          "يجب أن تتكوّن من 8 خانات على الأقل، وتحتوي على حرف كبير وحرف صغير ورقم ورمز خاص.",

      "email_required": "الرجاء إدخال البريد الإلكتروني",
      "email_invalid": "الرجاء إدخال بريد إلكتروني صالح",

      "full_name_required": "الرجاء إدخال الاسم الكامل",
      "full_name_invalid": "الاسم يجب أن يحتوي على أحرف فقط",

      "field_required": "هذا الحقل مطلوب",
      "country_required": "الرجاء اختيار الدولة",
      "enter_otp": "الرجاء ادخال رمز التحقق",
      "mobile_number_error1": "الرجاء ادخال رقم الموبايل",
      "please_enter_valid_email": "الرجاء ادخال ايميل صالح",
      "please_enter_your_passowrd": "الرجاء ادخال كلمة السر",
      "please_enter_your_email": "الرجاء ادخال ايميلك",
      "back to profail": "العودة الى صفحة البروفايل",
      "otpedit": "ادخل رمز التحقق",
      "log out?": "تسجيل الخروج",
      "blocked_alert_title": "تنبيه حظر",
      "Are you sure you want to log out?": "هل أنت متأكد من تسجيل الخروج؟",
      "Verification": "التحقق",
      "Pickup location": "نقطة الاستلام:",
      "recipient receives": "يحصل المستلم:",
      "Choose country": "اختر الدولة",
      "edit information": "تعديل المعلومات",
      "blocked": "محظور",
      "cancel-blocked": "يتطلب إعادة التقديم",
      "remove-verified": "يتطلب إعادة التحقق",
      "rejected": "❌  مرفوض",
      "under-review": "قيد المراجعة ",
      "Enter old password": "أدخل كلمة السر القديمة",
      // Transfer Confirmation Screen (من الصورة المُرفقة)
      "transfer_details": "تفاصيل الطلب",
      "Email": "الإيميل",
      "Do you want to activate the service via phone number or email?":
          "هل تريد تنفيذ التفعيل على رقم الهاتف أو الإيميل ؟",
      "two_factor_intro_phone":
          "تفعيل المصادقة الثنائية: سيصلك رمز تحقق على رقم جوالك عند كل تسجيل دخول.",
      "two_factor_enabled_phone_confirmation":
          "تم تفعيل المصادقة الثنائية. سيصلك رمز تحقق على رقم جوالك عند كل تسجيل دخول.",
      "two_factor_disabled_confirmation":
          "تم إيقاف المصادقة الثنائية.",
      "Deactivate": "إلغاء التفعيل",
      "Phone number or email": "رقم الهاتف أو الإيميل",
      "transfer_amount": "كمية الطلب:",
      "recipient": "المستلم:",
      "total_amount": "الكمية الإجمالي",
      "send_button": "إرسال  الطلب",
      "recipient_name": "اسم المستلم",
      "received_amount_label": "المبلغ المستلم:",
      "phone_number": "رقم الهاتف:",
      "currency_rate": "سعر الصرف :",
      "city": "المدينة:",
      "transfer_time": "وقت  الطلب",
      "exchange_rate": ": سعر الصرف",
      "note": "ملاحظة",
      "Only one": "واحدة فقط",
      "external_address_one_time":
          "عنوان الدفع الخارجي هذا مخصص لهذا الطلب فقط، ويُستخدم لمرة واحدة.",
      "external_payment_fee_notice":
          "ملاحظة: تُطبَّق رسوم عملية بقيمة {feeAmount} {symbol} على هذه الحوالة.",
      "Scan QR to copy address": "امسح رمز QR لتعبئة العنوان والمبلغ تلقائيًا",
      "copy": "نسخ",
      "sharing": "مشاركة",
      "amount_to_send": "المبلغ المطلوب إرساله",
      "external_payment_address": "إلى عنوان الدفع الخارجي التالي:",
      "Choose the network": "اختر الشبكة",
      "When paying, select the network.": "عند الدفع اختر الشبكة :",
      "you only, and at the same exchange rate specified for the transfer.":
          "قبلكم فقط وبنفس سعر الصرف المحدد  للطلب",
      "If a lesser or greater amount is received, the value of the received amount will be transferred from":
          "وصول كمية أقل أو أكثر سيتم  طلب قيمة كمية المستلم من ",
      "external_payment_full_amount":
          "يرجى التأكد من إرسال المبلغ بالكامل إلى عنوان الدفع الخارجي.",
      "To complete the transfer, please pay the amount due in digital dollars.":
          "لتنفيذ الطلب يرجى تسديد الكمية\nالمستحقة بالدولار الرقمي :",
      "Transfer number": "الرقم المرجعي",
      "Please pay to complete your order!": " يرجى الدفع لإتمام الطلب !",
      "transfer confirmation": "تأكيد  الطلب",
      "Click here to learn about payment methods":
          "اضغط هنا لمعرفة طريقة السداد",
      "external_payment_requirement":
          "قبل تأكيد الطلب، يجب أن تتمكن من إتمام الدفع عبر مزود الدفع الخارجي الخاص بك.",
      "The transfer will be paid using the chosen digital currency.":
          "يتم تسديد الطلب بواسطة العملة الرقمية المختارة ",
      "confirmation_message":
          "يتم معالجة  الطلب من قبلنا خلال 24 ساعة ثم يتلقى المستفيد رسالة نصية برقم الإشعار وعندها يمكن استلام  الطلب من مكاتب الهرم",
      "warning":
          "لإتمام  الطلب يجب إدخال رقم تتبع صالح. يرجى التأكد من إدخاله بشكل صحيح.",
      "confirm_transfer": "تأكيد الطلب",
      "send_amount_secondary_label": "2 دولار رقمي",
      "send_amount_tertiary_label": "202 دولار رقمي",
      "syp_2300": "SYP 2,300.00",
      "rate_conversion_label": "1 USD (Digital) = SYP 11500",
      "al_haram": "الهرم",
      "beirut": "بيروت",
      "within_24_hours": "خلال 24 ساعة",
      // Welcome Screen
      "enterotp ": "أدخل كود التحقق",
      "otp": "طلب التحقق",
      "current balance": "مبلغ الطلب الحالي",
      ".Write, paste for your transaction": "أكتب , ألصق من أجل معاملتك",
      "new user": "إضافة مستخدم جديد",
      "add_new_recipient": "إضافة مستلم جديد",
      "Change language": "تغيير اللغة",
      "Loaded": "تم التحميل",
      "Uploading documents (residence permit)": "تحميل المستندات ( الإقامة )",
      "Identity Information": "معلومات الهوية",
      "Required Documents": "المستندات المطلوبة",
      "National ID / Passport": "الهوية الوطنية / جواز السفر",
      "Selfie with ID": "صورة شخصية مع الهوية",
      "Proof of address": "إثبات العنوان",
      "Upload Documents": "رفع المستندات",
      "Review": "المراجعة",
      "Step 2 of 3": "الخطوة 2 من 3",
      "Tap to upload document": "اضغط لرفع المستند",
      "PDF, JPG, PNG supported": "يدعم PDF و JPG و PNG",
      "Choose File": "اختر ملف",
      "Tap to change file": "اضغط لتغيير الملف",
      "Upload Tips": "نصائح الرفع",
      "Good lighting is important": "الإضاءة الجيدة مهمة",
      "Make sure the full document is visible": "تأكد من ظهور المستند كاملاً",
      "Use a high-quality image": "استخدم صورة عالية الجودة",
      "Please wait a moment": "يرجى الانتظار لحظة",
      "Documents uploaded successfully": "تم رفع المستندات بنجاح",
      "Steps to complete orders": "الخطوات لإتمام الطلبات",
      "Not yet verified, please complete": "لم يتم التحقق بعد يرجى استكمال ",
      "Identity verification": "التحقق من الهوية",
      "Transaction": "سجل الطلبات",
      "Choose a city": " اختر مدينة",
      "Choose a region": "اختر منطقة",
      "choose_governorate": "اختر المحافظة",
      "choose_city_final": "اختر المدينة",
      "Write, paste for your transaction": "أكتب , ألصق من أجل معاملتك",
      "Enter your beneficiary information": "أدخل معلومات المستفيد الخاص ب",
      "Reference request": "طلب مرجعي",
      "Created": "تم أنشاؤها",
      "Saving information": "حفظ المعلومات",
      "Received": "تم استلامه",
      'Share information': 'مشاركة المعلومات',
      "transfer_status_pending": "حالة معلقة",
      "transfer_status_full_paid": "تم الدفع",
      "transfer_status_under_paid": "تم استلام مبلغ أقل من المطلوب",
      "transfer_status_over_paid": "تم استلام مبلغ أكبر من المطلوب",
      "transfer_status_cancelled": "ملغى",
      "transfer_status_expired": "منتهي",
      "transfer_status_completed": "مكتمل",
      "transfer_status_preparing_address": "جاري المعالجة",
      "transfer_status_can_receive": "يمكنك الاستلام",
      "transfer_status_received": "تم الاستلام",
      "transfer_status_dispute": "بخلاف",
      "requested_amount_label": "المبلغ المطلوب",
      "actually_paid_amount_label": "المبلغ المستلم فعلياً",
      "transfer_admin_note": "ملاحظة",
      "receiving_place_image": "مكان الاستلام",
      "payment_proof_image": "إثبات الاستلام",
      "Order Receiving Place": "مكان استلام الطلب",
      "Receiving place image was added to your order by admin.":
          "تمت إضافة صورة مكان الاستلام إلى طلبك من قبل الإدارة.",
      "transfer_proof_photo": "الصورة :",
      "image_load_error": "تعذر تحميل الصورة",
      "pdf_transfer_proof_title": "إثبات دفع الطلب",
      "pdf_transfer_number_line": "رقم الطلب: {number}",
      "pdf_summary_total": "الإجمالي",
      "pdf_summary_transfer_amount": "مبلغ الطلب",
      "pdf_summary_currency": "العملة",
      "pdf_section_transfer_details": "بيانات الطلب",
      "pdf_section_recipient_details": "بيانات المستلم",
      "pdf_label_created_at": "تاريخ الإنشاء",
      "pdf_label_transfer_number": "رقم الطلب",
      "pdf_label_amount": "المبلغ",
      "pdf_label_fee": "الرسوم",
      "pdf_label_payment_method": "طريقة الدفع",
      "pdf_label_receiver_name": "اسم المستلم",
      "pdf_label_receiver_phone": "رقم المستلم",
      "pdf_label_city": "المدينة",
      "pdf_label_area": "المنطقة",
      "pdf_footer_generated": "تم إنشاء هذا الملف تلقائياً من تطبيق Hawwel.",
      "share_transfer_image": "مشاركة صورة الحوالة",
      "pdf_share_subject": "إشعار حوالة رقم {number}",
      "pdf_filename": "hawwel_transfer_notice_{number}.pdf",
      "pdf_title": "إشعار حوالة",
      "pdf_section_recipient": "المستلم",
      "pdf_label_net_amount": "الصافي",
      "pdf_label_receiving_place_image": "مكان الاستلام",
      "pdf_label_proof_image": "إثبات الاستلام",
      "pdf_section_photos": "الصور المرفقة",
      "pdf_status_hint": "حالة الطلب الحالية: {status}",
      "pdf_admin_note_heading": "ملاحظة الإدارة",
      "It was sent": "تم ارساله",
      "Receipt from": "الاستلام من",
      "Send to": "الارسال الى",
      "Transfers via intermediaries": " الطلبات عبر الوسطاء",
      "Internal transfers": " الطلبات الداخلية",
      "Saved names": "الأسماء المحفوظة",
      "Conversion methods": "طرق الدفع",
      "welcome_title": "أهلاً بك",
      "send_amount_label": "الكمية المراد ارسالها",
      "send_to": "ارسال الى",
      "send_from": "ارسال من",
      "turkey": "تركيا",
      "select_city": "اختر المدينة",
      "select_area": "اختر منطقة",
      "transfer_methods": "طرق الطلب",
      "transfer_option_sham_cash": "شام كاش",
      "transfer_option_al_haram": "الهرم",
      "transfer_option_hand_to_hand": "تسليم باليد",
      "transfer_option_al_fouad": "الفؤاد",
      "receiver_gets": "يتلقى المستلم",
      "you_send": "انت ترسل",
      "transfer_label": "الطلب",
      "fees_label": "الرسوم",
      "transfer_fee_label": "رسوم الحوالة",
      "rate_summary_label": "سعر الصرف",
      "total_amount1": "الكمية الاجمالي",
      "send_transfer_cta": "أرسل الطلب",
      "home": "الرئيسية",
      "transactions": "الطلبات",
      "settings": "الإعدادات",
      "clients": "العملاء",

      // Login Screen
      "login_title": "تسجيل الدخول",
      "welcome_back": "! مرحباً بك، مجدداً ",
      "username": "اسم المستخدم",
      "phone": "رقم الجوال",
      "password": "كلمة المرور",
      "forgot_password": "نسيت كلمة السر؟",
      "login_button": "تسجيل الدخول",
      "invalid_phone_credentials":
          "عذراً، رقم الهاتف أو كلمة المرور غير صحيحة.",
      "invalid_email_credentials":
          "عذراً، البريد الإلكتروني أو كلمة المرور غير صحيحة.",
      "register_now": "سجل الآن",
      "dont_have_account": "ليس لديك حساب؟",
      "already_have_account": "هل لديك حساب؟",
      "login_now": "سجل الدخول",
      "phone_already_registered": "رقم الهاتف مسجل مسبقاً",
      "session_expired_login_again": "انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى.",
      "session_start_failed":
          "تعذر بدء الجلسة. يرجى تسجيل الدخول مرة أخرى.",

      // Register Screen
      "create_account": "إنشاء حساب جديد",
      "name": "الاسم",
      "surname": "الكنية",
      "country": "البلد",
      "email": "الإيميل",
      "resend_after": "أعد الطلب بعد {seconds} ثانية",
      "request_verification": "طلب التحقق",
      "verification_code": "أدخل كود التحقق",
      "phone_number1": "رقم الجوال",
      "confirm_mobile_title": "تأكيد رقم الجوال",
      "confirm_mobile_subtitle":
          "أدخل الرمز المرسل إلى هاتفك لإكمال إنشاء الحساب.",
      "confirm_registration": "تأكيد",

      // Payment Screens
      "payment": "الدفع",
      "confirm_payment_details": "تأكيد تفاصيل الدفع",
      "email_phone_hint": "الإيميل , رقم الهاتف",
      "phone_or_name_hint": "رقم الهاتف أو الاسم",
      "enter_beneficiary_info": "أدخل معلومات المستفيد الخاص بك",
      "write_paste_for_transaction": "أكتب , ألصق من أجل معاملتك",
      "send": "إرسال",
      "enter_amount_to_send": "أدخل الكمية المراد إرساله",
      "sending": "الإرسال",
      "next": "التالي",

      // Payment instructions
      "payment_instructions": "تعليمات الدفع",
      "total_balance": "إجمالي مبلغ الطلب",
      "increase_balance": "إضافة مبلغ الدفع الخارجي",
      "send_money": "إرسال",

      // Support chat
      "chat_with_support": "الدردشة مع الدعم",
      "type_a_message": "اكتب رسالة",
      "chat_connecting": "جاري الاتصال...",
      "chat_error": "تعذر الاتصال. حاول مجدداً.",
      "chat_empty_state": "أرسل رسالة وسيرد عليك فريق الدعم هنا.",

      // Technical Support
      "technical_support": "الدعم الفني",
      "faq": "الاسئلة الشائعة",
      "how_to_send_money": "كيف أرسل الأموال",
      "how_to_send_money_desc":
          "يمكنك الذهاب إلى الواجهة الرئيسية وتعبئة المعلومات",
      "how_to_increase_balance": "كيف أضيف مبلغ الدفع الخارجي",
      "how_to_increase_balance_desc":
          "انتقل إلى قسم تعليمات الدفع لخطوات الدفع الخارجي",
      "how_to_deposit": "طريقة إتمام الدفع الخارجي",
      "how_to_deposit_desc":
          "اذهب إلى تعليمات الدفع الخارجي واختر العملة ونوع الشبكة",
      "sending_instructions": "تعليمات الإرسال",
      "step_1_select_recipient": "اختر المرسل إليه",
      "step_2_enter_amount": "أدخل الكمية",
      "step_3_confirm_operation": "أكد العملية",
      "contact_us": "تواصل معنا",
      "contact_whatsapp": "واتساب",
      "contact_telegram": "تيليغرام",
      "support_floating_chat_hint":
          "استخدم الأزرار العائمة لفتح واتساب أو تيليغرام.",

      // Saved Names
      "saved_names": "الأسماء المحفوظة",
      "search": "بحث",
      "add_new_user": "اضافة مستخدم جديد",

      // Deposit Money
      "deposit_money": "إتمام الدفع الخارجي",
      "select_currency": "اختر العملة",
      "select_network": "اختر شبكة",

      // Profile
      "account_number": "رقم الحساب : {number}",
      "view_transactions": "عرض المعاملات",
      "verified": "✔  تم التحقق",
      "level": "المستوى",
      "profile": "الملف الشخصي",
      "change_password": "تغيير كلمة المرور",
      "enable_two_factor": "تفعيل المصادقة الثنائية",
      "logout": "تسجيل الخروج",
      "delete_account_submit_request": "إرسال طلب حذف الحساب",
      "delete_account_request_received":
          "تم استلام طلب حذف الحساب. سيقوم فريقنا بمراجعته ومعالجته وفقًا لسياسة الخصوصية ومتطلبات الامتثال.",
      "delete_account_request_already_pending":
          "يوجد طلب حذف حساب قيد المراجعة بالفعل.",
      "delete_account_request_failed":
          "تعذر إرسال طلب حذف الحساب حاليًا. يرجى المحاولة لاحقًا أو استخدام صفحة حذف الحساب.",
      "delete_account_web_fallback": "استخدم صفحة حذف الحساب",

      // Forgot Password
      "reset_password": "استعادة كلمة المرور",
      "forgot_password_question": "هل نسيت كلمة السر؟",
      "enter_email": "أدخل الإيميل",

      // Common
      "retry": "اعد المحاولة",
      "change_language": "تغيير اللغة",
      "submit": "إرسال",
      "cancel": "إلغاء",
      "confirm": "تأكيد",
      "back": "رجوع",
      "save": "حفظ",
      "delete": "حذف",
      "edit": "تعديل",
      "edit name": "تعديل الاسم",
      // OTP & Verification
      "verification": "التحقق",
      "enter_verification_code": "أدخل كود التحقق",
      "resend_code": "إعادة إرسال الكود",
      "Register now": "سجل الآن",

      // Transaction History
      "transaction_history": "سجل الطلبات",
      "beneficiary": "المستفيد",
      "current_balance": "مبلغ الطلب الحالي",

      // Notifications
      "notifications": "الإشعارات",
      "no_notifications": "لا توجد إشعارات لليوم",
      "Order Process": "معالجة الطلب",
      "Order Payment Proof": "إثبات دفع الطلب",
      "Transfer Ready": "الحوالة جاهزة",
      "Transfer Received": "تم استلام الحوالة",
      "Transfer Cancelled": "تم إلغاء الحوالة",
      "Transfer Disputed": "الحوالة بخلاف",
      "Transfer Underpaid": "دفع ناقص",
      "Transfer Overpaid": "دفع زائد",
      "notification_preparing_address": "جاري تجهيز عنوان استلام حوالتك.",
      "notification_can_receive":
          "حوالتك جاهزة الآن، يمكنك استلامها. يرجى اصطحاب الهوية الشخصية.",
      "notification_received": "تم استلام حوالتك بنجاح.",
      "notification_cancelled":
          "تم إلغاء حوالتك. للمزيد من التفاصيل تواصل مع الدعم.",
      "notification_dispute":
          "تم وضع حوالتك قيد المراجعة من قبل فريقنا. سنتواصل معك قريبًا.",
      "notification_underpaid_deposit":
          "استلمنا {{paid}} {{symbol}}، وهو أقل من {{amount}} {{symbol}} المطلوب. قيمة حوالتك الآن محسوبة على المبلغ المستلم فعليًا.",
      "notification_overpaid_deposit":
          "استلمنا {{paid}} {{symbol}}، وهو أكثر من {{amount}} {{symbol}} المطلوب. سيتم تسليم حوالتك بكامل المبلغ المستلم.",
      "KYC Approved": "تم قبول التحقق من الهوية",
      "KYC Rejected": "تم رفض التحقق من الهوية",
      "KYC Blocked": "تم حظر التحقق من الهوية",
      "KYC Unblocked": "تم رفع الحظر عن التحقق من الهوية",
      "KYC Verification Removed": "تم سحب التحقق من الهوية",
      "Account Blocked": "تم حظر الحساب",
      "Account Unblocked": "تم رفع الحظر عن الحساب",
      "notification_kyc_approved": "تم قبول التحقق من هويتك (KYC).",
      "notification_kyc_rejected":
          "تم رفض التحقق من هويتك (KYC).{{reasonClause}} يرجى إعادة رفع مستنداتك.",
      "notification_kyc_blocked":
          "تم حظر التحقق من هويتك (KYC).{{reasonClause}} تواصل مع الدعم لمزيد من التفاصيل.",
      "notification_kyc_unblocked":
          "تم رفع الحظر عن التحقق من هويتك (KYC). يرجى إعادة رفع مستنداتك لمتابعة عملية التحقق.",
      "notification_kyc_remove_verified":
          "تم سحب موافقة التحقق من هويتك (KYC).{{reasonClause}} يرجى إعادة رفع مستنداتك.",
      "notification_account_blocked":
          "تم حظر حسابك.{{reasonClause}} تواصل مع الدعم لمزيد من التفاصيل.",
      "notification_account_unblocked":
          "تم رفع الحظر عن حسابك. يمكنك الآن استخدام التطبيق بشكل طبيعي.",
      "Payment proof was added to your order by admin.":
          "تمت إضافة إثبات الدفع إلى طلبك من قبل الإدارة.",
      "external_payment_deposit_notice":
          "تم استلام دفع خارجي: {{amount}} {{currencyName}} في عنوان الدفع الخارجي: {{address}} على شبكة: {{network}}",
      "notification_deposit_message":
          "تم استلام دفع خارجي: {{amount}} {{currencyName}} على العنوان: {{address}} شبكة {{network}}",
      "notification_order_not_found":
          "تعذر العثور على الطلب المرتبط بهذا الإشعار",
      "order_details_section": "تفاصيل الطلب",
      "payment_notice_title": "إشعار الدفع",
      "order_share_privacy_note": "لا تشارك بيانات الطلب إلا مع المستفيد",
      "delivery_identity_note": "يتم التسليم بعد التأكد من الهوية",
      "secure_account_notice": "الحساب آمن",
      "external_payment_disclaimer":
          "أرسل المبلغ من محفظتك أو حساب منصّتك إلى العنوان الظاهر، وهو مخصّص لهذه الحوالة وحدها. يحتفظ تطبيق Hawwel بالمبلغ حتى تسليم حوالتك، ولا يعمل كبنك أو منصة تبادل، ولا يوفّر رصيداً في الحساب.",

      // Address
      "address": "العنوان",
      "enter_address": "العنوان",

      // Identity Verification
      "identity_verification": "التحقق من الهوية",

      // Register Screen
      "name_hint": "الاسم",
      "surname_hint": "الكنية",
      "country_hint": "البلد",
      "email_hint": "الإيميل",

      // Address
      "address_hint": "العنوان",

      // Copy to clipboard
      "copied_to_clipboard": "تم النسخ إلى الحافظة",

      // Payment Done
      "payment_completed": "اكتملت العملية",
      "you_paid": "لقد دفعت",

      // Confirm Password
      "new_password": "كلمة سر جديدة",
      "new_password_title": "كلمة المرور الجديدة",
      "enter_new_password": "أدخل كلمة مرور جديدة",
      "confirm_password": "تأكيد كلمة المرور",
      "at_least_8_chars": "على الأقل 8 رموز",

      // Review Transaction
      "review_transaction": "مراجعة تعليمات الطلبات",

      // Load File
      "go_to_home": "اذهب الى الصفحة الرئيسية",
      "complete_verification": "إتمام التحقق",

      // Sender Information
      "sender_data": "بيانات المرسل",
      "delivery_information": "معلومات التسليم",
      "full_name": "الاسم الثلاثي",
      "recipient_phone": "رقم هاتف المستلم",
      "saved_receivers": "المستلمون المحفوظون",
      "add_receiver": "إضافة",
      "payment_method": "طريقة الدفع",
      "transaction_details": "تفاصيل الطلب",
      "area_label": "المنطقة",
      "phone_label": "رقم الهاتف",
      "transfer_amount1": "قيمة  الطلب",
      "send_amount": "إرسال الكمية",

      // Review Transaction
      "recipient_receives": "المستفيد يتلقى",
      "beneficiary_data": "بيانات المستفيد",
      "confirm_send": "تأكيد الأرسال",

      // Identity Verification
      "identity_verification_title": "التحقق من الهوية",
      "not_verified_yet": "لم يتم التحقق بعد يرجى استكمال",
      "steps_to_complete_transfers": "الخطوات لإتمام  الطلبات",
      "identity_information": "معلومات الهوية",
      "uploading_now": "يتم التحميل الآن",
      "upload_completed": "تم التحميل",
      "upload_documents_residence": "تحميل المستندات ( الإقامة )",

      // OTP
      "request_new_code": "طلب رمز جديد",
      "New user": "مستخدم جديد",
      // 'resend_code': 'أعد الإرسال',
      "please_resend_after_seconds": "فضلًا أعد الطلب بعد {seconds} ثانية",
      "If you do not receive the verification code": "اذا لم تتلقى رمز التحقق ",
      "resend": "أعد الإرسال",
      "enter_verification_code_hint": "أدخل كود التحقق",
      "phone_number_hint": "رقم الجوال",
      "password_hint": "كلمة المرور",
      "confirm_password_hint": "تأكيد كلمة المرور",

      // Notifications
      "transfer_completed": "عملية طلب مكتملة",
      "minutes_ago": "منذ {minutes} دقائق 🕒",

      "hours_ago": "منذ {count} ساعة",
      "days_ago": "منذ {count} يوم",
    },
  };

  /// API order status codes → localized string (list + detail screens).
  static String transferStatusLabel(BuildContext context, String raw) {
    const keys = <String, String>{
      'pending': 'transfer_status_pending',
      'full-paid': 'transfer_status_full_paid',
      'under-paid': 'transfer_status_under_paid',
      'over-paid': 'transfer_status_over_paid',
      'cancelled': 'transfer_status_cancelled',
      'expired': 'transfer_status_expired',
      'compleated': 'transfer_status_completed',
      'completed': 'transfer_status_completed',
      'preparing-address': 'transfer_status_preparing_address',
      'preparing_address': 'transfer_status_preparing_address',
      'address-preparing': 'transfer_status_preparing_address',
      'can-receive': 'transfer_status_can_receive',
      'can_receive': 'transfer_status_can_receive',
      'ready-to-receive': 'transfer_status_can_receive',
      'ready_to_receive': 'transfer_status_can_receive',
      'received': 'transfer_status_received',
      'is-received': 'transfer_status_received',
      'is_received': 'transfer_status_received',
      'dispute': 'transfer_status_dispute',
      'rejected': 'transfer_status_dispute',
      'conflict': 'transfer_status_dispute',
    };
    final k = keys[raw.trim().toLowerCase()];
    if (k != null) return getTextStatic(context, k);
    return raw;
  }

  static String getTextStatic(BuildContext context, String key) {
    final language = context.read<LanguageCubit>().state;
    final locale = language == Language.english ? 'en' : 'ar';
    return _localizedValues[locale]?[key] ?? key;
  }

  static String getText(
    BuildContext context,
    String key, {
    Map<String, String>? replacements,
  }) {
    final language = context.watch<LanguageCubit>().state;
    final locale = language == Language.english ? 'en' : 'ar';
    String text = _localizedValues[locale]?[key] ?? key;

    if (replacements != null) {
      replacements.forEach((placeholder, value) {
        text = text.replaceAll('{$placeholder}', value);
      });
    }

    return text;
  }
}
