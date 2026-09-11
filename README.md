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

For the complete system architecture, deployment topology, and AI integration details, refer to the [main project repository](https://github.com/Anurag180259/ecommerce_suite).

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
git clone https://github.com/Anurag180259/ecommerce_suite_experience_api.git
cd ecommerce_suite_experience_api
```

### 2. Configure Properties

Create a `configuration.properties` file in `src/main/resources/`:

1. Right-click on `src/main/resources/` folder
2. Select **New** → **File**
3. Name it `configuration.properties`
4. Copy the content from [`configuration.example.properties`](./src/main/resources/configuration.example.properties)
5. Update the values according to your environment

Refer to [`configuration.example.properties`](./src/main/resources/configuration.example.properties) for the complete structure and required properties.

### 3. Build the Project

In Anypoint Studio:

1. Right-click on the project in **Package Explorer**
2. Select **Run As** → **Mule Application**

The project will automatically build and deploy to the embedded Mule Runtime.

### 4. Verify Deployment

Once deployed, the API will be running. Access the API Console:

```
http://localhost:<port>/console/
```

Replace `<port>` with your configured `http.port` value.

---

## Authentication

### JWT (JSON Web Token)

All secured endpoints require JWT authentication via the `Authorization` header.

**Token Structure:**
```json
{
  "userId": "B-a7d2c1",
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
  "userId": "B-a7d2c1"
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

### Quick Reference

| Method | Endpoint | Auth Required | Role | Description |
|---|---|---|---|---|
| `POST` | `/exp/auth/register` | No | — | Register a new user (buyer or seller) |
| `POST` | `/exp/auth/login` | No | — | Login and receive a JWT token |
| `POST` | `/exp/admin/setup` | No | — | One-time admin account setup |
| `POST` | `/exp/stores` | Yes | Seller | Create a new store |
| `PATCH` | `/exp/stores/{storeId}/verification` | Yes | Admin | Update store verification status |
| `GET` | `/exp/stores/admin` | Yes | Admin | Get stores filtered by verification status |
| `GET` | `/exp/stores/seller` | Yes | Seller | Get all stores owned by the authenticated seller |
| `POST` | `/exp/stores/{storeId}/products` | Yes | Seller | Add a new product to a store |
| `GET` | `/exp/stores/{storeId}/products` | No | — | Get all products in a store |
| `GET` | `/exp/products` | No | — | Get products with optional filters |
| `GET` | `/exp/products/{productId}` | No | — | Get a single product by ID |
| `PATCH` | `/exp/products/{productId}` | Yes | Seller | Update product details |
| `PATCH` | `/exp/products/{productId}/restock` | Yes | Seller | Update product stock quantity |
| `DELETE` | `/exp/products/{productId}` | Yes | Seller | Delete a product |
| `POST` | `/exp/carts` | Yes | Buyer | Add a product to cart |
| `GET` | `/exp/carts` | Yes | Buyer | Get all items in the cart |
| `PATCH` | `/exp/carts/{cartItemId}/quantity` | Yes | Buyer | Update quantity of a cart item |
| `DELETE` | `/exp/carts/{cartItemId}` | Yes | Buyer | Remove a specific item from cart |
| `DELETE` | `/exp/carts` | Yes | Buyer | Clear the entire cart |
| `POST` | `/exp/orders` | Yes | Buyer | Place an order |
| `GET` | `/exp/orders/buyer` | Yes | Buyer | Get all orders for the authenticated buyer |
| `GET` | `/exp/orders/seller` | Yes | Seller | Get all orders for the authenticated seller |
| `GET` | `/exp/orders/{orderId}` | Yes | Buyer | Get a specific order by ID |
| `PATCH` | `/exp/orders/{orderId}/cancellation` | Yes | Buyer | Cancel an order |

---

### Authentication

#### Register User
```
POST /exp/auth/register
Content-Type: application/json
```

**Request Body:**
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "newuser@example.com",
  "password": "securePassword123",
  "city": "Pune",
  "role": "buyer",
  "phoneNo": "9876543210"
}
```

> `phoneNo` is optional. `role` must be either `seller` or `buyer`.

**Response (200 OK):**
```json
{
  "message": "Thank you for registering into our ECommerce Website",
  "userId": "B-a7d2c1",
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
  "userId": "B-a7d2c1"
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
  "storeId": "ST-4f2a1c"
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
      "storeId": "ST-4f2a1c",
      "storeName": "Electronics Plus",
      "gstin": "18AABCR5055K1Z0",
      "accountNumber": "1234567890123456",
      "accountHolderName": "John Doe",
      "userId": "S-78a3c4"
    }
  ]
}
```

> The response is grouped by the `verificationStatus` value passed as a query parameter. Fields inside each store object are returned directly from the Database API.

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
    "storeId": "ST-4f2a1c",
    "storeName": "Electronics Plus",
    "gstin": "18AABCR5055K1Z0",
    "accountNumber": "1234567890123456",
    "accountHolderName": "John Doe",
    "verificationStatus": "verified",
    "userId": "S-78a3c4"
  }
]
```

> Fields are returned directly from the Database API with no transformation at the Process API layer.

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

> `subCategory` is optional. `details` has a maximum length of 255 characters.

**Response (200 OK):**
```json
{
  "message": "New product has been added successfully",
  "productId": "P-a4b231"
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
        "storeName": "Electronics Plus",
        "productName": "Wireless Headphones",
        "brand": "AudioTech",
        "productId": "P-a4b231",
        "storeId": "ST-4f2a1c",
        "stock": 50,
        "price": 5299,
        "category": "Electronics",
        "subCategory": "Audio",
        "rating": 0.0,
        "noOfReviews": 0,
        "details": "High-quality wireless headphones with noise cancellation"
      }
    ],
    "notInStock": []
  }
}
```

> Products are grouped by stock status. `storeName` is included because the stored procedure joins `storeData` with `products`.

---

#### Get Product Details by ID
```
GET /exp/products/{productId}
```

**Response (200 OK):**
```json
{
  "productId": "P-a4b231",
  "productName": "Wireless Headphones",
  "brand": "AudioTech",
  "price": 5299,
  "category": "Electronics",
  "subCategory": "Audio",
  "details": "High-quality wireless headphones with noise cancellation",
  "storeId": "ST-4f2a1c",
  "rating": 0.0,
  "noOfReviews": 0,
  "availability": true
}
```

> `stock` is not returned directly. Instead, `availability` is a computed boolean — `true` if stock is greater than 0, `false` otherwise.

---

#### Get Products by Store
```
GET /exp/stores/{storeId}/products
```

**Response (200 OK):**
```json
{
  "storeId": "ST-4f2a1c",
  "storeName": null,
  "noOfProducts": 15,
  "products": {
    "inStock": [
      {
        "productId": "P-a4b231",
        "productName": "Wireless Headphones",
        "brand": "AudioTech",
        "category": "Electronics",
        "subCategory": "Audio",
        "price": 5299,
        "stock": 50,
        "rating": 0.0,
        "noOfReviews": 0,
        "details": "High-quality wireless headphones with noise cancellation"
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

> `storeName` is `null` because the underlying query is `select * from products` which does not join `storeData`. Products are grouped by stock status.

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
  "productId": "P-a4b231",
  "quantity": 2
}
```

**Response (200 OK):**
```json
{
  "message": "Product added to the cart",
  "cartItemId": "CT-a3f9b2"
}
```

Or if product already in cart:
```json
{
  "message": "Quantity of the product updated",
  "cartItemId": "CT-a3f9b2"
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
      "productId": "P-a4b231",
      "productName": "Wireless Headphones",
      "brand": "AudioTech",
      "category": "Electronics",
      "subCategory": "Audio",
      "price": 5299,
      "stock": 50,
      "details": "High-quality wireless headphones with noise cancellation",
      "inCartQuantity": 2
    }
  ],
  "totalCartValue": 10598
}
```

> `inCartQuantity` is the quantity in the cart. `storeId` is stripped from product details at the Experience API layer. `totalCartValue` is computed as the sum of `inCartQuantity * price` for all products.

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
  "cartItemId": "CT-a3f9b2",
  "finalQuantity": 5
}
```

> `finalQuantity` reflects the absolute quantity value set by the request.

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
  "cartItemId": "CT-a3f9b2"
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
  "userId": "B-a7d2c1"
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
  "deliveryPincode": "100001",
  "product": {
    "productId": "P-a4b231",
    "quantity": 1
  }
}
```

> `product` is optional. If omitted, the order is placed for all items currently in the buyer's cart. `deliveryPincode` must be a 6-digit number. `productId` must follow the format `P-XXXXXX` (hex). `quantity` minimum is 1.

> **Note:** Delivery is currently only supported for the following pincodes: `100001`, `100002`, `100003`. Any other pincode will return a `422` with reason `notDeliverable`. This is a deliberate scope limitation.

**Response (200 OK):**
```json
{
  "orderId": "OD-7c4e1a",
  "expDeliveryDate": "2026-09-11",
  "totalOrderValue": 5299,
  "orderStatus": "confirmed",
  "transactionId": "PAY-3f1a2b4c",
  "paymentStatus": "success",
  "listOfItems": [
    {
      "orderItemId": "OI-3a1b2c",
      "productId": "P-a4b231",
      "productName": "Wireless Headphones",
      "quantity": 1,
      "priceAtPurchase": 5299
    }
  ]
}
```

> `orderStatus` can be `confirmed` or `pending` depending on the mock payment gateway response. `paymentStatus` can be `success`, `failure`, or `pending` — the mock payment gateway uses round-robin to simulate these outcomes. `expDeliveryDate` is computed by adding the delivery period to the current date.

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
    "orderId": "OD-7c4e1a",
    "orderStatus": "confirmed",
    "expDeliveryDate": "2026-09-11",
    "paymentStatus": "success",
    "totalOrderValue": 5299,
    "transactionId": "PAY-3f1a2b4c",
    "deliveryPincode": "100001",
    "items": [
      {
        "orderItemId": "OI-3a1b2c",
        "productId": "P-a4b231",
        "productName": "Wireless Headphones",
        "quantity": 1,
        "priceAtPurchase": 5299
      }
    ]
  }
]
```

> The Exp API maps only `orderId`, `orderStatus`, `expDeliveryDate`, `paymentStatus`, `totalOrderValue`, `transactionId`, `deliveryPincode`, and `items`. `orderDate` and `userId` are not included. `productName` is appended by the Process API.

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
    "storeId": "ST-4f2a1c",
    "accountHolderName": "John Doe",
    "orderItems": [
      {
        "orderItemsId": "OI-3a1b2c",
        "productId": "P-a4b231",
        "productName": "Wireless Headphones",
        "quantity": 1,
        "priceAtPurchase": 5299
      }
    ]
  }
]
```

> The Exp API maps only `storeName`, `storeId`, `accountHolderName`, and `orderItems` from the full store object. `productName` is appended by the Process API.

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
  "orderId": "OD-7c4e1a",
  "orderDate": "2026-09-07",
  "orderStatus": "confirmed",
  "totalOrderValue": 5299,
  "deliveryPincode": "100001",
  "expDeliveryDate": "2026-09-11",
  "transactionId": "PAY-3f1a2b4c",
  "paymentStatus": "success",
  "orderItems": [
    {
      "orderItemId": "OI-3a1b2c",
      "orderId": "OD-7c4e1a",
      "productId": "P-a4b231",
      "quantity": 1,
      "priceAtPurchase": 5299
    }
  ]
}
```

> `userId` is stripped from the order and `storeId` is stripped from each order item at the Experience API layer.

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
  "orderId": "OD-7c4e1a"
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
  "firstName": "Admin",
  "lastName": "User",
  "email": "admin@example.com",
  "password": "adminPassword123",
  "city": "Pune",
  "phoneNo": "9876543210"
}
```

> `phoneNo` is optional.

**Response (200 OK):**
```json
{
  "Message": "Admin setup is completed successfully",
  "userId": "A-1c3d2f"
}
```

**Error Responses:**
- `403 Forbidden` — Admin already registered

> **Note:** This endpoint is protected by a Basic Authentication policy enforced at the API Manager level when deployed on CloudHub. No auth header is required when running locally. Basic Auth was chosen deliberately to keep the setup simple — the recommended approach would be Client ID enforcement via API Manager, but that requires a separate connected app and credential request flow.

---

## Error Handling

The API returns standardized error responses with appropriate HTTP status codes:

| Status Code | Description |
|---|---|
| `200 OK` | Successful request |
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
  "message": "Descriptive error message"
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
- Admin setup (protected by Basic Auth policy on CloudHub — no auth needed for local deployment)
- Browse product catalog (`GET /exp/products`)
- `GET /exp/products/{productId}`
- `GET /exp/stores/{storeId}/products`

---

## API Console

The API Console is available at:

```
http://<host>:<http.port>/console/
```

You can explore all endpoints, view schemas, and test API calls interactively from the console.

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

### Order Not Deliverable
- **Error:** "order cannot be delivered at this pincode"
- **Solution:** Use one of the supported delivery pincodes: `100001`, `100002`, or `100003`

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

- **RAML Specification:** [`ecommercesuiteexperienceapi2.raml`](./src/main/resources/api)
- **API Console:** Available at `/console/` path after deployment
- **Main Project Repository:** [ecommerce_suite](https://github.com/Anurag180259/ecommerce_suite) — Contains overall architecture, deployment guide, and project scope

---

## Support

For issues, questions, or contributions, please refer to the main project repository.

---

**Last Updated:** September 2026  
**Version:** 1.0  
**Maintained by:** Anurag Ninave
