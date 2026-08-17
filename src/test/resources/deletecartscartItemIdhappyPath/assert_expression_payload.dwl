%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "message": "Product removed from the cart",
  "cartItemId": "CT-2d4518"
})