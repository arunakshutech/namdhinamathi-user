import 'package:flutter/material.dart';

class IAPScreen extends StatelessWidget {
  const IAPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription Plans'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display available subscription plans
            Text(
              'Choose your subscription plan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Example subscription plan
            ListTile(
              title: Text('Premium Monthly Plan'),
              subtitle: Text('\$4.99 per month'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Add logic to initiate the purchase process
                },
                child: Text('Subscribe'),
              ),
            ),
            // Add more plans or other UI elements as needed
          ],
        ),
      ),
    );
  }
}
