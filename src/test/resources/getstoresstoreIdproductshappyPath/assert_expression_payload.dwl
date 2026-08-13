%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "storeId": "ST-a715c5",
  "storeName": "Neha electronics",
  "noOfProducts": 1,
  "products": {
    "inStock": [
      {
        "productId": "P-11c443",
        "productName": "S25 ultra",
        "brand": "Samsung",
        "category": "Electronics",
        "subCategory": "smartphone",
        "price": 153000,
        "stock": 34,
        "rating": 0,
        "noOfReviews": 0,
        "details": "Best android phone in the market. In built s-pen"
      }
    ]
  },
  "meta": {
    "avgPrice": 153000,
    "inStockCount": 1,
    "outOfStock": null
  }
})