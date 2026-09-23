%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "message": "Order cancelled",
  "orderId": "OD-006e92"
})