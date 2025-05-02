//reusable setup screen widget
import "package:flutter/material.dart";

class SetupScreen extends StatelessWidget {
  final String title, subtitle;
  final Widget content;
  final VoidCallback? onNext, onBack;

  const SetupScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
    this.onNext,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(subtitle, style: TextStyle(fontSize: 16, color: Colors.black)),
              SizedBox(height: 32),
              Expanded(child: content),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (onBack != null) 
                    TextButton(
                      onPressed: onBack,
                      child: Text("Back", style: TextStyle(color: Colors.black)),
                    )
                  else 
                    SizedBox(width: 72),
                  FloatingActionButton(
                    onPressed: onNext,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}