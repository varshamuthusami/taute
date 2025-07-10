import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_name/services/database/firestore.dart';

class ThanksForOrderingPage extends StatefulWidget {
  final Map<String, dynamic> bookingDetails;

  ThanksForOrderingPage({required this.bookingDetails});
  

  @override
  State<ThanksForOrderingPage> createState() => _ThanksForOrderingPageState();
}

class _ThanksForOrderingPageState extends State<ThanksForOrderingPage> {

  FirestoreService db = FirestoreService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String receipt = generateReceipt(widget.bookingDetails);
    db.saveOrderToDatabase(receipt);
  }

 
 
  @override
  Widget build(BuildContext context) {
    // Extract necessary details from bookingDetails map with null checks
    bool preOrderFood = widget.bookingDetails['preOrderFood'] ?? false;
    String deliveryMethod = widget.bookingDetails['deliveryMethod'] ?? ''; // Default to empty string if null
    DateTime? deliveryDate = widget.bookingDetails['deliveryDate'];
    List<Map<String, dynamic>> cartItems = widget.bookingDetails['cartItems'] ?? []; // Default to empty list if null
    double total = widget.bookingDetails['total'] ?? 0.0; // Default to 0.0 if null
    String paymentMethod = widget.bookingDetails['paymentMethod'] ?? ''; // Default to empty string if null

    // Extract the additional details for booking
    String? event = widget.bookingDetails['event'];
    String? date = widget.bookingDetails['date'];  
    String? time = widget.bookingDetails['time'];  
    String? persons = widget.bookingDetails['persons'];

    // Extract necessary details from bookingDetails map with null checks
    DateTime? selectedDate = widget.bookingDetails['selectedDate'];  // DateTime object
    TimeOfDay? selectedTime = widget.bookingDetails['selectedTime'];  // TimeOfDay object

    // Format the date
    String formattedDate = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate)
        : 'Not Specified';

    // Format the time
    String formattedTime = selectedTime != null
        ? '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}'
        : 'Not Specified';

    // Format delivery date and time for scheduled deliveries
    String formattedDeliveryDate = deliveryDate != null
        ? DateFormat('yyyy-MM-dd').format(deliveryDate)
        : 'Not Specified';

    String formattedDeliveryTime = deliveryDate != null
        ? '${deliveryDate.hour}:${deliveryDate.minute.toString().padLeft(2, '0')}'
        : 'Not Specified';

    // Check if food delivery is involved or it's dine-in without pre-order
    bool isFoodDelivery = deliveryMethod == 'Scheduled' || deliveryMethod == 'Immediate';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.0,
        backgroundColor: Colors.amber,
        title: Text('Booking Confirmed'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 'Thanks for Booking!' text
            SizedBox(height: 20,),
            Text(
              'Thanks for Booking!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Tick Icon
            Icon(
              Icons.check_circle_outline,
              color: Colors.amber,
              size: 50,
            ),
            SizedBox(height: 5),

            // Conditional booking details
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Details
                  Text(
                    'Restaurant Details:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Name: ${widget.bookingDetails['restaurantName'] ?? ''}'),
                  Text('Address: ${widget.bookingDetails['restaurantAddress'] ?? ''}'),
                  SizedBox(height: 20),

                  // Booking Details Heading
                  Text(
                    'Booking Details:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Case 1: Pre-order Food but no Delivery Method (No Delivery)
                  if (preOrderFood && deliveryMethod.isEmpty) ...[
                    Text('Date: $formattedDate'),  // Display formatted date
                    Text('Time: $formattedTime'),  // Display formatted time

                    Text('Persons: ${persons ?? 'Not Specified'}'), // Show 'Not Specified' if persons is null
                    Text('Event: ${event ?? 'Not Specified'}'),
                    Text('Preorder Food: Yes'),
                    Text('Payment Method: $paymentMethod'),
                    SizedBox(height: 20),

                    // Cart Details
                    Text(
                      'Cart Details:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    for (var item in cartItems) ...[
                      Text('${item['name'] ?? ''} x${item['quantity'] ?? 0} - \$${(item['price'] * (item['quantity'] ?? 1)).toStringAsFixed(2)}'),
                    ],
                    SizedBox(height: 20),

                    // Total Section
                    Text(
                      'Total: \$${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],

                  // Case 2: Dine-In without Pre-order Food
                  if (!preOrderFood && deliveryMethod.isEmpty) ...[
                    Text('Date: ${date ?? 'Not Specified'}'),
                    Text('Time: ${time ?? 'Not Specified'}'),
                    Text('Persons: ${persons ?? 'Not Specified'}'),
                    Text('Event: ${event ?? 'Not Specified'}'),
                    Text('Preorder Food: No'),
                    SizedBox(height: 20),
                  ],

                  // Case 3: Food Delivery (Delivery Method Selected)
                  if (isFoodDelivery && !preOrderFood) ...[
                    Text('Payment Method: $paymentMethod'),
                    Text('Delivery Method: $deliveryMethod'),
                    if (deliveryMethod == 'Scheduled') ...[
                      // Display scheduled delivery date and time if the method is "Scheduled"
                      Text('Scheduled Date: $formattedDeliveryDate '),
                      Text('Scheduled Time: $formattedDeliveryTime'),
                    ],
                    SizedBox(height: 20),

                    // Cart Items Section
                    Text(
                      'Cart Details:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    for (var item in cartItems) ...[
                      Text('${item['name'] ?? ''} x${item['quantity'] ?? 0} - \$${(item['price'] * (item['quantity'] ?? 1)).toStringAsFixed(2)}'),
                    ],

                    SizedBox(height: 20),

                    // Total Section
                    Text(
                      'Total: \$${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      )
      
    );
  }
}

String generateReceipt(Map<String, dynamic> bookingDetails) {
  bool preOrderFood = bookingDetails['preOrderFood'] ?? false;
  String deliveryMethod = bookingDetails['deliveryMethod'] ?? '';
  DateTime? deliveryDate = bookingDetails['deliveryDate'];
  List<Map<String, dynamic>> cartItems = bookingDetails['cartItems'] ?? [];
  double total = bookingDetails['total'] ?? 0.0;
  String paymentMethod = bookingDetails['paymentMethod'] ?? '';

  String? event = bookingDetails['event'];
  String? date = bookingDetails['date'];
  String? time = bookingDetails['time'];
  String? persons = bookingDetails['persons'];

  DateTime? selectedDate = bookingDetails['selectedDate'];
  TimeOfDay? selectedTime = bookingDetails['selectedTime'];

  String formattedDate = selectedDate != null
      ? DateFormat('yyyy-MM-dd').format(selectedDate)
      : 'Not Specified';

  String formattedTime = selectedTime != null
      ? '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}'
      : 'Not Specified';

  String formattedDeliveryDate = deliveryDate != null
      ? DateFormat('yyyy-MM-dd').format(deliveryDate)
      : 'Not Specified';

  String formattedDeliveryTime = deliveryDate != null
      ? '${deliveryDate.hour}:${deliveryDate.minute.toString().padLeft(2, '0')}'
      : 'Not Specified';

  bool isFoodDelivery = deliveryMethod == 'Scheduled' || deliveryMethod == 'Immediate';

  // Start building the receipt string
  String receipt = '--- Receipt ---\n\n';

  // Add Restaurant Details
  receipt += 'Restaurant Details:\n';
  receipt += 'Name: ${bookingDetails['restaurantName'] ?? 'Not Specified'}\n';
  receipt += 'Address: ${bookingDetails['restaurantAddress'] ?? 'Not Specified'}\n\n';

  // Add Booking Details
  receipt += 'Booking Details:\n';
  if (preOrderFood && deliveryMethod.isEmpty) {
    receipt += 'Date: $formattedDate\n';
    receipt += 'Time: $formattedTime\n';
    receipt += 'Persons: ${persons ?? 'Not Specified'}\n';
    receipt += 'Event: ${event ?? 'Not Specified'}\n';
    receipt += 'Preorder Food: Yes\n';
  } else {
    receipt += 'Date: ${date ?? 'Not Specified'}\n';
    receipt += 'Time: ${time ?? 'Not Specified'}\n';
    receipt += 'Persons: ${persons ?? 'Not Specified'}\n';
    receipt += 'Event: ${event ?? 'Not Specified'}\n';
    receipt += 'Preorder Food: No\n';
  }

  // Add Cart Details
  receipt += '\nCart Details:\n';
  for (var item in cartItems) {
    receipt += '${item['name'] ?? 'Item'} x${item['quantity'] ?? 1} - \$${(item['price'] * (item['quantity'] ?? 1)).toStringAsFixed(2)}\n';
  }

  // Add Total
  receipt += '\nTotal: \$${total.toStringAsFixed(2)}\n';

  // Add Delivery Details if applicable
  if (isFoodDelivery) {
    receipt += '\nDelivery Method: $deliveryMethod\n';
    if (deliveryMethod == 'Scheduled') {
      receipt += 'Scheduled Date: $formattedDeliveryDate\n';
      receipt += 'Scheduled Time: $formattedDeliveryTime\n';
    }
  }

  // Add Payment Method
  receipt += '\nPayment Method: $paymentMethod\n';

  return receipt;
}

