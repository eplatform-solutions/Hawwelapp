export type Lang = "ar" | "en";

type Entry = {
  ar: string | string[];
  en: string | string[];
};

export const translations = {
  "common.operator": {
    ar: "تطبيق Hawwel App يُشغَّل من قِبل E-Platform Solutions UAB.",
    en: "Hawwel App is operated by E-Platform Solutions UAB.",
  },
  "common.operator.short": {
    ar: "مُشغَّل من قِبل E-Platform Solutions UAB",
    en: "Operated by E-Platform Solutions UAB",
  },
  "common.legalNote": {
    ar: "يُشغَّل Hawwel App من قِبل E-Platform Solutions UAB.",
    en: "Operated by E-Platform Solutions UAB.",
  },
  "common.disclaimer": {
    ar: "يوفّر Hawwel App واجهة رقمية لإنشاء الطلبات وتتبّعها، ويرتّب تسليم المبلغ المقابل نقدًا إلى المستلم. Hawwel App ليس بنكًا ولا مؤسسة قبض ودائع ولا منصّة تبادل عملات مشفّرة ولا مزوّد قروض أو ائتمان أو استثمار، ولا يوفّر محفظة دائمة أو رصيدًا في الحساب. لتنفيذ الحوالة، يُصدر Hawwel App عنوان إيداع يُستخدم مرة واحدة ويسيطر عليه، ويحتفظ بالأموال المُستلَمة للمدة اللازمة لإتمام تلك الحوالة فقط.",
    en: "Hawwel App provides a digital request creation and tracking interface, and arranges delivery of the corresponding amount in cash to the recipient. Hawwel App is not a bank, deposit-taking institution, crypto exchange, lending provider, credit provider, or investment service, and does not offer an ongoing wallet or account balance. To carry out a transfer, Hawwel App issues a single-use deposit address that it controls and holds the funds received only for as long as is needed to complete that transfer.",
  },
  "common.companyWebsite": {
    ar: "موقع الشركة",
    en: "Company website",
  },
  "common.skipToContent": {
    ar: "تخطّي إلى المحتوى",
    en: "Skip to content",
  },
  "common.languageSwitcherLabel": {
    ar: "تبديل اللغة",
    en: "Switch language",
  },
  "common.closeMenu": { ar: "إغلاق القائمة", en: "Close menu" },
  "common.openMenu": { ar: "فتح القائمة", en: "Open menu" },
  "common.copyright": {
    ar: "© {year} E-Platform Solutions UAB. جميع الحقوق محفوظة.",
    en: "© {year} E-Platform Solutions UAB. All rights reserved.",
  },

  "nav.home": { ar: "الرئيسية", en: "Home" },
  "nav.howItWorks": { ar: "طريقة العمل", en: "How it works" },
  "nav.regions": { ar: "المناطق المتاحة", en: "Available regions" },
  "nav.learn": { ar: "تعلّم", en: "Learn" },
  "nav.support": { ar: "الدعم", en: "Support" },
  "nav.legal": { ar: "الإشعار القانوني", en: "Legal Notice" },
  "nav.contact": { ar: "تواصل معنا", en: "Contact" },

  "footer.product": { ar: "المنتج", en: "Product" },
  "footer.legal": { ar: "قانوني", en: "Legal" },
  "footer.help": { ar: "المساعدة", en: "Help" },
  "footer.privacy": { ar: "سياسة الخصوصية", en: "Privacy Policy" },
  "footer.terms": { ar: "الشروط والأحكام", en: "Terms & Conditions" },
  "footer.termsOfService": { ar: "شروط الخدمة", en: "Terms of Service" },
  "footer.supportContact": { ar: "الدعم / تواصل معنا", en: "Support / Contact Us" },
  "footer.legalNotice": { ar: "الإشعار القانوني", en: "Legal Notice" },
  "footer.amlKyc": { ar: "سياسة AML / KYC", en: "AML / KYC Policy" },
  "footer.support": { ar: "الدعم", en: "Support" },
  "footer.companyWebsite": { ar: "موقع الشركة", en: "Company website" },
  "footer.contact": { ar: "تواصل معنا", en: "Contact" },
  "footer.disclaimer": {
    ar: "يوفّر Hawwel App واجهة رقمية لإنشاء الطلبات وتتبّعها، ويرتّب تسليم المبلغ المقابل نقدًا إلى المستلم. Hawwel App ليس بنكًا ولا مؤسسة قبض ودائع ولا منصّة تبادل عملات مشفّرة ولا مزوّد قروض أو ائتمان أو استثمار، ولا يوفّر محفظة دائمة أو رصيدًا في الحساب. تموّل الحوالة من محفظتك أو حساب منصّتك إلى عنوان يُستخدم مرة واحدة يُصدره Hawwel App، ويحتفظ بالمبلغ حتى تسليم تلك الحوالة فقط.\n\nيُشغَّل Hawwel App من قِبل E-Platform Solutions UAB. تعتمد الإتاحة على المنطقة ومتطلبات التحقق والامتثال.",
    en: "Hawwel App provides a digital request creation and tracking interface, and arranges delivery of the corresponding amount in cash to the recipient. Hawwel App is not a bank, deposit-taking institution, crypto exchange, lending provider, credit provider, or investment service, and does not offer an ongoing wallet or account balance. You fund a transfer from your own wallet or exchange account to a single-use address issued by Hawwel App, which holds the amount only until that transfer is delivered.\n\nHawwel App is operated by E-Platform Solutions UAB. Availability depends on region, verification, and compliance requirements.",
  },

  "store.appStore.title": { ar: "App Store", en: "App Store" },
  "store.googlePlay.title": { ar: "Google Play", en: "Google Play" },
  "store.comingSoon": { ar: "قريبًا", en: "Coming soon" },
  "store.noLink": { ar: "بدون رابط متجر حاليًا", en: "No store link yet" },
  "store.comingSoonBanner": {
    ar: "سيُتوفر التطبيق قريبًا على App Store و Google Play.",
    en: "Coming soon on the App Store and Google Play.",
  },
  "store.androidDirect.title": {
    ar: "تحميل مباشر لأندرويد (APK)",
    en: "Direct download for Android (APK)",
  },
  "store.androidDirect.note": {
    ar: "تحميل مباشر خارج Google Play — قد يطلب جهازك السماح بالتثبيت من مصادر غير معروفة.",
    en: "Direct download outside Google Play — your device may ask you to allow installs from unknown sources.",
  },

  "home.hero.eyebrow": {
    ar: "واجهة طلب للتحويل الرقمية",
    en: "Digital transfer request interface",
  },
  "home.hero.title": {
    ar: "Hawwel App",
    en: "Hawwel App",
  },
  "home.hero.subtitle": {
    ar: "أنشئ طلبات تحويل رقمية وتتبّع حالتها مع خطوات واضحة وتحديثات شفافة للحالة، وأسعارًا إرشادية وتدفق دفع خارجي حيث يكون ذلك مدعومًا، وتوفُّرًا وفق المنطقة، ودعمًا بشريًا.",
    en: "Create and track digital transfer requests with clear steps, transparent status updates, indicative rates, external payment flow where supported, region-based availability, and human support.",
  },
  "home.hero.cta.primary": {
    ar: "إنشاء طلب",
    en: "Create a Request",
  },
  "home.hero.cta.secondary": { ar: "طريقة العمل", en: "How It Works" },

  "home.mockup.statusLabel": { ar: "حالة الطلب", en: "Request status" },
  "home.mockup.statusValue": { ar: "قيد المراجعة", en: "Under review" },
  "home.mockup.regionLabel": { ar: "المنطقة المدعومة", en: "Supported region" },
  "home.mockup.regionValue": { ar: "منطقة استلام محلية", en: "Local payout area" },
  "home.mockup.verificationLabel": { ar: "التحقق", en: "Verification" },
  "home.mockup.verificationValue": { ar: "عند الحاجة", en: "When required" },
  "home.mockup.supportLabel": { ar: "الدعم", en: "Support" },
  "home.mockup.supportValue": { ar: "متاح", en: "Available" },
  "home.mockup.disclaimer": {
    ar: "نموذج توضيحي. لا يعرض أرصدة أو تحويلات مكتملة أو وعودًا مالية.",
    en: "Illustrative preview. No balances, completed payouts, or financial promises are shown.",
  },

  "home.supportStrip.eyebrow": {
    ar: "دعم بشري",
    en: "Human support",
  },
  "home.supportStrip.title": {
    ar: "فريق مساعدة يعمل ضمن سياسات الامتثال",
    en: "Guided help grounded in operational compliance",
  },
  "home.supportStrip.body": {
    ar: "يساعدك فريق الدعم على الوصول لوظائف Hawwel App وشرح حالة الطلبات حيث يمكن، دون تجاوز فحوصات التحقق.",
    en: "Support teammates walk you through Hawwel App tooling and timelines while honoring verification and AML reviews.",
  },
  "home.trustEyebrow": {
    ar: "الموثوقية والمسؤولية",
    en: "Trust & safety",
  },

  "home.trust.title": {
    ar: "مصمَّم للوضوح والاستخدام المسؤول",
    en: "Built for clarity and responsible use",
  },
  "home.trust.subtitle": {
    ar: "يساعد Hawwel App على إنشاء طلبات تحويل رقمية وتتبّع الحالة. تعتمد الإتاحة على الدولة والمنطقة وحالة التحقق والفحوصات الامتثالية. قد نطلب مستندات هوية أو معلومات مصدر أموال أو غرض التحويل عند الحاجة.",
    en: "Hawwel App helps users create and track digital transfer requests. Availability may depend on country, region, verification status, and compliance checks. We may request additional information such as identity documents, source of funds, or transfer purpose when required.",
  },
  "home.trust.card1.title": { ar: "أسعار إرشادية", en: "Indicative rates" },
  "home.trust.card1.text": {
    ar: "يطّلع المستخدم على الأسعار الإرشادية ومؤشرات المنطقة قبل إنشاء الطلب حيث تسمح القوانين المحلية بتقديمها.",
    en: "Users can review indicative rates and region guidance before creating a request subject to local disclosures.",
  },
  "home.trust.card2.title": { ar: "تتبّع الحالة", en: "Transparent status" },
  "home.trust.card2.text": {
    ar: "تجد آخر مستجدّات الطلب داخل لوحة واحدة لتفادي الالتباس.",
    en: "See consolidated status timelines so steps and reviews are understandable.",
  },
  "home.trust.card3.title": { ar: "دفع خارجي حيث ينطبق", en: "External payment flow" },
  "home.trust.card3.text": {
    ar: "حيث يكون ذلك مدعومًا يُكمَل جزء الدفع خارج التطبيق عبر وسيلة المستخدم أو منصّته وفق التعليمات المعروضة.",
    en: "Where supported, completion steps referencing payment occur outside Hawwel App via the user’s own wallet or exchange as instructed.",
  },
  "home.trust.card4.title": { ar: "دعم بشري", en: "Human support" },
  "home.trust.card4.text": {
    ar: "فريق الدعم يمكنه مساعدتك ضمن سياسات الامتثال دون تجاوز فحص التحقق.",
    en: "Support teammates help with onboarding and FAQs while adhering to AML/KYC requirements.",
  },

  "home.steps.title": { ar: "طريقة العمل باختصار", en: "How it works summary" },
  "home.steps.subtitle": {
    ar: "ست خطوات واضحة حتى الوصول لتعليمات إكمال الطلب.",
    en: "Six clear steps—from checking rates through tracking—to completion.",
  },
  "home.steps.list": {
    ar: [
      "اطّلع على الأسعار الإرشادية حيث تُعرض",
      "اختر منطقة الاستلام أو موقع الوكيل حيث ينطبق ذلك",
      "أدخل بيانات المستلم",
      "أنشئ طلب التحويل الرقمي",
      "حيث يكون ذلك مدعومًا، أكمل الدفع خارج التطبيق عبر المحفظة أو المنصّة الخاصة بك",
      "تابع حالة الطلب حتى الإكمال",
    ],
    en: [
      "Check indicative rates where displayed",
      "Choose the payout region or agent location where applicable",
      "Enter recipient details",
      "Create your digital transfer request",
      "Complete payment externally from your own wallet or exchange account where supported",
      "Track your request status until completion",
    ],
  },

  "home.why.title": { ar: "لماذا Hawwel App", en: "Why Hawwel App" },
  "home.why.list": {
    ar: [
      "أسعار واضحة قبل إنشاء الطلب",
      "مناطق مدعومة مختارة",
      "تجربة مستخدم مناسبة للعربية",
      "تحديثات لحالة الطلب",
      "دعم بالعربية والإنجليزية",
      "إجراءات تحقق وامتثال عند الحاجة",
    ],
    en: [
      "Clear rates before creating a request",
      "Selected supported regions",
      "Arabic-friendly user experience",
      "Status updates",
      "Support in Arabic and English",
      "Verification and compliance checks where required",
    ],
  },

  "home.regionsTeaser.title": { ar: "المناطق المدعومة", en: "Supported regions" },
  "home.regionsTeaser.body": {
    ar: "تتغيّر المناطق والقنوات المتاحة بحسب التشغيل والامتثال المحلي. اطّلع على التفاصيل الحالية من صفحة المناطق.",
    en: "Regions and availability depend on operations and local compliance. Review the latest coverage on the regions page.",
  },

  "hiw.title": { ar: "كيف يعمل Hawwel App", en: "How Hawwel App works" },
  "hiw.intro": {
    ar: "يعرض Hawwel App خطوات إنشاء طلب تحويل رقمي وتتبّع حالته مع تدفق دفع خارجي حيث يكون ذلك مدعومًا.",
    en: "Hawwel App walks you through creating a digital transfer request, completing payment externally where supported, and tracking status to completion.",
  },
  "hiw.step1.title": { ar: "اطّلع على الأسعار الإرشادية", en: "Check indicative rates" },
  "hiw.step1.text": {
    ar: "راجع الأسعار والمعلومات الإرشادية المتاحة داخل التطبيق قبل تأكيد الطلب حيث تُعرض.",
    en: "Review indicative rates and guidance shown in-app before confirming a request.",
  },
  "hiw.step2.title": {
    ar: "اختر منطقة الاستلام أو موقع الوكيل",
    en: "Choose the payout region or agent location",
  },
  "hiw.step2.text": {
    ar: "حدّد المنطقة أو مسار الوكيل المتوافق مع الفحص الامتثالي وحالة حسابك.",
    en: "Select an eligible payout path based on verification and screening results.",
  },
  "hiw.step3.title": { ar: "أدخل بيانات المستلم", en: "Enter recipient details" },
  "hiw.step3.text": {
    ar: "أدخل بيانات التحويل المطلوبة بدقة حيث تطلب سياسات مكافحة الاحتيال ذلك.",
    en: "Submit recipient information accurately consistent with AML and fraud‑prevention needs.",
  },
  "hiw.step4.title": { ar: "أنشئ طلب التحويل الرقمي", en: "Create your transfer request" },
  "hiw.step4.text": {
    ar: "أكمل المراجعة الداخلية للطلب وفق المتاح في الواجهة قبل المتابعة لخطوة الدفع.",
    en: "Finalize the structured request preview before moving toward payment stages.",
  },
  "hiw.step5.title": {
    ar: "أتمِم الدفع خارج التطبيق",
    en: "Complete payment externally",
  },
  "hiw.step5.text": {
    ar: "اتبع التعليمات لإرسال المبلغ من محفظتك أو منصّتك إلى العنوان المخصّص لهذه الحوالة. يحتفظ Hawwel App بالمبلغ حتى تسليم حوالتك فقط، وهو ليس محفظة تحتفظ فيها برصيد.",
    en: "Follow the instructions to pay from your own wallet or exchange to the single-use address shown. Hawwel App holds that amount only until your transfer is delivered; it is not a wallet you keep a balance in.",
  },
  "hiw.step6.title": { ar: "تابع الحالة حتى الإكمال", en: "Track status until completion" },
  "hiw.step6.text": {
    ar: "راقب التحديثات داخل سجل الطلب حتى تصل إلى حالة الإكمال أو تتلقى التعليمات التالية.",
    en: "Monitor timeline updates until the request reaches completion or you receive the next instruction.",
  },

  "hiw.footerHint": {
    ar: "للحصول على تفاصيل المشغِّل والسياسات المعمول بها، انتقل إلى الإشعار القانوني أو صفحة الدعم.",
    en: "Visit the legal notice or contact support for operator details and enforced policies.",
  },

  "regions.title": { ar: "المناطق المتاحة", en: "Available regions" },
  "regions.intro": {
    ar: "قد يدعم Hawwel App مناطق استلام مختارة تبعًا لتوفّر التشغيل، والمتطلبات المحلية، والفحوصات اللازمة، وإجراءات الامتثال.",
    en: "Hawwel App may support selected payout regions depending on operational availability, local requirements, screening, and compliance obligations.",
  },
  "regions.card1": { ar: "مناطق استلام مختارة", en: "Selected recipient regions" },
  "regions.card2": { ar: "مناطق دفع محلية", en: "Local payout areas" },
  "regions.card3": { ar: "قد تتوفر مناطق إضافية لاحقًا", en: "More regions may become available" },
  "regions.cardStatus.available": { ar: "متاحة", en: "Available" },
  "regions.cardStatus.planned": { ar: "قيد التوسّع", en: "Planned" },
  "regions.note": {
    ar: "قد تتغيّر المناطق المتاحة في أي وقت. وقد تتطلب بعض المناطق تحققًا إضافيًا، وقد لا تكون متاحة لجميع المستخدمين.",
    en: "Availability may change at any time. Some regions may require additional verification or may not be available for all users.",
  },

  "support.title": { ar: "الدعم", en: "Support" },
  "support.intro": {
    ar: "تحتاج مساعدة في Hawwel App؟ يوجِّه فريق الدعم المستخدمين خلال الأسئلة الشائعة، وحالة الطلبات حيث يمكن، وخطوات الاتصال الرسمية دون تجاوز الامتثال.",
    en: "Need help with Hawwel App? Support teammates answer navigation questions, escalate privacy topics, and describe request timelines without overriding compliance safeguards.",
  },
  "support.contactCard.title": { ar: "قنوات التواصل", en: "Contact channels" },
  "support.contactCard.supportLabel": { ar: "الدعم", en: "Support" },
  "support.contactCard.privacyLabel": { ar: "الخصوصية", en: "Privacy" },
  "support.operator.title": { ar: "المُشغِّل", en: "Operator" },
  "support.faq.title": { ar: "الأسئلة الشائعة", en: "Frequently asked questions" },
  "support.faq.q1": { ar: "هل Hawwel App بنك؟", en: "Is Hawwel App a bank?" },
  "support.faq.a1": {
    ar: "لا. Hawwel App واجهة رقمية مُشغّلة من قِبل E-Platform Solutions UAB لإنشاء طلب التحويل الرقمية وتتبّع الحالة وليست جهة قبض أو مصرف تجزئة.",
    en: "No. Hawwel App is operated by E-Platform Solutions UAB as a structured interface for initiating and observing digital transfer requests—not a chartered bank.",
  },
  "support.faq.q2": { ar: "هل يحتفظ Hawwel App بأموالي؟", en: "Does Hawwel App hold my funds?" },
  "support.faq.a2": {
    ar: "خلال مدة الحوالة فقط. لا يوفّر Hawwel App محفظة تحتفظ فيها برصيد. المبلغ الذي ترسله يُستلَم على عنوان يُستخدم مرة واحدة، ويُحتفَظ به حتى تسليم تلك الحوالة، ثم يُسلَّم. ولا يوجد رصيد محفوظ بين حوالة وأخرى.",
    en: "Only for the duration of a transfer. Hawwel App does not offer a wallet you can keep a balance in. The amount you send is received at a single-use address, held until that transfer is delivered, and then paid out. There is no stored balance between transfers.",
  },
  "support.faq.q3": { ar: "لماذا قد يُطلب مني التحقق؟", en: "Why may I be asked for verification?" },
  "support.faq.a3": {
    ar: "قد يُطلب التحقق تبعًا للمبلغ، والمنطقة، ومستوى المخاطر، والمتطلبات القانونية المعمول بها.",
    en: "Verification may be required depending on the amount, region, risk level, and applicable legal requirements.",
  },
  "support.faq.q4": { ar: "هل يستطيع جميع المستخدمين استخدام جميع المناطق؟", en: "Can all users use all regions?" },
  "support.faq.a4": {
    ar: "لا. تعتمد الإتاحة على دولة المستخدم، ومنطقة المستلم، ومستوى التحقق، وتوفّر التشغيل، والفحوصات اللازمة، والقوانين المعمول بها.",
    en: "No. Availability depends on the user's country, recipient region, verification level, operational availability, screening, and applicable laws.",
  },

  "contact.title": { ar: "تواصل معنا", en: "Contact" },
  "contact.intro": {
    ar: "للأسئلة والاستفسارات، يمكنك التواصل معنا عبر إحدى القنوات التالية.",
    en: "For questions and inquiries, you can reach us through one of the channels below.",
  },
  "contact.supportLabel": { ar: "الدعم", en: "Support" },
  "contact.privacyLabel": { ar: "الخصوصية", en: "Privacy" },
  "contact.legalLabel": { ar: "القانوني", en: "Legal" },
  "contact.operatorLabel": { ar: "المُشغِّل", en: "Operator" },
  "contact.form.title": { ar: "إرسال رسالة", en: "Send a message" },
  "contact.form.name": { ar: "الاسم", en: "Name" },
  "contact.form.email": { ar: "البريد الإلكتروني", en: "Email" },
  "contact.form.subject": { ar: "الموضوع", en: "Subject" },
  "contact.form.message": { ar: "الرسالة", en: "Message" },
  "contact.form.button": { ar: "إرسال الرسالة", en: "Send message" },
  "contact.form.note": {
    ar: "هذا النموذج عرض بصري مؤقت. للتواصل، يُرجى استخدام البريد الإلكتروني في الوقت الحالي.",
    en: "This form is a visual placeholder. For now, please contact us by email.",
  },
  "contact.form.namePh": { ar: "اسمك الكامل", en: "Your full name" },
  "contact.form.emailPh": { ar: "name@example.com", en: "name@example.com" },
  "contact.form.subjectPh": { ar: "موضوع الرسالة", en: "Subject" },
  "contact.form.messagePh": { ar: "اكتب رسالتك هنا…", en: "Write your message here…" },

  "legal.title": { ar: "الإشعار القانوني", en: "Legal Notice" },
  "legal.s1.title": { ar: "العلامة والمُشغِّل", en: "Brand and operator" },
  "legal.s1.body": {
    ar: "Hawwel App هو اسم المنتج المُقدَّم للمستخدمين. يُشغَّل Hawwel App من قِبل E-Platform Solutions UAB («المُشغِّل»).",
    en: "Hawwel App is the consumer-facing product brand. Hawwel App is operated by E-Platform Solutions UAB (“Operator”).",
  },
  "legal.s2.title": { ar: "الموقع الإلكتروني", en: "Website" },
  "legal.s2.body": {
    ar: "الموقع الرسمي للمنتج: hawwelapp.com. الموقع المرجعي للمُشغِّل: https://eplatform-solutions.com",
    en: "Official product website: hawwelapp.com. Operator reference website: https://eplatform-solutions.com",
  },
  "legal.s3.title": { ar: "التواصل", en: "Contact" },
  "legal.s3.body": {
    ar: "الدعم العام: support@hawwelapp.com. الخصوصية: privacy@hawwelapp.com. القانوني والامتثال: legal@hawwelapp.com",
    en: "General support: support@hawwelapp.com. Privacy: privacy@hawwelapp.com. Legal and compliance: legal@hawwelapp.com",
  },
  "legal.s4.title": { ar: "طبيعة الخدمة", en: "Nature of the service" },
  "legal.s4.body": {
    ar: "يوفّر Hawwel App واجهة رقمية لإنشاء طلبات تحويل رقمية وتتبّع حالتها وتحديثاتها والدعم، إضافة إلى شبكة تُسلّم المبلغ المقابل نقدًا إلى المستلم. Hawwel App ليس بنكًا ولا مؤسسة قبض ودائع ولا منصّة تبادل عملات مشفّرة ولا مزوّد قروض أو ائتمان أو استثمار، ولا يوفّر محفظة دائمة أو رصيدًا في الحساب. لتنفيذ الحوالة، يُصدر Hawwel App عنوان إيداع يُستخدم مرة واحدة ويسيطر عليه، ويحتفظ بالأموال المُستلَمة للمدة اللازمة لإتمام تلك الحوالة فقط.",
    en: "Hawwel App provides a digital interface to create digital transfer requests, track status updates, and receive support, together with a network that delivers the corresponding amount in cash to the recipient. Hawwel App is not a bank, deposit-taking institution, crypto exchange, lending provider, credit provider, or investment service, and does not offer an ongoing wallet or account balance. To carry out a transfer, Hawwel App issues a single-use deposit address that it controls, and holds the funds received only for as long as is needed to complete that transfer.",
  },
  "legal.s5.title": { ar: "الإتاحة", en: "Availability" },
  "legal.s5.body": {
    ar: "تعتمد إتاحة الميزات على المنطقة وحالة التحقق ومتطلبات الامتثال والمتطلبات التشغيلية. قد تختلف المناطق والقنوات المدعومة بمرور الوقت.",
    en: "Feature availability depends on region, verification status, compliance requirements, and operational requirements. Supported regions and channels may change over time.",
  },
  "legal.s6.title": { ar: "لا يُعدّ نصيحة مالية أو قانونية", en: "No financial, legal, tax, or investment advice" },
  "legal.s6.body": {
    ar: "لا يُشكّل أي محتوى على هذا الموقع أو داخل Hawwel App نصيحة مالية أو قانونية أو ضريبية أو استثمارية. أي أسعار أو مؤشرات أو حالة طلب معروضة قد تكون إرشادية وقابلة للتغيير.",
    en: "Nothing on this website or within Hawwel App constitutes financial, legal, tax, or investment advice. Any indicative rates, status information, or availability shown may change and is provided for transparency where permitted.",
  },
  "legal.s7.title": { ar: "العنوان المسجَّل", en: "Registered address" },
  "legal.s7.body": {
    ar: "[PLACEHOLDER — أضف عنوان الشركة المسجَّلة للمُشغِّل]",
    en: "[PLACEHOLDER — add the Operator’s registered company address]",
  },
  "legal.s8.title": { ar: "التحقق والمعلومات الإضافية", en: "Verification and additional information" },
  "legal.s8.body": {
    ar: "قد يطلب Hawwel App مستندات هوية أو بيانات مستلم أو معلومات مصدر أموال أو غرض الطلب عند الحاجة لأغراض التحقق والامتثال ومنع الإساءة.",
    en: "Hawwel App may request identity documents, recipient details, source-of-funds information, or request purpose information when required for verification, compliance, and abuse prevention.",
  },

  "aml.title": { ar: "سياسة AML / KYC", en: "AML / KYC Policy" },
  "aml.intro": {
    ar: "يلخّص هذا المستند نهج Hawwel App في التحقق ومكافحة الاحتيال والامتثال بلغة مبسّطة. لا يُفسر هذا المستند على أنه بيان بأن Hawwel App مرخّص كبنك أو ناقل أموال أو منصّة تبادل عملات مشفّرة أو محفظة وصيّنة أو مؤسسة مالية، إلا إذا نُشر ترخيص صريح في مكان آخر.",
    en: "This Policy summarizes Hawwel App’s verification, anti-fraud, and compliance approach in plain language. It does not state or imply that Hawwel App is licensed as a bank, money transmitter, crypto exchange, custodial wallet, or financial institution unless such licensing is expressly published elsewhere.",
  },
  "aml.disclaimer": {
    ar: "يوفّر Hawwel App واجهة رقمية لإنشاء الطلبات وتتبّعها، ويرتّب تسليم المبلغ المقابل نقدًا إلى المستلم. تموّل الحوالة من محفظتك أو حساب منصّتك إلى عنوان يُستخدم مرة واحدة يُصدره Hawwel App، ويحتفظ بالمبلغ حتى تسليم تلك الحوالة فقط.",
    en: "Hawwel App provides a digital request creation and tracking interface, and arranges delivery of the corresponding amount in cash to the recipient. You fund a transfer from your own wallet or exchange account to a single-use address issued by Hawwel App, which holds the amount only until that transfer is delivered.",
  },
  "aml.s1.title": { ar: "الغرض", en: "Purpose" },
  "aml.s1.body": {
    ar: "يطبّق Hawwel App إجراءات تحقق وفحص وضبط مخاطر للمساعدة في منع إساءة استخدام المنصّة، والاحتيال، وانتهاكات العقوبات، وغسل الأموال، وتمويل الإرهاب، وغيرها من الأنشطة المحظورة.",
    en: "Hawwel App applies verification, screening, and risk controls to help prevent misuse of the platform, fraud, sanctions breaches, money laundering, terrorism financing, and other prohibited activity.",
  },
  "aml.s2.title": { ar: "طبيعة Hawwel App", en: "Nature of Hawwel App" },
  "aml.s2.body": {
    ar: "Hawwel App منصّة لإنشاء طلبات تحويل رقمية وتتبّع حالتها وتحديثاتها والدعم، ولتسليم المبلغ المقابل نقدًا إلى المستلم. الأموال المُستلَمة لحوالة معيّنة يُحتفَظ بها حتى تسليم تلك الحوالة فقط، ولا يوفّر Hawwel App رصيدًا محفوظًا.",
    en: "Hawwel App is a platform for creating digital transfer requests, tracking status updates, and receiving support, and for delivering the corresponding amount in cash to the recipient. Funds received for a transfer are held only until that transfer is delivered; Hawwel App does not offer a stored balance.",
  },
  "aml.s3.title": { ar: "التحقق من الهوية", en: "Identity verification" },
  "aml.s3.body": {
    ar: "قد يطلب Hawwel App مستندات هوية أو معلومات تعريفية أو إثبات عنوان أو تحققًا إضافيًا وفق تقييم المخاطر.",
    en: "Hawwel App may request identity documents, identifying information, proof of address, or additional verification based on assessed risk.",
  },
  "aml.s4.title": { ar: "فحوصات قائمة على المخاطر", en: "Risk-based checks" },
  "aml.s4.body": {
    ar: "قد تتأثر المتطلبات بالأنماط الدورية، والمناطق، وسلوك المستخدم، ومعلومات من شركاء أو أدوات فحص حيث ينطبق ذلك.",
    en: "Requirements may depend on activity patterns, regions, user behaviour, and information from screening tools or partners where applicable.",
  },
  "aml.s5.title": { ar: "مصدر الأموال وغرض الطلب", en: "Source of funds and purpose of request" },
  "aml.s5.body": {
    ar: "قد نطلب وصفًا لغرض الطلب ومعلومات عن مصدر التمويل عند وجود متطلبات قانونية أو تشغيلية أو امتثالية.",
    en: "We may request the purpose of a request and information about funding sources when required for legal, operational, or compliance reasons.",
  },
  "aml.s6.title": {
    ar: "الرفض أو التأخير أو التعليق أو طلب معلومات إضافية",
    en: "Refusal, delay, suspension, or additional information",
  },
  "aml.s6.body": {
    ar: "قد نؤخر مراجعة طلب أو نرفضه أو نعلّق حسابًا أو نطلب معلومات إضافية عند نقص الوثائق أو عدم انسجامها مع المتطلبات القانونية أو الامتثالية أو التشغيلية أو متطلبات الشركاء.",
    en: "We may delay review, refuse a request, suspend an account, or request additional information when documents are incomplete or inconsistent with applicable legal, compliance, operational, or partner requirements.",
  },
  "aml.s7.title": { ar: "العقوبات والاستخدام المقيّد", en: "Sanctions and restricted use" },
  "aml.s7.body": {
    ar: "قد نمنع استخدامًا يتعلق بأشخاص أو كيانات خاضعة للعقوبات أو مناطق مقيّدة أو أنماط استخدام محظورة وفق القوائم والسياسات المعمول بها.",
    en: "We may restrict use involving sanctioned persons or entities, restricted regions, or prohibited use patterns according to applicable lists and policies.",
  },
  "aml.s8.title": { ar: "الاحتفاظ بالسجلات", en: "Record keeping" },
  "aml.s8.body": {
    ar: "قد نحتفظ بسجلات التحقق والامتثال للمدة اللازمة لأغراض الامتثال والأمان والتدقيق أو حسب ما يفرضه القانون.",
    en: "We may retain verification and compliance records for as long as necessary for compliance, security, audit, or as required by law.",
  },
  "aml.s9.title": { ar: "التعاون مع الطلبات القانونية", en: "Cooperation with lawful requests" },
  "aml.s9.body": {
    ar: "عند قبول طلبات أو أوامر قانونية مُعتمدة حيث يلزم، قد يتعاون فريق Hawwel App أو E-Platform Solutions UAB وفق متطلبات الإثبات وحماية البيانات حيث يفرض ذلك القانون.",
    en: "Where lawful and properly scoped, the Hawwel App team or E-Platform Solutions UAB may cooperate with competent authorities subject to procedural safeguards and applicable law.",
  },
  "aml.s10.title": { ar: "مسؤولية المستخدم عن دقة المعلومات", en: "User responsibility for accuracy" },
  "aml.s10.body": {
    ar: "يجب أن تكون المعلومات المقدّمة صادقة ومحدَّثة قدر الإمكان. قد يؤدي تقديم معلومات مضللة عمدًا إلى تعليق أو إنهاء الوصول.",
    en: "Information you provide must be truthful and kept up to date where possible. Knowingly misleading information may result in suspension or termination of access.",
  },
  "aml.s11.title": { ar: "التواصل", en: "Contact" },
  "aml.s11.body": {
    ar: "للمسائل الامتثالية، راسلنا على legal@hawwelapp.com مع تفاصيل كافية لتسهيل المعالجة.",
    en: "For compliance topics, contact legal@hawwelapp.com with sufficient detail to assist review.",
  },

  "terms.title": { ar: "الشروط والأحكام", en: "Terms & Conditions" },
  "terms.intro": {
    ar: "تُنظّم هذه الشروط الوصول إلى Hawwel App وموقع hawwelapp.com واستخدامهما. باستخدامك للتطبيق أو الموقع فإنك توافق على هذه الشروط.",
    en: "These Terms govern access to and use of Hawwel App and the hawwelapp.com website. By using Hawwel App or the website, you agree to these Terms.",
  },
  "terms.s1.title": { ar: "1. قبول الشروط", en: "1. Acceptance of terms" },
  "terms.s1.body": {
    ar: "باستخدام Hawwel App أو الموقع أو إنشاء حساب، فإنك تقر بأنك قد قرأت وفهمت هذه الشروط وتوافق عليها. إذا لم توافق، يُرجى عدم استخدام الخدمات.",
    en: "If you access Hawwel App, use the website, or create an account, you acknowledge that you have read and agree to these Terms. If you do not agree, do not use Hawwel App or the website.",
  },
  "terms.s2.title": { ar: "2. المُشغّل", en: "2. Operator" },
  "terms.s2.body": {
    ar: "Hawwel App يُشغَّل من قِبل E-Platform Solutions UAB.",
    en: "Hawwel App is operated by E-Platform Solutions UAB.",
  },
  "terms.s3.title": { ar: "3. وصف Hawwel App", en: "3. Description of Hawwel App" },
  "terms.s3.body": {
    ar: "Hawwel App منصّة لإنشاء طلبات تحويل رقمية وتتبّع حالتها وتحديثاتها والدعم. لا ينفّذ Hawwel App تحويلات الأموال بشكل مستقل. قد يعرض التطبيق أسعارًا إرشادية وحالة الطلبات وبيانات المستلم وقنوات الدعم وتعليمات إكمال خطوات الدفع خارج التطبيق حيث ينطبق ذلك.",
    en: "Hawwel App is a platform to create digital transfer requests, track status updates, and receive support. Hawwel App does not independently execute money transfers. The app may show indicative rates, request status, recipient details, support channels, and instructions for completing payment steps externally where supported.",
  },
  "terms.s4.title": { ar: "4. ليس بنكًا ولا منصّة تبادل ولا رصيدًا محفوظًا", en: "4. No bank, exchange, or stored balance" },
  "terms.s4.body": {
    ar: "لا يُقدَّم Hawwel App بوصفه بنكًا، أو مؤسسة قبض ودائع، أو خدمة استثمارية، أو ائتمان، أو منصّة تبادل عملات مشفّرة، ولا يوفّر محفظة أو رصيدًا تحتفظ فيه بأموالك. الأموال التي ترسلها لحوالة معيّنة تُستلَم على عنوان يُستخدم مرة واحدة يُصدره Hawwel App، ويُحتفَظ بها حتى تسليم تلك الحوالة فقط.",
    en: "Hawwel App is not a bank, deposit-taking institution, investment service, credit provider, or crypto exchange, and does not offer a wallet or account balance you can keep funds in. Funds you send for a transfer are received at a single-use address issued by Hawwel App and held only until that transfer is delivered.",
  },
  "terms.s5.title": { ar: "5. أهلية المستخدم", en: "5. User eligibility" },
  "terms.s5.body": {
    ar: "يجب أن تكون مؤهلًا قانونيًا للدخول في العقود في نطاق اختصاصك وتلتزم بالقوانين المعمول بها. لا يُسمح بالاستخدام لأغراض مخالفة للقانون أو لتقديم معلومات خاطئة.",
    en: "You must be legally able to enter into binding agreements under applicable law where you reside. Do not use Hawwel App for unlawful purposes or to provide false information.",
  },
  "terms.s6.title": { ar: "6. تسجيل الحساب وأمنه", en: "6. Account registration and security" },
  "terms.s6.body": {
    ar: "أنت مسؤول عن دقة البيانات المقدّمة عند التسجيل والحفاظ على سرّية وسائل الدخول ومتابعة OTP أو طرق المصادقة حيث تُطبَّق.",
    en: "You are responsible for accurate registration details, safeguarding credentials, and securing authentication flows (such as OTP) where used.",
  },
  "terms.s7.title": { ar: "7. مسؤوليات المستخدم", en: "7. User responsibilities" },
  "terms.s7.body": {
    ar: "تلتزم بتقديم معلومات صحيحة ومحدّثة، وعدم إساءة استخدام المنصّة أو محاولة التحايل على الفحوصات، واحترام حقوق الآخرين والامتثال لأي متطلبات محلية تخصك.",
    en: "Provide accurate information, do not misuse the platform or circumvent checks, respect others’ rights, and comply with local requirements applicable to your use.",
  },
  "terms.s8.title": { ar: "8. التحقق وفحص الامتثال ومعلومات إضافية", en: "8. Verification, compliance, and requests for information" },
  "terms.s8.body": {
    ar: "قد يطلب Hawwel App التحقق أو معلومات إضافية (هوية، مستلم، مصدر الأموال، الغرض…) وفق نهج قائم على المخاطر. لا يمكن للدعم تجاوز إجراءات الامتثال.",
    en: "Hawwel App may require verification or further information on a risk-based basis. Support cannot bypass compliance obligations.",
  },
  "terms.s9.title": { ar: "9. الإتاحة والمناطق", en: "9. Availability and regions" },
  "terms.s9.body": {
    ar: "قد تختلف إتاحة الخدمات حسب الدولة أو منطقة المستلم أو موقع الوكيل حيث يُطبَّق، ومستوى التحقق، والتقييم التشغيلي أو للمخاطر. قد تتغير المناطق حيث تقتضي الظروف.",
    en: "Availability may vary by jurisdiction, payout region or agent location where applicable, verification level, and operational circumstances. Regions may change as required.",
  },
  "terms.s10.title": { ar: "10. الأسعار الإرشادية والمسار الخارجي للدفع", en: "10. Indicative rates and external payment" },
  "terms.s10.body": {
    ar: "قد تكون الأسعار والرسوم والحالة والإتاحة إرشادية أو معلوماتية وقابلة للتغيير. لا يضمن Hawwel App قبول أي طلب أو إكماله أو توقيته أو تسعيره أو أسعار الصرف أو إتاحة أي حوالة. تموّل الحوالة من محفظتك أو حساب منصّتك إلى العنوان المخصّص لها.",
    en: "Rates, fees, status information, and availability shown in Hawwel App may be indicative or informational and may change. Hawwel App does not guarantee acceptance, completion, timing, pricing, exchange rates, or availability of any transfer. You fund a transfer from your own wallet or exchange account to the single-use address shown.",
  },
  "terms.s11.title": { ar: "11. التأخير أو الرفض أو التعليق", en: "11. Delay, refusal, or suspension" },
  "terms.s11.body": {
    ar: "قد يؤخر Hawwel App أو يرفض أو يعلّق طلبًا أو حسابًا أو يطلب معلومات إضافية لأسباب امتثال أو مخاطر أو تشغيل أو أمن.",
    en: "Hawwel App may delay, refuse, suspend, or request further information for compliance, risk, operational, or security reasons.",
  },
  "terms.s12.title": { ar: "12. الأنشطة المحظورة", en: "12. Prohibited activities" },
  "terms.s12.body": {
    ar: "لا يجوز استخدام Hawwel App لأغراض غير قانونية أو احتيالية أو مخالفة للعقوبات أو محظورة بموجب القانون أو هذه الشروط.",
    en: "You must not use Hawwel App for illegal, fraudulent, sanctioned, or otherwise prohibited purposes.",
  },
  "terms.s13.title": { ar: "13. متطلب الخدمة", en: "13. Availability of the service" },
  "terms.s13.body": {
    ar: "يُوفَّر التطبيق قدر التوفر؛ قد تنشأ تعطيلات بسبب الصيانة أو الشبكة.",
    en: "Hawwel App is offered as available and may experience maintenance or outages beyond our reasonable control.",
  },
  "terms.s14.title": { ar: "14. حدّ المسؤولية", en: "14. Limitation of liability" },
  "terms.s14.body": {
    ar: "ضمن ما يسمح القانون، لا يكون Hawwel App مسؤولًا عن أعطال محافظ أو منصّات أو بنوك أو مزودي اتصالات أو دفع أو خدمات خارجية أخرى، إلا حيث يفرض القانون خلاف ذلك. تبقى الحقوق الإلزامية للمستهلك حيث تنطبق.",
    en: "To the extent permitted by law, Hawwel App is not responsible for failures of third-party wallets, exchanges, banks, telecom providers, payment providers, or other external services, except where required by law. Mandatory consumer protections remain unaffected where applicable.",
  },
  "terms.s15.title": { ar: "15. السياسات ذات الصلة", en: "15. Related policies" },
  "terms.s15.body": {
    ar: "تُطبَّق سياسة الخصوصية وAML/KYC Policy وصفحة حذف الحساب. يُرجى مراجعة /privacy و/aml-kyc و/delete-account.",
    en: "Our Privacy Policy, AML/KYC Policy, and Delete Account page apply. Please review /privacy, /aml-kyc, and /delete-account.",
  },
  "terms.s16.title": { ar: "16. تعديل الشروط", en: "16. Changes to terms" },
  "terms.s16.body": {
    ar: "قد نحدّث هذه الشروط ويعكس تاريخهم منشور المنصّة عند الانطباق. استمرار الاستخدام بعد التحديث المعقول قد يُعد قبولًا حسب ما يرضيه القانون.",
    en: "We may update these Terms over time and reflect material changes reasonably in-product or online. Continued use may signify acceptance subject to applicable law.",
  },
  "terms.s17.title": { ar: "17. التواصل", en: "17. Contact" },
  "terms.s17.body": {
    ar: "الدعم: support@hawwelapp.com. للمسائل القانونية المتعلقة بهذه الشروط: legal@hawwelapp.com.",
    en: "Support: support@hawwelapp.com. Legal inquiries about these Terms: legal@hawwelapp.com.",
  },

  "privacy.title": { ar: "سياسة الخصوصية", en: "Privacy Policy" },
  "privacy.intro": {
    ar: "توضّح هذه السياسة كيفية جمع Hawwel App واستخدامه للبيانات الشخصية. Hawwel App يُشغَّل من قِبل E-Platform Solutions UAB.",
    en: "This Privacy Policy explains how Hawwel App collects and uses personal data. Hawwel App is operated by E-Platform Solutions UAB.",
  },
  "privacy.lastUpdatedLabel": { ar: "آخر تحديث:", en: "Last updated:" },
  "privacy.lastUpdatedValue": { ar: "٧ يونيو ٢٠٢٦", en: "07 June 2026" },
  "privacy.s1.title": { ar: "1. مقدّمة", en: "1. Introduction" },
  "privacy.s1.body": {
    ar: "تسري هذه السياسة على استخدام تطبيق Hawwel App وموقع hawwelapp.com عند الانطباق. Hawwel App واجهة لإنشاء طلبات تحويل رقمية وتتبّعها، ويرتّب تسليم المبلغ المقابل نقدًا إلى المستلم.",
    en: "This Policy applies to your use of the Hawwel App and hawwelapp.com website, as applicable. Hawwel App is an interface to create and track digital transfer requests, and arranges delivery of the corresponding amount in cash to the recipient.",
  },
  "privacy.s2.title": { ar: "2. من يُشغِّل Hawwel App", en: "2. Who operates Hawwel App" },
  "privacy.s2.body": {
    ar: "Hawwel App يُشغَّل من قِبل E-Platform Solutions UAB.",
    en: "Hawwel App is operated by E-Platform Solutions UAB.",
  },
  "privacy.s3.title": { ar: "3. طبيعة الخدمة", en: "3. Nature of the service" },
  "privacy.s3.body": {
    ar: "يساعد Hawwel App المستخدمين على إنشاء طلبات التحويل الرقمية وتتبّعها، وعرض أسعار إرشادية، واتباع تعليمات الدفع، وتلقّي تحديثات الحالة، والوصول إلى الدعم، ويُسلّم المبلغ المقابل نقدًا إلى المستلم. لا يعمل Hawwel App كبنك أو منصّة تبادل، ولا يوفّر محفظة أو رصيدًا تحتفظ فيه بأموالك.",
    en: "Hawwel App helps users create and track digital transfer requests, view indicative rates, follow payment instructions, receive status updates, and access support, and delivers the corresponding amount in cash to the recipient. Hawwel App does not operate as a bank or an exchange, and does not offer a wallet or account balance you can keep funds in.",
  },
  "privacy.s4.title": { ar: "4. متحكّم البيانات", en: "4. Data controller" },
  "privacy.s4.body": {
    ar: "E-Platform Solutions UAB هي متحكّم البيانات للبيانات الشخصية المعالجة عبر Hawwel App، ما لم يُذكر خلاف ذلك.",
    en: "E-Platform Solutions UAB is the data controller for personal data processed through Hawwel App, unless otherwise stated.",
  },
  "privacy.s5.title": { ar: "5. البيانات التي قد نجمعها", en: "5. Data we may collect" },
  "privacy.s5.list": {
    ar: [
      "الاسم",
      "رقم الهاتف",
      "البريد الإلكتروني",
      "بيانات الحساب",
      "إشارات المصادقة مثل OTP",
      "بيانات المستلم",
      "تفاصيل طلبات التحويل الرقمية",
      "مراجع دفع أو معاملات خارجية حيث ينطبق",
      "رسائل الدعم",
      "بيانات الجهاز",
      "البلد والمدينة والمنطقة عند اختيارها يدويًا أثناء التسجيل أو عند إنشاء طلب تحويل",
      "رموز إشعارات الدفع حيث تُفعَّل الإشعارات",
      "سجلات الأمان",
      "مستندات KYC حيث تُطلب",
      "معلومات مصدر الأموال أو غرض الطلب حيث تُطلب",
    ],
    en: [
      "Name",
      "Phone number",
      "Email address",
      "Account data",
      "Authentication signals such as OTP",
      "Recipient details",
      "Digital transfer request details",
      "External payment or transaction references where applicable",
      "Support messages",
      "Device data",
      "Country, city, and area information when you manually select them during registration or when submitting a transfer request",
      "Push notification tokens where you enable notifications",
      "Security logs",
      "KYC documents where required",
      "Source-of-funds or request purpose information where required",
    ],
  },
  "privacy.s6.title": { ar: "6. كيفية استخدام البيانات", en: "6. How we use data" },
  "privacy.s6.list": {
    ar: [
      "إنشاء الحسابات وإدارتها والمصادقة",
      "إنشاء طلبات التحويل الرقمية وتتبّعها",
      "تقديم الدعم",
      "إجراء التحقق وفحوصات الامتثال",
      "منع الاحتيال وإساءة الاستخدام",
      "تحسين الأمان والموثوقية",
      "الوفاء بالالتزامات القانونية",
    ],
    en: [
      "Create and manage accounts and authenticate users",
      "Create and track digital transfer requests",
      "Provide support",
      "Perform verification and compliance checks",
      "Prevent fraud and misuse",
      "Improve security and reliability",
      "Meet legal obligations",
    ],
  },
  "privacy.s7.title": { ar: "7. الأساس القانوني", en: "7. Legal bases / lawful grounds" },
  "privacy.s7.body": {
    ar: "نعالج البيانات عند الضرورة لتقديم الخدمة، والامتثال للقانون، وحماية المصالح المشروعة، ومنع الإساءة، وعند الانطباق بناءً على الموافقة.",
    en: "We process personal data where necessary to provide the service, comply with legal obligations, protect legitimate interests, prevent misuse, and where applicable based on consent.",
  },
  "privacy.s8.title": { ar: "8. بيانات KYC والامتثال", en: "8. KYC and compliance data" },
  "privacy.s8.body": {
    ar: "قد نجمع ونستخدم مستندات هوية ومعلومات تحقق ومعلومات مصدر أموال أو غرض طلب عند الحاجة لأغراض الامتثال ومنع الإساءة.",
    en: "We may collect and use identity documents, verification information, source-of-funds information, or request purpose information when required for compliance and abuse prevention.",
  },
  "privacy.s9.title": { ar: "9. OTP والمصادقة والأمان", en: "9. OTP, authentication, and security data" },
  "privacy.s9.body": {
    ar: "قد نستخدم OTP أو إشارات مصادقة مشابهة ومعلومات أمان لحماية الحسابات ومنع الوصول غير المصرّح به.",
    en: "We may use OTP or similar authentication signals and security information to protect accounts and prevent unauthorized access.",
  },
  "privacy.s10.title": { ar: "10. الجهاز والاستخدام والسجلات", en: "10. Device, usage, and log data" },
  "privacy.s10.body": {
    ar: "لا يقوم تطبيق Hawwel على الهاتف بالكشف التلقائي عن الدولة اعتمادًا على عنوان IP. قد نقوم بجمع الدولة أو المدينة أو المنطقة عندما تختارها يدويًا أثناء التسجيل أو عند إنشاء طلب تحويل. قد تقوم خوادمنا بمعالجة عناوين IP ضمن سجلات الخادم لأغراض الأمان، ومنع الاحتيال، ومنع إساءة الاستخدام، والتشغيل التقني، والحماية الامتثالية. قد تُجمع أيضًا بيانات الجهاز وسجلات الاستخدام والسجلات التقنية لتحسين الأمان والموثوقية وتشخيص المشكلات.",
    en: "The Hawwel mobile app does not perform automatic IP-based country detection. Country, city, and area information may be collected when you manually select them during registration or when submitting a transfer request. Our servers may process IP addresses in server logs for security, fraud prevention, abuse prevention, technical operations, and compliance protection. We may also collect device data, usage logs, and technical logs to improve security, reliability, and troubleshooting.",
  },
  "privacy.s11.title": { ar: "11. مشاركة البيانات", en: "11. Data sharing" },
  "privacy.s11.lead": { ar: "قد نشارك البيانات مع:", en: "We may share data with:" },
  "privacy.s11.list": {
    ar: [
      "مزودي SMS/OTP أو المصادقة مثل Twilio حيث يُستخدم",
      "مزودي الاستضافة والبنية التحتية",
      "أدوات الدعم",
      "مزودي التحقق/KYC",
      "Firebase Cloud Messaging (FCM) لإشعارات الدفع حيث تُفعَّل",
      "أدوات أمان حيث تُستخدم",
      "السلطات القانونية أو التنظيمية عند الحاجة",
      "شركاء تشغيليين عند اللزوم لمعالجة الطلبات",
    ],
    en: [
      "SMS/OTP or authentication providers such as Twilio where used",
      "Hosting and infrastructure providers",
      "Support tools",
      "Verification/KYC providers",
      "Firebase Cloud Messaging (FCM) for push notifications where enabled",
      "Security tools where used",
      "Legal or regulatory authorities where required",
      "Operational partners where necessary for request handling",
    ],
  },
  "privacy.s11.noSell": {
    ar: "لا يستخدم تطبيق Hawwel على الهاتف حزم تحليلات خارجية لتتبّع السلوك، ولا نبيع بياناتك الشخصية.",
    en: "The Hawwel mobile app does not use third-party analytics SDKs for behavioral tracking, and we do not sell your personal data.",
  },
  "privacy.s11.noAds": {
    ar: "لا نستخدم البيانات الشخصية للإعلانات لطرف ثالث إلا إذا أُفصح عن ذلك صراحةً ووُجدت موافقة حيث يلزم.",
    en: "We do not use personal data for third-party advertising unless expressly disclosed and consented to where required.",
  },
  "privacy.s12.title": { ar: "12. النقل الدولي", en: "12. International transfers" },
  "privacy.s12.body": {
    ar: "قد تُعالَج البيانات في دول أخرى حيث يتواجد مزودو الخدمات، مع ضمانات مناسبة عند الحاجة.",
    en: "Data may be processed in other countries where service providers are located, subject to appropriate safeguards where required.",
  },
  "privacy.s13.title": { ar: "13. الاحتفاظ بالبيانات", en: "13. Data retention" },
  "privacy.s13.body": {
    ar: "تختلف فترات الاحتفاظ حسب نوع البيانات وقد تعتمد على متطلبات قانونية وامتثالية ومنع احتيال وأمن ومحاسبة وحل نزاعات.",
    en: "Retention periods vary by data type and may depend on legal, compliance, fraud prevention, security, accounting, and dispute-resolution requirements.",
  },
  "privacy.s14.title": { ar: "14. الأمان", en: "14. Security" },
  "privacy.s14.body": {
    ar: "نطبّق إجراءات تقنية وتنظيمية معقولة لحماية البيانات الشخصية.",
    en: "We use reasonable technical and organizational measures to protect personal data.",
  },
  "privacy.s15.title": { ar: "15. حقوق المستخدم", en: "15. User rights" },
  "privacy.s15.body": {
    ar: "قد يحق لك، عند الانطباق، الوصول إلى بياناتك أو تصحيحها أو حذفها أو الاعتراض على معالجتها أو تقييدها أو نقلها.",
    en: "You may have rights, where applicable, to access, correct, delete, object to, restrict, or port your personal data.",
  },
  "privacy.s16.title": { ar: "16. حذف الحساب والبيانات", en: "16. Account and data deletion" },
  "privacy.s16.lead": {
    ar: "يمكنك تقديم طلب حذف حساب من داخل التطبيق عبر: الملف الشخصي > حذف الحساب > إرسال طلب حذف الحساب، أو عبر صفحة حذف الحساب على https://hawwelapp.com/delete-account. تُراجع طلبات الحذف يدويًا. قد تُحفَظ بعض السجلات حيث يلزم أو يُسمح بموجب القانون، بما في ذلك للامتثال لـ AML/KYC والأمان ومنع الاحتيال والتدقيق وحل النزاعات والالتزامات القانونية.",
    en: "You may submit an account deletion request through the in-app path: Profile → Delete account → Submit account deletion request, or through our deletion page at https://hawwelapp.com/delete-account. Deletion requests are reviewed manually. Some records may be retained where required or permitted by law, including for AML/KYC compliance, security, fraud prevention, audit, dispute resolution, and legal obligations.",
  },
  "privacy.s16.link": { ar: "صفحة حذف الحساب والبيانات", en: "Delete account and data" },
  "privacy.s17.title": { ar: "17. الأطفال", en: "17. Children" },
  "privacy.s17.body": {
    ar: "Hawwel App ليس موجّهًا للأطفال.",
    en: "Hawwel App is not directed to children.",
  },
  "privacy.s18.title": { ar: "18. تغييرات على هذه السياسة", en: "18. Changes to this policy" },
  "privacy.s18.body": {
    ar: "قد نحدّث هذه السياسة من وقت لآخر. يُرجى مراجعة هذه الصفحة دوريًا.",
    en: "We may update this Privacy Policy from time to time. Please review this page periodically.",
  },
  "privacy.s19.title": { ar: "19. التواصل", en: "19. Contact" },
  "privacy.s19.lead": {
    ar: "للأسئلة المتعلقة بالخصوصية:",
    en: "For privacy-related questions:",
  },

  "deleteAccount.title": { ar: "حذف الحساب والبيانات", en: "Delete account & data" },
  "deleteAccount.intro": {
    ar: "توضّح هذه الصفحة كيف يمكن لمستخدمي Hawwel App طلب حذف الحساب والبيانات. تتم مراجعة طلبات الحذف يدويًا ولا يؤدي تقديم الطلب إلى حذف فوري لجميع البيانات. قد نحتفظ ببعض السجلات عندما يكون ذلك مطلوبًا أو مسموحًا به قانونيًا، بما في ذلك لأغراض الامتثال لـ AML/KYC، والأمان، ومنع الاحتيال، والتدقيق، وحل النزاعات، والالتزامات القانونية.",
    en: "This page explains how Hawwel App users can request account and data deletion. Deletion requests are reviewed manually; submitting a request does not immediately delete all data. Some records may be retained where required or permitted by law, including for AML/KYC compliance, security, fraud prevention, audit, dispute resolution, and legal obligations.",
  },
  "deleteAccount.s1.title": { ar: "الطلب من داخل التطبيق", en: "Request deletion in the app" },
  "deleteAccount.s1.body": {
    ar: "داخل التطبيق، انتقل إلى: الملف الشخصي → حذف الحساب → إرسال طلب حذف الحساب. يمكنك أيضًا استخدام هذه الصفحة أو التواصل مع الدعم لطلب الحذف.",
    en: "In the app, go to Profile → Delete account → Submit account deletion request. You can also use this web page or contact support to request deletion.",
  },
  "deleteAccount.s2.title": { ar: "طلب عبر الويب أو البريد", en: "Web or email request" },
  "deleteAccount.s2.lead": {
    ar: "يمكنك إرسال طلب حذف إلى:",
    en: "You may send a deletion request to:",
  },
  "deleteAccount.s3.title": { ar: "معلومات يُرجى تضمينها", en: "Information to include" },
  "deleteAccount.s3.list": {
    ar: [
      "رقم الهاتف المسجّل",
      "البريد الإلكتروني المسجّل إن وُجد",
      "الاسم الكامل إذا لزم للتحقق",
      "نوع الطلب: حذف حساب / حذف بيانات معيّنة",
    ],
    en: [
      "Registered phone number",
      "Registered email address, if any",
      "Full name, if required for verification",
      "Request type: delete account / delete certain data",
    ],
  },
  "deleteAccount.s4.title": { ar: "ما الذي قد يُحذَف", en: "What may be deleted" },
  "deleteAccount.s4.list": {
    ar: [
      "ملف الحساب، حيث ينطبق",
      "بيانات تسجيل الدخول، حيث ينطبق",
      "تفضيلات التطبيق، حيث ينطبق",
      "بيانات دعم لم تعد مطلوبة",
      "بيانات شخصية أخرى غير مطلوبة قانونًا للاحتفاظ",
    ],
    en: [
      "Account profile, where applicable",
      "Login credentials, where applicable",
      "App preferences, where applicable",
      "Support data no longer needed",
      "Other personal data not legally required to be retained",
    ],
  },
  "deleteAccount.s5.title": { ar: "ما الذي قد يُحفَظ", en: "What may be retained" },
  "deleteAccount.s5.list": {
    ar: [
      "سجلات التحقق وAML/KYC",
      "سجل الطلبات",
      "سجلات الامتثال",
      "سجلات الأمان",
      "سجلات منع الاحتيال",
      "سجلات تدقيق",
      "سجلات محاسبية",
      "سجلات نزاعات",
      "سجلات مطلوبة بموجب القانون أو شركاء تشغيليين",
    ],
    en: [
      "Verification and AML/KYC records",
      "Request history",
      "Compliance records",
      "Security logs",
      "Fraud prevention records",
      "Audit records",
      "Accounting records",
      "Dispute records",
      "Records required by law or operational partners",
    ],
  },
  "deleteAccount.s6.title": { ar: "المدة المتوقعة للمعالجة", en: "Expected processing time" },
  "deleteAccount.s6.body": {
    ar: "تُراجع طلبات الحذف يدويًا. نسعى لمعالجتها خلال مدة معقولة بعد التحقق من الطلب، ما لم تكن هناك فترة احتفاظ أطول مطلوبة أو مسموح بها بموجب القانون.",
    en: "Deletion requests are reviewed manually. We aim to process them within a reasonable time after verifying the request, unless a longer retention period is required or permitted by law.",
  },
  "deleteAccount.s7.title": { ar: "إلغاء تثبيت التطبيق", en: "Uninstalling the app" },
  "deleteAccount.s7.body": {
    ar: "حذف التطبيق من الجهاز لا يعني حذف الحساب.",
    en: "Deleting the app from your device does not delete your account.",
  },
  "deleteAccount.s8.title": { ar: "التواصل", en: "Contact" },
  "deleteAccount.s8.lead": {
    ar: "لمتابعة طلبات الحذف أو الخصوصية:",
    en: "For deletion or privacy follow-up:",
  },

  "footer.deleteAccount": { ar: "حذف الحساب والبيانات", en: "Delete account / data" },
  "footer.corporateDisclosure": {
    ar: "© {year} Hawwel. جميع الحقوق محفوظة. Hawwel منصّة برمجيات تقنية مالية طُوِّرت ونُشرت من قِبل E-Platform Solutions UAB{registrationClause}. تُدار توجيهات الأصول المشفّرة ومعالجة البيانات عالميًا عبر شبكات دفتر موثّق آمنة. يتم تنفيذ تسوية العملات المحلية وصرف النقد حصريًا من قِبل مؤسسات مالية مستقلة مرخّصة محليًا ومكاتب صرف أموال معتمدة في الولايات القضائية المعنية.",
    en: "© {year} Hawwel. All rights reserved. Hawwel is a financial technology software platform developed and published by E-Platform Solutions UAB{registrationClause}. Cryptographic asset routing and data processing are managed globally via secure ledger networks. Local fiat currency fulfillment and cash payouts are performed exclusively by independent, locally licensed financial institutions and authorized money exchange bureaus in the respective destination jurisdictions.",
  },
  "store.modal.title": { ar: "قريبًا على المتاجر", en: "Coming soon to app stores" },
  "store.modal.body": {
    ar: "سيُتوفر Hawwel App قريبًا على App Store و Google Play. للمساعدة الآن، تواصل معنا عبر support@hawwelapp.com أو صفحة الدعم.",
    en: "Hawwel App will be available on the App Store and Google Play soon. For help now, reach us at support@hawwelapp.com or visit our support page.",
  },
  "store.modal.close": { ar: "حسنًا", en: "Got it" },
  "store.modal.supportCta": { ar: "الدعم والتواصل", en: "Support & contact" },

  "support.complianceNotice": {
    ar: "يقوم فريق الدعم بمساعدتك في التطبيق والطلبات، لكن لا يمكنه تجاوز إجراءات التحقق أو الامتثال أو الموافقة على طلب لا يحقق المتطلبات القانونية.",
    en: "Our support staff can guide you within Hawwel App, but cannot bypass verification, AML/KYC workflows, or compliance decisions required by applicable rules.",
  },
  "support.sensitiveDocsNotice": {
    ar: "يُرجى عدم إرسال مستندات هوية حسّاسة أو وثائق تحقق كاملة عبر البريد الإلكتروني إلا إذا طُلب ذلك صراحةً ضمن عملية تحقق معتمدة داخل التطبيق أو عبر قناة آمنة مُحدَّدة.",
    en: "Please do not send sensitive identity documents or full verification files by email unless explicitly requested through an approved in-app verification process or designated secure channel.",
  },
  "support.contactCard.legalLabel": { ar: "الامتثال والقضايا القانونية", en: "Legal & compliance" },
  "contact.complianceNotice": {
    ar: "يرجى إرسال الاستفسارات القانونية أو الامتثال أو الخصوصية إلى القنوات المخصَّصة. لا يمكن لطلب واحد تجاوز فحص الامتثال.",
    en: "Route privacy, AML, or legal topics to the dedicated mailboxes listed here. Operational teams cannot circumvent compliance screenings.",
  },
  "contact.brandLead": {
    ar: "Hawwel App — واجهة إنشاء طلبات التحويل الرقمية وتتبّعها.",
    en: "Hawwel App — request creation & tracking interface for digital transfer requests.",
  },

  "learn.title": { ar: "تعلّم", en: "Learning center" },
  "learn.subtitle": {
    ar: "محتوى توعوي مبسّط حول طلبات التحويل الرقمية وتتبّعها والأسعار الإرشادية ومفاهيم الامتثال.",
    en: "Educational content about digital transfer requests, request tracking, indicative rates, and compliance-related concepts.",
  },
  "learn.readMore": { ar: "اقرأ المقال", en: "Read article" },
  "learn.backToLearn": { ar: "العودة إلى مركز التعلّم", en: "Back to learning center" },
  "learn.card1": { ar: "ما هو طلب التحويل الرقمي؟", en: "What is a digital money transfer request?" },
  "learn.card2": { ar: "كيف يمكن تتبع طلب حوالة؟", en: "How to track a transfer request" },
  "learn.card3": { ar: "لماذا قد يُطلب التحقق من الهوية؟", en: "Why verification may be required" },
  "learn.card4": { ar: "فهم الأسعار المتاحة قبل إنشاء الطلب", en: "Understanding available rates" },
  "learn.card5": { ar: "الفرق بين تطبيق طلبات التحويل والمحفظة الرقمية", en: "Transfer request app vs digital wallet" },
  "learn.card6": { ar: "كيف تعمل المناطق المدعومة؟", en: "How supported regions work" },

  "notFound.title": { ar: "الصفحة غير موجودة", en: "Page not found" },
  "notFound.body": { ar: "تعذر العثور على الصفحة المطلوبة.", en: "The page you requested could not be found." },
  "notFound.cta": { ar: "العودة إلى الرئيسية", en: "Back to home" },

  "seo.home.title": {
    ar: "Hawwel App | تتبّع طلبات التحويل الرقمية",
    en: "Hawwel App | Digital Transfer Request Tracking",
  },
  "seo.home.description": {
    ar: "يساعد Hawwel App المستخدمين على إنشاء طلبات تحويل رقمية وتتبّعها مع تحديثات الحالة والدعم والتحقق حيث يلزم. لا يحتفظ Hawwel App بالأموال ولا ينفّذ تحويلات الأموال بشكل مستقل.",
    en: "Hawwel App helps users create, manage, and track digital transfer requests with status updates, support, and verification where required. Hawwel App does not hold funds or independently execute money transfers.",
  },
  "seo.hiw.title": {
    ar: "Hawwel App | طريقة العمل",
    en: "Hawwel App | How it works",
  },
  "seo.hiw.description": {
    ar: "خريطة المراحل الست لاستخدام Hawwel App لطلب تحويل رقمي.",
    en: "Six onboarding steps inside Hawwel App for digital transfer requests.",
  },
  "seo.regions.title": { ar: "Hawwel App | المناطق المتاحة", en: "Hawwel App | Available regions" },
  "seo.regions.description": {
    ar: "المناطق المدعومة حاليًا وحالات التحقق المرتبطة بها في Hawwel App.",
    en: "Supported payout geographies referenced within Hawwel App.",
  },
  "seo.learn.title": {
    ar: "Hawwel App | مركز التعلّم",
    en: "Hawwel App | Learning center",
  },
  "seo.learn.description": {
    ar: "مقالات تعليمية حول طلبات التحويل الرقمية وتتبعها والأسعار الإرشادية والمناطق المدعومة.",
    en: "Educational articles about digital transfer requests, request tracking, indicative rates, and supported regions.",
  },
  "seo.support.title": { ar: "Hawwel App | الدعم", en: "Hawwel App | Support" },
  "seo.support.description": {
    ar: "صفحة دعم Hawwel App مع الأسئلة الشائعة والبريد.",
    en: "Hawwel App support with FAQs and email channels.",
  },
  "seo.contact.title": { ar: "Hawwel App | تواصل معنا", en: "Hawwel App | Contact" },
  "seo.contact.description": {
    ar: "قنوات التواصل لتطبيق Hawwel App والمُشغِّل القانوني.",
    en: "Contact channels for Hawwel App.",
  },
  "seo.legal.title": { ar: "Hawwel App | الإشعار القانوني", en: "Hawwel App | Legal Notice" },
  "seo.legal.description": {
    ar: "الإشعار القانوني الرسمي لـ Hawwel App والمُشغِّل القانوني.",
    en: "Official legal notice for Hawwel App.",
  },
  "seo.aml.title": { ar: "Hawwel App | سياسة AML / KYC", en: "Hawwel App | AML / KYC Policy" },
  "seo.aml.description": {
    ar: "سياسة مكافحة غسل الأموال والتحقق من الهوية المرتبطة بـ Hawwel App.",
    en: "AML and KYC policy for Hawwel App.",
  },
  "seo.terms.title": { ar: "Hawwel App | الشروط والأحكام", en: "Hawwel App | Terms & Conditions" },
  "seo.terms.description": {
    ar: "الشروط والأحكام الخاصة بـ Hawwel App وhawwelapp.com.",
    en: "Terms governing Hawwel App and hawwelapp.com.",
  },
  "seo.privacy.title": { ar: "Hawwel App | سياسة الخصوصية", en: "Hawwel App | Privacy Policy" },
  "seo.privacy.description": {
    ar: "كيف يجمع Hawwel App ويعالج البيانات الشخصية. لا نبيع البيانات الشخصية.",
    en: "How Hawwel App collects and processes personal data. We do not sell personal data.",
  },
  "seo.deleteAccount.title": {
    ar: "Hawwel App | حذف الحساب والبيانات",
    en: "Hawwel App | Delete account",
  },
  "seo.deleteAccount.description": {
    ar: "كيف تحذف حساب Hawwel App وما الذي قد يُحفظ لأسباب قانونية.",
    en: "How Hawwel App users delete data and carve-outs retained for legal reasons.",
  },
  "seo.notFound.title": { ar: "Hawwel App | الصفحة غير موجودة", en: "Hawwel App | Page not found" },
  "seo.notFound.description": { ar: "الصفحة المطلوبة غير متاحة.", en: "The requested page is unavailable." },
} as const satisfies Record<string, Entry>;

export type TranslationKey = keyof typeof translations;
