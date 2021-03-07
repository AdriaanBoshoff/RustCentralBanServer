# RustCentralBanServer
Central Banning Server for rust servers and developers.

## Setting up with your Rust Server
Example: ```server.bansServerEndpoint "https://contoso.com/api/rustBans/"```.
<br>
You can follow the steps Facepunch provided in order to set this up with your rust: https://wiki.facepunch.com/rust/centralized-banning#howdoiuseit

## For Developers
This is for external developers that want to uses this central banning system for their own needs.

### Testing
The ban server has a special "ID" to test if everything is working as it should. Do a ban request on `GET /api/rustBans/test`. You should get a normal Get ban request data.

### Getting a ban
Perform a `Get` request to the following path adding the SteamID64 to the end: `GET /api/rustBans/{steamID64}`

#### Response
Status Code: `200`

Body:
```json
{
  "steamId": "76561197960287930",
  "reason": "definitely not cheating",
  "expiryDate": 1608611830
}
```

### Adding a ban
Perform a `Post` request to the following path with the body below: `POST /api/addRustBans`

#### Body
```json
{
    "apiKey": "ChangeMe1",
    "steamId": "76561197960287930",
    "reason": "This is a test reason",
    "expiryDate": -1
}
```

#### Reponse Codes
You will recieve the following response codes:
* `200` - The ban has been added.
* `403` - Your apiKey does not match what you set it to be in your settings file.
* `500` - An internal server error. See console for details.