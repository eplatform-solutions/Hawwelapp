import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';

class paidsacssus extends StatefulWidget {
  const paidsacssus({
    super.key,
    required this.city,
    required this.name,
    required this.paid,
    required this.symbol,
    required this.country,
  });
  final String city;
  final String name;
  final String paid;
  final String symbol;
  final String country;

  @override
  State<paidsacssus> createState() => _paidsacssusState();
}

class _paidsacssusState extends State<paidsacssus>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _iconCtrl;
  late final AnimationController _contentCtrl;
  late final AnimationController _particleCtrl;

  late final Animation<double> _bgFade;
  late final Animation<double> _iconScale;
  late final Animation<double> _iconFade;
  late final Animation<double> _checkDraw;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;
  late final Animation<double> _ripple1;
  late final Animation<double> _ripple2;

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _iconCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _contentCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _particleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat();

    _bgFade = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeOut);

    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _iconCtrl, curve: Curves.elasticOut));
    _iconFade = CurvedAnimation(
        parent: _iconCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut));
    _checkDraw = CurvedAnimation(
        parent: _iconCtrl,
        curve: const Interval(0.35, 0.85, curve: Curves.easeInOut));

    _contentFade =
        CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);
    _contentSlide = Tween<Offset>(
            begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOutCubic));

    _ripple1 = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _particleCtrl, curve: Curves.easeOut));
    _ripple2 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _particleCtrl,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut)));

    HapticFeedback.heavyImpact();
    _bgCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _iconCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      _contentCtrl.forward();
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _iconCtrl.dispose();
    _contentCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: FadeTransition(
          opacity: _bgFade,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0A7A55),
                  const Color(0xFF10B981),
                  const Color(0xFF34D399),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // ── Decorative background circles ──────────────────
                Positioned(
                  top: -80.h,
                  right: -60.w,
                  child: Container(
                    width: 260.w,
                    height: 260.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100.h,
                  left: -80.w,
                  child: Container(
                    width: 320.w,
                    height: 320.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),

                // ── Animated ripple rings ──────────────────────────
                Positioned(
                  top: 160.h,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _particleCtrl,
                    builder: (_, __) {
                      return Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _RippleRing(
                                progress: _ripple1.value, size: 160.w),
                            _RippleRing(
                                progress: _ripple2.value, size: 160.w),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ── Floating particles ─────────────────────────────
                AnimatedBuilder(
                  animation: _particleCtrl,
                  builder: (_, __) => CustomPaint(
                    size: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height),
                    painter: _ParticlePainter(_particleCtrl.value),
                  ),
                ),

                // ── Main content ───────────────────────────────────
                SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 80.h),

                      // ── Animated check icon ────────────────────
                      ScaleTransition(
                        scale: _iconScale,
                        child: FadeTransition(
                          opacity: _iconFade,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 110.w,
                                height: 110.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                              Container(
                                width: 86.w,
                                height: 86.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: AnimatedBuilder(
                                  animation: _checkDraw,
                                  builder: (_, __) => CustomPaint(
                                    painter: _CheckPainter(
                                      _checkDraw.value,
                                      const Color(0xFF10B981),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // ── Title & subtitle ───────────────────────
                      FadeTransition(
                        opacity: _contentFade,
                        child: SlideTransition(
                          position: _contentSlide,
                          child: Column(
                            children: [
                              Text(
                                AppTranslations.getText(
                                    context, "payment_success"),
                                style: GoogleFonts.cairo(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 7.h),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withValues(alpha: 0.18),
                                  borderRadius:
                                      BorderRadius.circular(30.r),
                                ),
                                child: Text(
                                  '${widget.paid} ${widget.symbol}',
                                  style: GoogleFonts.cairo(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // ── Details card ───────────────────────────
                      FadeTransition(
                        opacity: _contentFade,
                        child: SlideTransition(
                          position: _contentSlide,
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 24.w),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color:
                                      Colors.white.withValues(alpha: 0.25),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  _DetailRow(
                                    icon: Icons.person_rounded,
                                    label: AppTranslations.getText(
                                        context, "The cash will be sent to"),
                                    value: widget.name,
                                    isFirst: true,
                                  ),
                                  _Divider(),
                                  _DetailRow(
                                    icon: Icons.location_on_rounded,
                                    label: AppTranslations.getText(
                                        context, "city"),
                                    value: widget.city,
                                  ),
                                  _Divider(),
                                  _DetailRow(
                                    icon: Icons.flag_rounded,
                                    label: AppTranslations.getText(
                                        context, "country"),
                                    value: widget.country,
                                    isLast: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // ── Done button ────────────────────────────
                      FadeTransition(
                        opacity: _contentFade,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 32.h),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context)
                                  .popUntil((r) => r.isFirst);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 54.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: 0.12),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  AppTranslations.getText(context, 'done'),
                                  style: GoogleFonts.cairo(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF10B981),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Detail row ──────────────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isFirst;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.sp, color: Colors.white),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    color: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.cairo(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Colors.white.withValues(alpha: 0.12),
      indent: 16,
      endIndent: 16,
    );
  }
}

// ── Ripple ring painter ──────────────────────────────────────────────────────
class _RippleRing extends StatelessWidget {
  final double progress;
  final double size;
  const _RippleRing({required this.progress, required this.size});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (1 - progress).clamp(0.0, 1.0) * 0.35,
      child: Container(
        width: size * (1 + progress * 1.4),
        height: size * (1 + progress * 1.4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

// ── Check painter ────────────────────────────────────────────────────────────
class _CheckPainter extends CustomPainter {
  final double progress;
  final Color color;
  const _CheckPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // checkmark path: down-left then up-right
    final p1 = Offset(cx - 16, cy);
    final p2 = Offset(cx - 4, cy + 12);
    final p3 = Offset(cx + 18, cy - 14);

    final totalLen =
        (p2 - p1).distance + (p3 - p2).distance;
    final drawn = totalLen * progress;

    final seg1 = (p2 - p1).distance;

    if (drawn <= seg1) {
      final t = drawn / seg1;
      canvas.drawLine(p1, Offset.lerp(p1, p2, t)!, paint);
    } else {
      canvas.drawLine(p1, p2, paint);
      final t = (drawn - seg1) / (p3 - p2).distance;
      canvas.drawLine(p2, Offset.lerp(p2, p3, t)!, paint);
    }
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.progress != progress;
}

// ── Particle painter ─────────────────────────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final double t;
  static final List<_Particle> _particles = List.generate(
    18,
    (i) => _Particle(
      angle: (i / 18) * 2 * pi,
      radius: 0.18 + (i % 3) * 0.07,
      size: 3.0 + (i % 4) * 2.0,
      speed: 0.4 + (i % 5) * 0.12,
      offset: (i % 7) * 0.13,
    ),
  );

  const _ParticlePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.34;
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in _particles) {
      final progress = ((t + p.offset) % 1.0);
      if (progress < 0.05) continue;
      final opacity = (1.0 - progress).clamp(0.0, 1.0) * 0.6;
      final r = size.width * p.radius * progress;
      final x = cx + cos(p.angle) * r;
      final y = cy + sin(p.angle) * r * 0.6;
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), p.size * (1 - progress * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}

class _Particle {
  final double angle;
  final double radius;
  final double size;
  final double speed;
  final double offset;
  const _Particle({
    required this.angle,
    required this.radius,
    required this.size,
    required this.speed,
    required this.offset,
  });
}