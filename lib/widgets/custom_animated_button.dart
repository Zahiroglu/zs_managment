import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Duration animationDuration;
  final double height;
  final double width;
  final double borderRadius;


  const AnimatedButton({
    this.animationDuration = const Duration(milliseconds: 800),
    this.height = 30,
    this.width = 130.0,
    this.borderRadius = 10.0,
  });

  @override
  _AnimatedButtonState createState() =>
      _AnimatedButtonState();
}

class _AnimatedButtonState
    extends State<AnimatedButton> {
  double _animatedWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              widget.borderRadius,
            ),
            color: Colors.grey,
          ),
        ),
        AnimatedContainer(
          duration: widget.animationDuration,
          height: widget.height,
          width: _animatedWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              widget.borderRadius,
            ),
            color: Colors.white,
          ),
        ),
        InkWell(
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                widget.borderRadius,
              ),
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.play_arrow,
                  color: Colors.black87,
                ),
                Text(
                  'Next Episode',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            setState(() {
              _animatedWidth = widget.width;
            });
          },
        ),
      ],
    );
  }}