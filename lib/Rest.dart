import 'package:flutter/material.dart';
import 'package:project_name/PostDetailPage.dart';
import 'package:project_name/onboarding.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'RestaurantMenuPage.dart';
import 'ThanksForOrderingPage.dart';
import 'package:project_name/ReelsPage.dart';
import 'CartPage.dart';

// Import the video player package
List<Map<String, dynamic>> foodItems = [
  {
    'name': 'Burger',
    'rating': 4.5,
    'price': 5.99,
    'description': 'Delicious beef burger with cheese',
    'imageUrl': 'images/img1.jpeg',
  },
  {
    'name': 'Pizza',
    'rating': 4.7,
    'price': 8.99,
    'description': 'Tasty cheese pizza with extra toppings',
    'imageUrl': 'imagesimg1.jpeg',
  },
];

class Rest extends StatelessWidget {
  final String image;
  final String name;
  final String address;
  final String location;
  final double rating;

  const Rest({
    Key? key,
    required this.image,
    required this.name,
    required this.address,
    required this.location,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _currentIndex = 0;
    final List<Widget> _pages = [
      Onboarding(), // Home page
      ReelsPage(), // Explore page
      CartPage(
          cartItems: [],
          preOrderFood: false,
          restaurantName: '',
          restaurantAddress: ''), // Cart page // Cart page
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 253, 253, 240),
        appBar: AppBar(
          toolbarHeight: 50.0,
          backgroundColor: Color.fromARGB(255, 45, 125, 95),
          iconTheme: IconThemeData( color: Color.fromARGB(255, 253, 253, 240),),
          title: Text(
            name,
            style: TextStyle(color: Color.fromARGB(255, 253, 253, 240),),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor:  Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            // Navigate to the selected page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _pages[index]),
            );
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
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
          selectedItemColor: Color.fromARGB(255, 45, 125, 95),
          unselectedItemColor: Colors.grey,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundImage: AssetImage(image),
                ),
                SizedBox(height: 10),
                Text(name,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.blue),
                    Text(address, style: TextStyle(fontSize: 17)),
                    Text(location),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(rating.toString(), style: TextStyle(fontSize: 18)),
                    SizedBox(width: 20),
                  ],
                ),
                SizedBox(height: 5),
                _optionpopup(context),
                SizedBox(height: 10),
                TabBar(
                  indicatorColor: Color.fromARGB(255, 45, 125, 95),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(
                        icon: Icon(Icons.video_collection, color: Color.fromARGB(255, 45, 125, 95)),
                        text: 'Nibbles'),
                    Tab(
                        icon: Icon(Icons.photo, color: Color.fromARGB(255, 45, 125, 95)),
                        text: 'Posts'),
                    Tab(
                        icon: Icon(Icons.comment, color: Color.fromARGB(255, 45, 125, 95)),
                        text: 'Reviews'),
                  ],
                ),
                SizedBox(
                  height: 420,
                  child: TabBarView(
                    children: [
                      ReelsSection(
                        name: name,
                      ),
                      PostsSection(
                        restaurantName: name,
                        address: address,
                        restaurantImage: image,
                      ),
                      ReviewsSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _optionpopup(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.90),
              contentPadding: EdgeInsets.all(20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name
                  Text(
                    name, // Dynamically set the restaurant name
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  // Address with location icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: Colors.blue),
                      SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          address, // Dynamically set the restaurant address
                          style: TextStyle(fontSize: 16),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Distance, Time, and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '3.5 km - 20 mins', // Add logic for dynamic distance/time if needed
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          SizedBox(width: 3),
                          Text(
                            rating.toString(), // Dynamically set the rating
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Book Your Dine Button
                 ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.amber[50],
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          bool isCustomInput = false;
                          bool preOrderFood =
                              false; // Initialize the pre-order food option
                          DateTime selectedDate = DateTime.now();
                          TimeOfDay selectedTime = TimeOfDay.now();
                          String?
                              selectedPersons; // Variable for selected number of persons
                          String? selectedEvent;
                          TextEditingController customController =
                              TextEditingController(); // To store the entered number for 'Other'
// Variable for selected event

                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return DraggableScrollableSheet(
                                initialChildSize:
                                    0.6, // Adjustable initial size
                                minChildSize: 0.4, // Minimum height
                                maxChildSize:
                                    0.9, // Maximum height to fill the screen
                                expand: false,
                                builder: (context, scrollController) {
                                  return Container(
                                    padding: EdgeInsets.all(20.0),
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Book Your Dine',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 20),

                                          // Date Picker
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Date: ',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              TextButton(
                                                onPressed: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: selectedDate,
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime(2100),
                                                  );
                                                  if (pickedDate != null) {
                                                    setState(() {
                                                      selectedDate = pickedDate;
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  '${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),

                                          // Time Picker
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Time: ',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              TextButton(
                                                onPressed: () async {
                                                  TimeOfDay? pickedTime =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime,
                                                  );
                                                  if (pickedTime != null) {
                                                    setState(() {
                                                      selectedTime = pickedTime;
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  '${selectedTime.format(context)}',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.amber),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),

                                          // Number of Persons Dropdown
                                         Container(
                                    width: 250,
                                     child: DropdownButton<String>(
                                      
                                       value: isCustomInput ? "Other" : selectedPersons,
                                       hint: Text("Number of Persons"),
                                       isExpanded: true,
                                       items: [
                                         '1', '2', '3', '4', '5', '6', 'Other',
                                       ].map((String value) {
                                         return DropdownMenuItem<String>(
                                           value: value,
                                           child: Text(value),
                                         );
                                       }).toList(),
                                       onChanged: (String? value) {
                                         if (value == "Other") {
                                           setState(() {
                                             isCustomInput = true;
                                             selectedPersons = "Other"; // Show 'Other' if selected
                                           });
                                         } else {
                                           setState(() {
                                             isCustomInput = false;
                                             selectedPersons = value;
                                           });
                                         }
                                       },
                                     ),
                                   ),

// If "Other" is selected, show the TextField for custom input
if (isCustomInput)
  Container(
    width: 250,
    height: 100,
    child: TextField(
      
      controller: customController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Enter number of persons",
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          selectedPersons = value.isNotEmpty ? value : "Other";
        });
      },
    ),
  ),
                                          SizedBox(height: 10),

                                          // Event Dropdown
                                          DropdownButton<String>(
                                            isExpanded: false,
                                            hint: Text('Event'),
                                            value: selectedEvent,
                                            items: [
                                              'Birthday',
                                              'Anniversary',
                                              'Casual',
                                              'Meeting'
                                            ]
                                                .map((String value) =>
                                                    DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value),
                                                    ))
                                                .toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedEvent = newValue;
                                              });
                                            },
                                          ),
                                          SizedBox(height: 20),

                                          // Preorder Food Question
                                          Center(
                                            child: Text(
                                              'Do you want to preorder food?',
                                              style: TextStyle(fontSize: 18),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(height: 10),

                                          // Preorder Food Switch
                                          Transform.scale(
                                            scale: 1.00,
                                            child: Switch(
                                              value: preOrderFood,
                                              activeColor: Colors.amber,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  preOrderFood = value;
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 20),

                                          // Done Button
                                          ElevatedButton(
                                            onPressed: () {
                                              if (preOrderFood) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RestaurantMenuPage(
                                                      image: image,
                                                      name: name,
                                                      address: address,
                                                      location: location,
                                                      rating: rating,
                                                      preOrderFood:
                                                          preOrderFood,
                                                      selectedDate:
                                                          selectedDate,
                                                      selectedTime:
                                                          selectedTime,
                                                      selectedPersons:
                                                          selectedPersons,
                                                      selectedEvent:
                                                          selectedEvent,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ThanksForOrderingPage(
                                                      bookingDetails: {
                                                        'date': DateFormat(
                                                                'yyyy-MM-dd')
                                                            .format(
                                                                selectedDate),
                                                        'time': selectedTime
                                                            .format(context),
                                                        'persons':
                                                            selectedPersons ??
                                                                'Not specified',
                                                        'event':
                                                            selectedEvent ??
                                                                'No event',
                                                        'preOrderFood':
                                                            preOrderFood,
                                                        'restaurantName': name,
                                                        'restaurantAddress':
                                                            address,
                                                        'restaurantImage':
                                                            image,
                                                        'restaurantRating':
                                                            rating,
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.amber,
                                              minimumSize:
                                                  Size(double.infinity, 50),
                                            ),
                                            child: Text(
                                              'Done',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Book Your Dine',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Food Delivery Button
                  ElevatedButton(
                    onPressed: () {
                      // Replace the pop call with navigation to the menu page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantMenuPage(
                            name: name, // Dynamically set restaurant name
                            address:
                                address, // Dynamically set restaurant address
                            //distance: 3.5,                  // Dynamically set distance (you can calculate this based on user location)
                            //time: '20 mins',                // Dynamically set estimated delivery time
                            rating: rating, // Dynamically set rating
                            image: image,
                            location: location,
                            preOrderFood: false, // Dynamically set logo URL
                            /*selectedDate:  , // Pass selected date
            selectedTime: selectedTime, // Pass selected time
            selectedPersons: selectedPersons, // Pass number of persons
            selectedEvent: selectedEvent, // Pass selected event*/
                            //foodItems: foodItems, // List of food items, ensure this is defined above
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Order For Delivery',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
      ),
      child: Text(
        'Book & Order',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }




  void setState(Null Function() param0) {}
}

class ReelsSection extends StatelessWidget {
  final String name;
  const ReelsSection({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List of video URLs (can be network URLs or assets)
    final List<String> videoList = [
      'videos/vid1.mp4',
      'videos/vid1.mp4',
      'videos/vid1.mp4',
      'videos/vid1.mp4',
      'videos/vid1.mp4',
      'videos/vid1.mp4',
      'videos/vid1.mp4',
      'videos/vid1.mp4',
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        crossAxisSpacing: 2.0, // Space between columns
        mainAxisSpacing: 2.0, // Space between rows
        childAspectRatio: 9 / 16, // Aspect ratio for 9:16 videos
      ),
      itemCount: videoList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReelsPage(
                  videos: [videoList[index]],
                  name: name,
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4), // Rounded corners
            child: VideoPlayerWidget(videoUrl: videoList[index]),
            // Video widget
          ),
        );
      },
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: 9 / 16, // Ensure the video respects 9:16 ratio
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}

class PostsSection extends StatelessWidget {
  final String restaurantName;
  final String address;
  final String restaurantImage;

  const PostsSection({
    Key? key,
    required this.restaurantName,
    required this.address,
    required this.restaurantImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> imageList = [
      'images/img1.jpeg',
      'images/img1.jpeg',
      'images/img1.jpeg',
      'images/img1.jpeg',
      'images/img1.jpeg',
      'images/img1.jpeg',
      'images/img1.jpeg',
      'images/img1.jpeg',
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
        childAspectRatio: 1,
      ),
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(
                  imageList: imageList,
                  initialIndex: index,
                  restaurantName: restaurantName,
                  address: address,
                  restaurantImage: restaurantImage,
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              imageList[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class ReviewsSection extends StatefulWidget {
  const ReviewsSection({Key? key}) : super(key: key);

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  final List<String> _reviews = [];

  void _addReview(String review) {
    setState(() {
      _reviews.add(review);
    });
  }

  void _showReviewDialog() {
    final TextEditingController _reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Write a Review'),
        content: TextField(
          controller: _reviewController,
          decoration: const InputDecoration(hintText: 'Enter your review here'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.amber)),
          ),
          TextButton(
            onPressed: () {
              if (_reviewController.text.isNotEmpty) {
                _addReview(_reviewController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Post', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _reviews.isEmpty
          ? const Center(
              child: Text(
                'No Reviews',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: _reviews.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_reviews[index]),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showReviewDialog,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
