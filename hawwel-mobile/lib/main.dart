import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/localization/lang_cubit.dart';
import 'package:hawwel/constans/server_lectur.dart';
import 'package:hawwel/constans/token.dart';
import 'package:hawwel/constans/widgets/floating_chat_button.dart';
import 'package:hawwel/featue/support_chat/data/unread_chat_state.dart';
import 'package:hawwel/featue/support_chat/data/chat_socket_service.dart';
import 'package:hawwel/featue/Two-factor_authentication/data/cubit/cubit.dart';
import 'package:hawwel/featue/Two-factor_authentication/data/repo/repo_implmntion.dart';
import 'package:hawwel/featue/auth/conferm_password/data/cubit/conferm_cubit.dart';
import 'package:hawwel/featue/auth/conferm_password/data/repo/conferm_repo_implmantion.dart';
import 'package:hawwel/featue/auth/forgeat_password/data/cubit/forget_cubit.dart';
import 'package:hawwel/featue/auth/forgeat_password/data/repo/forget_repo_implmantion.dart';
import 'package:hawwel/featue/auth/login/data/cubit/login_cubir.dart';
import 'package:hawwel/featue/auth/login/data/repo/login_repo.dart';
import 'package:hawwel/featue/auth/login/login_screen_view.dart';
import 'package:hawwel/featue/auth/rejster/regster_screen_view.dart';
import 'package:hawwel/featue/auth/rejster/data/cubit/regster_cubut.dart';
import 'package:hawwel/featue/auth/rejster/data/repo/rejster_repo_implmantion.dart';
import 'package:hawwel/featue/auth/resst_passwrd/cubit/cubit.dart';
import 'package:hawwel/featue/auth/resst_passwrd/repo/repo_implmntion.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_airea/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_amount_to_send.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_city/cubit_city.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_conversion_methods/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_country_payment_methods/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_transfers/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubite_rate/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo/repo_implmantion.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_airea/repo_implmntion.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_city/repo_implmntion_city.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_conversion_methods/repo_implmntion.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_country_payment_methods/repo_implmntion.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_rate/repo_imolmantion.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_trnsfer/repo_implmntion.dart';
import 'package:hawwel/featue/bootom_navigator.dart';
import 'package:hawwel/featue/first_screen/bootom_navigatot_first_screen.dart';
import 'package:hawwel/featue/first_screen/home_first_screen.dart';
import 'package:hawwel/featue/lode_file/data/cubit/cubit.dart';
import 'package:hawwel/featue/lode_file/data/repo/repo_implmantion.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/cubit/cubit.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/data_edit_information/cubit/cubit.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/data_edit_information/cubit/repo/repo_implmentaion.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/repo/repo_implmantion.dart';
import 'package:hawwel/featue/notifation/data/cubit/cubit.dart';
import 'package:hawwel/featue/notifation/data/cubit/cubit_mark.dart';
import 'package:hawwel/featue/notifation/data/repo/repo_implmantion.dart';
import 'package:hawwel/featue/notifation/notifacation_view.dart';
import 'package:hawwel/featue/notifation/notification_navigation.dart';
import 'package:hawwel/featue/profail/data/cubit/cubit.dart';
import 'package:hawwel/featue/profail/data/cubit_image/cubi.dart';
import 'package:hawwel/featue/profail/data/cubit_put/cubit.dart';
import 'package:hawwel/featue/profail/data/repo/repo_implmantion.dart';
import 'package:hawwel/featue/profail/data/repo_image/repo_implmntion.dart';
import 'package:hawwel/featue/profail/data/repo_put/repo_implmntion.dart';
import 'package:hawwel/featue/sender_information/data/repo/cubit/cubit.dart';
import 'package:hawwel/featue/sender_information/data/repo/repo_implmntion.dart';
import 'package:hawwel/featue/technical_support/data/cubite/cubite.dart';
import 'package:hawwel/featue/technical_support/data/repo/repo_implmantion.dart';
import 'package:hawwel/featue/support_chat/data/cubite/cubite.dart';
import 'package:hawwel/featue/transaction_historu/data/cubit/cubit.dart';
import 'package:hawwel/featue/transaction_historu/data/repo/repo_implmnation.dart';
import 'package:hawwel/firbeas/firbeas_option.dart';
import 'package:hawwel/firbeas/notifaction.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool openedFromNotification = false;
Map<String, dynamic>? initialNotificationData;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    // 1. تهيئة Firebase أولاً
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. إعداد التعامل مع الخلفية قبل أي شيء آخر
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 3. تهيئة الإشعارات المحلية والقنوات (التي تحتوي على ID_v2)
    await Notifications.init();

    // 4. التحقق من الرسالة التي فتحت التطبيق
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      openedFromNotification = true;
      initialNotificationData = Map<String, dynamic>.from(initialMessage.data);
    }
  }

  // Every screen is laid out for portrait; landscape only breaks the forms
  // and gives store reviewers something to rotate into.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // ... بقية الإعدادات
  setupServiceLocator();
  await Functions().testToken();
  ChatUnreadState.refreshFromServer();
  ChatSocketService.instance.init();
  // Registered on every launch (not only at login): a token that was not
  // ready at login time (iOS APNs, emulators) or that changed after a
  // reinstall would otherwise leave the server with an empty/stale token
  // and every push failing with NotRegistered.
  Notifications.registerFCMToken(
    loggedIn: Functions.loginStateNotifier.value,
    language: 'ar',
  );

  runApp(const MyApp());

  // لا يجب أن يعلّق بدء تشغيل التطبيق: الواجهة تستمع لـ appBrandingNotifier
  // وتتحدّث تلقائياً متى ما وصلت الاستجابة (كما يحدث بالفعل عند استئناف التطبيق).
  AppBrandingService.load();
}
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   // await Firebase.initializeApp();
//   final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

//   if (initialMessage != null) {
//     openedFromNotification = true;
//   }

//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//   await Notifications.init();

//   /// DI
//   setupServiceLocator();

//   await Functions().testToken();

//   /// Lock orientation
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   runApp(const MyApp());
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final payload = initialNotificationData;
      if (payload == null || !mounted) return;
      initialNotificationData = null;
      final opened = await NotificationNavigation.openFromNotificationData(
        context,
        payload,
      );
      if (!opened && mounted) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const Notifation()));
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AppBrandingService.load();
      ChatUnreadState.refreshFromServer();
      ChatSocketService.instance.ensureConnected(force: true);
      Notifications.registerFCMToken(
        loggedIn: Functions.loginStateNotifier.value,
        language: 'ar',
      );
    }
  }

  Widget _buildPreviewScreen(String rawKey) {
    final key = rawKey.trim().toLowerCase();
    switch (key) {
      case 'welcome':
        return const Homefirstscreen();
      case 'login':
        return const Loginview();
      case 'register':
        return const Regsterview();
      case 'transfer':
        return const Welcomyoufirstscreen();
      case 'app-home':
        return const HomeScreen();
      case 'notifications':
        return const Notifation();
      default:
        return const Homefirstscreen();
    }
  }

  Widget _resolveHome() {
    if (kIsWeb && Uri.base.queryParameters['preview'] == 'true') {
      final previewScreen = Uri.base.queryParameters['screen'] ?? 'welcome';
      return _buildPreviewScreen(previewScreen);
    }

    return Functions().isLogin ? const HomeScreen() : const Homefirstscreen();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(
            ImplmentRepoLogin(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(create: (context) => CurrencyCubit()),
        BlocProvider(
          create: (context) => PaymentMethodsCubit(
            PaymentMethodsRepoImpl(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(
          create: (context) => CountryPaymentMethodsCubit(
            CountryPaymentMethodsRepoImpl(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(
          create: (context) =>
              SupportCubit(SupportRepoImpl(api: getIt.get<ApiService>())),
        ),
        BlocProvider(
          create: (context) => ChatCubit(getIt.get<ApiService>()),
        ),
        BlocProvider(
          create: (context) => ExchangeRatesCubit(
            ExchangeRatesRepoImpl(api: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(
          create: (context) => TransferCubit(
            TransferRepoImpl(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(
          create: (context) =>
              CitiesCubit(CitiesRepoImpl(apiService: getIt.get<ApiService>())),
        ),
        BlocProvider(
          create: (context) =>
              AreasCubit(AreasRepoImpl(apiService: getIt.get<ApiService>())),
        ),
        BlocProvider(
          create: (context) =>
              UploadKycCubit(KycRepoImpl(getIt.get<ApiService>())),
        ),
        BlocProvider(
          create: (context) => CountriesCubit(
            CountriesRepoImpl(apiService: getIt.get<ApiService>()),
          ),
        ),

        BlocProvider(
          create: (_) => UpdateReceiverCubit(
            UpdateReceiverRepoImpl(ApiService(dio: Dio())),
          ),
        ),
        //  BlocProvider(
        //   create: (context) => KycCubit(
        //     ImplmentRepoLogin(apiService: getIt.get<ApiService>()),
        //   ),
        // ),
        BlocProvider(
          create: (context) => RegisterCubit(
            ImplmentReporejster(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(
          create: (context) => MarkAllReadCubit(
            NotificationsRepoImpl(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(
          create: (context) => NotificationsCubit(
            NotificationsRepoImpl(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(
          create: (context) => ReceiversDisplayCubit(
            ReceiversDisplayRepoImpl(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(
          create: (context) => ReceiversCubit(
            ReceiversRepoImpl(apiService: getIt.get<ApiService>()),
          ),
        ),

        //       BlocProvider(
        //   create: (context) => CurrencyCubit(), // ← هنا يتم توفير الـ Cubit
        //   child: Welcomyou(),
        // ),
        BlocProvider(
          create: (context) =>
              TransfersCubit(TransfersRepoImpl(api: getIt.get<ApiService>())),
        ),
        BlocProvider(
          create: (context) => ForgetCubit(
            ImplmentRepoforgetpassword(apiService: getIt.get<ApiService>()),
          ),
        ),

        BlocProvider(
          create: (context) => ConfermCubit(
            ImplmentConfirmRepo(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(
          create: (context) => Userinfogcubit(
            Implemntuserinfo(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(
          create: (context) => ChangeImageCubit(
            ImplementChangeImageRepo(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(
          create: (context) => ChangePasswordCubit(
            ChangePasswordRepoImpl(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(
          create: (context) => UpdateInfoCubit(
            UpdateInfoRepoImpl(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider(
          create: (context) => Change2FACubit(
            Change2FARepositoryImpl(apiService: getIt.get<ApiService>()),
          ),
        ),
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
      ],

      child: BlocBuilder<LanguageCubit, Language>(
        builder: (context, language) {
          final isArabic = language == Language.arabic;

          return ScreenUtilInit(
            designSize: const Size(375, 866),
            minTextAdapt: true,
            splitScreenMode: true,
            child: ValueListenableBuilder<AppBrandingConfig>(
              valueListenable: appBrandingNotifier,
              builder: (context, branding, _) {
                final textTheme = GoogleFonts.cairoTextTheme().apply(
                  bodyColor: branding.textColorValue,
                  displayColor: branding.textColorValue,
                );

                Decoration globalBackground;
                if (branding.themeMode == 'solid') {
                  globalBackground = BoxDecoration(
                    color: branding.solidBackgroundColorValue,
                  );
                } else if (branding.themeMode == 'image' &&
                    branding.backgroundImageUrl.isNotEmpty) {
                  globalBackground = BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(branding.backgroundImageUrl),
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  globalBackground = BoxDecoration(
                    gradient: branding.buildHeaderGradient(),
                  );
                }

                return MaterialApp(
                  navigatorKey: navigatorKey,
                  navigatorObservers: [CurrentRouteObserver()],
                  debugShowCheckedModeBanner: false,
                  locale: Locale(isArabic ? 'ar' : 'en'),
                  supportedLocales: const [Locale('ar'), Locale('en')],
                  localizationsDelegates: const [
                    CountryLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  theme: ThemeData(
                    textTheme: textTheme,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: branding.gradientStartColorValue,
                      primary: branding.gradientStartColorValue,
                      secondary: branding.accent,
                      surface: branding.screenBg,
                      error: branding.error,
                    ),
                    primaryColor: branding.gradientStartColorValue,
                    scaffoldBackgroundColor: branding.screenBg,
                    appBarTheme: AppBarTheme(
                      backgroundColor: branding.appBar,
                      foregroundColor: branding.buttonText,
                    ),
                  ),
                  builder: (context, child) {
                    return DecoratedBox(
                      decoration: globalBackground,
                      child: Stack(
                        children: [
                          child ?? const SizedBox.shrink(),
                          const FloatingChatButton(),
                        ],
                      ),
                    );
                  },
                  home: _resolveHome(),
                  // (Functions().isLogin)
                  //     ? HomeScreen()
                  //     : const Homefirstscreen(),
                  //Homefirstscreen(),
                  // (Functions().isLogin) ? HomeScreen() : const Homefirstscreen(),
                  //  Loginview(),
                  //paidsacssus(),
                  //statepademor(),
                  //Loginview(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => LanguageCubit(),
//       child: BlocBuilder<LanguageCubit, Language>(
//         builder: (context, language) {
//           final isArabic = language == Language.arabic;

//           return ScreenUtilInit(
//             designSize: const Size(375, 866),
//             minTextAdapt: true,
//             splitScreenMode: true,
//             child: MaterialApp(
//               debugShowCheckedModeBanner: false,

//               // لغة التطبيق
//               locale: Locale(isArabic ? 'ar' : 'en'),
//               supportedLocales: const [Locale('ar'), Locale('en')],

//               localizationsDelegates: const [
//                 GlobalMaterialLocalizations.delegate,
//                 GlobalWidgetsLocalizations.delegate,
//                 GlobalCupertinoLocalizations.delegate,
//               ],

//               theme: ThemeData(
//                 textTheme: GoogleFonts.cairoTextTheme(),
//               ),

//               builder: (context, child) {
//                 return Directionality(
//                   textDirection:
//                       isArabic ? TextDirection.rtl : TextDirection.ltr,
//                   child: child!,
//                 );
//               },

//               home: Loginview(),
//             ),
//           );
//         },
//       ),
//     );
//   }
