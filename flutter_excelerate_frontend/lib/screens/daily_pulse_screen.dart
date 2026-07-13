import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
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
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'A quick check-in helps Learnify personalize your pace and support.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_moods.length, (index) {
                    final mood = _moods[index];
                    final isSelected = index == _selectedMood;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => setState(() => _selectedMood = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? LearnifyColors.wellness.withValues(
                                      alpha: 0.16,
                                    )
                                  : LearnifyColors.canvas,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? LearnifyColors.wellness
                                    : LearnifyColors.ink.withValues(
                                        alpha: 0.06,
                                      ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  mood.$2,
                                  color: isSelected
                                      ? LearnifyColors.warning
                                      : LearnifyColors.muted,
                                ),
                                const SizedBox(height: 6),
                                FittedBox(
                                  child: Text(
                                    mood.$1,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: isSelected
                                          ? LearnifyColors.warning
                                          : LearnifyColors.muted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                        return FilterChip(
                          label: Text(
                            tag,
                            style: TextStyle(color: Colors.black),
                          ),
                          selected: _selectedTags.contains(tag),
                          onSelected: (selected) {
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
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Submit Pulse'),
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
