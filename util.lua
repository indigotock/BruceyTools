local util = {}

-- Merge two tables and return the result
function util.merge_table(base, detail)
  base = base or {}
  detail = detail or {}
  for key, val in pairs(detail) do
    if type(val) == 'table' then
      mt(base[key] or {}, detail[key] or {})
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

return util
