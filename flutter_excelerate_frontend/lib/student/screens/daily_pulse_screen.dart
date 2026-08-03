import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../firebase/models/daily_pulse_model.dart';
import '../../firebase/service/daily_pulse_service.dart';
import '../../theme/app_theme.dart';
import '../widgets/learnify_widgets.dart';

class DailyPulseScreen extends StatefulWidget {
  const DailyPulseScreen({super.key});

  @override
  State<DailyPulseScreen> createState() => _DailyPulseScreenState();
}

class _DailyPulseScreenState extends State<DailyPulseScreen> {
  final _reflectionController = TextEditingController();
  final _selectedTags = <String>{'#Work', '#Mission'};
  int _selectedMood = 3;
  bool _isSaving = false;

  final _moods = const [
    ('Drained', Icons.sentiment_very_dissatisfied_rounded),
    ('Low', Icons.sentiment_dissatisfied_rounded),
    ('Steady', Icons.sentiment_neutral_rounded),
    ('Good', Icons.sentiment_satisfied_rounded),
    ('Great', Icons.sentiment_very_satisfied_rounded),
  ];

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  void _selectMood(int index) {
    if (_selectedMood != index) {
      HapticFeedback.mediumImpact();
      setState(() {
        _selectedMood = index;
      });
    }
  }

  Future<void> _submitPulse() async {
    HapticFeedback.mediumImpact();
    setState(() => _isSaving = true);

    try {
      await DailyPulseService.instance.addPulse(
        mood: _selectedMood,
        moodLabel: _moods[_selectedMood].$1,
        reflection: _reflectionController.text.trim(),
        tags: _selectedTags.toList()..sort(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Daily Pulse saved.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save pulse: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveScaffold(
      appBar: AppBar(title: const Text('Daily Pulse')),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SectionCard(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const IconBadge(
                  icon: Icons.favorite_rounded,
                  color: LearnifyColors.wellness,
                  size: 58,
                ),
                const SizedBox(height: 18),
                Text(
                  'How are you feeling today?',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'A quick check-in helps Learnify personalize your pace and support.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_moods.length, (index) {
                    final mood = _moods[index];
                    final isSelected = index == _selectedMood;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _MoodItem(
                          label: mood.$1,
                          icon: mood.$2,
                          isSelected: isSelected,
                          onTap: () => _selectMood(index),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _reflectionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Write a short reflection...',
                    prefixIcon: Icon(Icons.edit_note_rounded),
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['#Work', '#Mission', '#Focus', '#Win', '#NeedHelp']
                      .map((tag) {
                        final isSelected = _selectedTags.contains(tag);
                        return FilterChip(
                          label: Text(
                            tag,
                            style: TextStyle(color: Colors.black),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              selected
                                  ? _selectedTags.add(tag)
                                  : _selectedTags.remove(tag);
                            });
                          },
                        );
                      })
                      .toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isSaving ? null : _submitPulse,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_circle_outline_rounded),
                    label: Text(_isSaving ? 'Saving...' : 'Submit Pulse'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Recent Check-ins', style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
          StreamBuilder<List<DailyPulseModel>>(
            stream: DailyPulseService.instance.currentUserPulsesStream(),
            builder: (context, snapshot) {
              final pulses = snapshot.data ?? [];

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (pulses.isEmpty) {
                return SectionCard(
                  child: Text(
                    'No check-ins yet.',
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }

              return Column(
                children: pulses.take(3).map((pulse) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PulseTile(pulse: pulse),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PulseTile extends StatelessWidget {
  const _PulseTile({required this.pulse});

  final DailyPulseModel pulse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadge(
            icon: Icons.favorite_rounded,
            color: LearnifyColors.wellness,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pulse.moodLabel, style: theme.textTheme.titleMedium),
                if (pulse.reflection.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    pulse.reflection,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: pulse.tags
                      .map(
                        (tag) => Pill(
                          label: tag,
                          icon: Icons.sell_outlined,
                          color: LearnifyColors.primary,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodItem extends StatelessWidget {
  const _MoodItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.12 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        child: AnimatedRotation(
          turns: isSelected ? 0.015 : 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? LearnifyColors.wellness.withValues(alpha: 0.16)
                  : theme.brightness == Brightness.light
                  ? const Color(0xFFF1F5F9)
                  : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? LearnifyColors.wellness
                    : theme.brightness == Brightness.light
                    ? const Color(0xFFE2E8F0)
                    : const Color(0xFF334155),
                width: isSelected ? 1.8 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: LearnifyColors.wellness.withValues(
                          alpha: isDark ? 0.2 : 0.15,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: isSelected
                      ? LearnifyColors.wellness
                      : (isDark
                            ? LearnifyColors.mutedDark
                            : LearnifyColors.mutedLight),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: isSelected
                          ? LearnifyColors.wellness
                          : (isDark
                                ? LearnifyColors.mutedDark
                                : LearnifyColors.mutedLight),
                    ),
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
