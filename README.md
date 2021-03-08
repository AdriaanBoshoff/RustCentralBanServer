# RustCentralBanServer
Central Banning Server for rust servers and developers.

## Adding and removing a Ban
You can use the api below or you can use the following commands:  (-1 = permanent).
* Add ban - `addban <steamid> <reason> <unixtimestamp>` Example: `addban 76561197960287930 "This is a test ban" -1`.
* Remove Ban - `removeban <steamid>` Example: `removeban 76561197960287930`.

## Setting up with your Rust Servers
This is really quick and easy to setup. Just follow the steps below and everything will work. For this tutorial lets pretend the central ban server is running on the same machines as your Rust Servers. You will see refernces to `localhost`. This should be the IP address of your remote machine if you do end up running the central ban server on another machine.
<br>
1. Download the latest build from releases area.
2. Extract it into a folder.
3. Run the file that you extracted and close it.
4. You will notice a `settings.ini` file got generated. Edit it and change the `apiKey` to whatever you want. This is like your password to use the central ban server api. Don't share it. Close and save.
5. Run the application again and type `start`. It will then tell you that the HTTP server has been started.
6. Now that the central ban server has been started you will need to point your rust servers to the ban server. You can do this by issuing your rust server with the following command:
```server.bansServerEndpoint "http://localhost:2855/api/rustBans/"```
Then type the following to make sure the server saves it:
```server.writecfg```
7. You're done!. To add a ban to the central ban server you can see the commands above. If you want more options such as what should your server do when when the ban server fails please refer to the rust docs: https://wiki.facepunch.com/rust/centralized-banning#faq

# For Developers
This is for external developers that want to uses this central banning system for their own needs.

## Testing
The ban server has a special "ID" to test if everything is working as it should. Do a ban request on `GET /api/rustBans/test`. You should get a normal Get ban request data.

## Getting a ban
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

## Adding a ban
Perform a `Post` request to the following path with the body below: `POST /api/addRustBans`

### Body
```json
{
    "apiKey": "ChangeMe1",
    "steamId": "76561197960287930",
    "reason": "This is a test reason",
    "expiryDate": -1
}
```

### Reponse Codes
You will recieve the following response codes:
* `200` - The ban has been added.
* `403` - Your apiKey does not match what you set it to be in your settings file.
* `500` - An internal server error. See console for details.

## Icons
* <a target="_blank" href="https://icons8.com/icons/set/centralized-network">Centralized Network icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>