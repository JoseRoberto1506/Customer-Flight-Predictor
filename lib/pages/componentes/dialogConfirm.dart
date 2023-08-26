import 'package:flutter/material.dart';

class ConfirmationDialog {
  static Future<bool?> show(
      BuildContext context, String title, String content) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false (not confirmed)
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true (confirmed)
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}
