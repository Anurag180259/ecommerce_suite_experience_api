%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "message": "Thank you for registering into our ECommerce Website",
  "userId": "S-15d32e",
  "jwt": "eyJhbGciOiAiSFMyNTYiLCJ0eXAiOiAiSldUIn0.eyJ1c2VySWQiOiAiUy0xNWQzMmUiLCJpc3MiOiAiZWNvbW1lcmNlX3N1aXRlX2JhY2tlbmQiLCJhdWQiOiAiZWNvbW1lcmNlX2FwaSIsImlhdCI6IDE3ODYyNDkzMjgsImV4cCI6IDE3ODYyNTI5MjgsInJvbGUiOiAic2VsbGVyIn0.HbQQcBWM--ME0_pEQs3gviz2jp68lNbe4AahGM3Cp_0"
})