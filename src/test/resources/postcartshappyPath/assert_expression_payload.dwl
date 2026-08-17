%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "message": "Product added to the cart",
  "cartItemId": "CT-dd762d"
})