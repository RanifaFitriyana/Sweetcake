import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      {
        "image": "assets/images/logo.png",
        "title": "SweetCake",
        "subtitle": "Kue Lezat, Momen Spesial",
      },
      {
        "image": "assets/images/onboarding2.png",
        "title": "Fresh Every Day",
        "subtitle":
            "Roti dan kue dibuat setiap hari menggunakan bahan terbaik.",
      },
      {
        "image": "assets/images/onboarding3.png",
        "title": "Easy Ordering",
        "subtitle": "Pesan roti favoritmu kapan saja dan di mana saja.",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.changePage,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(pages[index]["image"]!, height: 260),

                        const SizedBox(height: 40),

                        Text(
                          pages[index]["title"]!,
                          style: AppTextStyles.title,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 15),

                        Text(
                          pages[index]["subtitle"]!,
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: controller.currentPage.value == index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: controller.nextPage,
                  child: Obx(
                    () => Text(
                      controller.currentPage.value == 2
                          ? "Get Started"
                          : "Next",
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
