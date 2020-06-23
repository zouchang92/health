import 'package:flutter/material.dart';

class CheckBoxGroup extends StatefulWidget {
  final List data;
  final String label;
  final ValueChanged<List<dynamic>> onValueChange;
  CheckBoxGroup({this.data, this.label,this.onValueChange});
  @override
  _CheckBoxGroupState createState() => _CheckBoxGroupState();
}

class _CheckBoxGroupState extends State<CheckBoxGroup> {
  List _data;
  List<int> selectItem = [];
  @override
  void initState() {
    _data = widget.data;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _length = this._data.length;
    String _label = widget.label;
    return Wrap(
      key: widget.key,
      children: List.generate(
          _length,
          (index) => checkBoxItem(
              label: _label != null ? _data[index][_label] : _data[index],
              value: selectItem.contains(index),
              onChanged: (bool isSelected) {
                
                this.setState(() {
                  // this._selected = iindex;
                  if (isSelected&&(!selectItem.contains(index))) {
                    selectItem.add(index);
                  }
                  if(!isSelected){
                    selectItem.remove(index);
                  }
                  print('selectItem:$selectItem');
                  var t = selectItem.map((e) => _data[e]).toList();
                  print('t:$t');
                  widget.onValueChange?.call(selectItem.map((e) => _data[e]).toList());
                  
                });
              })).toList(),
    );
  }

  Widget checkBoxItem({value, onChanged, String label}) {
    return Padding(
      padding: EdgeInsets.only(left: 0),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Checkbox(value: value, onChanged: onChanged),
          Text(label)
        ],
      ),
    );
  }
}
