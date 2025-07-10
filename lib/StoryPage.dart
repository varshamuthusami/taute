import 'package:flutter/material.dart';
import 'rest.dart';
class StoryPage extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final String address;
  final double rating;

  StoryPage({
    required this.imageUrl,
    required this.userName,
    required this.address,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Full-screen Story Content
          Positioned.fill(
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          // Restaurant DP and Name (Top Left Corner)
          Positioned(
            top: 35,
            left: 50,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(imageUrl),
                ),
                SizedBox(width: 10),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Back button
          Positioned(
            top: 40,
            left: 2,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context); // Pops the current screen off the stack
              },
            ),
          ),
          Positioned(
  bottom: 30,
  right: 20,
  child: FloatingActionButton.extended(
    backgroundColor: Colors.amber,
    onPressed: () {
      // Navigate to restaurant details page, replacing the current page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Rest(
            image: imageUrl,
            name: userName,
            address: address,
            location: '',
            rating: rating,
          ),
        ),
      );
    },
    label: Text(
      "View Restaurant",
      style: TextStyle(color: Colors.white),
    ),
    icon: Icon(Icons.restaurant, color: Colors.white),
  ),
),
        ],
      ),
    );
  }
}

