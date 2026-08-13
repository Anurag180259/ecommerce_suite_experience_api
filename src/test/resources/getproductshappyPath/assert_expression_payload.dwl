%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "totalProducts": 0,
  "inStockCount": null,
  "notInStockCount": null,
  "avgPrice": null,
  "products": {}
})