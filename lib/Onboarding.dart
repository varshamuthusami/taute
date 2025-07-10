import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project_name/LoginPage.dart';
import 'package:project_name/ReelsPage.dart';
import 'package:project_name/StoryPage.dart';
import 'package:project_name/firebase_options.dart';
import 'package:project_name/services/auth_gate.dart';
import 'package:project_name/services/auth_service.dart';
import 'rest.dart';
import 'CartPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taute',
      theme: ThemeData(
        //brightness: Brightness.dark,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Poppins'),
          bodyMedium: TextStyle(fontFamily: 'Poppins'),
          bodySmall: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  // Global key for Scaffold to control the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;
  final List<Widget> _pages = [
    Onboarding(), // Home page
    ReelsPage(), // Explore page
    CartPage(
      cartItems: [],
      preOrderFood: false,
      restaurantName: '',
      restaurantAddress: '',
    ), // Cart page
  ];
  final PageController _controller = PageController();

  // Sample variable for checking if the user is logged in
  bool _isLoggedIn = false; // Change this to true if the user is logged in
 String _userName = "John Doe"; // Example user name

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Method to show the right drawer
  void _showRightDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void logout() {
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
      key: _scaffoldKey, // Set the scaffold key
      appBar: AppBar(
         automaticallyImplyLeading: false, // Removes the back button
        toolbarHeight: 50.0,
        backgroundColor: Colors.white,
        elevation: 0, // Adjust elevation to control shadow intensity
   
        titleSpacing: 0,
        title: Row(
          children: [
            // Location icon
            Icon(
              Icons.location_on,
              color: Colors.black,
              size: 30,
            ),
            SizedBox(width: 2),
            // Column for location and address
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '122 Nehru Street',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Gesture to open the right-side drawer
          GestureDetector(
            onTap: _showRightDrawer, // Open the end drawer
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: _isLoggedIn
                    ? null
                    : AssetImage('images/img1.jpeg'), // Placeholder image
                child: _isLoggedIn
                    ? null
                    : Text(
                        _userName[0], // Display the first letter if no image
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: 100,
                  child: StoriesView(),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: StickySearchBarDelegate(),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 10),
                ImageCarousel(),
                SizedBox(height: 10),
                Services(),
                Res(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => _pages[index]),
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 54, 128, 56),
        unselectedItemColor: Colors.grey,
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            // Profile and Login Section in the same row
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Circle Avatar (Profile Picture or Initials)
                  Padding(
                    
                    padding:  EdgeInsets.all(20),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: _isLoggedIn
                          ? null
                          : AssetImage('images/img1.jpeg'),
                      child: _isLoggedIn
                          ? null
                          : Text(
                              _userName[0], // Display first letter if no image
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 30), // Space between the avatar and login button
                  // Login Button or User's Name
                  !_isLoggedIn
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Loginpage(onTap: () {  },)),
                            );
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      : Text(
                          'Hello, $_userName',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(height: 15), // Space between profile section and menu items
           // Divider(),
            // Menu Items
            ListTile(
              leading: Icon(Icons.history_edu),
              title: Text('History'),
              onTap: () {
                // Handle history tap
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite_outline_rounded),
              title: Text('Favorites'),
              onTap: () {
                // Handle favorites tap
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Orders'),
              onTap: () {
                // Handle orders tap
              },
            ),
           // Divider(),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Logout'),
              onTap: () {
                logout();
                Navigator.pop(context); // Close the drawer after logging out
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ImageCarousel extends StatelessWidget {
  final List<String> imageUrls = [
    "images/img1.jpeg",
    "images/img1.jpeg",
    "images/img1.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01),
      child: CarouselSlider.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index, realIndex) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              child: Image.asset(
                imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        },
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: false,
          aspectRatio: 16 / 9,
          viewportFraction: 1.0,
        ),
      ),
    );
  }
}

class StickySearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: SearchandFilter(),
    );
  }

  @override
  double get maxExtent => 70; // Height of the sticky bar
  @override
  double get minExtent => 70; // Height of the sticky bar

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class SearchandFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01),
      child: Column(
        children: [
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Changed background color
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.amber, // Border color
                      width: 1.0, // Border width
                    ),
                  ),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Search Restaurant',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color:
                            Colors.amber, // Changed search icon color to amber
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// Main Stories View with List of Restaurants
class StoriesView extends StatefulWidget {
  @override
  _StoriesViewState createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  final List<Restaurant> restaurants = [
    Restaurant(image: 'images/img1.jpeg', name: 'Gourmet Bistro', address: '123 Main St', rating: '4.5', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Cafe Delight', address: '456 Oak Ave', rating: '4.2', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Taste of Italy', address: '789 Pine Blvd', rating: '4.8', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Sunset Grill', address: '101 Beach Rd', rating: '4.3', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Mountain View', address: '12 Hilltop Rd', rating: '4.6', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Ocean Breeze', address: '15 Shore St', rating: '4.7', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Pasta Paradise', address: '23 River Rd', rating: '4.4', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Urban Diner', address: '56 City Center', rating: '4.1', location: 'Near City Center'),
  ];

  List<bool> viewedStatus = List.generate(8, (_) => false);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                viewedStatus[index] = true;
              });
              // Navigate to StoryPage when a restaurant is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryPage(
                    imageUrl: restaurant.image,
                    userName: restaurant.name,
                    address: restaurant.address,
                    rating: double.parse(restaurant.rating),
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: viewedStatus[index] ? Colors.grey : Colors.amber, width: 3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(restaurant.image),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(restaurant.name, style: TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                'Pick an event',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Ensure horizontal scrolling row fits well
          Container(
            height: 100, // Adjusted height for the services section
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildServiceCard(
                      context, 'Birthday Party', 'images/img1.jpeg'),
                  _buildServiceCard(
                      context, 'Family Dineout', 'images/img1.jpeg'),
                  _buildServiceCard(context, 'Wedding ', 'images/img1.jpeg'),
                  _buildServiceCard(
                      context, 'Corporate Events', 'images/img1.jpeg'),
                  _buildServiceCard(context, 'Reunion', 'images/img1.jpeg'),
                  _buildServiceCard(context, 'Others', 'images/img1.jpeg'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
      BuildContext context, String title, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: GestureDetector(
        /* onTap: () {
          // Navigate to the Rest page when tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Rest()), // Navigate to Rest page
          );
        },*/
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                width: 140,
                height: 80, // Adjusted height for the card
                fit: BoxFit.cover,
              ),
              Container(
                width: 140,
                height: 80,
                alignment: Alignment.center,
                //color: Colors.black54,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Restaurant {
  final String image;
  final String name;
  final String address;
  final String rating;
  final String location;

  Restaurant({required this.image, required this.name, required this.address, required this.rating, required this.location});
}
class Res extends StatelessWidget {
  final List<Restaurant> restaurants = [
    Restaurant(image: 'images/img1.jpeg', name: 'Gourmet Bistro', address: '123 Main St', rating: '4.5', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Cafe Delight', address: '456 Oak Ave', rating: '4.2', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Taste of Italy', address: '789 Pine Blvd', rating: '4.8', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Sunset Grill', address: '101 Beach Rd', rating: '4.3', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Mountain View', address: '12 Hilltop Rd', rating: '4.6', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Ocean Breeze', address: '15 Shore St', rating: '4.7', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Pasta Paradise', address: '23 River Rd', rating: '4.4', location: 'Near City Center'),
    Restaurant(image: 'images/img1.jpeg', name: 'Urban Diner', address: '56 City Center', rating: '4.1', location: 'Near City Center'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Restaurants',
            style: TextStyle(fontSize: 22, color: Colors.black),
          ),
          SizedBox(height: 10),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(), // Disable scrolling here
            shrinkWrap: true, // Makes grid view take only necessary space
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 0.75, // Adjust the aspect ratio for two columns
            ),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to the Rest page with restaurant details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Rest(
                        image: restaurant.image,
                        name: restaurant.name,
                        address: restaurant.address,
                        location: restaurant.location,
                        rating: double.parse(restaurant.rating),
                      ),
                    ),
                  );
                },
                child: RestaurantCard(
                  image: restaurant.image,
                  name: restaurant.name,
                  address: restaurant.address,
                  rating: double.parse(restaurant.rating),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


class RestaurantCard extends StatelessWidget {
  final String image;
  final String name;
  final String address;
  final double rating;

  const RestaurantCard({
    required this.image,
    required this.name,
    required this.address,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            spreadRadius: -2,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // This ensures the column only takes necessary height
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.asset(
              image,
              height: 70,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  address,
                  style: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 78, 75, 75)),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(fontSize: 14),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the restaurant's page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Rest(
                                    image: image,
                                    name: name,
                                    address: address,
                                    location: '',
                                    rating: rating,
                                  )), // Navigate to Rest page
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(15, 25),
                      ),
                      child: Text(
                        'Visit',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

