import 'package:flutter/material.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';

Future<void> showDeleteuser(
  BuildContext context,
  Function(String) onDelete, {
  required String codeController,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // المستخدم يجب أن يضغط على زر لتجاهل

    builder: (BuildContext context) {
      return AlertDialog(
        title: 'حذف دور المعلم'.style().center(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            'هل أنت متأكد أنك تريد حذف دور المعلم؟'.style(
              fontSize: 16,
            ),
            const SizedBox(height: 16),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: 'إلغاء'.style(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('حذف'),
            onPressed: () {
              final code = codeController;

              if (code.isNotEmpty) {
                onDelete(code);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يرجى ملء كافة الحقول')),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

void showDeleteDialog(BuildContext context, void Function()? onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: 'تأكيد الحذف'.style().center(),
        content: 'هل أنت متأكد أنك تريد حذف'.style(),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('ألغاء'),
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('حذف'),
          ),
        ],
      );
    },
  );
}
