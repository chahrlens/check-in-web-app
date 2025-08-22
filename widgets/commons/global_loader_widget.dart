import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/controllers/loader_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GlobalLoader extends StatelessWidget {
  const GlobalLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = Get.find<LoaderController>().isLoading.value;

      if (!isLoading) return const SizedBox.shrink();

      return Stack(
        children: [
          // Backdrop
          const Opacity(
            opacity: 0.5,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
          // Loading animation centered
          Center(
            child: LoadingAnimationWidget.dotsTriangle(
              color: Theme.of(context).colorScheme.secondary,
              size: 75,
            ),
          ),
        ],
      );
    });
  }
}
