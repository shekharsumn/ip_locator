# IP Locator

A Flutter app that finds location details for any IP address or your current location.

## Demo Video

🎥 [Watch the app demo on YouTube](https://youtube.com/shorts/rB5m96YVx4E?si=ZhIXLq2K5MPs5I-3)

## What it does

- **Enter an IP address** → Get location details (city, country, timezone, etc.)
- **Get your current location** → Find details about your public IP address
- **View on map** → See the location on an interactive map
- **Offline handling** → Shows helpful messages when internet is not available

## Features

- Clean, simple interface
- Works with both IPv4 and IPv6 addresses
- Real-time validation as you type
- Shows detailed location info including:
  - City, region, and country
  - Coordinates and timezone
  - Internet service provider
  - Currency and languages
- Interactive map view
- Error handling with retry options
- Works offline (shows cached data when available)

## How to run

1. **Install Flutter** (if you haven't already)
   ```bash
   # Check if Flutter is installed
   flutter --version
   ```

2. **Get the code**
   ```bash
   git clone <your-repo-url>
   cd ip_locator
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Requirements

- Flutter SDK 3.9.2 or higher
- Internet connection for fetching IP data
- Android 5.0+ or iOS 11.0+

## How to use

1. **Enter an IP address** in the text field (like `8.8.8.8`)
2. **Tap "Get Location Details"** or press the search button
3. **Or tap "Get My Current IP Location"** to find your own location
4. **View the results** on the details page
5. **Tap "View on Map"** to see the location visually

## Built with

- **Flutter** - UI framework
- **Riverpod** - State management
- **Dio** - HTTP requests
- **Flutter Map** - Interactive maps
- **Connectivity Plus** - Network status checking
