# Google Play – بيانات القائمة والنماذج (Hawwel 1.1.1+27)

الملفات في هذا المجلد:
- `icon_512.png` – أيقونة التطبيق (512×512، PNG).
- `feature_graphic_1024x500.png` – الصورة المميزة.
- `../../build/app/outputs/bundle/release/app-release.aab` – ملف الرفع.

الروابط المطلوبة في القائمة:
- سياسة الخصوصية: https://hawwelapp.com/privacy
- حذف الحساب (Data safety → Account deletion): https://hawwelapp.com/delete-account
- الدعم: https://hawwelapp.com/support

---

## 1. Store listing

**اسم التطبيق (30 حرفاً):** `Hawwel حوّل`

**الوصف المختصر (80 حرفاً):**
- EN: `Send value in USDT/USDC, delivered as cash to your recipient in Syria.`
- AR: `أرسل قيمة بعملة USDT/USDC وتُسلَّم نقداً للمستلم داخل سوريا.`

**الوصف الكامل – EN:**

```
Hawwel lets you send value to family and friends in Syria. You pay with a
stablecoin (USDT or USDC) from your own external wallet or exchange, and
Hawwel's delivery network hands the equivalent amount in cash to your
recipient at their city and region.

How it works
• Create an account and verify your identity (KYC) once.
• Enter the amount, the recipient and the delivery city/region.
• Hawwel shows a one-time payment address and network. Send the amount from
  your external wallet or exchange.
• Track the transfer status in the app and receive notifications at every
  step. When it is delivered, you get a delivery notice you can share.

Good to know
• Hawwel does not hold a balance for you, does not provide a custodial
  wallet, and is not a bank or an exchange. Each payment address is
  generated for a single transfer.
• Identity verification is required by our AML/KYC policy before the first
  transfer: https://hawwelapp.com/aml-kyc
• You can request deletion of your account from inside the app or at
  https://hawwelapp.com/delete-account

Operated by E-Platform Solutions. Support: https://hawwelapp.com/support
```

**الوصف الكامل – AR:**

```
حوّل يتيح لك إرسال قيمة مالية إلى أهلك وأصدقائك في سوريا. تدفع بعملة
مستقرة (USDT أو USDC) من محفظتك أو منصتك الخارجية، وتقوم شبكة التوصيل
الخاصة بحوّل بتسليم المبلغ المعادل نقداً للمستلم في مدينته ومنطقته.

كيف يعمل
• أنشئ حساباً ووثّق هويتك (KYC) مرة واحدة.
• أدخل المبلغ والمستلم ومدينة/منطقة التسليم.
• يعرض لك التطبيق عنوان دفع لمرة واحدة والشبكة. أرسل المبلغ من محفظتك
  أو منصتك الخارجية.
• تابع حالة الحوالة داخل التطبيق واستلم إشعاراً عند كل خطوة. عند التسليم
  يصلك إشعار تسليم يمكنك مشاركته.

من المهم معرفته
• حوّل لا يحتفظ برصيد لك، ولا يوفّر محفظة وصاية، وليس بنكاً أو منصة تداول.
  كل عنوان دفع يُنشأ لحوالة واحدة فقط.
• توثيق الهوية مطلوب وفق سياسة مكافحة غسل الأموال ومعرفة العميل قبل أول
  حوالة: https://hawwelapp.com/aml-kyc
• يمكنك طلب حذف حسابك من داخل التطبيق أو عبر
  https://hawwelapp.com/delete-account

تشغيل: E-Platform Solutions. الدعم: https://hawwelapp.com/support
```

**الفئة:** Finance. **الوسوم:** Money transfer, Remittance.

**لقطات الشاشة (هاتف):** 2 على الأقل، 8 كحد أقصى، بنسبة 16:9 إلى 9:16، كل ضلع بين 320 و3840 بكسل. الشاشات المقترحة بالترتيب: تسجيل الدخول، إدخال المبلغ والمستلم، عنوان الدفع والشبكة، سجل الحوالات، تفاصيل حوالة مسلَّمة، إشعار التسليم القابل للمشاركة.

---

## 2. App content (الأسئلة التي يجب الإجابة عنها قبل الرفع)

### Privacy policy
`https://hawwelapp.com/privacy`

### App access
- اختر: **All or some functionality is restricted**.
- أضف Instructions: اسم المستخدم وكلمة مرور حساب المراجعة (الذي ينشئه
  `scripts/create-reviewer-user.js`). اكتب ملاحظة:
  `Login with email + password. 2FA is disabled and KYC is pre-approved on
  this account, so no OTP is needed. Creating a transfer shows a payment
  address; no real payment is required to review the flow.`

### Ads
- **No, my app does not contain ads.**

### Content rating (IARC)
- الفئة: Utility / Productivity / Communication / Other → لا عنف، لا محتوى
  جنسي، لا مقامرة. سؤال "هل يسمح التطبيق بتبادل أموال أو عملات رقمية؟" →
  **نعم** (هذا لا يرفع التصنيف لكنه يجب أن يكون صادقاً).

### Target audience
- **18 and over** فقط. لا تختر أي فئة أقل من 18.

### News app: لا. COVID-19: لا. Government app: لا.

### Data safety
**Does your app collect or share any of the required user data types?** نعم.
**Is all user data encrypted in transit?** نعم.
**Do you provide a way for users to request that their data is deleted?** نعم
(رابط `https://hawwelapp.com/delete-account` + من داخل التطبيق).

البيانات المجموعة (Collected، ليست Shared، ما لم يُذكر):

| النوع | الغرض | إلزامي؟ |
|---|---|---|
| Personal info → Name | App functionality, Account management | نعم |
| Personal info → Email address | Account management | اختياري |
| Personal info → Phone number | Account management, App functionality | نعم |
| Personal info → User IDs (رقم الحساب) | Account management | نعم |
| Personal info → Other (اسم الأب، بلد الإقامة) | Fraud prevention, security, compliance | نعم |
| Financial info → Other financial info (بيانات الحوالات: المبلغ، العملة، المستلم) | App functionality | نعم |
| Photos and videos → Photos (وثيقة الهوية، السيلفي، صورة الملف الشخصي) | Fraud prevention, security, compliance | نعم للتوثيق |
| App info and performance → Crash logs | لا يُجمع (لا يوجد Crashlytics) | – |
| Device or other IDs → (رمز FCM للإشعارات) | App functionality | نعم |
| Messages → Other in-app messages (محادثة الدعم) | App functionality, Customer support | لا |

Shared: لا شيء يُشارك مع أطراف ثالثة. (Firebase Cloud Messaging يعالج رمز
الجهاز فقط كمزوّد خدمة، وهذا لا يُعدّ Sharing وفق تعريف Google.)

### Financial features (إقرار الميزات المالية)
- **Does your app provide any financial features?** نعم.
- اختر: **Money transfer / remittance** و**Cryptocurrency exchange
  or facilitation of cryptocurrency transactions** (كلاهما، لأن الدفع بعملة
  مستقرة والتسليم نقداً).
- لا تختر: Loans، Banking، Insurance، Investing.
- ستُسأل عن التراخيص حسب دول التوزيع. جهّز: اسم الجهة المشغّلة، بلد
  التسجيل، رقم التسجيل/الترخيص إن وُجد، ورابط صفحة AML/KYC.

### Countries / regions
- ابدأ بقائمة محدودة تعرف وضعها القانوني (دول المرسلين الأساسيين). لا تختر
  "All countries". يمكن التوسّع لاحقاً دون مراجعة جديدة للتطبيق.

---

## 3. الرفع

1. Play Console → Create app → اسم `Hawwel حوّل` → App / Free → أقرّ
   بالسياسات.
2. Setup → App integrity → **Play App Signing**: استخدم الخيار الافتراضي
   (Google تحفظ مفتاح التوقيع النهائي، ومفتاحك الحالي يصبح Upload key).
   المفتاح الحالي في `android/key.properties` هو مفتاح الرفع، احتفظ به.
3. Test and release → **Internal testing** → Create release → ارفع
   `app-release.aab` → Release notes: `First public build (1.1.1).`
4. أضف بريدك وبريد الفريق كمختبرين داخليين وثبّت من رابط Play للتأكد من
   التثبيت والدخول بحساب المراجعة.
5. عند نجاح ذلك: Production → Create release → اختر نفس الـAAB → Review
   release → Start rollout.
