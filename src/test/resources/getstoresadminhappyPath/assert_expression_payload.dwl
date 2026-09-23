%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "verified": [
    {
      "storeName": "Tom electronics",
      "storeId": "ST-0143d3",
      "accountNumber": "8957946325",
      "gstin": "24GIOCD7483H9Z9",
      "accountHolderName": "Tom Cruise",
      "userId": "S-fc1493"
    },
    {
      "storeName": "Deepika Fashion",
      "storeId": "ST-179ca4",
      "accountNumber": "1757946325",
      "gstin": "24IOOCD7483H9Z9",
      "accountHolderName": "Deepkia Padukone",
      "userId": "S-62bd2d"
    }
  ]
})