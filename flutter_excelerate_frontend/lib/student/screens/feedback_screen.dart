import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/models/feedback_model.dart';
import 'package:flutter_excelerate_frontend/firebase/service/feedback_service.dart';
import 'package:flutter_excelerate_frontend/firebase/service/user_service.dart';
import 'package:flutter_excelerate_frontend/student/widgets/learnify_widgets.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;
  String _category = "General";
  static const int _minFeedbackLength = 10;
  static const int _maxFeedbackLength = 800;
  bool get isValid =>
      _messageController.text.trim().length >= _minFeedbackLength;
  final List<String> _categories = [
    "General",
    "Course",
    "Bug Report",
    "Feature Request",
    "UI / UX",
    "Performance",
    "AI Assistant",
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> submitFeedback() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      try {
        if (firebaseUser == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Please login first.")));
          return;
        }
        if (!_formKey.currentState!.validate()) {
          return;
        }
        setState(() {
          _isLoading = true;
        });
        final appUser = await UserService.instance.getUser(firebaseUser.uid);

        if (appUser == null) {
          throw Exception("User profile not found.");
        }

        final feedback = FeedbackModel(
          id: '',
          uid: firebaseUser.uid,
          userName: appUser.name,
          userEmail: appUser.email,
          message: _messageController.text.trim(),
          category: _category,
          createdAt: Timestamp.now(),
        );
        await FeedbackService.instance.addFeedback(feedback: feedback);
        if (!mounted) return;

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Thank you! Your feedback has been submitted."),
          ),
        );
        _titleController.clear();
        _messageController.clear();
        setState(() {
          _category = "General";
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(
          SnackBar(
            content: Text("Something went wrong please try again later"),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Feedback")),

      body: SafeArea(
        child: GradientBlobBackground(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(context).viewInsets.bottom + 20,
            ),

            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),

                    items: _categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,

                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _category = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 6,
                    maxLength: _maxFeedbackLength,
                    decoration: const InputDecoration(
                      labelText: "Feedback",
                      hintText: "Tell us about your experience...",
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your feedback.";
                      }
                      final text = value.trim();
                      if (text.length < _minFeedbackLength) {
                        return "Feedback must be at least $_minFeedbackLength characters.";
                      }
                      if (text.length > _maxFeedbackLength) {
                        return "Feedback cannot exceed $_maxFeedbackLength characters.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: FilledButton(
                        onPressed: (_isLoading || !isValid)
                            ? null
                            : submitFeedback,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text("Submit Feedback"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
