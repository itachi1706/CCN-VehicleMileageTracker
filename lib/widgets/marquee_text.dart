import 'package:flutter/material.dart';

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double velocity;

  MarqueeText({
    required this.text,
    this.style,
    this.velocity = 50.0,
  });

  @override
  _MarqueeTextState createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> {
  late ScrollController _scrollController;
  final GlobalKey _textKey = GlobalKey();
  late double _containerWidth;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  void _startScrolling() {
    final RenderBox renderBox = _textKey.currentContext!.findRenderObject() as RenderBox;
    final double _textWidth = renderBox.size.width;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: (_textWidth / widget.velocity).round()),
      curve: Curves.linear,
    ).then((_) {
      _scrollController.jumpTo(0.0);
      _startScrolling();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _containerWidth = constraints.maxWidth;
        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                widget.text,
                key: _textKey,
                style: widget.style,
              ),
              SizedBox(width: _containerWidth),
            ],
          ),
        );
      },
    );
  }
}