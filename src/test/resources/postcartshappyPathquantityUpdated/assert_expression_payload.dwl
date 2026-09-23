%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "message": "Quantity of the product updated",
  "cartItemId": "CT-fa64e6"
})