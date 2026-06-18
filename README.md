# AWWA iOS App

A native iOS application serving as a dedicated mobile portal for the AWWA (Army Wives Welfare Association) website. Built entirely with modern Swift and SwiftUI, this app provides a seamless, app-like experience for web content using a robust `WKWebView` integration.

## 📱 Features

* **Custom Tab Navigation:** A persistent bottom `TabView` allowing users to instantly switch between core sections:
  * Home (`/`)
  * Donate (`/Donation`)
  * Entrepreneur (`/Entrepreneur`)
  * Login (`/Entrepreneur/Login`)
* **Custom iconography:** Utilizes custom high-resolution SVG assets rendered in their original colors for the tab bar.
* **Smart Link Handling:** Intercepts user navigation. Internal domain links open smoothly within the app, while external links (payment gateways, social media, etc.) are securely passed out to the device's default Safari browser.
* **Native Loading State:** Features a SwiftUI `ProgressView` with a frosted-glass (`.regularMaterial`) background that perfectly syncs with the web view's load state.
* **Pull-to-Refresh:** Integrates Apple's native `UIRefreshControl` directly into the web view's scroll view, allowing users to reload the current page with a standard swipe-down gesture.

## 🛠 Prerequisites

* A Mac running macOS Monterey (12.0) or later.
* **Xcode 14.0** or later.
* **iOS 15.0** or later deployment target.

## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/sugam-dev/awwa-ios-app.git
