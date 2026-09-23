%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo([
  {
    "orderId": "OD-006e92",
    "orderStatus": "confirmed",
    "expDeliveryDate": "2026-09-11",
    "paymentStatus": "success",
    "totalOrderValue": 125000,
    "transactionId": "PAY-2668650e",
    "deliveryPincode": "100001",
    "items": [
      {
        "orderItemId": "OI-ad1756",
        "productId": "P-a8fb8c",
        "quantity": 1,
        "priceAtPurchase": 125000,
        "productName": "S25 ultra"
      }
    ]
  }
])