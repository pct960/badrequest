-- Copyright (C) Kong Inc.

local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local strip = require("pl.stringx").strip

local BadRequestHandler = BasePlugin:extend()

BadRequestHandler.PRIORITY = 920
BadRequestHandler.VERSION = "0.1.0-1"

--function table_print (tt, indent, done)
--  done = done or {}
--  indent = indent or 0
--  if type(tt) == "table" then
--    local sb = {}
--    for key, value in pairs (tt) do
--      table.insert(sb, string.rep (" ", indent)) -- indent it
--      if type (value) == "table" and not done [value] then
--        done [value] = true
--        table.insert(sb, "{\n");
--        table.insert(sb, table_print (value, indent + 2, done))
--        table.insert(sb, string.rep (" ", indent)) -- indent it
--        table.insert(sb, "}\n");
--      elseif "number" == type(key) then
--        table.insert(sb, string.format("\"%s\"\n", tostring(value)))
--      else
--        table.insert(sb, string.format(
--            "%s = \"%s\"\n", tostring (key), tostring(value)))
--       end
--    end
--    return table.concat(sb)
--  else
--    return tt .. "\n"
--  end
--end

--function to_string( tbl )
--    if  "nil"       == type( tbl ) then
--        return tostring(nil)
--    elseif  "table" == type( tbl ) then
--        return table_print(tbl)
--    elseif  "string" == type( tbl ) then
--        return tbl
--    else
--        return tostring(tbl)
--    end
--end

local function check_data(data)
  
  local flag=false
   
  for c in data:gmatch"." do
    if(string.byte(c)>127) then
      flag=true
      break
    end
  end
  
  if flag==true then
    responses.send(401,"Bad Request")
  end
end

function BadRequestHandler:new()
  BadRequestHandler.super.new(self, "badrequest")
end

function BadRequestHandler:access(conf)
  BadRequestHandler.super.access(self)
  --
  --local headers = to_string(ngx.req.get_headers())
  local body = ngx.req.get_body_data()
  
  --if headers ~= nil and headers ~= '' then 
    --check_data(to_string(headers))
  --end
  
  if body ~= nil then
    check_data(body)
  end
end

return BadRequestHandler
