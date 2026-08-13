%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "message": "Your store has been created successfully",
  "storeId": "ST-101da4"
})