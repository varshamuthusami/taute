import 'package:flutter/material.dart';

class PostDetailPage extends StatefulWidget {
  final List<String> imageList;
  final int initialIndex;
  final String restaurantName;
  final String address;
  final String restaurantImage;

  const PostDetailPage({
    Key? key,
    required this.imageList,
    required this.initialIndex,
    required this.restaurantName,
    required this.address,
    required this.restaurantImage,
  }) : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late ScrollController _scrollController;
  List<bool> _likedPosts = [];
  List<int> _likeCounts = [];
  List<String> _comments = [];
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize all posts with unliked state and 0 likes
    _likedPosts = List.generate(widget.imageList.length, (_) => false);
    _likeCounts = List.generate(widget.imageList.length, (_) => 0);
    _comments = List.generate(widget.imageList.length, (_) => "");
    _scrollController = ScrollController(
      initialScrollOffset: widget.initialIndex * 400, // Approximate item height
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        toolbarHeight:
            screenHeight * 0.08, // Adjust app bar height based on screen height
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Posts',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: widget.imageList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02), // Adjust vertical margin
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Info
                Padding(
                  padding: EdgeInsets.all(screenWidth *
                      0.04), // Adjust padding based on screen width
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          widget.restaurantImage,
                          width: screenWidth *
                              0.12, // Use percentage of screen width for image size
                          height: screenWidth *
                              0.12, // Use percentage of screen width for image size
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                          width: screenWidth *
                              0.04), // Adjust space between image and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.restaurantName,
                            style: TextStyle(
                              fontSize: screenWidth *
                                  0.05, // Use percentage of screen width for font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height:
                                  screenHeight * 0.01), // Adjust vertical space
                          Text(
                            widget.address,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: screenWidth *
                                  0.04, // Adjust font size based on screen width
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Post Image
                ClipRRect(
                  child: Image.asset(
                    widget.imageList[index],
                    fit: BoxFit.cover,
                    width: screenWidth, // Full width of the screen
                    height: screenHeight *
                        0.4, // Adjust image height to 40% of screen height
                  ),
                ),

                // Interaction Buttons
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.04,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          _likedPosts[index]
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _likedPosts[index] ? Colors.red : Colors.black,
                          size: screenWidth * 0.06,
                        ),
                        onPressed: () {
                          setState(() {
                            _likedPosts[index] = !_likedPosts[index];
                            if (_likedPosts[index]) {
                              _likeCounts[index]++;
                            } else {
                              _likeCounts[index]--;
                            }
                          });
                        },
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      IconButton(
                        icon: Icon(
                          Icons.comment_outlined,
                          color: Colors.black,
                          size: screenWidth * 0.06,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _commentController,
                                      decoration: InputDecoration(
                                        labelText: 'Add a comment...',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _comments[index] = _commentController.text;
                                          _commentController.clear();
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Post Comment'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Icon(
                        Icons.share,
                        color: Colors.black,
                        size: screenWidth * 0.06,
                      ),
                    ],
                  ),
                ),

                // Like count
                if (_likeCounts[index] > 0)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Text(
                      '${_likeCounts[index]} Likes',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black,
                      ),
                    ),
                  ),

                // Comment section
                if (_comments[index].isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Text(
                      'Comment: ${_comments[index]}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
