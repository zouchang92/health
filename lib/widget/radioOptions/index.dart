import 'package:flutter/material.dart';

class RadioOptions extends StatefulWidget {
  final List data;
  final String label;
  final ValueChanged<int> onValueChange;
  RadioOptions({Key key,this.data,this.onValueChange,this.label}):assert(data!=null),super(key:key);
  @override
  _RadioOptionsState createState() => _RadioOptionsState();
}

class _RadioOptionsState extends State<RadioOptions> {
  List _data;
  int _selected;
  @override
  void initState() {
    _data = widget.data;
    _selected = 0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    int _length = this._data.length;
    String _label = widget.label;
    return Wrap(
      key: widget.key,
      children: List.generate(_length, (index) => radioItem(
        label:_label!=null?_data[index][_label]:_data[index],
        value:index,
        groupValue:this._selected,
        onChanged: (iindex){
          this.setState(() {
            this._selected = iindex;
           });
           widget.onValueChange?.call(this._selected);
        }
      )).toList(),
    );
  }

  Widget radioItem({value,groupValue,onChanged,String label}) {
    return Padding(
      padding: EdgeInsets.only(left: 0),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Radio(value: value, groupValue: groupValue, onChanged: onChanged),
          Text(label)
        ],
      ),
    );
  }
}
