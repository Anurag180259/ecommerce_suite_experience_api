%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo([
  {
    "storeName": "Tom electronics",
    "storeId": "ST-0143d3",
    "accountHolderName": "Tom Cruise",
    "orderItems": [
      {
        "orderItemsId": "OI-ad1756",
        "productId": "P-a8fb8c",
        "priceAtPurchase": 125000,
        "quantity": 1,
        "productName": "S25 ultra"
      }
    ]
  }
])