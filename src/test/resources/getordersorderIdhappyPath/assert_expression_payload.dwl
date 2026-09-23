%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "orderId": "OD-006e92",
  "orderDate": "2026-09-07",
  "orderStatus": "confirmed",
  "totalOrderValue": 125000,
  "deliveryPincode": "100001",
  "expDeliveryDate": "2026-09-11",
  "transactionId": "PAY-2668650e",
  "paymentStatus": "success",
  "orderItems": [
    {
      "orderItemId": "OI-ad1756",
      "orderId": "OD-006e92",
      "productId": "P-a8fb8c",
      "priceAtPurchase": 125000,
      "quantity": 1
    }
  ]
})