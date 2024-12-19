import 'package:flutter/material.dart';

class LabeledFabSmall extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final String heroTag;

  const LabeledFabSmall({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.icon,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(label,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  )),
        ),
        const SizedBox(width: 12),
        FloatingActionButton.small(
          onPressed: onPressed,
          heroTag: heroTag,
          child: Icon(icon),
        ),
      ],
    );
  }
}
