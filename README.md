# E-Commerce Integration Suite — Experience API

## Overview

The **Experience API** is the customer-facing layer of the E-Commerce Integration Suite. It provides RESTful endpoints for user authentication, store management, product catalog operations, shopping cart management, and order processing. This API follows API-led connectivity principles and acts as the gateway between external consumers (web/mobile clients) and the internal Process API layer.

**Key responsibilities:**
- User authentication and JWT token generation
- Request validation and transformation
- Business logic orchestration via the Process API
- Response formatting and error handling
- Role-based access control (Admin, Seller, Buyer)

---

## Architecture

The Experience API is designed as part of an **AI-powered e-commerce integration suite** using MuleSoft and the Model Context Protocol (MCP). The Experience API serves as the gateway that bridges the MCP Server (controlled by an AI Agent) with the backend process orchestration layer.

### Experience API Layer Flow

```
    AI Agent (via MCP Server)
              ↓
    Experience API (This Layer)
              ↓
      Process API Layer
              ↓
    System APIs (Database API, Mock Payment API)
              ↓
    Data Layer (MySQL Database on Aiven Cloud)
```

**Role of Experience API:**
- Acts as the **customer-facing gateway** for all e-commerce operations
- Provides **RESTful endpoints** for product browsing, user authentication, store management, shopping carts, and order processing
- Handles **JWT-based authentication** and role-based access control
- Transforms and validates incoming requests before forwarding to the Process API
- Formats responses for consistent consumption by the MCP Server

For the complete system architecture, deployment topology, and AI integration details, refer to the [main project repository](link-to-root-repo).

---

## Prerequisites

- **Mule Runtime**: 4.4.0 or later
- **Java**: JDK 11 or higher
- **Maven**: 3.8.0 or later (for building)
- **MuleSoft Connector Packs**: 
  - HTTP Connector
  - APIKit
- **Process API**: Must be running and accessible at the configured host and port

---

## Setup & Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd ecommerce-integration-suite-exp-api
```

### 2. Configure Properties

Create a `configuration.properties` file in `src/main/resources/`:

1. Right-click on `src/main/resources/` folder
2. Select **New** → **File**
3. Name it `configuration.properties`
4. Copy the content from [`configuration.properties.example`](./src/main/resources/configuration.properties.example)
5. Update the values according to your environment

Refer to [`configuration.properties.example`](./src/main/resources/configuration.properties.example) for the complete structure and required properties.

### 3. Build the Project

In Anypoint Studio:

1. Right-click on the project in **Package Explorer**
2. Select **Run As** → **Mule Application**

The project will automatically build and deploy to the embedded Mule Runtime.

### 4. Verify Deployment

Once deployed, the API will be running. Access the API Console:

```
http://localhost:8081/console/
```

Replace `8081` with your configured `http.port` value.

---

## Authentication

### JWT (JSON Web Token)

All secured endpoints require JWT authentication via the `Authorization` header.

**Token Structure:**
```json
{
  "userId": "USER123",
  "iss": "ecommerce_suite_backend",
  "aud": "ecommerce_api",
  "iat": 1693478400,
  "exp": 1693482000,
  "role": "buyer"
}
```

**Obtaining a Token:**

Call the login endpoint:

```bash
POST /exp/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

Response:
```json
{
  "message": "Login Successful",
  "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "userId": "USER123"
}
```

**Using the Token:**

Include the token in all subsequent requests:

```bash
Authorization: Bearer <your-jwt-token>
```

**Token Expiry:** Tokens expire after 1 hour (3600 seconds). Request a new token via the login endpoint after expiry.

---

## API Endpoints

### Authentication

#### Register User
```
POST /exp/auth/register
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": "newuser@example.com",
  "password": "securePassword123",
  "firstName": "John",
  "lastName": "Doe"
}
```

**Response (201 Created):**
```json
{
  "message": "Thank you for registering into our ECommerce Website",
  "userId": "USER456",
  "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Error Responses:**
- `409 Conflict` — Email already registered

---

#### Login
```
POST /exp/auth/login
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "message": "Login Successful",
  "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "userId": "USER123"
}
```

**Error Responses:**
- `404 Not Found` — Email not found
- `401 Unauthorized` — Incorrect password

---

### Store Management

#### Create Store
```
POST /exp/stores
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Required Role:** `seller`

**Request Body:**
```json
{
  "storeName": "Electronics Plus",
  "gstin": "18AABCR5055K1Z0",
  "accountNumber": "1234567890123456",
  "accountHolderName": "John Doe"
}
```

**Response (200 OK):**
```json
{
  "message": "Your store has been created successfully",
  "storeId": "ST-7ef50f"
}
```

**Error Responses:**
- `401 Unauthorized` — Invalid or missing JWT token
- `403 Forbidden` — Only sellers can create stores
- `409 Conflict` — Store name already registered

---

#### Update Store Verification Status
```
PATCH /exp/stores/{storeId}/verification
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Required Role:** `admin`

**Request Body:**
```json
{
  "status": "verified"
}
```

**Status Values:** `verified`, `unverified`, `rejected`

**Response (200 OK):**
```json
{
  "message": "Verification status changed successfully"
}
```

---

#### Get Stores by Verification Status (Admin)
```
GET /exp/stores/admin?verificationStatus=verified
Authorization: Bearer <jwt-token>
```

**Required Role:** `admin`

**Query Parameters:**
- `verificationStatus` (required): `verified`, `unverified`, or `rejected`

**Response (200 OK):**
```json
{
  "verified": [
    {
      "storeId": "ST-7ef50f",
      "storeName": "Electronics Plus",
      "gstin": "18AABCR5055K1Z0",
      "accountNumber": "1234567890123456",
      "accountHolderName": "John Doe"
    }
  ]
}
```

---

#### Get All Stores for a Seller
```
GET /exp/stores/seller
Authorization: Bearer <jwt-token>
```

**Required Role:** `seller`

**Response (200 OK):**
```json
[
  {
    "storeId": "ST-7ef50f",
    "storeName": "Electronics Plus",
    "verificationStatus": "verified"
  }
]
```

---

### Product Management

#### Add Product to Store
```
POST /exp/stores/{storeId}/products
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Required Role:** `seller`

**Request Body:**
```json
{
  "productName": "Wireless Headphones",
  "brand": "AudioTech",
  "category": "Electronics",
  "subCategory": "Audio",
  "price": 5299,
  "stock": 50,
  "details": "High-quality wireless headphones with noise cancellation"
}
```

**Response (200 OK):**
```json
{
  "message": "New product has been added successfully",
  "productId": "PROD-123456"
}
```

**Error Responses:**
- `403 Forbidden` — Store belongs to a different seller or store not verified

---

#### Get Products by Filters
```
GET /exp/products?brand=AudioTech&category=Electronics&minPrice=5000&maxPrice=10000&inStock=true
```

**Query Parameters (all optional):**
- `brand` — Brand name
- `category` — Product category
- `subCategory` — Product sub-category
- `minPrice` — Minimum price
- `maxPrice` — Maximum price
- `inStock` — `true` or `false`
- `minRatings` — Minimum rating
- `storeName` — Store name

**Response (200 OK):**
```json
{
  "totalProducts": 25,
  "inStockCount": 20,
  "notInStockCount": 5,
  "avgPrice": 7599.5,
  "products": {
    "inStock": [
      {
        "productId": "PROD-123456",
        "productName": "Wireless Headphones",
        "brand": "AudioTech",
        "price": 5299,
        "category": "Electronics",
        "subCategory": "Audio",
        "rating": 4.5,
        "noOfReviews": 120
      }
    ],
    "notInStock": []
  }
}
```

---

#### Get Product Details by ID
```
GET /exp/products/{productId}
```

**Response (200 OK):**
```json
{
  "productId": "PROD-123456",
  "productName": "Wireless Headphones",
  "brand": "AudioTech",
  "price": 5299,
  "stock": 50,
  "category": "Electronics",
  "subCategory": "Audio",
  "rating": 4.5,
  "noOfReviews": 120,
  "details": "High-quality wireless headphones with noise cancellation",
  "availability": true
}
```

---

#### Get Products by Store
```
GET /exp/stores/{storeId}/products
```

**Response (200 OK):**
```json
{
  "storeId": "ST-7ef50f",
  "storeName": "Electronics Plus",
  "noOfProducts": 15,
  "products": {
    "inStock": [
      {
        "productId": "PROD-123456",
        "productName": "Wireless Headphones",
        "price": 5299,
        "stock": 50
      }
    ],
    "OutOfStock": []
  },
  "meta": {
    "avgPrice": 6500,
    "inStockCount": 12,
    "outOfStock": 3
  }
}
```

---

#### Update Product Details
```
PATCH /exp/products/{productId}
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Required Role:** `seller`

**Request Body:**
```json
{
  "productName": "Premium Wireless Headphones",
  "price": 5999,
  "details": "Updated description"
}
```

**Response (200 OK):**
```json
{
  "message": "Product data successfully updated"
}
```

---

#### Restock Product
```
PATCH /exp/products/{productId}/restock
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Required Role:** `seller`

**Request Body:**
```json
{
  "quantity": 100
}
```

**Response (200 OK):**
```json
{
  "Message": "Successfully updated stock"
}
```

---

#### Delete Product
```
DELETE /exp/products/{productId}
Authorization: Bearer <jwt-token>
```

**Required Role:** `seller`

**Response (200 OK):**
```json
{
  "message": "Product successfully deleted."
}
```

---

### Cart Management

#### Add Product to Cart
```
POST /exp/carts
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Required Role:** `buyer`

**Request Body:**
```json
{
  "productId": "PROD-123456",
  "quantity": 2
}
```

**Response (200 OK):**
```json
{
  "message": "Product added to the cart",
  "cartItemId": "CART-789012"
}
```

Or if product already in cart:
```json
{
  "message": "Quantity of the product updated",
  "cartItemId": "CART-789012"
}
```

---

#### Get Cart Items
```
GET /exp/carts
Authorization: Bearer <jwt-token>
```

**Required Role:** `buyer`

**Response (200 OK):**
```json
{
  "productCount": 3,
  "totalItems": 5,
  "products": [
    {
      "productId": "PROD-123456",
      "productName": "Wireless Headphones",
      "price": 5299,
      "inCartQuantity": 2
    }
  ],
  "totalCartValue": 10598
}
```

---

#### Update Cart Item Quantity
```
PATCH /exp/carts/{cartItemId}/quantity
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Required Role:** `buyer`

**Request Body:**
```json
{
  "quantity": 5
}
```

**Response (200 OK):**
```json
{
  "message": "Quantity successfully updated",
  "cartItemId": "CART-789012",
  "finalQuantity": 5
}
```

---

#### Remove Product from Cart
```
DELETE /exp/carts/{cartItemId}
Authorization: Bearer <jwt-token>
```

**Required Role:** `buyer`

**Response (200 OK):**
```json
{
  "message": "Product removed from the cart",
  "cartItemId": "CART-789012"
}
```

---

#### Clear Entire Cart
```
DELETE /exp/carts
Authorization: Bearer <jwt-token>
```

**Required Role:** `buyer`

**Response (200 OK):**
```json
{
  "message": "Your cart is empty now",
  "userId": "USER123"
}
```

---

### Order Management

#### Place Order
```
POST /exp/orders
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Required Role:** `buyer`

**Request Body:**
```json
{
  "productId": "PROD-123456",
  "quantity": 1,
  "deliveryPincode": "411001",
  "paymentMethod": "card",
  "paymentDetails": {
    "cardNumber": "4111111111111111",
    "cvv": "123",
    "expiryDate": "12/25"
  }
}
```

**Response (200 OK):**
```json
{
  "orderId": "ORD-654321",
  "expDeliveryDate": "2024-09-15",
  "totalOrderValue": 5299,
  "orderStatus": "confirmed",
  "transactionId": "TXN-789456",
  "paymentStatus": "successful",
  "listOfItems": [
    {
      "productId": "PROD-123456",
      "productName": "Wireless Headphones",
      "quantity": 1,
      "priceAtPurchase": 5299
    }
  ]
}
```

**Error Responses:**
- `401 Unauthorized` — Invalid JWT token
- `403 Forbidden` — Wrong role (only buyers can place orders)
- `422 Unprocessable Entity` — Stock unavailable, payment failed, delivery not available, or empty cart

---

#### Get Orders (Buyer)
```
GET /exp/orders/buyer
Authorization: Bearer <jwt-token>
```

**Required Role:** `buyer`

**Response (200 OK):**
```json
[
  {
    "orderId": "ORD-654321",
    "orderStatus": "confirmed",
    "expDeliveryDate": "2024-09-15",
    "paymentStatus": "successful",
    "totalOrderValue": 5299,
    "transactionId": "TXN-789456",
    "deliveryPincode": "411001",
    "items": [
      {
        "orderItemId": "ORDI-123",
        "productId": "PROD-123456",
        "productName": "Wireless Headphones",
        "quantity": 1,
        "priceAtPurchase": 5299
      }
    ]
  }
]
```

---

#### Get Orders (Seller)
```
GET /exp/orders/seller
Authorization: Bearer <jwt-token>
```

**Required Role:** `seller`

**Response (200 OK):**
```json
[
  {
    "storeName": "Electronics Plus",
    "storeId": "ST-7ef50f",
    "accountHolderName": "John Doe",
    "orderItems": [
      {
        "orderItemsId": "ORDI-123",
        "productId": "PROD-123456",
        "productName": "Wireless Headphones",
        "quantity": 1,
        "priceAtPurchase": 5299
      }
    ]
  }
]
```

---

#### Get Order by ID
```
GET /exp/orders/{orderId}
Authorization: Bearer <jwt-token>
```

**Required Role:** `buyer`

**Response (200 OK):**
```json
{
  "orderId": "ORD-654321",
  "orderStatus": "confirmed",
  "expDeliveryDate": "2024-09-15",
  "paymentStatus": "successful",
  "totalOrderValue": 5299,
  "transactionId": "TXN-789456",
  "deliveryPincode": "411001",
  "orderItems": [
    {
      "productId": "PROD-123456",
      "productName": "Wireless Headphones",
      "quantity": 1,
      "priceAtPurchase": 5299
    }
  ]
}
```

---

#### Cancel Order
```
PATCH /exp/orders/{orderId}/cancellation
Authorization: Bearer <jwt-token>
```

**Required Role:** `buyer`

**Response (200 OK):**
```json
{
  "message": "Order cancelled",
  "orderId": "ORD-654321"
}
```

---

### Admin Setup

#### Setup Admin Account
```
POST /exp/admin/setup
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": "admin@example.com",
  "password": "adminPassword123",
  "firstName": "Admin",
  "lastName": "User"
}
```

**Response (200 OK):**
```json
{
  "Message": "Admin setup is completed successfully",
  "userId": "ADMIN001"
}
```

**Error Responses:**
- `403 Forbidden` — Admin already registered

---

## Error Handling

The API returns standardized error responses with appropriate HTTP status codes:

| Status Code | Description |
|---|---|
| `200 OK` | Successful request |
| `201 Created` | Resource created successfully |
| `400 Bad Request` | Invalid request format or missing required fields |
| `401 Unauthorized` | Missing or invalid JWT token |
| `403 Forbidden` | User lacks required role for this operation |
| `404 Not Found` | Resource not found |
| `405 Method Not Allowed` | HTTP method not supported for this endpoint |
| `406 Not Acceptable` | Content type not acceptable |
| `409 Conflict` | Resource already exists (e.g., duplicate email) |
| `415 Unsupported Media Type` | Request body media type not supported |
| `422 Unprocessable Entity` | Semantic error (e.g., out of stock, invalid delivery pincode) |
| `500 Internal Server Error` | Unexpected server error |
| `501 Not Implemented` | Feature not yet implemented |

**Error Response Format:**
```json
{
  "message": "Descriptive error message",
  "details": "Additional context (if applicable)"
}
```

---

## Role-Based Access Control

The Experience API enforces role-based access control on secured endpoints:

| Role | Permissions |
|---|---|
| **Admin** | Verify/reject store registrations, view all stores by verification status |
| **Seller** | Create stores, add/update/delete products, restock inventory, view seller orders |
| **Buyer** | Browse products, manage cart, place orders, cancel orders, view order history |

**Anonymous** (no JWT required):
- User registration
- User login
- Admin setup
- Browse product catalog (GET `/exp/products`)

---

## API Console

The API Console is available at:

```
http://<host>:<http.port>/console/
```

You can explore all endpoints, view schemas, and test API calls interactively from the console.

---

---

## Logging

The Experience API logs key events at `INFO` level:

- Incoming requests (endpoint, operation)
- Calls to the Process API
- Authorization failures
- Errors and exceptions

Logs are output to the Mule Runtime console and can be redirected to a file via Mule configuration.

---

## Testing

### Testing with Postman

Use Postman or the built-in API Console (available at `/console/` after deployment) to test all endpoints. Set the `Authorization` header to `Bearer <your-jwt-token>` for secured endpoints.

---

## Deployment

1. Right-click on the project in **Package Explorer**
2. Select **Run As** → **Mule Application**
3. The embedded Mule Runtime will start and deploy the application
4. Access the API Console at `http://localhost:<http.port>/console/`

---

## Troubleshooting

### JWT Token Expired
- **Error:** "Please provide valid JWT token"
- **Solution:** Call the login endpoint again to obtain a fresh token

### Store Verification Required
- **Error:** "Your store is not verified yet"
- **Solution:** Admin must verify the store via `PATCH /exp/stores/{storeId}/verification`

### Process API Connection Failed
- **Error:** "Connection refused" or "Host unreachable"
- **Solution:** Ensure Process API is running and `http.request.host` and `http.request.port` are correctly configured

### Insufficient Role Permissions
- **Error:** "You are not allowed to access this resource"
- **Solution:** Verify the JWT token contains the correct role and the endpoint requires that role

---

## Related Documentation

- **RAML Specification:** `ecommercesuiteexperienceapi2.raml`
- **API Console:** Available at `/console/` path after deployment
- **Main Project Repository:** [Link to root repository] — Contains overall architecture, deployment guide, and project scope

---

## Support

For issues, questions, or contributions, please refer to the main project repository.

---

**Last Updated:** September 2026  
**Version:** 1.0  
**Maintained by:** [Your Name/Team]
