part of ui_kit;

typedef void _OnChanged(String value);

class PasswordInputView extends StatefulWidget {
  final _OnChanged change;
  final double height;
  PasswordInputView({required this.change, this.height = 100}) : assert(change != null);
  @override
  State<StatefulWidget> createState() {
    return _PasswordInputViewState();
  }
}

class _PasswordInputViewState extends State<PasswordInputView> {
  FocusNode? _focusNode;
  TextEditingController? _controller;
  List<String>? _value;
  @override
  void initState() {
    _focusNode = FocusNode();
    _controller = TextEditingController();
    _value = List.filled(6, "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _focusNode!.requestFocus();
        },
        child: Container(
          height: widget.height,
          width: double.infinity,
          child: Row(
            children: [
              SizedBox(
                width: 1,
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none
                  ),
                  focusNode: _focusNode,
                  controller: _controller,
                  onChanged: (String value) {
                    setState(() {
                      if (value == null && value.length > 0) {
                        _value!.fillRange(0, _value!.length, "");
                      } else {
                        List<String> _temp = value.split("");
                        for (int index = 0; index < _temp.length; index++) {
                          _value![index] = _temp[index];
                        }
                        _value!.fillRange(_temp.length, _value!.length, "");
                      }
                      if (value.length == 6) {
                        _focusNode!.unfocus();
                      }
                      widget.change(value);
                    });
                  },
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]*'))],
                  keyboardType: TextInputType.number,
                  showCursor: false,
                ),
              ),
            ]..add(
                Expanded(
                  child: Row(
                    children: List<Widget>.generate(
                      6,
                          (index) => Container(
                        height: widget.height,
                        width: widget.height,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black26, width: 1)),
                        child: _value![index] == "" ? SizedBox() : DotView(),
                      ),
                    ),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
              ),
          ),
        ),);
  }
}

class DotView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.all(Radius.circular(5))),
    );
  }
}
