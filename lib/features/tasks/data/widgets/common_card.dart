import 'package:flutter/material.dart';

class CommonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onPressed;
  final VoidCallback? ontap;
  final IconData? icon;
  const CommonCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onPressed,
    this.icon,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: GestureDetector(
            onTap: ontap,
            child: Icon(icon, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
