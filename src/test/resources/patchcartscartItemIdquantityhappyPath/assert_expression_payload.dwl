%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "message": "Quantity successfully updated",
  "cartItemId": "CT-b6027a",
  "finalQuantity": 4
})