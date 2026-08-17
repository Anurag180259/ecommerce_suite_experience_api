%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "productCount": 3,
  "totalItems": 8,
  "products": [
    {
      "productName": "S25 ultra",
      "productId": "P-11c443",
      "brand": "Samsung",
      "stock": 34,
      "price": 153000,
      "category": "Electronics",
      "subCategory": "smartphone",
      "rating": 0,
      "noOfReviews": 0,
      "details": "Best android phone in the market. In built s-pen",
      "inCartQuantity": 1
    },
    {
      "productName": "Thermosteel bottle:736",
      "productId": "P-ca5bc4",
      "brand": "Milton",
      "stock": 80,
      "price": 800,
      "category": "Daily essentials",
      "subCategory": "Bottle",
      "rating": 0,
      "noOfReviews": 0,
      "details": "This is a very good branded thermosteel bottle. 1 Ltr capacity, keeps water cool and warm for 24 hrs",
      "inCartQuantity": 5
    },
    {
      "productName": "Ethnic Saree:677",
      "productId": "P-73724c",
      "brand": "Sabyasachi",
      "stock": 25,
      "price": 5300,
      "category": "Clothes",
      "subCategory": "saree",
      "rating": 0,
      "noOfReviews": 0,
      "details": "This is an Ethnic saree. Great for festive season and traditional functions",
      "inCartQuantity": 2
    }
  ],
  "totalCartValue": 167600
})