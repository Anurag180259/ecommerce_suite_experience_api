%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "message": "Your cart is empty now",
  "userId": "B-dc4c25"
})