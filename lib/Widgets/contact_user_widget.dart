
import 'package:flutter/material.dart';

class ContractUserBtn extends StatelessWidget {
  const ContractUserBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(color: Colors.blue),
        backgroundColor: Colors.white,
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      onPressed: () => {
      },
      icon: const Icon(Icons.send_sharp,),
      label: const Text('Chat',),
    );
  }
}