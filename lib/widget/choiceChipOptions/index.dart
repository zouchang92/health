import 'package:flutter/material.dart';

class ChoiceChipOptions extends StatefulWidget {
  final List data;
  @required
  final String label;
  final int selectIndex;
  final ValueChanged<int> onValueChange;
  ChoiceChipOptions(
      {Key key, this.data, this.label, this.selectIndex, this.onValueChange})
      : assert(data != null),
        super(key: key);
  @override
  _ChoiceChipOptionsState createState() => _ChoiceChipOptionsState();
}

class _ChoiceChipOptionsState extends State<ChoiceChipOptions> {
  List _data;
  int _selectedIndex;
  @override
  void initState() {
    _data = widget.data;
    _selectedIndex = widget.selectIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _length = widget.data.length;
    String _label = widget.label;

    return Wrap(
      key: widget.key,
      children: List.generate(
          _length,
          (index) => Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: ChoiceChip(
                // backgroundColor: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                label:
                    Text(_label != null ? _data[index][_label] : _data[index]),
                selected: this._selectedIndex == index,
                onSelected: (bool status) {
                  this.setState(() {
                    // this._selectedIndex = status ? index : null;
                    if (status) {
                      this._selectedIndex = index;
                    }
                    widget.onValueChange?.call(this._selectedIndex);
                  });
                },
              ))).toList(),
    );
  }
}
