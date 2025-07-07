
/// API Endpoints Configuration
library;

/// Base URLs
const String basedURL = "https://brillprime-dev.onrender.com";
const String wsBaseURL = "wss://brillprime-dev.onrender.com";
const String supaBaseURL = "https://xvvinilnmimavowaabvv.supabase.co/";

/// Authentication Endpoints
const String loginEndpoint = "auth/signin";
const String signUpEndpoint = "auth/signup";
const String verifyOtpEndpoint = "auth/verify-otp";
const String resetPasswordEndpoint = "auth/reset-password";
const String forgotPasswordEndpoint = "auth/forgot-password";
const String resendOtpEndpoint = "auth/resend-email-otp";
const String refreshTokenEndpoint = "auth/refresh-token";
const String logoutEndpoint = "auth/logout";

/// User Profile Endpoints
const String getProfileEndpoint = "user/profile";
const String updateProfileEndpoint = "user/profile/update";
const String uploadProfileImageEndpoint = "user/profile/upload-image";
const String deleteAccountEndpoint = "user/account/delete";

/// Vendor Endpoints
const String createVendorEndpoint = "vendor/create";
const String getVendorProfileEndpoint = "vendor/profile";
const String updateVendorProfileEndpoint = "vendor/profile/update";
const String getVendorAnalyticsEndpoint = "vendor/analytics";
const String getVendorOrdersEndpoint = "vendor/orders";
const String updateVendorOrderStatusEndpoint = "vendor/orders/update-status";
const String getVendorInventoryEndpoint = "vendor/inventory";
const String getVendorBusinessHoursEndpoint = "vendor/business-hours";
const String updateVendorBusinessHoursEndpoint = "vendor/business-hours/update";
const String getVendorSubscriptionEndpoint = "vendor/subscription";
const String updateVendorSubscriptionEndpoint = "vendor/subscription/update";

/// Consumer Endpoints
const String createCustomerEndpoint = "consumer/create";
const String getConsumerOrdersEndpoint = "consumer/orders";
const String placeOrderEndpoint = "consumer/orders/place";
const String getConsumerProfileEndpoint = "consumer/profile";
const String updateConsumerProfileEndpoint = "consumer/profile/update";

/// Commodity Endpoints
const String getCommoditiesEndpoint = "commodities";
const String getCommodityDetailsEndpoint = "commodities/details";
const String createCommodityEndpoint = "commodities/create";
const String updateCommodityEndpoint = "commodities/update";
const String deleteCommodityEndpoint = "commodities/delete";
const String searchCommoditiesEndpoint = "commodities/search";
const String getCommodityCategoriesEndpoint = "commodities/categories";

/// Order Management Endpoints
const String getOrdersEndpoint = "orders";
const String getOrderDetailsEndpoint = "orders/details";
const String updateOrderStatusEndpoint = "orders/update-status";
const String cancelOrderEndpoint = "orders/cancel";
const String trackOrderEndpoint = "orders/track";
const String getOrderHistoryEndpoint = "orders/history";

/// Cart Endpoints
const String getCartEndpoint = "cart";
const String addToCartEndpoint = "cart/add";
const String updateCartItemEndpoint = "cart/update";
const String removeFromCartEndpoint = "cart/remove";
const String clearCartEndpoint = "cart/clear";
const String getCartTotalEndpoint = "cart/total";

/// Payment Endpoints
const String getPaymentMethodsEndpoint = "payment/methods";
const String addPaymentMethodEndpoint = "payment/methods/add";
const String updatePaymentMethodEndpoint = "payment/methods/update";
const String deletePaymentMethodEndpoint = "payment/methods/delete";
const String processPaymentEndpoint = "payment/process";
const String verifyPaymentEndpoint = "payment/verify";
const String getPaymentHistoryEndpoint = "payment/history";

/// Bank Account Endpoints
const String getBankAccountsEndpoint = "bank/accounts";
const String addBankAccountEndpoint = "bank/accounts/add";
const String updateBankAccountEndpoint = "bank/accounts/update";
const String deleteBankAccountEndpoint = "bank/accounts/delete";
const String verifyBankAccountEndpoint = "bank/accounts/verify";

/// Address Endpoints
const String getAddressesEndpoint = "addresses";
const String addAddressEndpoint = "addresses/add";
const String updateAddressEndpoint = "addresses/update";
const String deleteAddressEndpoint = "addresses/delete";
const String setDefaultAddressEndpoint = "addresses/set-default";

/// Notification Endpoints
const String getNotificationsEndpoint = "notifications";
const String markNotificationReadEndpoint = "notifications/mark-read";
const String deleteNotificationEndpoint = "notifications/delete";
const String getNotificationSettingsEndpoint = "notifications/settings";
const String updateNotificationSettingsEndpoint = "notifications/settings/update";

/// Review Endpoints
const String getReviewsEndpoint = "reviews";
const String addReviewEndpoint = "reviews/add";
const String updateReviewEndpoint = "reviews/update";
const String deleteReviewEndpoint = "reviews/delete";
const String getVendorReviewsEndpoint = "reviews/vendor";

/// Favourites Endpoints
const String getFavouritesEndpoint = "favourites";
const String addToFavouritesEndpoint = "favourites/add";
const String removeFromFavouritesEndpoint = "favourites/remove";

/// Search Endpoints
const String searchEndpoint = "search";
const String advancedSearchEndpoint = "search/advanced";
const String getSearchSuggestionsEndpoint = "search/suggestions";
const String getSearchHistoryEndpoint = "search/history";

/// Toll Gate Endpoints
const String getTollGatesEndpoint = "toll-gates";
const String getTollGateDetailsEndpoint = "toll-gates/details";
const String purchaseTollTicketEndpoint = "toll-gates/purchase";
const String getTollTicketsEndpoint = "toll-gates/tickets";

/// Real-time Endpoints
const String realtimeOrdersEndpoint = "realtime/orders";
const String realtimeInventoryEndpoint = "realtime/inventory";
const String realtimeNotificationsEndpoint = "realtime/notifications";
const String realtimeChatEndpoint = "realtime/chat";

/// File Upload Endpoints
const String uploadImageEndpoint = "upload/image";
const String uploadDocumentEndpoint = "upload/document";
const String uploadMultipleFilesEndpoint = "upload/multiple";

/// Analytics Endpoints
const String getAnalyticsEndpoint = "analytics";
const String getVendorAnalyticsDetailEndpoint = "analytics/vendor/details";
const String getConsumerAnalyticsEndpoint = "analytics/consumer";
const String getSystemAnalyticsEndpoint = "analytics/system";

/// Support Endpoints
const String getSupportTicketsEndpoint = "support/tickets";
const String createSupportTicketEndpoint = "support/tickets/create";
const String updateSupportTicketEndpoint = "support/tickets/update";
const String closeSupportTicketEndpoint = "support/tickets/close";

/// Location Endpoints
const String getNearbyVendorsEndpoint = "location/nearby-vendors";
const String getDeliveryZonesEndpoint = "location/delivery-zones";
const String validateAddressEndpoint = "location/validate-address";

/// Inventory Management Endpoints
const String getInventoryEndpoint = "inventory";
const String updateInventoryEndpoint = "inventory/update";
const String addInventoryItemEndpoint = "inventory/add";
const String removeInventoryItemEndpoint = "inventory/remove";
const String getInventoryAlertsEndpoint = "inventory/alerts";

/// Business Hours Endpoints
const String getBusinessHoursEndpoint = "business-hours";
const String updateBusinessHoursEndpoint = "business-hours/update";

/// Subscription Endpoints
const String getSubscriptionPlansEndpoint = "subscription/plans";
const String subscribeEndpoint = "subscription/subscribe";
const String unsubscribeEndpoint = "subscription/unsubscribe";
const String getSubscriptionStatusEndpoint = "subscription/status";

/// QR Code Endpoints
const String generateQRCodeEndpoint = "qr/generate";
const String scanQRCodeEndpoint = "qr/scan";
const String validateQRCodeEndpoint = "qr/validate";

/// Websocket Endpoints
const String wsOrderUpdatesEndpoint = "/ws/orders";
const String wsInventoryUpdatesEndpoint = "/ws/inventory";
const String wsNotificationsEndpoint = "/ws/notifications";
const String wsChatEndpoint = "/ws/chat";
