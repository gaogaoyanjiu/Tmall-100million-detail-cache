local uri_args = ngx.req.get_uri_args()
local productId = uri_args["productId"]

local host = {"192.168.1.105", "192.168.1.106"}
local hash = ngx.crc32_long(productId)
hash = (hash % 2) + 1  
backend = "http://"..host[hash]

local method = uri_args["requestPath"]
local requestBody = "/"..method.."?productId="..productId

local http = require("resty.http")  
local httpc = http.new()  

local resp, err = httpc:request_uri(backend, {  
    method = "GET",  
    path = requestBody
})

if not resp then  
    ngx.say("request error :", err)  
    return  
end

ngx.say(resp.body)  
  
httpc:close() 