local util = {}

-- Merge two tables and return the result
function util.merge_table(base, detail)
  base = base or {}
  detail = detail or {}
  for key, val in pairs(detail) do
    if type(val) == 'table' then
      util.merge_table(base[key] or {}, detail[key] or {})
    else
      base[key] = val
    end
  end
  return base
end

-- Rounds a number to a given number of decimal places
function util.round_number(number,places)
  local exponent = 10*(places or 1)
  return math.floor(number * exponent + .5) / exponent
end

-- Serialises a table into a string with no care for readability
function util.serialise_table(table, key)
  local ret = ''
  if key then
    if type(key) == 'string' then
      ret = ret..'[\''..key..'\']='
    elseif type(key) == 'number' then
      ret = ret..'['..key..']='
    end
  end
  if type(table) == "table" then
    ret = ret.."{"
    for key,val in pairs(table) do
      ret = ret..util.serialise_table(val,key)..","
    end
    ret = ret.."}"
  elseif type(table)=="string" then
    ret = ret .. "'"..table.."'"
  elseif type(table)=="number" then
    ret = ret .. tostring(table)
  elseif type(table)=="boolean" then
    ret = ret..(table and "true" or "false")
  end
  -- Remove any trailing commas (,})
  return ret:gsub(',\}','}')
end

-- Trims whitespace from the end and start of a string
function util.trim_string(str)
  return str:gsub("^\\s*", ""):gsub("\\s*$", "")
end

-- Deserialises a table and returns the result, or nil if it failed.
function util.deserialise_table(string)
  local loaded = loadstring('return '..string)
  local worked, ret = pcall(loaded)
  return worked and ret or nil
end

-- Clones a table recursively, leaving no references behind
function util.clone_table(table)
  local new = {}
  for key, val in pairs(table) do
    if type(v) == 'table' then
      new[key] = util.clone_table(val)
    else
      new[key] = val
    end
  end
  return new
end

-- Returns the number of key/value pairs in the table
function util.table_size(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end

-- Default base64 character set
util.s64Chars =
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-."

-- Encodes a string to base64
function util.encode_base64(string, charset)
  -- If charset and charset is 64 long then charset = charset, else default 
  charset = (charset and #charset == 64) and charset or util.s64Chars
  print(charset)
  return ((string:gsub('.', function(x) 
    local r,b='',x:byte()
    for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
    return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
  if (#x < 6) then return '' end
  local c=0
  for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
  return charset:sub(c+1,c+1)
  end)..({ '', '==', '=' })[#string%3+1])
end


-- Decodes a base64 string
function util.decode_base64(string, charset)
  -- If charset and charset is 64 long then charset = charset, else default 
  charset = (charset and #charset == 64) and charset or util.s64Chars
  return (string:gsub('.', function(x)
    if (x == '=') then return '' end
    local r,f='',(charset:find(x)-1)
    for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
    return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
    if (#x ~= 8) then return '' end
    local c=0
    for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
    return string.char(c)
    end))
end

Apollo.RegisterPackage(util,'indigotock.btools.util',1,{})