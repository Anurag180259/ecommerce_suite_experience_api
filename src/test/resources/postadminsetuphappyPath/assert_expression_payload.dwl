%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "Message": "Admin setup is completed successfully",
  "userId": "A-ccceda"
})