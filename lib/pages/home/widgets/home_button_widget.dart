import 'package:flutter/material.dart';

class HomeButtonWidget extends StatelessWidget {
  final IconData icon;
  final String buttonName;
  final VoidCallback? onPressed;
  final Color? color;

  const HomeButtonWidget({
    Key? key,
    required this.icon,
    required this.buttonName,
    this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 1,
            offset: Offset(1, 1), // Shadow position
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: onPressed != null
            ? Colors.blue[400]
            : Colors.grey,
        child: InkWell(
          borderRadius: BorderRadius.circular(5.0),
          onTap: onPressed,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30.0, color: Colors.white.withOpacity(0.7)),
                const SizedBox(
                  height: 25.0,
                ),
                Text(
                  buttonName,
                  style: TextStyle(
                      fontSize: 16.0, color: Colors.white.withOpacity(0.7)),
                  // overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
