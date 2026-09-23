%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "orderId": "OD-006e92",
  "expDeliveryDate": (now() as Date) ++ "P4D" as Period,
  "totalOrderValue": 125000,
  "orderStatus": "confirmed",
  "transactionId": "PAY-2668650e",
  "paymentStatus": "success",
  "listOfItems": [
    {
      "orderItemId": "OI-48dea0",
      "productId": "P-a8fb8c",
      "quantity": 1,
      "orderId": "OD-006e92",
      "priceAtPurchase": 125000,
      "productName": "S25 ultra"
    }
  ]
})