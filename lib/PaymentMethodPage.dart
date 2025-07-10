import 'package:flutter/material.dart';

class PaymentMethodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Payment Method'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Text - Centered Title for Page
             
            const SizedBox(height: 20),

            // Title for Credit/Debit Card (Centered)
            const Center(
              child: Text(
                'Cards',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),

            // Credit or Debit Card Option - Increased Height
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: SizedBox(
                height: 70, // Increase the height of the card
                child: ListTile(
                  leading: Icon(Icons.credit_card, color: Colors.amber),
                  title: const Text('Credit or Debit Card'),
                  onTap: () {
                    Navigator.pop(context, 'Credit/Debit Card');
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title for Pay by any UPI (Centered)
            const Center(
              child: Text(
                'Pay by Any UPI app',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),

            // Pay by UPI Option - Increased Height
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: SizedBox(
                height: 70, // Increase the height of the card
                child: ListTile(
                  leading: Icon(Icons.payment, color: Colors.amber),
                  title: const Text('Add new UPI ID'),
                  onTap: () {
                    Navigator.pop(context, 'Pay by UPI');
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title for Cash on Delivery (Centered)
            const Center(
              child: Text(
                'Pay later',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),

            // Cash on Delivery Option - Increased Height
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: SizedBox(
                height: 70, // Increase the height of the card
                child: ListTile(
                  leading: Icon(Icons.attach_money, color: Colors.amber),
                  title: const Text('Cash on Delivery'),
                  onTap: () {
                    Navigator.pop(context, 'Cash on Delivery');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

