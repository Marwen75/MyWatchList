# 🎬 MyWatchList  
“Organize your watchlist. Rediscover your favorites. Enjoy the show.”

![Version](https://img.shields.io/badge/version-1.7-darkred?style=for-the-badge)
![Platform](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20watchOS-blue?style=for-the-badge)
![Swift](https://img.shields.io/badge/Swift-6.0-orange?style=for-the-badge)

**MyWatchList** is an iOS, macOS, and watchOS app built with **SwiftUI** that lets you track, organize, and rediscover your favorite movies and TV shows.  
It combines smooth performance and smart filtering to make managing your watchlist effortless and fun.

**MyWatchList** is powered by the [TMDB API](https://developer.themoviedb.org) and [YouTubePlayerKit](https://github.com/SvenTiigi/YouTubePlayerKit).

---

## ✨ Features

- 🎥 **Track your movies and TV shows**  
  Add titles from TMDB, organize them with tags, and mark them as watched or to watch later.

- 🔍 **Smart Search**  
  Instantly find any title by keyword, genre, or actor.

- 🏷️ **Custom Tags**  
  Categorize your content with personalized tags like *“Weekend Nights”* or *“With Friends”*.

- 💎 **Premium Unlock**  
  Unlock unlimited tags and advanced customization options through an in-app purchase powered by StoreKit.

- 📺 **TV Show Progress**  
  Track your progress across seasons and episodes with live progress indicators.

- 🔔 **Personalized Reminders**  
  Set notifications for upcoming movies or shows and get reminded when it’s time to watch.

- 🧱 **Widgets (iOS)**  
  Display your favorite content right on your Home Screen:  
  - 🔸 **Movie Widget** — highlights a selected movie with poster, metadata and quick access.  
  - 🔸 **Next Episode Widget** — shows your next unwatched episode across all TV shows.

- ⌚ **watchOS Companion App**  
  A native Apple Watch experience featuring:  
  - Full navigation between movies and TV shows  
  - Collapsible seasons  
  - Episode tracking  
  - Read/expand movie overview  
  - Swipe-to-delete  
  - Instant sync with iCloud

- 💾 **Core Data + iCloud Sync**  
  Your watchlist stays synced and backed up across all your devices.

- 🌍 **Automatic Localization**  
  Available in English and French — the app adapts automatically to your system language.

- 🔎 **Spotlight Integration (iOS & macOS)**  
  Search for movies or shows directly from Spotlight and jump instantly to their detail page.

- 🎨 **Designed for Apple platforms**  
  A native SwiftUI interface optimized for iOS, macOS, and watchOS, with adaptive layouts and smooth animations.

---

## 🧰 Tech Stack

- 🖥️ Swift / SwiftUI  
- 💾 Core Data  
- ☁️ Core Data + CloudKit Sync  
- 🧱 Pragmatic MVVM Architecture  
- 🔄 Swift Modern Concurrency  
- 🌐 TheMovieDB API  
- 🎬 YouTubePlayerKit  
- 🔔 UserNotifications  
- 🛒 StoreKit 2 (In-App Purchases)  
- ✨ WidgetKit  
- ⌚ SwiftUI-based watchOS App  
- 🔍 Core Spotlight & NSUserActivity for deep linking  

---

## 🖼️ Screenshots

### 📱 iOS App Preview
<img width="269" height="685" alt="i_1" src="https://github.com/user-attachments/assets/d9991c6f-4212-4155-8bb2-ebed6429f0d8" />
<img width="269" height="685" alt="i_2" src="https://github.com/user-attachments/assets/5054826a-e1e1-4cdd-8217-fd500484460e" />
<img width="269" height="685" alt="i_5" src="https://github.com/user-attachments/assets/6d1112e8-533e-4651-b2a6-249b98a124d2" />
<img width="269" height="685" alt="i_6" src="https://github.com/user-attachments/assets/08eb1d78-6d5a-4d4b-bb3b-c9964045781b" />
<img width="269" height="685" alt="i_14" src="https://github.com/user-attachments/assets/16b01955-fc17-41e0-bdfe-9a2d6ac1f724" />
<img width="269" height="685" alt="i_13" src="https://github.com/user-attachments/assets/886c13cf-fe94-4d96-a07f-68a442f90e3a" />
<img width="269" height="685" alt="i_12" src="https://github.com/user-attachments/assets/509d7c85-69fb-4741-88d8-eeb572e5de1b" />
<img width="269" height="685" alt="i_11" src="https://github.com/user-attachments/assets/b4a92527-cd0a-4111-9cee-167bfbd1fc7d" />
<img width="269" height="685" alt="i_15" src="https://github.com/user-attachments/assets/cc6ac07f-a939-49bc-b552-6d83b1d02d3e" />
<img width="269" height="685" alt="i_9" src="https://github.com/user-attachments/assets/d2a4c5ef-97e2-4010-86d1-4043c9d7a8fc" />
<img width="269" height="685" alt="i_8" src="https://github.com/user-attachments/assets/b50a25f1-be93-4c40-bb8a-53f89f0a38c9" />
<img width="269" height="685" alt="i_7" src="https://github.com/user-attachments/assets/42a8276f-dfa0-4a56-9424-2963f6de40b8" />

### ⌚ watchOS App Preview
<img width="388" height="490" alt="w_seen" src="https://github.com/user-attachments/assets/67e54efc-e1fe-47b0-9af3-9a7eeb5ba8d1" />
<img width="388" height="490" alt="Capture d’écran 2025-11-23 à 11 51 04" src="https://github.com/user-attachments/assets/7dd3f4c8-275e-4607-95c0-140b9210f023" />
<img width="388" height="490" alt="w_movie" src="https://github.com/user-attachments/assets/db5bd000-3a5b-4eae-bae9-115310bf265a" />
<img width="388" height="490" alt="w_movie_w" src="https://github.com/user-attachments/assets/d457c2bc-25b6-43a9-98d8-d6719daa23bd" />
<img width="388" height="490" alt="w_std" src="https://github.com/user-attachments/assets/4b0af926-8f17-4c84-9d39-8829e88f17bd" />
<img width="388" height="490" alt="w_show_s" src="https://github.com/user-attachments/assets/52d59506-7435-4c53-9ee5-37f98209ca9f" />
<img width="388" height="490" alt="w_show_e" src="https://github.com/user-attachments/assets/a796be4d-d178-4a6a-8244-cfb690672a07" />
<img width="388" height="490" alt="w_show" src="https://github.com/user-attachments/assets/c5189ee9-b83e-45f8-9183-6e4eee98bafb" />

### 🖥️ macOS App Preview
<img width="1068" height="698" alt="mac_1" src="https://github.com/user-attachments/assets/7559cca2-94b2-4bb5-b222-1e89f3978ecb" />
<img width="1068" height="698" alt="mac_2" src="https://github.com/user-attachments/assets/d4c4cb08-fb1d-4cba-963d-9336acaf92ba" />
<img width="1173" height="698" alt="mac_3" src="https://github.com/user-attachments/assets/281cc2b0-4f1e-4c96-ad4f-859268eb59e3" />

---

## 🚀 Upcoming Features

Here’s what’s next for **MyWatchList** 👇

- 🥽 **visionOS support** — immersive viewing and browsing experience in spatial UI.

---

## 💻 Requirements

- iOS **26.0** or later  
- macOS **Tahoe (26.0)** or later  
- watchOS **26.0** or later  
- Xcode **26.0** or later  
- Swift **6.2**

---

## ✨ Author

- Built with ❤️ by **Marwen Haouacine**  
- 📧 marwen.haouacine@gmail.com  
- 💼 [GitHub](https://github.com/Marwen75) / [LinkedIn](https://fr.linkedin.com/in/marwen-haouacine-b451911b7)


---

## 📄 License

This project is licensed under the **MIT License**.  
You’re free to use, modify, and distribute this software with attribution.

© 2025 Marwen Haouacine. All rights reserved.
