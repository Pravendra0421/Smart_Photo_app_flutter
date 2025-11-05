import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controllers/onboarding_main_controller.dart';
import '../../../routes.dart';
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.onboardingPages.isEmpty) {
          return const Center(child: Text("Onboarding is empty"));
        }

        // Get the data for the current page to display background and MainTitle
        final currentPageData = controller.onboardingPages[controller.currentPageIndex.value];

        return Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                currentPageData.bgUrl,
                fit: BoxFit.cover,
                // Show a solid color while the image loads or if it fails
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: const Color(0xFF3A86FF)); // Blue background fallback
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: const Color(0xFF3A86FF));
                },
              ),
            ),

            // Layer 2: Main Content
            SafeArea(
              child: Column(
                children: [
                  // Top Bar: App Name and Skip Button
                  _buildTopBar(context, currentPageData.mainTitle),

                  // The swipeable content area
                  Expanded(
                    child: PageView.builder(
                      controller: controller.pageController,
                      itemCount: controller.onboardingPages.length,
                      onPageChanged: (index) => controller.currentPageIndex.value = index,
                      itemBuilder: (context, index) {
                        final pageData = controller.onboardingPages[index];
                        return OnboardingPageContent(
                          imageUrl: pageData.imageUrl,
                          title: pageData.title,
                          subtitle: pageData.subTitle,
                        );
                      },
                    ),
                  ),

                  // Dot Indicator
                  SmoothPageIndicator(
                    controller: controller.pageController,
                    count: controller.onboardingPages.length,
                    effect: const WormEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.white54,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Next Button
                  _buildNextButton(context, controller),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // Helper widget for the top bar
  Widget _buildTopBar(BuildContext context, String mainTitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            mainTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle skip logic, e.g., navigate to home
              Get.toNamed(AppRoutes.PHONELOGIN);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for the "Next" button
  Widget _buildNextButton(BuildContext context, OnboardingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ElevatedButton(
        onPressed: () => controller.nextPage(),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50), // Full width
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF3A86FF), // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          // Change button text on the last page
          controller.currentPageIndex.value == controller.onboardingPages.length - 1
              ? "Get Started"
              : "Next",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// A widget to hold the content FOR A SINGLE PAGE that slides
class OnboardingPageContent extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const OnboardingPageContent({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main illustration for the page
          Image.network(
            imageUrl,
            height: MediaQuery.of(context).size.height * 0.35,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.broken_image_rounded,
              size: 150,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 60),

          // Title Text
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Subtitle Text
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}