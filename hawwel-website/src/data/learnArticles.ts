import type { Lang } from "../i18n/translations";

type Localized = {
  ar: string;
  en: string;
};

type LocalizedArray = {
  ar: string[];
  en: string[];
};

export type LearnArticle = {
  slug: string;
  title: Localized;
  description: Localized;
  keywords: LocalizedArray;
  sections: {
    heading: Localized;
    paragraphs: LocalizedArray;
  }[];
  legalNote: Localized;
};

export const learnArticles: LearnArticle[] = [
  {
    slug: "what-is-digital-transfer-request",
    title: {
      ar: "ما هو طلب التحويل الرقمي؟",
      en: "What is a digital money transfer request?",
    },
    description: {
      ar: "شرح مبسّط لمفهوم طلب التحويل الرقمي، وكيف يساعد تطبيق Hawwel في تنظيم طلبات الحوالات وتتبع الحالة خطوة بخطوة.",
      en: "A practical guide to what a digital money transfer request means and how Hawwel helps organize requests and track status updates.",
    },
    keywords: {
      ar: [
        "حوالات",
        "حوالات رقمية",
        "تطبيق حوالات",
        "طلب تحويل",
        "تتبع حوالة",
      ],
      en: [
        "money transfer",
        "money transfer request",
        "digital remittance",
        "remittance app",
        "transfer tracking",
      ],
    },
    sections: [
      {
        heading: {
          ar: "تعريف طلب التحويل الرقمي",
          en: "Defining a digital money transfer request",
        },
        paragraphs: {
          ar: [
            "طلب التحويل الرقمي هو سجل منظّم داخل التطبيق يوضح نية المستخدم في إرسال حوالة، مع إدخال تفاصيل أساسية مثل بيانات المستلم، قيمة الطلب، والمنطقة المدعومة أو منطقة الاستلام المتاحة. الفكرة الأساسية هي أن المستخدم يحصل على مسار واضح لإدارة طلب التحويل قبل الوصول إلى مرحلة التنفيذ.",
            "في تطبيق حوالات حديث مثل Hawwel، لا يتم تقديم التجربة على أنها حساب ودائع أو محفظة احتفاظ بالأموال. بدلًا من ذلك، يركّز التطبيق على تنظيم البيانات، عرض المعلومات المتاحة، وإيضاح حالة كل طلب تحويل بطريقة قابلة للتتبع. هذا يقلل الالتباس ويمنح المستخدم صورة أوضح عن الخطوة الحالية وما يلزم بعدها.",
            "وجود طلب تحويل واضح يفيد المستخدم من ناحية الدقة أيضًا. عندما تدخل بيانات المستلم في نموذج منظم، يصبح من الأسهل مراجعتها قبل الإرسال. كذلك يمكن العودة إلى نفس الطلب لاحقًا لمعرفة أي ملاحظات إضافية مرتبطة بالتحقق أو المتطلبات التشغيلية أو التحديثات الجديدة على الحالة.",
          ],
          en: [
            "A digital money transfer request is a structured record inside an app that captures a user's intent to transfer money. It typically includes recipient details, request amount, and the selected supported region or payout area. The core purpose is to give users a clear process before any fulfillment step happens.",
            "In a modern remittance app like Hawwel, the experience is not presented as a deposit account or a custodial wallet. Instead, the app focuses on organizing request data, showing available information, and making request status updates easy to follow. This reduces confusion and helps users understand what stage they are currently in.",
            "A clearly structured money transfer request also improves accuracy. When recipient details are entered in an organized format, users can review them before submission. The same request can then be revisited later to check verification notes, operational requirements, or newer status updates related to processing.",
          ],
        },
      },
      {
        heading: {
          ar: "لماذا هذا المفهوم مهم في تطبيق حوالات؟",
          en: "Why this matters in a transfer request app",
        },
        paragraphs: {
          ar: [
            "الكثير من المستخدمين يخلطون بين تنفيذ التحويل نفسه وبين إنشاء طلب التحويل. في الواقع، وجود مرحلة مستقلة لطلب تحويل رقمي يمنح مساحة للتحقق من البيانات، وفهم الأسعار المتاحة، والتأكد من المنطقة المدعومة قبل أي خطوة لاحقة. هذا النهج يرفع مستوى الشفافية ويقلل الأخطاء.",
            "عند وجود طلب تحويل موثق، يصبح من السهل تتبع حوالة بشكل منهجي. بدل الاعتماد على رسائل متفرقة، يحصل المستخدم على حالة موحدة داخل التطبيق: قيد المراجعة، بانتظار معلومات إضافية، أو تعليمات جاهزة. هذه البساطة مهمة جدًا لثقة المستخدم، خصوصًا في خدمات تحويل الأموال الرقمية.",
            "من منظور الامتثال، يساعد هذا النموذج على تطبيق الفحوصات عند الحاجة بطريقة متناسقة. عندما تكون البيانات مجمعة في طلب تحويل واحد، يمكن للمستخدم معرفة المطلوب بدقة أكبر، ويستطيع فريق الدعم تقديم مساعدة أدق لأن الطلب نفسه يحتوي التاريخ والتحديثات ذات الصلة.",
          ],
          en: [
            "Many users confuse actual fulfillment with creating a transfer request. A dedicated money transfer request stage allows users to review recipient details, understand available rates, and confirm supported regions before later steps. This approach improves transparency and helps prevent avoidable mistakes.",
            "When requests are clearly documented, transfer tracking becomes much easier. Instead of relying on scattered messages, users can follow one visible status timeline in the app: under review, more information needed, or instructions available. This clarity is a major trust factor in digital remittance journeys.",
            "From a compliance perspective, the request-based model also helps apply checks consistently when needed. Because data is captured in one request record, users get clearer guidance about what is required, and support teams can provide better help using a single, traceable context.",
          ],
        },
      },
      {
        heading: {
          ar: "ما الذي يقدمه Hawwel تحديدًا؟",
          en: "What Hawwel provides in practice",
        },
        paragraphs: {
          ar: [
            "Hawwel يقدّم منصة رقمية لإدارة طلبات الحوالات: إنشاء الطلب، تعديل المعلومات عند الحاجة، ومتابعة حالة الطلب بوضوح. يمكن للمستخدم الاطلاع على الأسعار المتاحة، إدخال بيانات المستلم، واستلام تعليمات الطلب داخل التطبيق. هذا يجعل تجربة تحويل الأموال أكثر تنظيمًا ووضوحًا.",
            "التطبيق يدعم كذلك التواصل مع فريق الدعم عندما يحتاج المستخدم إلى توضيح حول الحالة أو متطلبات التحقق. وجود قناة دعم واضحة ضمن تجربة تطبيق حوالات يقلل التوتر لدى المستخدم ويمنحه نقاطًا عملية للمتابعة بدل التخمين.",
            "باختصار، إذا كنت تبحث عن فهم أفضل لرحلة تحويل الأموال الرقمية، فمفهوم طلب التحويل الرقمي هو البداية الصحيحة. هو ليس وعدًا بإنجاز فوري، بل إطار واضح لإدارة الطلب وتتبع التطورات بطريقة مهنية وقابلة للمراجعة.",
          ],
          en: [
            "Hawwel provides a digital platform for transfer request management: creating requests, updating details when needed, and following request status clearly. Users can view available rates, submit recipient details, receive request instructions, and monitor updates in one app experience.",
            "The app also supports human assistance when users need clarification about status, verification requirements, or next actions. In a remittance app context, visible support channels are important because they replace uncertainty with practical guidance.",
            "In short, if you want a clearer money transfer journey, the digital transfer request model is a strong foundation. It is not a promise of immediate fulfillment; it is a transparent framework for creating, managing, and tracking requests responsibly.",
          ],
        },
      },
    ],
    legalNote: {
      ar: "Hawwel مُشغَّل من قِبل E-Platform Solutions UAB. تعتمد إتاحة الخدمة على المناطق المدعومة، ومتطلبات التحقق، والفحوصات اللازمة، والقوانين المعمول بها.",
      en: "Hawwel is operated by E-Platform Solutions UAB. Availability depends on supported regions, verification requirements, screening, and applicable laws.",
    },
  },
  {
    slug: "how-to-track-transfer-request",
    title: {
      ar: "كيف يمكن تتبع طلب حوالة؟",
      en: "How to track a transfer request",
    },
    description: {
      ar: "خطوات عملية لتتبع حوالة داخل تطبيق حوالات رقمي: من إدخال بيانات المستلم وحتى فهم تحديثات الحالة والتعليمات.",
      en: "Practical steps to track a money transfer request in a remittance app, from recipient details to status updates and request instructions.",
    },
    keywords: {
      ar: ["تتبع حوالة", "طلب تحويل", "تحديثات الحالة", "بيانات المستلم", "حوالات رقمية"],
      en: ["transfer tracking", "request status", "recipient details", "money transfer request", "remittance app"],
    },
    sections: [
      {
        heading: {
          ar: "ابدأ بطلب منظم",
          en: "Start with a well-structured request",
        },
        paragraphs: {
          ar: [
            "أفضل طريقة لتتبع حوالة هي البدء بطلب تحويل منظم وواضح. عندما تدخل بيانات المستلم والبيانات الأساسية بدقة، يصبح من السهل على النظام إظهار حالة الطلب الصحيحة في الوقت المناسب. أي نقص في المعلومات قد يؤدي إلى تأخير أو طلب توضيح إضافي.",
            "في Hawwel، فكرة تتبع حوالة تعتمد على رؤية الحالة داخل سجل الطلب نفسه، وليس عبر قنوات مشتتة. هذا يعني أن المستخدم يعرف أين ينظر للحصول على آخر تحديث، وما إذا كان مطلوبًا منه إجراء إضافي مثل استكمال معلومة أو مراجعة تعليمات معينة.",
            "من المهم أيضًا مراجعة البيانات قبل إرسال الطلب لأول مرة. كثير من مشكلات الطلبات ليست تقنية، بل ناتجة عن خطأ بسيط في بيانات المستلم أو المنطقة المدعومة. المراجعة المبكرة توفر الوقت وتحسن دقة تتبع الحالة لاحقًا.",
          ],
          en: [
            "The most effective way to track a transfer request is to start with accurate request data. When recipient details and request information are entered clearly, the app can provide meaningful status updates. Missing or inconsistent details may trigger delays or follow-up checks.",
            "In Hawwel, transfer tracking is centered on the request record itself, not scattered channels. Users can check one timeline to see the latest update and understand whether any next action is required, such as adding information or following a displayed instruction.",
            "It also helps to review request details before initial submission. Many tracking problems are not technical; they come from simple data entry issues. Early review improves request quality and makes status progression easier to follow.",
          ],
        },
      },
      {
        heading: {
          ar: "فهم حالات الطلب داخل التطبيق",
          en: "Understanding request status updates",
        },
        paragraphs: {
          ar: [
            "عادةً ما يمر طلب التحويل بعدة مراحل مثل: قيد المراجعة، بانتظار معلومات، قيد التحديث، أو مكتمل مع تعليمات. الهدف من هذه الحالات ليس التعقيد، بل إعطاء المستخدم صورة واضحة عن المرحلة الحالية. لذلك، من الأفضل متابعة الحالة داخل التطبيق بشكل دوري بدلاً من الافتراض.",
            "إذا ظهرت حالة تشير إلى التحقق، فهذا لا يعني مشكلة بالضرورة. في خدمات تحويل الأموال الرقمية، قد تكون الفحوصات جزءًا طبيعيًا من الامتثال وإدارة المخاطر. التعامل مع الحالة بهدوء ورفع المعلومات المطلوبة يساعد في استمرار معالجة الطلب وفق المسار الصحيح.",
            "احرص كذلك على قراءة الرسائل أو الملاحظات المرتبطة بكل حالة. أحيانًا تكون الحالة مختصرة، بينما التفاصيل العملية موجودة في شرح الحالة نفسها. هذه التفاصيل قد تتضمن ما يجب فعله الآن، وما الذي ينتظره النظام قبل الانتقال للمرحلة التالية.",
          ],
          en: [
            "A transfer request typically moves through statuses such as under review, more information needed, in progress, or completed with instructions. These statuses are not meant to complicate things; they are designed to give users visibility into what is happening at each stage.",
            "If you see a verification-related status, it does not automatically mean there is a problem. In digital remittance workflows, checks may be a standard part of compliance and risk controls. Responding clearly and providing requested details can help the process continue.",
            "Always read the note attached to the status. A label may be short, while the useful instruction sits in the detailed message. That message usually explains what action is needed now and what the app is waiting for before moving forward.",
          ],
        },
      },
      {
        heading: {
          ar: "متى تتواصل مع الدعم؟",
          en: "When to contact support",
        },
        paragraphs: {
          ar: [
            "إذا بقيت الحالة دون تغيير لفترة طويلة أو كانت التعليمات غير واضحة، فالتواصل مع الدعم خطوة صحيحة. قدم رقم الطلب، وصف الحالة الحالية، وأي معلومات طلبها النظام. كلما كانت رسالتك واضحة، كان حل الاستفسار أسرع وأكثر دقة.",
            "الدعم مفيد أيضًا إذا أردت التأكد من معنى حالة معينة، أو إذا كنت غير متأكد من تنسيق بيانات المستلم المطلوبة. في تطبيق حوالات، الدعم البشري مهم لأنه يربط بين تجربة المستخدم والمتطلبات الفعلية للتشغيل والامتثال.",
            "الخلاصة: تتبع حوالة ناجح يعتمد على ثلاثة عناصر: إدخال دقيق، متابعة واعية للحالة، وتواصل سريع عند الحاجة. بهذه الطريقة، تبقى رحلة طلب التحويل واضحة ويمكن إدارتها بهدوء وثقة.",
          ],
          en: [
            "If the status remains unchanged for an extended period, or if instructions are unclear, contacting support is the right move. Share your request reference, current status, and any message shown in the app. Clear support requests usually lead to faster and better guidance.",
            "Support is also helpful when you need clarity about a specific status or recipient detail requirement. In a remittance app experience, human support connects user questions with operational and compliance realities in a practical way.",
            "In summary, effective transfer tracking depends on three things: accurate request setup, consistent status review, and timely support communication when needed. This keeps your money transfer request journey clear and manageable.",
          ],
        },
      },
    ],
    legalNote: {
      ar: "Hawwel مُشغَّل من قِبل E-Platform Solutions UAB. تعتمد إتاحة الخدمة على المناطق المدعومة، ومتطلبات التحقق، والفحوصات اللازمة، والقوانين المعمول بها.",
      en: "Hawwel is operated by E-Platform Solutions UAB. Availability depends on supported regions, verification requirements, screening, and applicable laws.",
    },
  },
  {
    slug: "why-verification-may-be-required",
    title: {
      ar: "لماذا قد يُطلب التحقق من الهوية؟",
      en: "Why verification may be required",
    },
    description: {
      ar: "مقال توعوي يشرح لماذا قد يُطلب التحقق في تطبيق حوالات رقمية، وما علاقة ذلك بإدارة المخاطر والامتثال.",
      en: "Educational guidance on why identity verification may be requested in a transfer request app and how this supports compliance and risk controls.",
    },
    keywords: {
      ar: ["التحقق من الهوية", "فحوصات الامتثال", "حوالات رقمية", "طلب تحويل", "مصدر الأموال"],
      en: ["verification", "compliance checks", "risk controls", "source of funds", "money transfer request"],
    },
    sections: [
      {
        heading: {
          ar: "التحقق جزء من الحماية وليس عائقًا",
          en: "Verification is a safety layer, not a barrier",
        },
        paragraphs: {
          ar: [
            "عند استخدام تطبيق حوالات أو منصة طلب تحويل، قد يُطلب منك التحقق من الهوية أو تقديم معلومات إضافية. هذا الإجراء ليس موجهًا ضد المستخدم، بل هو جزء من حماية المنصة والمستخدمين من الاحتيال وإساءة الاستخدام. في خدمات تحويل الأموال الرقمية، الفحوصات عنصر أساسي للسلامة التشغيلية.",
            "التحقق يساعد على التأكد من دقة بيانات المستلم ومشروعية الطلب ضمن الإطار القانوني. كما يساهم في تقليل المخاطر المرتبطة بالطلبات غير المكتملة أو الأنماط غير المعتادة. لذلك، وجود عملية تحقق واضحة يعكس نهجًا مهنيًا وليس تعقيدًا غير ضروري.",
            "في Hawwel، قد يختلف مستوى التحقق حسب نوع الطلب، قيمة الطلب، المنطقة المدعومة، وأنماط المخاطر. بعض الطلبات تمر بشكل مباشر، وبعضها يحتاج توثيقًا إضافيًا. الهدف دائمًا هو موازنة سهولة الاستخدام مع المتطلبات القانونية والرقابية.",
          ],
          en: [
            "In a remittance app or transfer request platform, you may be asked for identity verification or extra details. This is not designed to block users; it is a safety layer to reduce fraud and misuse. In digital money transfer workflows, verification is a core operational protection.",
            "Verification helps confirm recipient details, request legitimacy, and alignment with applicable legal requirements. It also reduces risk from incomplete data or unusual request patterns. A clear verification process reflects responsible service design, not unnecessary friction.",
            "In Hawwel, verification depth may vary by request type, amount, supported region, and risk indicators. Some requests move quickly, while others require additional checks. The objective is to balance a clear user experience with compliance and risk obligations.",
          ],
        },
      },
      {
        heading: {
          ar: "ما الذي قد يُطلب منك؟",
          en: "What users may be asked to provide",
        },
        paragraphs: {
          ar: [
            "قد يتضمن التحقق معلومات تعريف شخصية، وثائق هوية، بيانات عنوان، أو توضيحًا حول الغرض من الطلب. في بعض الحالات قد يُطلب أيضًا شرح مصدر الأموال بشكل مناسب لطبيعة الطلب. تقديم هذه المعلومات بشكل واضح يساعد على تسريع المراجعة وتقليل الرجوع المتكرر.",
            "من الأفضل تجهيز المعلومات المطلوبة بطريقة متسقة: اسم واضح، وثيقة مقروءة، وبيانات حديثة. جودة المعلومات تؤثر مباشرة في سرعة المعالجة. كثير من التأخير يحدث بسبب صور غير واضحة أو حقول ناقصة، وليس بسبب الرفض المبدئي للطلب.",
            "إذا لم تكن متأكدًا مما هو مطلوب، تواصل مع الدعم قبل إعادة الإرسال عدة مرات. المراجعة المنظمة مع الدعم توفر وقتك وتمنحك توجيهًا عمليًا يتناسب مع حالة الطلب الحالية دون تخمين.",
          ],
          en: [
            "Verification may include identity details, ID documents, address information, or clarification about request purpose. In some scenarios, users may also be asked for source-of-funds information depending on request context. Clear submissions usually make review smoother.",
            "It helps to provide information in a consistent format: clear names, readable documents, and up-to-date details. Submission quality has a direct impact on processing speed. Many delays come from missing fields or unreadable files rather than a policy rejection.",
            "If requirements are unclear, contact support before repeated resubmissions. Structured guidance can save time and align your response with the exact request status shown in the app.",
          ],
        },
      },
      {
        heading: {
          ar: "كيف تبقى تجربة المستخدم واضحة؟",
          en: "Keeping the user journey clear",
        },
        paragraphs: {
          ar: [
            "أفضل تجربة تحقق هي التي تشرح السبب والخطوة التالية بوضوح. لذلك، Hawwel يعرض حالة الطلب ويترك للمستخدم مسارًا مفهوما: ما المطلوب الآن؟ ولماذا؟ ومتى يمكن توقع التحديث القادم؟ هذه الشفافية تقلل الضغط وتمنح المستخدم تحكمًا أكبر.",
            "وجود التحقق لا يعني أن الخدمة بنكية أو استثمارية. هو ببساطة جزء من العمل المسؤول في بيئة تحويل أموال رقمية تتطلب امتثالًا وفحوصات. الفصل الواضح بين منصة إدارة الطلبات وبين مزاعم الخدمات المالية المقيّدة قانونيًا مهم جدًا لحماية المستخدم والمنتج.",
            "النتيجة العملية: عندما تفهم دور التحقق كأداة أمان، تصبح عملية طلب تحويل أكثر توقعًا وأقل غموضًا. والمتابعة الجيدة للحالة داخل التطبيق تجعل رحلة الحوالة الرقمية أكثر استقرارًا ووضوحًا.",
          ],
          en: [
            "A good verification experience explains both the reason and the next step. Hawwel is designed to present request status in practical terms: what is needed now, why it is needed, and what update to expect next. This clarity reduces stress and improves user control.",
            "Verification does not mean the product is presenting itself as a bank or investment service. It simply reflects responsible operation in a digital remittance environment that requires screening and compliance checks. Clear service positioning is essential for user trust.",
            "In practice, once verification is understood as a safety mechanism, transfer request journeys become more predictable and less confusing. Consistent status tracking in the app then keeps the process calm and transparent.",
          ],
        },
      },
    ],
    legalNote: {
      ar: "Hawwel مُشغَّل من قِبل E-Platform Solutions UAB. تعتمد إتاحة الخدمة على المناطق المدعومة، ومتطلبات التحقق، والفحوصات اللازمة، والقوانين المعمول بها.",
      en: "Hawwel is operated by E-Platform Solutions UAB. Availability depends on supported regions, verification requirements, screening, and applicable laws.",
    },
  },
  {
    slug: "understanding-available-rates",
    title: {
      ar: "فهم الأسعار المتاحة قبل إنشاء الطلب",
      en: "Understanding available rates",
    },
    description: {
      ar: "كيف يقرأ المستخدم الأسعار المتاحة في تطبيق حوالات رقمي، وما الفرق بين السعر الإرشادي والتأكيد النهائي قبل اكتمال الطلب.",
      en: "How to read available rates in a transfer request app and understand indicative values versus final confirmation.",
    },
    keywords: {
      ar: ["أسعار التحويل", "حوالات رقمية", "طلب تحويل", "معلومات الطلب", "تطبيق حوالات"],
      en: ["available rates", "money transfer", "transfer request", "request status", "digital remittance"],
    },
    sections: [
      {
        heading: {
          ar: "ماذا يعني السعر المتاح؟",
          en: "What does an available rate mean?",
        },
        paragraphs: {
          ar: [
            "عند استخدام تطبيق حوالات، قد ترى سعرًا متاحًا قبل إنشاء طلب التحويل. هذا السعر يساعدك على اتخاذ قرار أولي، لكنه قد يكون إرشاديًا إلى أن يتم تأكيد الطلب وفق المعطيات النهائية والفحوصات المطلوبة. لذلك، من المهم التعامل مع السعر المتاح كمرجع واضح، وليس كضمان مطلق.",
            "الأسعار المتاحة مفيدة لأنها تمنح المستخدم رؤية مبكرة قبل إدخال كل التفاصيل. يمكنك مقارنة الخيارات، فهم نطاق التكلفة، ثم الانتقال إلى إنشاء الطلب إذا كانت الشروط مناسبة لك. هذا النهج يجعل تجربة تحويل الأموال الرقمية أكثر شفافية ويقلل المفاجآت.",
            "في Hawwel، الهدف من عرض الأسعار المتاحة هو تمكين المستخدم من الفهم المبكر، مع بقاء التأكيد النهائي مرتبطًا بمرحلة مراجعة الطلب. هذه الصياغة القانونية والتنظيمية مهمة لأنها تعكس واقع التشغيل وتمنع الوعود المضللة.",
          ],
          en: [
            "In a remittance app, an available rate is often shown before a request is fully processed. This helps users make informed decisions early, but the value may remain indicative until request review and required checks are completed.",
            "Available rates are useful because they provide early transparency. Users can evaluate options, estimate transfer context, and then submit a money transfer request with better expectations. This creates a clearer and more responsible user journey.",
            "In Hawwel, rate visibility is designed for clarity while final confirmation remains tied to request review. This is an important compliance-aware approach because it avoids misleading certainty and reflects real operational conditions.",
          ],
        },
      },
      {
        heading: {
          ar: "ما العوامل التي قد تؤثر على السعر؟",
          en: "What can affect available rates?",
        },
        paragraphs: {
          ar: [
            "هناك عوامل متعددة قد تؤثر على السعر الإرشادي أو على تفاصيل الطلب، مثل المنطقة المدعومة، توقيت الطلب، متطلبات التحقق، وتوفّر التشغيل عبر القنوات المتاحة. لهذا السبب، قد ترى تحديثًا في المعلومات قبل اكتمال الطلب النهائي.",
            "تغيير بسيط في بيانات المستلم أو منطقة الاستلام قد ينعكس على المعلومات المعروضة. لذلك، من المهم إدخال البيانات بدقة من البداية. كذلك، متابعة حالة الطلب تعطيك إشارات مبكرة إذا كانت هناك مراجعة إضافية قد تؤثر على الخطوات اللاحقة.",
            "بدل البحث عن وعود مثل \"الأقل دائمًا\" أو \"الأسرع دائمًا\"، الأفضل هو الاعتماد على بيانات واضحة داخل التطبيق: ما هو المعروض الآن؟ وما هي الخطوة التالية؟ هذه المقاربة أكثر واقعية وتناسب خدمات تحويل الأموال الرقمية بشكل مهني.",
          ],
          en: [
            "Several variables may influence indicative rates or request details, including supported region selection, request timing, verification requirements, and operational availability. That is why app information can be updated before final request completion.",
            "Even small changes in recipient details or payout area can affect displayed information. Accurate input from the start is important. Status tracking also helps users understand whether additional review may impact later steps.",
            "Rather than relying on aggressive promises such as guaranteed speed or guaranteed price advantage, users should focus on transparent in-app information: what is shown now and what comes next. This is a safer and more realistic approach in digital remittance workflows.",
          ],
        },
      },
      {
        heading: {
          ar: "كيف تستخدم الأسعار بشكل ذكي؟",
          en: "How to use rates intelligently",
        },
        paragraphs: {
          ar: [
            "استخدم الأسعار المتاحة كأداة تخطيط: قارن الخيارات، تأكد من بيانات المستلم، وحدد المنطقة المناسبة قبل إرسال الطلب. هذه الخطوات البسيطة تقلل الحاجة لتعديلات لاحقة وتزيد وضوح العملية.",
            "بعد إنشاء الطلب، تابع تحديثات الحالة بعناية. إذا ظهرت ملاحظة تطلب معلومات إضافية، قد يساعد الرد السريع في استمرار معالجة الطلب بسلاسة. ربط السعر بالحالة الفعلية أفضل من الاكتفاء بلقطة أولية للسعر فقط.",
            "في النهاية، فهم أسعار التحويل داخل تطبيق حوالات يعني الجمع بين الشفافية والتوقع الواقعي. المعلومات المتاحة تمنحك بداية قوية، والمتابعة داخل التطبيق تمنحك رؤية أدق حتى اكتمال الطلب.",
          ],
          en: [
            "Treat available rates as a planning tool: compare options, verify recipient details, and choose the right supported region before submission. These steps reduce rework and make the process smoother.",
            "After creating the request, monitor status updates closely. If additional information is requested, timely responses can help progress continue. Rate awareness works best when combined with active status tracking.",
            "Ultimately, understanding transfer rates in a remittance app means balancing transparency with realistic expectations. Available information gives users a solid start, while in-app updates provide clarity through completion.",
          ],
        },
      },
    ],
    legalNote: {
      ar: "Hawwel مُشغَّل من قِبل E-Platform Solutions UAB. تعتمد إتاحة الخدمة على المناطق المدعومة، ومتطلبات التحقق، والفحوصات اللازمة، والقوانين المعمول بها.",
      en: "Hawwel is operated by E-Platform Solutions UAB. Availability depends on supported regions, verification requirements, screening, and applicable laws.",
    },
  },
  {
    slug: "transfer-request-app-vs-digital-wallet",
    title: {
      ar: "الفرق بين تطبيق طلبات التحويل والمحفظة الرقمية",
      en: "Transfer request app vs digital wallet",
    },
    description: {
      ar: "توضيح الفرق بين منصة إدارة طلبات الحوالات الرقمية وبين المحفظة الرقمية التي تحتفظ بالأموال، مع صياغة قانونية واضحة.",
      en: "A clear comparison between a transfer request app and a custodial digital wallet, written with compliance-aware positioning.",
    },
    keywords: {
      ar: ["تطبيق حوالات", "طلب تحويل", "محفظة رقمية", "تحويل أموال", "تتبع حوالة"],
      en: ["transfer request app", "digital wallet", "custodial wallet", "money transfer request", "digital remittance"],
    },
    sections: [
      {
        heading: {
          ar: "نقطة البداية: ما وظيفة كل نموذج؟",
          en: "Starting point: what each model does",
        },
        paragraphs: {
          ar: [
            "تطبيق طلبات التحويل الرقمي يركّز على إنشاء الطلب، إدارة البيانات، وتتبع حالة الطلب. أما المحفظة الرقمية فقد تتضمن وظيفة حفظ الأموال وإدارتها مباشرة. هذا فرق جوهري يؤثر في طريقة وصف الخدمة قانونيًا وفي توقعات المستخدم.",
            "Hawwel يقدَّم كمنصة رقمية لإدارة طلبات الحوالات، وليس كخدمة حفظ أموال المستخدمين. لذلك، من الطبيعي أن تركز تجربة التطبيق على بيانات المستلم، الأسعار المتاحة، تعليمات الطلب، وتحديثات الحالة بدل عرض رصيد محفظة أو ميزات حساب ودائع.",
            "فهم هذا الفرق يحمي المستخدم من التوقعات الخاطئة. عندما تعرف أن الخدمة قائمة على \"طلب تحويل\"، ستتعامل مع التطبيق كأداة تنظيم وتتبّع، لا كبديل لحساب مالي تقليدي.",
          ],
          en: [
            "A transfer request app focuses on request creation, data management, and status tracking. A digital wallet may include storing or holding user funds. This distinction is fundamental for legal positioning and user expectations.",
            "Hawwel is presented as a digital platform for managing money transfer requests, not as a custodial wallet. That is why the experience emphasizes recipient details, available rates, request instructions, and status updates rather than wallet balances.",
            "Understanding this difference prevents confusion. When users know they are using a request-based platform, they approach it as a structured tracking tool rather than a substitute for a deposit account or custodial product.",
          ],
        },
      },
      {
        heading: {
          ar: "الأثر على تجربة المستخدم والامتثال",
          en: "Impact on user experience and compliance",
        },
        paragraphs: {
          ar: [
            "في تطبيق حوالات قائم على الطلبات، الرحلة مصممة لتوضيح المرحلة الحالية والمتطلبات القادمة. هذا يساعد المستخدم على تتبع حوالة بطريقة منهجية، خصوصًا عندما تظهر متطلبات تحقق أو فحوصات إضافية. وضوح الحالة هنا عنصر أساسي.",
            "من زاوية الامتثال، التفريق بين المنصتين مهم جدًا. عندما يتم تقديم المنتج كمنصة طلبات تحويل، تكون الرسائل القانونية أكثر دقة: لا ادعاء بخدمة بنك، ولا حساب ودائع، ولا منصة تداول، ولا محفظة احتفاظ. هذه الشفافية تحسّن الثقة وتقلل مخاطر التضليل.",
            "عمليًا، المستخدم يستفيد من رؤية أوضح: ماذا أدخل الآن؟ ماذا أتابع لاحقًا؟ وما الذي ينتظر التأكيد؟ هذا النوع من التجربة ينسجم مع هدف تحويل الأموال الرقمية بطريقة مسؤولة وقابلة للتتبع.",
          ],
          en: [
            "In a request-based remittance app, the journey is built around clarity: current status, required next steps, and visible updates. This is especially useful when verification or screening checks are involved.",
            "From a compliance standpoint, clear service positioning matters. A transfer request platform can communicate accurately without claiming to be a bank, deposit account, trading platform, cryptocurrency exchange, or custodial wallet.",
            "For users, the practical benefit is better control: what to enter now, what to monitor later, and what remains pending confirmation. This supports a more stable and transparent digital money transfer experience.",
          ],
        },
      },
      {
        heading: {
          ar: "كيف تقرأ الوصف الصحيح للخدمة؟",
          en: "How to read service descriptions correctly",
        },
        paragraphs: {
          ar: [
            "عندما ترى عبارات مثل \"إنشاء وإدارة وتتبع طلبات التحويل\" فهذا يعني أن التطبيق يركز على تنظيم الطلب وتدفق المعلومات. وعندما ترى عبارة \"لا يُقدَّم بوصفه محفظة احتفاظ\" فهذا توضيح مباشر لحدود الخدمة وطبيعة المنتج.",
            "في المحتوى التعليمي أو صفحات الشروط، ابحث دائمًا عن عناصر الشفافية: من هو المشغّل القانوني؟ ما نطاق الخدمة؟ ما العوامل التي تؤثر على الإتاحة؟ هذه الأسئلة تساعدك على اتخاذ قرار واعٍ عند استخدام أي تطبيق حوالات.",
            "الخلاصة أن الفرق بين تطبيق الطلبات والمحفظة الرقمية ليس تفصيلًا تقنيًا صغيرًا، بل أساس لفهم تجربة المستخدم، إدارة المخاطر، والتواصل القانوني الصحيح.",
          ],
          en: [
            "When you read phrases like \"create, manage, and track transfer requests,\" the product is describing a request-management model. When it states \"not presented as a custodial wallet,\" it is clarifying service boundaries.",
            "In legal and educational pages, look for transparency signals: who operates the service, what the service does, and what factors affect availability. These details help users evaluate remittance tools responsibly.",
            "The difference between a transfer request app and a digital wallet is not a minor technical detail. It is central to user understanding, risk communication, and compliant product positioning.",
          ],
        },
      },
    ],
    legalNote: {
      ar: "Hawwel مُشغَّل من قِبل E-Platform Solutions UAB. تعتمد إتاحة الخدمة على المناطق المدعومة، ومتطلبات التحقق، والفحوصات اللازمة، والقوانين المعمول بها.",
      en: "Hawwel is operated by E-Platform Solutions UAB. Availability depends on supported regions, verification requirements, screening, and applicable laws.",
    },
  },
  {
    slug: "how-supported-regions-work",
    title: {
      ar: "كيف تعمل المناطق المدعومة؟",
      en: "How supported regions work",
    },
    description: {
      ar: "شرح عملي لمعنى المناطق المدعومة ومناطق الاستلام المحلية، وكيف تؤثر الإتاحة التشغيلية والامتثال على خيارات المستخدم.",
      en: "A practical explanation of supported regions and local payout areas, and how operational and compliance factors affect availability.",
    },
    keywords: {
      ar: ["مناطق مدعومة", "مناطق استلام", "تطبيق حوالات", "طلب تحويل", "تتبع الحالة"],
      en: ["supported regions", "recipient regions", "local payout areas", "money transfer request", "operational availability"],
    },
    sections: [
      {
        heading: {
          ar: "ما المقصود بالمناطق المدعومة؟",
          en: "What are supported regions?",
        },
        paragraphs: {
          ar: [
            "المناطق المدعومة هي المناطق التي يمكن فيها استقبال أو معالجة الطلب ضمن إطار التشغيل المتاح حاليًا. في خدمات تحويل الأموال الرقمية، الإتاحة لا تكون ثابتة دائمًا، بل قد تتغير حسب عوامل تشغيلية وفنية وقانونية.",
            "عندما يذكر تطبيق حوالات أنه يدعم \"مناطق مختارة\"، فهذا يعني أن الخدمة قد تكون متاحة في بعض مناطق الاستلام دون غيرها، أو قد تختلف الشروط حسب نوع الطلب. لذلك، من الطبيعي أن يرى المستخدم تحديثات في الإتاحة من وقت لآخر.",
            "الهدف من عرض المناطق المدعومة داخل التطبيق هو تقليل الالتباس. المستخدم يعرف منذ البداية أين يمكن إنشاء طلب تحويل بشكل واقعي، وما إذا كانت هناك فحوصات إضافية مطلوبة بناءً على المنطقة المختارة.",
          ],
          en: [
            "Supported regions are areas where requests may be handled under current operational conditions. In digital remittance services, availability is not always static; it can change based on legal, compliance, and operational factors.",
            "When a transfer app says it supports selected regions, this usually means request availability can differ across recipient regions or local payout areas. Requirements may vary depending on request context and screening outcomes.",
            "Showing supported regions inside the app helps reduce confusion. Users can make informed decisions early and understand where requests are currently feasible under applicable conditions.",
          ],
        },
      },
      {
        heading: {
          ar: "لماذا قد تتغيّر الإتاحة؟",
          en: "Why availability may change",
        },
        paragraphs: {
          ar: [
            "الإتاحة قد تتأثر بتحديثات الامتثال، الفحوصات اللازمة، تغيّر متطلبات الشركاء المحليين، أو تغيّرات تشغيلية. لذلك، من الطبيعي وجود ملاحظة قانونية تقول إن المناطق المدعومة قد تتغير في أي وقت.",
            "هذا لا يعني غموضًا في الخدمة، بل يعني شفافية في عرض الواقع التشغيلي. بدل تقديم وعود ثابتة قد لا تبقى دقيقة، يعرض التطبيق المعلومات المتاحة الآن ويحدّثها عند الحاجة. هذه المقاربة أكثر مهنية وتحمي المستخدم من التوقعات غير الواقعية.",
            "عند إنشاء طلب تحويل، احرص على اختيار المنطقة المدعومة التي تظهر داخل التطبيق وقت الطلب نفسه. المتابعة المستمرة للحالة تساعدك أيضًا على معرفة أي تحديث قد يؤثر على الخطوات التالية.",
          ],
          en: [
            "Availability can change due to compliance updates, screening outcomes, local partner conditions, or operational constraints. That is why responsible platforms state clearly that supported regions may change over time.",
            "This is not a sign of uncertainty; it is a sign of transparent service communication. Instead of making fixed promises that may become inaccurate, the app shows current availability and updates it when needed.",
            "When creating a transfer request, rely on the supported region information shown at that moment. Ongoing status tracking also helps users notice any changes that may affect next steps.",
          ],
        },
      },
      {
        heading: {
          ar: "أفضل ممارسات للمستخدم",
          en: "Best practices for users",
        },
        paragraphs: {
          ar: [
            "قبل إنشاء الطلب، راجع قائمة المناطق المدعومة بعناية. بعد ذلك أدخل بيانات المستلم بشكل صحيح لتجنب التأخير الناتج عن المراجعة أو نقص المعلومات. هذه الخطوة البسيطة تجعل رحلة تتبع حوالة أكثر سلاسة.",
            "إذا لم تجد المنطقة المطلوبة متاحة، راقب التحديثات لاحقًا بدل محاولة استخدام معلومات قديمة. الإتاحة داخل التطبيق هي المرجع الأحدث. كما يمكنك التواصل مع الدعم لفهم الخيارات المتاحة دون الاعتماد على افتراضات.",
            "الخلاصة: فهم المناطق المدعومة يعني فهم حدود الخدمة الواقعية. هذا الفهم يمنحك قرارات أفضل ويجعل استخدام تطبيق حوالات أكثر وضوحًا وموثوقية.",
          ],
          en: [
            "Before creating a request, review supported regions carefully. Then enter recipient details accurately to reduce avoidable delays. This simple discipline improves transfer tracking and overall request quality.",
            "If a desired region is unavailable, check updates later rather than relying on old assumptions. The in-app availability view is the most relevant reference. Support can also help clarify current options.",
            "In summary, understanding supported regions means understanding real service boundaries. That clarity leads to better decisions and a more reliable digital transfer request experience.",
          ],
        },
      },
    ],
    legalNote: {
      ar: "Hawwel مُشغَّل من قِبل E-Platform Solutions UAB. تعتمد إتاحة الخدمة على المناطق المدعومة، ومتطلبات التحقق، والفحوصات اللازمة، والقوانين المعمول بها.",
      en: "Hawwel is operated by E-Platform Solutions UAB. Availability depends on supported regions, verification requirements, screening, and applicable laws.",
    },
  },
];

export const learnArticleMap = new Map(learnArticles.map((article) => [article.slug, article]));

export function getLocalized<T extends Localized | LocalizedArray>(value: T, lang: Lang) {
  return value[lang];
}
