# 🍽️ Taute – Restaurant Booking & Food Delivery App

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

*A modern solution for restaurant reservations, food delivery, and real-time restaurant content.*

### 🚀 Built With:

* **Flutter** – Cross-platform UI
* **Firebase** – Authentication & Backend Services

---

## 📱 Features

### 🏠 Home Page

* **Stories for Each Restaurant**: Get a glimpse of *what's new today* with short clips (like Instagram stories) from restaurants.
  → Tap **"View Restaurant"** in a story to visit its dedicated page.
* **Event-Based Booking**: Filter restaurants based on events like birthdays, anniversaries, and corporate meets.
* **Offer Carousel**: See limited-time discounts and deals from various restaurants.
* **All Restaurants List**: Displays restaurant name, rating, distance and duration of delivery.

---

## 🍴 Restaurant Pages

Each restaurant has its **own dynamic page** containing:

* **Details**: Name, location, duration, distance and average rating.

Tabs:

Posts: Visual content (images, updates) shared by the restaurant.

Nibbles: Short, engaging video clips showcasing ambiance and food.

Reviews: View and write customer reviews.

✅ Users can like, comment on, and share both Posts and Nibbles — making restaurant interactions feel social and real-time.

✨ This replaces the need for third-party influencers—restaurants can directly engage customers through rich, interactive media.

---

## 🧾 Booking & Ordering System

From the **Book & Order** button:

1. **Table Booking**:

   * Select number of people and event type.
   * Optionally add food from the restaurant's menu (which has images, descriptions, and ratings).
   * Items are added to cart.

2. **Food Delivery**:

   * Direct access to the menu.
   * Add to cart and choose:

     * **Instant Delivery**
     * **Scheduled Delivery** (pick future date and time — perfect for birthday cakes or planned meals)

---

## 🧭 Navigation

* **Home**: Explore restaurants, stories, offers, and book/order easily.
* **Nibbles**: Watch mini restaurant reels from nearby eateries.
* **Cart**: View and manage your table bookings and orders.

---

## 🛠️ Tech Highlights

* **Firebase Authentication**: Secure user login.
* **Firestore**: Handles orders, restaurant posts, reviews, and scheduled deliveries.
* **Flutter UI**: Fast, beautiful, and responsive design for Android, iOS and Web.

---

## 🔮 Future Work

* ✅ Admin dashboard for restaurant owners to manage posts, bookings, and menus
* 🔔 In-app push notifications for order status and offers
* 🎁 Loyalty & rewards system for returning users

---

## 📸 Why Taute?

> Restaurants today rely heavily on influencer marketing. **Taute gives control back to the restaurants** by letting them upload short posts and reels themselves, helping users engage directly with the restaurant's vibe and offerings. Merging table booking with menu selection helps reduce wait times at the venue—solving a real-world pain point.

---

## 🔐 Security & Privacy

To protect sensitive information and follow best practices:

* `android/app/google-services.json`
* `lib/firebase_options.dart`

have been added to `.gitignore` to prevent committing Firebase credentials and configuration data to the repository.

> 🔒 Ensure these files are added manually during local development.



