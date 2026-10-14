import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:usdt/constans/app_branding.dart';

class CustomStepper extends StatelessWidget {
  final int currentStep; // رقم الخطوة الحالية (1 أو 2 أو 3)
  const CustomStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        int stepNumber = index + 1;
        bool isActive = stepNumber <= currentStep;

        return Row(
          children: [
            // 🔸 الدائرة
            Container(
              height: 30.h,
              width: 30.h,
              decoration: BoxDecoration(
                color: isActive ? branding.accent : Colors.white,
                shape: BoxShape.circle,
                // border: Border.all(color: Color(), width: 2),
              ),
              child: Center(
                child: Text(
                  "$stepNumber",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: branding.primaryText,
                  ),
                ),
              ),
            ),

            // 🔹 الخط بين الدوائر (ما يظهر بعد الأخيرة)
            if (stepNumber != 3)
              Container(
                height: 3.h,
                width: 80.w,
                color: stepNumber < currentStep
                    ? branding.accent
                    : Colors.white,
              ),
          ],
        );
      }),
    );
  }
}
