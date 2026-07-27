import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/service/admin_service.dart';

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
      final success =
          await AdminService.instance.loginAsAdmin(_controller.text);

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
    return AlertDialog(
      title: const Text("Administrator Login"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Admin Code",
              errorText: _error,
            ),
          ),
          const SizedBox(height: 20),
          if (_loading) const CircularProgressIndicator(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: _loading ? null : _verify,
          child: const Text("Verify"),
        ),
      ],
    );
  }
}
