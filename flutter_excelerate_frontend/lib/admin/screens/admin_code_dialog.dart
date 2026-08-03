import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/service/admin_service.dart';
import 'package:flutter_excelerate_frontend/theme/app_theme.dart';
import 'package:flutter_excelerate_frontend/student/widgets/learnify_widgets.dart';

class AdminCodeDialog extends StatefulWidget {
  const AdminCodeDialog({super.key});

  @override
  State<AdminCodeDialog> createState() => _AdminCodeDialogState();
}

class _AdminCodeDialogState extends State<AdminCodeDialog> {
  final TextEditingController _controller = TextEditingController();

  bool _loading = false;

  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final success = await AdminService.instance.loginAsAdmin(
        _controller.text,
      );

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);
      } else {
        setState(() {
          _loading = false;
          _error = "Invalid Admin Code";
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = "Permission denied or network error: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LearnifyDialogShell(
      title: 'Administrator Login',
      subtitle: 'Enter the access code to unlock admin tools.',
      icon: Icons.admin_panel_settings_outlined,
      color: LearnifyColors.secondary,
      primaryLabel: _loading ? 'Verifying...' : 'Verify',
      isPrimaryLoading: _loading,
      onPrimaryPressed: _loading ? null : _verify,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LearnifyDialogField(
            controller: _controller,
            label: 'Admin Code',
            icon: Icons.password_rounded,
            errorText: _error,
          ),
        ],
      ),
    );
  }
}
