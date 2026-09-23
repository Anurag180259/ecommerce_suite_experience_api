%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "storeId": "ST-179ca4",
  "message": "This store doesnt have any products or the store with this storeId doesn't exist"
})