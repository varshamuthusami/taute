import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:project_name/onboarding.dart';
import 'CartPage.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Onboarding(),
    ReelsPage(),
    CartPage(
      cartItems: [], preOrderFood: false,restaurantName: '', restaurantAddress: ''),   // Cart page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

// Reels Page
class ReelsPage extends StatefulWidget {
  final List<String> videos;
  final int initialIndex;
  final String name;

  // Constructor with default list for `videos`
  ReelsPage({
    Key? key,
    List<String>? videos,
    this.initialIndex = 0,
    this.name = 'Mountain View',
  })  : videos = videos ?? [
          'videos/vid1.mp4',
          'videos/vid1.mp4',
          'videos/vid1.mp4',
        ],
        super(key: key);

  @override
  _ReelsPageState createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nibbles'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context); // To go back to the previous page
          },
        ),
        toolbarHeight: 50.0,
        backgroundColor: Colors.amber,
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.videos.length,
        controller: PageController(
          initialPage: widget.initialIndex,
        ), // Start from the correct video
        itemBuilder: (context, index) {
          return VideoPlayerWidget(
            videoPath: widget.videos[index],
            name: widget.name,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
  backgroundColor: Colors.white,
  currentIndex: _currentIndex,  // This ensures the correct index is highlighted
  onTap: (index) {
    setState(() {
      _currentIndex = index;  // Update the index when a tab is tapped
    });

    // Navigate to the selected page
    // Instead of pushReplacement, use push to navigate and keep the BottomNavigationBar state
    Navigator.push(
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
    );
  }
}


// Video Player Widget
class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final String name;

  const VideoPlayerWidget({
    Key? key,
    required this.videoPath,
    required this.name, // Default value for name
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isLiked = false; // Track the like state
  int _likes = 0;
  // Track the number of likes

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showCommentBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Leave a Comment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close bottom sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Comment Posted')),
                  );
                },
                child: Text('Post Comment'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video Player
        Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(),
        ),
        // Overlay Buttons
        Positioned(
          right: 10,
          bottom: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Like Button
              IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.amber : Colors.white,
                ),
                iconSize: 25,
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked; // Toggle like state
                    if (_isLiked) {
                      _likes++;
                    } else {
                      _likes--;
                    }
                  });
                },
              ),
              Text(
                '$_likes', // Show like count
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 5),
              // Comment Button
              IconButton(
                icon: Icon(Icons.comment, color: Colors.white),
                iconSize: 25,
                onPressed:
                    _showCommentBottomSheet, // Show bottom sheet on click
              ),
              Text(
                '0', // Placeholder for comment count
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 5),
              // Share Button
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                iconSize: 25,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Shared')),
                  );
                },
              ),
            ],
          ),
        ),
        // Profile Section Below Video
        Positioned(
          bottom: 20,
          left: 10,
          right: 10,
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        AssetImage('images/img1.jpeg'), // Profile image
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Text('20 mins - 15km',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check out our yummy restaurant',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      softWrap: true,
                    ),
                  ]),
            ],
          ),
        ),
      ],
    );
  }
}

// Cart Page
