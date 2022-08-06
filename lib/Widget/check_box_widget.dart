import '../../Modelo/check_box_modelo.dart';
import 'package:flutter/material.dart';

import '../Uteis/paleta_cores.dart';

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget({Key? key, required this.item}) : super(key: key);

  final CheckBoxModel item;

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      activeColor: PaletaCores.corAdtl,
      checkColor: PaletaCores.corAdtlLetras,
      title: Text(widget.item.texto,
          style: const TextStyle(color: PaletaCores.corAmarela)),
      side: const BorderSide(width: 2, color: Colors.white),
      value: widget.item.checked,
      onChanged: (value) {
        setState(() {
          widget.item.checked = value!;
        });
      },
    );
  }
}
