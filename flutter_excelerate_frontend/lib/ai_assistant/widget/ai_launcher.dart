import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/core/persona/ai_persona.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/module/ai_module.dart';

class AiLauncher extends StatefulWidget {
  final AiPersona persona;
  const AiLauncher({super.key, required this.persona});

  @override
  State<AiLauncher> createState() => _AiLauncherState();
}

class _AiLauncherState extends State<AiLauncher> with TickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressScaleAnimation;

  late AnimationController _entranceController;
  late Animation<double> _entranceScaleAnimation;

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _pressScaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _entranceScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -3.0, end: 3.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _pressController.dispose();
    _entranceController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _entranceScaleAnimation,
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            transformHitTests: true,
            child: child,
          );
        },
        child: ScaleTransition(
          scale: _pressScaleAnimation,
          child: SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Visual layer (Image without touch area)
                IgnorePointer(
                  child: OverflowBox(
                    maxWidth: 100,
                    maxHeight: 100,
                    child: Builder(
                      builder: (context) {
                        final isDark =
                            Theme.of(context).brightness == Brightness.dark;
                        return Image.asset(
                          isDark
                              ? 'assets/ai_icon/dark.png'
                              : 'assets/ai_icon/light.png',
                          width: 90,
                          height: 90,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),

                // Interactive layer (GestureDetector restricted to a circle)
                ClipOval(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (_) => _pressController.forward(),
                    onTapUp: (_) {
                      _pressController.reverse();

                      if (!AiModule.isInitialized) {
                        try {
                          const String apiKey = String.fromEnvironment(
                            'GEMINI_API_KEY',
                            defaultValue: '',
                          );
                          AiModule.initialize(apiKey: apiKey);
                        } catch (e) {
                          debugPrint('Failed safe initialization: $e');
                        }
                      }

                      if (AiModule.isInitialized) {
                        try {
                          AiModule.instance.openChat(
                            context,
                            persona: widget.persona,
                          );
                        } catch (e) {
                          debugPrint('Failed to open AI Chat: $e');
                        }
                      } else {
                        debugPrint(
                          'AI Launcher tapped but AiModule could not be initialized.',
                        );
                      }
                    },
                    onTapCancel: () => _pressController.reverse(),
                    child: const SizedBox(width: 90, height: 90),
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
