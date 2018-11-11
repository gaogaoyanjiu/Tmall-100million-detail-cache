server {
	listen    80;

	location /hello {
		content_by_lua_block {
			ngx.req.read_body()
			local args, err = ngx.req.get_uri_args()

			local http = require "resty.http"   -- ①
			local httpc = http.new()
			local res, err = httpc:request_uri( -- ②
				"http://127.0.0.1:81/spe_md5",
					{
					method = "POST",
					body = args.data,
				  }
			)

			if 200 ~= res.status then
				ngx.exit(res.status)
			end

			if args.key == res.body then
				ngx.say("valid request")
			else
				ngx.say("invalid request")
			end
		}
	}
}

server {
	listen    81;

	location /spe_md5 {
		content_by_lua_block {
			ngx.req.read_body()
			local data = ngx.req.get_body_data()
			ngx.print(ngx.md5(data .. "*&^%$#$^&kjtrKUYG"))
		}
	}
}