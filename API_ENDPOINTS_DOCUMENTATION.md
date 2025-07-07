
# Brill Prime API Endpoints Documentation

This document provides a comprehensive overview of all API endpoints used in the Brill Prime application and how they connect to the backend server at `https://brillprime-dev.onrender.com`.

## Base Configuration

- **Base URL**: `https://brillprime-dev.onrender.com`
- **WebSocket URL**: `wss://brillprime-dev.onrender.com`
- **Supabase URL**: `https://xvvinilnmimavowaabvv.supabase.co/`

## Authentication Endpoints

### POST `/auth/signin`
- **Purpose**: User login
- **Used by**: `AuthProvider.login()`, `LoginScreen`
- **Request Body**: `{email, password}`
- **Response**: `{success, token, user}`

### POST `/auth/signup`
- **Purpose**: User registration
- **Used by**: `AuthProvider.signUp()`, `SignUpScreen`
- **Request Body**: `{email, password, firstName, lastName, phone, userType}`
- **Response**: `{success, message, user}`

### POST `/auth/verify-otp`
- **Purpose**: OTP verification
- **Used by**: `AuthProvider.verifyOtp()`, `ConfirmEmailScreen`
- **Request Body**: `{email, otp}`
- **Response**: `{success, message, token}`

### POST `/auth/forgot-password`
- **Purpose**: Password reset request
- **Used by**: `AuthProvider.forgotPassword()`, `ForgotPasswordScreen`
- **Request Body**: `{email}`
- **Response**: `{success, message}`

### POST `/auth/reset-password`
- **Purpose**: Password reset
- **Used by**: `AuthProvider.resetPassword()`, `SetNewPasswordScreen`
- **Request Body**: `{email, password, token}`
- **Response**: `{success, message}`

## User Profile Endpoints

### GET `/user/profile`
- **Purpose**: Get user profile
- **Used by**: `AuthProvider.getUserProfile()`, `ProfileScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Response**: `{success, user}`

### PUT `/user/profile/update`
- **Purpose**: Update user profile
- **Used by**: `AuthProvider.updateProfile()`, `ProfileScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**: `{firstName, lastName, phone, address, ...}`
- **Response**: `{success, message, user}`

## Vendor Endpoints

### POST `/vendor/create`
- **Purpose**: Create vendor profile
- **Used by**: `VendorProvider.createVendor()`, `CompleteVendorProfileScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**: `{businessName, businessType, address, ...}`
- **Response**: `{success, message, vendor}`

### GET `/vendor/profile`
- **Purpose**: Get vendor profile
- **Used by**: `VendorProvider.getVendorProfile()`, `VendorProfileScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Response**: `{success, vendor}`

### GET `/vendor/analytics`
- **Purpose**: Get vendor analytics
- **Used by**: `VendorProvider.getAnalytics()`, `VendorAnalyticsScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Response**: `{success, analytics}`

### GET `/vendor/orders`
- **Purpose**: Get vendor orders
- **Used by**: `VendorProvider.getOrders()`, `VendorOrderScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Response**: `{success, orders}`

### PATCH `/vendor/orders/update-status`
- **Purpose**: Update order status
- **Used by**: `VendorProvider.updateOrderStatus()`, `VendorOrderDetailScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**: `{orderId, status}`
- **Response**: `{success, message, order}`

## Commodity Endpoints

### GET `/commodities`
- **Purpose**: Get commodities list
- **Used by**: `DashboardProvider.getCommodities()`, `CommoditiesScreen`
- **Query Parameters**: `?page=1&limit=20&category=grains&search=rice`
- **Response**: `{success, data, pagination}`

### GET `/commodities/details/{id}`
- **Purpose**: Get commodity details
- **Used by**: `DashboardProvider.getCommodityDetails()`, `CommodityDetailsScreen`
- **Response**: `{success, commodity}`

### POST `/commodities/create`
- **Purpose**: Create new commodity
- **Used by**: `VendorProvider.createCommodity()`, `AddNewCommodityScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**: `{name, description, price, category, images, ...}`
- **Response**: `{success, message, commodity}`

### PUT `/commodities/update/{id}`
- **Purpose**: Update commodity
- **Used by**: `VendorProvider.updateCommodity()`, `EditCommodityScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**: `{name, description, price, category, ...}`
- **Response**: `{success, message, commodity}`

### DELETE `/commodities/delete/{id}`
- **Purpose**: Delete commodity
- **Used by**: `VendorProvider.deleteCommodity()`, `ManageCommoditiesScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Response**: `{success, message}`

## Cart Endpoints

### GET `/cart`
- **Purpose**: Get user cart
- **Used by**: `CartProvider.getCart()`, `CartScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Response**: `{success, cart}`

### POST `/cart/add`
- **Purpose**: Add item to cart
- **Used by**: `CartProvider.addToCart()`, `CommodityCard`
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**: `{commodityId, quantity}`
- **Response**: `{success, message, cartItem}`

### PATCH `/cart/update`
- **Purpose**: Update cart item quantity
- **Used by**: `CartProvider.updateCartItem()`, `CartScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**: `{itemId, quantity}`
- **Response**: `{success, message, cartItem}`

### DELETE `/cart/remove`
- **Purpose**: Remove item from cart
- **Used by**: `CartProvider.removeFromCart()`, `CartScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**: `{itemId}`
- **Response**: `{success, message}`

## Order Endpoints

### GET `/orders`
- **Purpose**: Get user orders
- **Used by**: `OrderManagementProvider.getOrders()`, `OrderManagementScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Query Parameters**: `?page=1&limit=20&status=pending`
- **Response**: `{success, orders, pagination}`

### GET `/orders/details/{id}`
- **Purpose**: Get order details
- **Used by**: `OrderManagementProvider.getOrderDetails()`, `OrderDetailScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Response**: `{success, order}`

### POST `/orders/place`
- **Purpose**: Place new order
- **Used by**: `OrderManagementProvider.placeOrder()`, `CheckoutScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**: `{items, deliveryAddress, paymentMethod, ...}`
- **Response**: `{success, message, order}`

### PATCH `/orders/update-status`
- **Purpose**: Update order status
- **Used by**: `OrderManagementProvider.updateOrderStatus()`, `OrderDetailScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**: `{orderId, status}`
- **Response**: `{success, message, order}`

## Payment Endpoints

### GET `/payment/methods`
- **Purpose**: Get payment methods
- **Used by**: `PaymentMethodsProvider.getPaymentMethods()`, `PaymentMethodsScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Response**: `{success, paymentMethods}`

### POST `/payment/methods/add`
- **Purpose**: Add payment method
- **Used by**: `PaymentMethodsProvider.addPaymentMethod()`, `AddPaymentCardScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**: `{type, cardNumber, expiryDate, cvv, ...}`
- **Response**: `{success, message, paymentMethod}`

### POST `/payment/process`
- **Purpose**: Process payment
- **Used by**: `PaymentMethodsProvider.processPayment()`, `PaymentScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**: `{orderId, paymentMethodId, amount, ...}`
- **Response**: `{success, message, transaction}`

## Notification Endpoints

### GET `/notifications`
- **Purpose**: Get user notifications
- **Used by**: `NotificationProvider.getNotifications()`, `NotificationScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Query Parameters**: `?page=1&limit=20`
- **Response**: `{success, notifications, pagination}`

### PATCH `/notifications/mark-read`
- **Purpose**: Mark notification as read
- **Used by**: `NotificationProvider.markAsRead()`, `NotificationScreen`
- **Headers**: `Authorization: Bearer {token}`
- **Request Body**: `{notificationId}`
- **Response**: `{success, message}`

## Search Endpoints

### GET `/search`
- **Purpose**: Search commodities
- **Used by**: `SearchProvider.search()`, `SearchScreen`
- **Query Parameters**: `?q=rice&category=grains&location=lagos`
- **Response**: `{success, results, pagination}`

### GET `/search/advanced`
- **Purpose**: Advanced search
- **Used by**: `SearchProvider.advancedSearch()`, `AdvancedSearchScreen`
- **Query Parameters**: `?q=rice&minPrice=100&maxPrice=500&category=grains`
- **Response**: `{success, results, pagination}`

## Real-time Endpoints (WebSocket)

### WebSocket `/ws/orders`
- **Purpose**: Real-time order updates
- **Used by**: `RealTimeService.connectToOrders()`, `RealTimeOrderCard`
- **Headers**: `Authorization: Bearer {token}`
- **Events**: `order_placed`, `order_updated`, `order_cancelled`

### WebSocket `/ws/inventory`
- **Purpose**: Real-time inventory updates
- **Used by**: `RealTimeService.connectToInventory()`, `RealTimeInventoryWidget`
- **Headers**: `Authorization: Bearer {token}`
- **Events**: `inventory_updated`, `low_stock_alert`

### WebSocket `/ws/notifications`
- **Purpose**: Real-time notifications
- **Used by**: `RealTimeService.connectToNotifications()`, `RealTimeNotificationWidget`
- **Headers**: `Authorization: Bearer {token}`
- **Events**: `new_notification`, `notification_read`

## File Upload Endpoints

### POST `/upload/image`
- **Purpose**: Upload single image
- **Used by**: `ImageUploadProvider.uploadImage()`, `AddNewCommodityScreen`
- **Headers**: `Authorization: Bearer {token}`, `Content-Type: multipart/form-data`
- **Form Data**: `file: {image_file}`
- **Response**: `{success, message, imageUrl}`

### POST `/upload/multiple`
- **Purpose**: Upload multiple files
- **Used by**: `ImageUploadProvider.uploadMultipleImages()`, `AddNewCommodityScreen`
- **Headers**: `Authorization: Bearer {token}`, `Content-Type: multipart/form-data`
- **Form Data**: `files: {file1, file2, ...}`
- **Response**: `{success, message, imageUrls}`

## Error Handling

All endpoints follow consistent error response format:
```json
{
  "success": false,
  "message": "Error description",
  "error": {
    "code": "ERROR_CODE",
    "details": "Detailed error information"
  }
}
```

Common HTTP status codes:
- `200`: Success
- `201`: Created
- `400`: Bad Request
- `401`: Unauthorized
- `403`: Forbidden
- `404`: Not Found
- `422`: Validation Error
- `500`: Internal Server Error

## Authentication Flow

1. User signs up via `/auth/signup`
2. User verifies email via `/auth/verify-otp`
3. User logs in via `/auth/signin` and receives JWT token
4. All subsequent requests include `Authorization: Bearer {token}` header
5. Token expires after certain time, user must login again

## Rate Limiting

API implements rate limiting to prevent abuse:
- 100 requests per minute per IP for public endpoints
- 1000 requests per minute per user for authenticated endpoints
- Special limits for file upload endpoints

## Implementation Notes

1. All API calls are implemented in `ApiService` class
2. Error handling is centralized in `_handleResponse()` method
3. Authentication tokens are managed by `AuthProvider`
4. WebSocket connections are handled by `RealTimeService`
5. File uploads use multipart form data
6. All responses include proper CORS headers for web support

## Testing

Run the API integration tests:
```bash
flutter test test/integration/api_integration_test.dart
```

Run specific endpoint tests:
```bash
flutter test test/services/api_service_test.dart
```

## Environment Configuration

The app supports different environments:
- Development: `https://brillprime-dev.onrender.com`
- Staging: `https://brillprime-staging.onrender.com`
- Production: `https://brillprime.onrender.com`

Environment is configured in `lib/resources/constants/endpoints.dart`.
