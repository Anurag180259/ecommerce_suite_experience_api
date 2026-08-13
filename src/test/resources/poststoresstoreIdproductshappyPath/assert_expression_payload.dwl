%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "message": "New product has been added successfully",
  "productId": "P-9b8bc5"
})