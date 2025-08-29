# Staff Portal - Flutter Employee Management System

## Project Overview

Staff Portal adalah aplikasi Flutter untuk employee management system dengan complete CRUD functionality. Project ini menggunakan **DummyJSON API** sebagai backend service dan menggunakan **GetX** untuk state management.

## Features Completed

### Authentication Module
- **Login/Register** dengan JWT token management
- **Secure storage** dengan GetStorage
- **Form validation** dengan error handling

### Dashboard Module  
- **Employee ListView** Dengan Modern UI
- **Pagination** dengan infinite scroll (10 data untuk sekali scroll)
- **Search functionality** (nama & email)
- **Pull-to-refresh** untuk data update
- **Loading states** dan empty states

### Employee Management (CRUD)
- **CREATE**: Add employee (Only confirmation doesnt changed the actual data from server api)
- **READ**: Dashboard list + detailed view
- **UPDATE**: Edit employee (Only confirmation doesnt changed the actual data from server api)
- **DELETE**: Deleted employee (Only confirmation doesnt changed the actual data from server api)

## Technical Stack

### Frontend
- **Flutter** - Cross-platform mobile framework
- **GetX** - State management & dependency injection
- **Dio** - HTTP client dengan interceptors
- **GetStorage** - Encrypted local storage

### Backend API
- **DummyJSON** - RESTful API untuk testing
- **JWT Authentication** - Token-based security
- **CRUD Operations** - Complete data management

## Key Features Detail

### Employee Dashboard
- **ListView dengan pagination** (10 items per page)
- **Real-time search** dengan debounce (500ms)
- **Filter by**: nama & email
- **Professional employee cards** dengan avatar & job title
- **Pull-to-refresh** functionality
- **Auto-load more** ketika scroll

### Employee Detail View
- **Professional layout** dengan organized sections:
  - Personal Information (username, gender, birth date)
  - Contact Information (email, phone, address)
  - Professional Information (job title, department, employee ID)
- **CRUD Action buttons** (Edit/Delete)

### Add Employee Form
- **Form fields**: Name, Email, Position, Salary
- **Validation rules**:
  - Email format validation
  - Salary minimum 1,000,000
  - Required field validation
- **Success/Error dialogs**
- **Auto dashboard refresh**

### Edit Employee Form  
- **Editable fields**: firstName, lastName, email, phone, gender, birthDate, jobTitle, department
- **Read-only fields**: employeeID, username (security)
- **Advanced components**:
  - Gender dropdown (Male/Female)
  - DatePicker untuk birth date
  - Sectioned layout untuk better organization
- **Form pre-population** dari existing data
- **Comprehensive validation**

## Security Features

- **JWT Token** management dengan auto-refresh
- **Secure storage** dengan encryption
- **Auto-logout** pada token expiry
- **Input validation** dan sanitization
- **API error handling** dengan user feedback
- **Navigation guards** untuk protected routes

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=2.17.0)
- Android Studio / VS Code
- Android/iOS Emulator atau Physical Device

### Installation
1. Clone repository
2. Run `flutter pub get`
3. Run `flutter run`

### Test Credentials
- Username: `emilys` (di case ini saya pake dummy json yang tidak menyediakan login menggunakan email hanya
  melalui username, jadi saya menggunakan username di inputan email)
- Password: `emilyspass`
- (Any valid DummyJSON user credentials)

## API Endpoints Used

```
Authentication:
POST /auth/login

Users (CRUD):  
GET  /users (with pagination)
GET  /users/{id}
POST /users/add
PUT  /users/{id}  
DELETE /users/{id}
GET  /users/search?q={query}
```

## Authentication Flow

**Login Response → User Model Conversion**
User Login → DummyJSON API → LoginResponseModel → UserModel → UI Display

**Why Two Models?**
- `LoginResponseModel`: Complete API response with tokens and metadata
- `UserModel`: Clean data without sensitive information like tokens etc

**Implementation:**
```dart
// API returns complete data
LoginResponseModel loginResponse = await ApiService.login(email, password);

// Automatically converted to clean model
UserModel user = UserModel.fromLoginResponse(loginResponse);

// Easy access throughout app
Text('Welcome ${authController.userName}!');
```

**Benefits:**
- Clean separation between API data and app data
- Secure token handling (stored separately)
- Simple UI data access with reactive updates

## Custom Snackbar

**Consistent Notifications**
- Standardized colors and styling across the app
- Full-width display for modern UI
- Multiple types: success (green), error (red), warning (orange), info (blue)

**Anti-Spam Protection**
- Debouncer prevents notification spam
- 500ms delay between similar messages

**Usage:**
```dart
CustomSnackbar.showSuccess(message: 'Login successful!');
CustomSnackbar.showError(message: 'Login failed!');
```

---