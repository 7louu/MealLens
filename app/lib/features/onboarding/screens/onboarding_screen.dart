import 'package:flutter/material.dart';
import '../../../routes/routes.dart';
class OnboardingContent {
  final String image;
  final String text;

  OnboardingContent({required this.image, required this.text});
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  final List<OnboardingContent> onboardingData = [
    OnboardingContent(image: 'assets/images/onboarding1.png', text: 'Congratulations on taking the first step towards a healthier you!'),
    OnboardingContent(image: 'assets/images/onboarding2.png', text: 'Easily log your meals and track your progress.'),
    OnboardingContent(image: 'assets/images/onboarding3.png', text: 'Set realistic goals and stay motivated with our app.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (context, index) {
                final item = onboardingData[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Image.asset(item.image, height: 300),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        item.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(onboardingData.length, (dotIndex) {
                        bool isActive = dotIndex == currentIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          height: 10,
                          width: isActive ? 24 : 10,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.black : Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 50),
                  ],
                );
              },
            ),
            // Skip Button 
            Positioned(
              left: 20,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  if (currentIndex == 0) {
                    Navigator.pushReplacementNamed(context, AppRoutes.welcome);
                  } else {
                    controller.previousPage(
                      duration: const Duration(microseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Text(currentIndex == 0 ? "Skip" : "Back", style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
            // Next Button
            Positioned(
              right: 20,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  if (currentIndex < onboardingData.length - 1){
                    controller.nextPage(
                      duration: const Duration(microseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushReplacementNamed(context, AppRoutes.welcome);
                  }  
                },
                child: Image.asset('assets/images/next_button.png', width: 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
