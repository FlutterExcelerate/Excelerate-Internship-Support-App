import 'package:flutter/material.dart';
import 'theme.dart';

class DailyPulseScreen extends StatefulWidget {
  const DailyPulseScreen({super.key});

  @override
  State<DailyPulseScreen> createState() => _DailyPulseScreenState();
}

class _DailyPulseScreenState extends State<DailyPulseScreen> {
  int _selectedMood = 2; // 0=sad ... 4=excited, default middle
  final TextEditingController _reflectionController = TextEditingController();
  final Set<String> _selectedTags = {'#Work'};

  static const _moods = ['😢', '😕', '😐', '🙂', '🤩'];
  static const _allTags = ['#Work', '#Mission', '#Success', '#Learning'];

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'REFLECTION',
          style: AppTextStyles.labelMd.copyWith(
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'How do you feel today?',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 24),
                    // Mood picker
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(_moods.length, (index) {
                          final isActive = index == _selectedMood;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedMood = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isActive ? 64 : 52,
                              height: isActive ? 64 : 52,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? colorScheme.primaryContainer.withValues(alpha: 0.2)
                                    : Colors.transparent,
                                border: isActive
                                    ? Border.all(color: colorScheme.primary)
                                    : null,
                              ),
                              child: Text(
                                _moods[index],
                                style: TextStyle(fontSize: isActive ? 30 : 24),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Reflection text area
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.edit_note_rounded, size: 18, color: colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Write a short reflection...',
                            style: AppTextStyles.labelMd.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                      ),
                      child: TextField(
                        controller: _reflectionController,
                        maxLines: 6,
                        style: AppTextStyles.bodyMd,
                        decoration: InputDecoration(
                          hintText: 'What insights or challenges surfaced today?',
                          hintStyle: AppTextStyles.bodyMd.copyWith(
                            color: colorScheme.outline.withValues(alpha: 0.6),
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Tag selector
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Focus Areas',
                        style: AppTextStyles.labelMd.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ..._allTags.map((tag) {
                          final isActive = _selectedTags.contains(tag);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isActive) {
                                  _selectedTags.remove(tag);
                                } else {
                                  _selectedTags.add(tag);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? colorScheme.secondary.withValues(alpha: 0.15)
                                    : colorScheme.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: isActive
                                      ? colorScheme.secondary.withValues(alpha: 0.6)
                                      : colorScheme.outlineVariant.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                tag,
                                style: AppTextStyles.caption.copyWith(
                                  color: isActive ? colorScheme.secondary : colorScheme.onSurfaceVariant,
                                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }),
                        // Add custom tag button
                        Container(
                          width: 40,
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.4),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Icon(Icons.add_rounded, size: 18, color: colorScheme.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Submit button (fixed at bottom)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: save the daily pulse entry
                      Navigator.of(context).maybePop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save Pulse',
                          style: AppTextStyles.labelMd.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}