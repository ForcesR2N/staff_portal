# Staff Portal

  ## Authentication Flow

  The app uses a dual-model approach for clean data handling:

  **Login Response → User Model Conversion**
  User Login → DummyJSON API → LoginResponseModel → UserModel → UI Display

  **Why Two Models?**
  - `LoginResponseModel`: Complete API response with tokens and metadata
  - `UserModel`: Clean cuz without sensitive information like tokens etc

  **Implementation:**
  ```dart
  // API returns complete data
  LoginResponseModel loginResponse = await ApiService.login(email, password);

  // Automatically converted to clean model
  UserModel user = UserModel.fromLoginResponse(loginResponse);

  // Easy access throughout app
  Text('Welcome ${authController.userName}!');

  Benefits:
  - Clean separation between API data and app data
  - Secure token handling (stored separately)
  - Simple UI data access with reactive updates

  Custom Snackbar System

  Consistent Notifications
  - Standardized colors and styling across the app
  - Full-width display for modern UI
  - Multiple types: success (green), error (red), warning (orange), info (blue)

  Anti-Spam Protection
  - Used debouncer prevents notification spam
  - 500ms delay between similar messages

  Usage:
  CustomSnackbar.showSuccess(message: 'Login successful!');
  CustomSnackbar.showError(message: 'Login failed!');