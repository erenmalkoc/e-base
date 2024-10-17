# E-base File Editing Web App

A web-based file editing application built with Flutter/Dart for the frontend, and Node.js, Express.js, and MongoDB for the backend. This application supports real-time file editing using **Socket.io** and a rich text editor powered by **Quill**. State management is handled with **Riverpod**.

## Technologies Used

- **Node.js**: Backend framework
- **Socket.io**: Real-time changes in file editing
- **Express.js**: Server framework
- **MongoDB**: NoSQL database for storing data
- **Flutter/Dart**: Frontend framework
- **Quill**: Rich text editor
- **Riverpod**: State management library for Flutter

## Getting Started

### Prerequisites

Ensure you have the following installed:

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Node.js: [Install Node.js](https://nodejs.org/)
- MongoDB: [Install MongoDB](https://www.mongodb.com/try/download/community)

### Setup Instructions

1. **Change API URL:**
   - Update the API URL in `constants.dart` to point to your backend server.

2. **Install Flutter Dependencies:**
   - Run the following command in the terminal to install the required Flutter packages:
     ```bash
     flutter pub get
     ```

3. **Launch the Project:**
   - Use this command to run the project in a web environment (Chrome), using port 3000:
     ```bash
     flutter run -d chrome --web-port 3000
     ```

4. **Configure MongoDB:**
   - Update the MongoDB URL in the backend code to point to your own MongoDB instance.

5. **Ensure Quill is Up-to-Date:**
   - Check the [Quill package](https://pub.dev/packages/flutter_quill) and make sure it is the latest version.

### Screenshot

Login Page:

![Login Page](assets/images/grup_7.png)

### Support

For any issues, please feel free to contact me via email: [malkoceren24@gmail.com](mailto:malkoceren24@gmail.com).

![Erenium Logo](assets/images/erenium.png)

