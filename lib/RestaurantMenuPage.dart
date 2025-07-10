import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'ReelsPage.dart';
import 'CartPage.dart'; // Import CartPage

final List<Map<String, dynamic>> menuItems = [
  {
    'name': 'Spaghetti Carbonara',
    'price': 12.99,
    'description': 'Classic pasta with a creamy bacon sauce.',
    'imageUrl': 'images/img1.jpeg',
  },
  {
    'name': 'Margherita Pizza',
    'price': 9.99,
    'description': 'A simple pizza with tomato, mozzarella, and basil.',
    'imageUrl': 'images/img1.jpeg',
  },
  {
    'name': 'Caesar Salad',
    'price': 8.49,
    'description': 'Crisp romaine lettuce with Caesar dressing and croutons.',
    'imageUrl': 'images/img1.jpeg',
  },
  {
    'name': 'Grilled Chicken Sandwich',
    'price': 10.49,
    'description': 'Juicy grilled chicken with lettuce, tomato, and mayo.',
    'imageUrl': 'images/img1.jpeg',
  },
  {
    'name': 'Chocolate Cake',
    'price': 6.99,
    'description': 'Decadent chocolate cake with a rich, moist texture.',
    'imageUrl': 'images/img1.jpeg',
  },
];

class RestaurantMenuPage extends StatefulWidget {
  final String image;
  final String name;
  final String address;
  final String location;
  final double rating;
  final bool preOrderFood; // Receive the pre-order status
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String? selectedPersons;
  final String? selectedEvent;

  const RestaurantMenuPage({
    Key? key,
    required this.image,
    required this.name,
    required this.address,
    required this.location,
    required this.rating,
    required this.preOrderFood, 
    this.selectedDate,
    this.selectedTime,
    this.selectedPersons,
    this.selectedEvent,
  }) : super(key: key);
  @override
  _RestaurantMenuPageState createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  int _currentIndex = 0;
  int _itemsAdded = 0;
  final List<Map<String, dynamic>> cartItems = [];
  final List<Widget> _pages = [
    Onboarding(),
    ReelsPage(),
    CartPage(cartItems: [], preOrderFood: true, restaurantName: '', restaurantAddress: '',),
  ];

  // Method to handle adding item to cart
  void _incrementItemCount(Map<String, dynamic> item) {
    setState(() {
      _itemsAdded++;
      cartItems.add({...item, 'quantity': 1});
    });
  }

  // Navigate to the CartPage
  void _navigateToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          cartItems: cartItems,
          preOrderFood: widget.preOrderFood, // Pass the pre-order flag
          restaurantName: widget.name,     // Pass the restaurant name
          restaurantAddress: widget.address, // Pass the restaurant address
           selectedDateTime: widget.selectedDate, // Pass selected date
          selectedTime: widget.selectedTime, // Pass selected time
          selectedPersons: widget.selectedPersons, // Pass selected persons
          selectedEvent: widget.selectedEvent, // Pass selected event 
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
        backgroundColor: Colors.amber,
        toolbarHeight: 50.0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      widget.image,
                      height: 125,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.rating.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.address,
                          style: const TextStyle(fontSize: 16),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: StickySearchBarDelegate(), // Keep search bar as before
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var item = menuItems[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${item['price'].toString()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['description'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                item['imageUrl'],
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => _incrementItemCount(item),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: const Size(25, 25),
                              ),
                              child: const Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: menuItems.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _pages[index]),
          );
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (_itemsAdded > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.amber,
                      child: Text(
                        '$_itemsAdded',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
        ],
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 50,
          child: FloatingActionButton.extended(
            onPressed: _navigateToCartPage,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("$_itemsAdded items added", style: TextStyle(color: Colors.black)),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
              ],
            ),
            backgroundColor: Colors.amber,
          ),
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
                      labelText: 'Search Food',
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