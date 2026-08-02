import 'package:flutter/material.dart';

class AiLoadingWidget extends StatelessWidget {
  const AiLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}



