import 'package:flutter/material.dart';
import 'PaymentMethodPage.dart';
import 'package:intl/intl.dart';
import 'ThanksforOrderingPage.dart';
import 'Onboarding.dart';
import 'ReelsPage.dart';
 

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final bool preOrderFood; // Added isPreOrder flag
  final String restaurantName; // Added restaurant name
  final String restaurantAddress; // Added restaurant address
  final DateTime? selectedDateTime; // Add selected date parameter
  final TimeOfDay? selectedTime; // Add selected time parameter
  final String? selectedPersons; // Add selected persons parameter
  final String? selectedEvent; // Add selected event parameter


   const CartPage({
    Key? key,
    required this.cartItems,
    required this.preOrderFood,
    required this.restaurantName, // Restaurant Name
    required this.restaurantAddress,
    this.selectedDateTime,
    this.selectedTime,
    this.selectedPersons,
    this.selectedEvent,
  }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
   int _currentIndex = 0;

  // Define the pages to navigate to
  final List<Widget> _pages = [
    Onboarding(),  // Home page
    ReelsPage(),       // Explore page
    CartPage(cartItems: [], preOrderFood:false, restaurantName: '', restaurantAddress: '',),        // Cart page
  ];
  double get total => widget.cartItems
      .fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));

  String? selectedPaymentMethod; // Store the selected payment method
  String? selectedDeliveryMethod;  
  DateTime? selectedDateTime;

  void _updateQuantity(int index, int change) {
    setState(() {
      widget.cartItems[index]['quantity'] =
          (widget.cartItems[index]['quantity'] + change).clamp(1, 100);
    });
  }

  // Remove item function
  void _removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
  }

  // Navigate to payment method page
  Future<void> _selectPaymentMethod() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentMethodPage()),
    );

    // If a payment method is selected, update the payment method
    if (result != null) {
      setState(() {
        selectedPaymentMethod = result;
      });
    }
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _pickDateTime() async {
    await showDialog(
      context: context,
      builder: (context) {
        // Use StatefulBuilder to manage dialog's state
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.90),
              title: const Text(
                'Select Delivery Date and Time',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Date: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            builder: (context, child) {
                              return Transform.scale(
                                scale:
                                    0.85, // Reduce overall size of the pop-up
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: 500,
                                      ), // Set max height
                                      child: Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: Colors
                                                .amber, // Amber color for the header
                                          ),
                                        ),
                                        child: child!,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          if (pickedDate != null) {
                            setDialogState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Text(
                          '${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber, // Set text color to amber
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Time picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Time: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                            builder: (context, child) {
                              return Transform.scale(
                                scale:
                                    0.85, // Reduce overall size of the pop-up
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: 500,
                                      ), // Set max height
                                      child: Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: Colors
                                                .amber, // Amber color for the header
                                          ),
                                        ),
                                        child: child!,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          if (pickedTime != null) {
                            setDialogState(() {
                              selectedTime = pickedTime;
                            });
                          }
                        },
                        child: Text(
                          '${selectedTime.format(context)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Navigate to the ThanksPage after confirming the order
   void _confirmOrder() {
     DateTime? selectedDateTime = DateTime(
    selectedDate.year, 
    selectedDate.month, 
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );
      
    final bookingDetails = {
      'cartItems': widget.cartItems,
      'total': total,
      'paymentMethod': selectedPaymentMethod,
      'deliveryMethod': selectedDeliveryMethod, // Now can be null
      'deliveryDate': selectedDateTime,
      'restaurantName': widget.restaurantName,
      'restaurantAddress': widget.restaurantAddress,
      'selectedTime': widget.selectedTime,
      'selectedDate': widget.selectedDateTime,
      'event': widget.selectedEvent, // Add event
      'preOrderFood': widget.preOrderFood, // Add pre-order status
      'persons': widget.selectedPersons, // Add persons
    };
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThanksForOrderingPage(bookingDetails: bookingDetails)),
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600; // A basic check for mobile devices

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.amber,
        toolbarHeight: 50,
         leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined, // Default back arrow icon
            color: Colors.black, // You can change the color here
          ),
          onPressed: () {
            // Custom behavior when the back button is pressed
            Navigator.pop(context);  // Go back to the previous page
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 10 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Cart Items:',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      var item = widget.cartItems[index];
                      return Card(
                        color: Colors.white,
                        margin: EdgeInsets.all(isMobile ? 8 : 12),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: isMobile ? 8 : 12,
                              horizontal: isMobile ? 6 : 12),
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
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${item['price'].toString()}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      item['imageUrl'],
                                      height: isMobile ? 70 : 90,
                                      width: isMobile ? 70 : 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 25,
                                    width: 80, // Reduced width
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.amber),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.amber.shade50,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly, // Equal spacing
                                      children: [
                                        Flexible(
                                          child: IconButton(
                                            icon: const Icon(Icons.remove,
                                                color: Colors.amber,
                                                size: 10), // Reduced size
                                            padding: EdgeInsets
                                                .zero, // No extra padding
                                            constraints: const BoxConstraints(
                                              maxWidth:
                                                  20, // Limit icon size to fit
                                              maxHeight: 20,
                                            ),
                                            onPressed: () =>
                                                _updateQuantity(index, -1),
                                          ),
                                        ),
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit
                                                .scaleDown, // Ensure text scales down
                                            child: Text(
                                              item['quantity'].toString(),
                                              style: const TextStyle(
                                                fontSize:
                                                    12, // Reduced font size
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: IconButton(
                                            icon: const Icon(Icons.add,
                                                color: Colors.amber,
                                                size: 10), // Reduced size
                                            padding: EdgeInsets
                                                .zero, // No extra padding
                                            constraints: const BoxConstraints(
                                              maxWidth:
                                                  20, // Limit icon size to fit
                                              maxHeight: 20,
                                            ),
                                            onPressed: () =>
                                                _updateQuantity(index, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 16.0),
            child: Column(
              children: [
                if (widget.preOrderFood==false) ...[
                  Wrap(
                    alignment: WrapAlignment.center, // Align items to the start
                    crossAxisAlignment:
                        WrapCrossAlignment.center, // Align items vertically
                    spacing: 8.0, // Horizontal spacing between items
                    runSpacing: 8.0, // Vertical spacing between wrapped rows
                    children: [
                      const Text(
                        'Delivery Method:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      // Wrapping the Row in a Container ensures proper alignment
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Minimize Row size
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDeliveryMethod = 'Immediate';
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(
                                    milliseconds: 200), // Add smooth animation
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      selectedDeliveryMethod == 'Immediate'
                                          ? 8
                                          : 5,
                                  horizontal:
                                      selectedDeliveryMethod == 'Immediate'
                                          ? 12
                                          : 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .white, // Keep the background color constant
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.amber,
                                    width: selectedDeliveryMethod == 'Immediate'
                                        ? 2
                                        : 1, // Thicker border for selected button
                                  ),
                                ),
                                child: const Text(
                                  'Immediate',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDeliveryMethod = 'Scheduled';
                                  _pickDateTime();
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(
                                    milliseconds: 200), // Add smooth animation
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      selectedDeliveryMethod == 'Scheduled'
                                          ? 8
                                          : 5,
                                  horizontal:
                                      selectedDeliveryMethod == 'Scheduled'
                                          ? 12
                                          : 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .white, // Keep the background color constant
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.amber,
                                    width: selectedDeliveryMethod == 'Scheduled'
                                        ? 2
                                        : 1, // Thicker border for selected button
                                  ),
                                ),
                                child: const Text(
                                  'Scheduled',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 10),
                // Total Price display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total: ',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextButton(
                        onPressed: _selectPaymentMethod,
                        child: Row(
                          children: [
                            const Text(
                              'Pay Using',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(Icons.arrow_drop_down, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: _confirmOrder, // Navigate to ThanksPage
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Confirm Order',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
