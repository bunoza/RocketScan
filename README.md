iOS application developed as assignment for OKPP - FERIT '22/'23.

**RocketScan** is an iOS application designed to streamline the process of document scanning and management. The app leverages advanced image processing techniques to convert physical documents into digital format quickly and efficiently. It's ideal for users who need to digitize documents on the go, providing a fast, reliable, and user-friendly experience.

## Features

- **Quick Scanning**: Capture documents using your iPhone's camera with automatic edge detection and cropping.
- **High-Quality Output**: Process images to enhance readability and clarity.
- **File Management**: Organize scanned documents within the app for easy access and retrieval.
- **Export Options**: Save scans as PDFs or images and share them via email, cloud storage, or other apps.

## Implementation Details

RocketScan is implemented using the **Model-View-ViewModel (MVVM)** architectural pattern, which enhances the app's scalability, testability, and maintainability:

- **Model**: Represents the data and business logic, including image processing and file management functions.
  
- **View**: The user interface where users interact with the app, designed to be intuitive and easy to use.
  
- **ViewModel**: Connects the View and Model, handling the logic for processing images, managing documents, and updating the UI.

### Frameworks and Libraries Used

- **UIKit**: The fundamental framework for building the user interface, providing the necessary components for designing the app's layout and handling user interactions.
- **Core Image**: A powerful framework used for image processing, allowing for enhancements like edge detection, cropping, and filtering.
- **PDFKit**: Utilized for rendering and managing PDF documents within the app, enabling users to create, view, and share PDFs from their scanned documents.
- **AVFoundation**: Handles camera input for capturing images, ensuring high-quality document scans.

The MVVM architecture combined with these frameworks allows for a robust and flexible application structure.

## Installation

To install and run RocketScan on your iOS device:

1. Clone this repository:
   ```bash
   git clone https://github.com/bunoza/RocketScan.git
   ```
2. Open the project in Xcode.
3. Build and run the application on your iOS device or simulator.
