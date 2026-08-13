%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "productName": "Ethnic Saree:677",
  "productId": "P-73724c",
  "storeId": "ST-7ef50f",
  "brand": "sabyasachi",
  "price": 5300,
  "category": "Clothes",
  "subCategory": "saree",
  "rating": 0,
  "noOfReviews": 0,
  "details": "This is an Ethnic saree. Great for festive season and traditional functions",
  "availability": true
})