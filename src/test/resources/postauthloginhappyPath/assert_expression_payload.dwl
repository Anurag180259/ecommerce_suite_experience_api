%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "message": "Login Successful",
  "jwt": "eyJhbGciOiAiSFMyNTYiLCJ0eXAiOiAiSldUIn0.eyJ1c2VySWQiOiAiQS0yNzgwZDUiLCJpc3MiOiAiZWNvbW1lcmNlX3N1aXRlX2JhY2tlbmQiLCJhdWQiOiAiZWNvbW1lcmNlX2FwaSIsImlhdCI6IDE3ODYxOTgxMDYsImV4cCI6IDE3ODYyMDE3MDYsInJvbGUiOiAiYWRtaW4ifQ.8IogZ1TW9ZH0cevU161q_XgLS4YArkG42KTq2Yw0yyc",
  "userId": "A-2780d5"
})