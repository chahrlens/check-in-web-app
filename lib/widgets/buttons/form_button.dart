
import 'package:flutter/material.dart';
import 'package:qr_check_in/shared/resources/custom_style.dart';

import 'custom_button.dart';


class FormButton extends StatelessWidget {
  final void Function() onPress;
  final String text;

const FormButton({ super.key, required this.onPress, this.text = "Guardar" });

  @override
  Widget build(BuildContext context){
    return  Padding(
        padding: const EdgeInsets.all(50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton(
                width: 35,
                height: 25,
                color: Theme.of(context).colorScheme.primary,
                text: Text(
                  text,
                  style: CustomStyle.textStyleWhite(context),
                ),
                isLoading: false,
                onPress: onPress)
          ],
        ),
      );
  }
}