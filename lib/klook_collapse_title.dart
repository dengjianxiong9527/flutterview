import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// FAQ可折叠控件
class CarRentalQuestionExpansionTile extends StatefulWidget {
  const CarRentalQuestionExpansionTile({
    Key key,
    @required this.title,
    this.onExpansionChanged,
    this.onExpansionClick,
    this.children = const <Widget>[],
    this.trailing,
    this.index,
    this.initiallyExpanded,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  /// The primary content of the list item.
  final Widget title;

  /// Called when the tile expands or collapses.
  final ValueChanged<bool> onExpansionChanged;

  /// Called when the tile expands or collapses.
  final ValueChanged<int> onExpansionClick;

  /// The widgets that are displayed when the tile expands.
  final List<Widget> children;

  /// A widget to display instead of a rotating arrow icon.
  final Widget trailing;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  final int index;

  @override
  State<StatefulWidget> createState() {
    return _CarRentalQuestionExpansionTileState();
  }
}
class _CarRentalQuestionExpansionTileState
    extends State<CarRentalQuestionExpansionTile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;

  bool _isExpanded = false;
  int currentIndex = -1;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
    final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    debugPrint("initiallyExpanded :${widget.initiallyExpanded}");
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//  void showExpand() async{
//    final prefs = await SharedPreferences.getInstance();
//    currentIndex = prefs.get("currentIndex");
//    debugPrint("currentIndex :${currentIndex}");
//  }

  @override
  Widget build(BuildContext context) {
    //showExpand();
    debugPrint("index:${widget.index}");
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: _handleTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: widget.title ?? const SizedBox(),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16.0),
                  child: RotationTransition(
                    turns: _iconTurns,
                    child: widget.trailing,
                  ),
                ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: Align(
            heightFactor: _heightFactor.value,
            child: child,
          ),
        ),
      ],
    );
  }

  void _handleTap() async {
    currentIndex = widget.index;
//    final prefs = await SharedPreferences.getInstance();
//    prefs.setInt("currentIndex", currentIndex);
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    if (widget.onExpansionChanged != null)
     widget.onExpansionChanged(_isExpanded);

    if(widget.onExpansionClick != null){
      widget.onExpansionClick(currentIndex);
    }
  }

}
