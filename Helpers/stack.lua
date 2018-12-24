--################################
--# @author: Grégoire Boiron     #
--# @date: 12/08/2018            #
--################################

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  Stack = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Private functions
--#################################################################

--#################################################################
-- Public functions
--#################################################################

function new ()
  return {first = 0, last = -1}
end

function pushleft (stack, value)
  local first = stack.first - 1
  stack.first = first
  stack[first] = value
end

function pushright (stack, value)
  local last = stack.last + 1
  stack.last = last
  stack[last] = value
end

function popleft (stack)
  local first = stack.first
  if first > stack.last then return nil end
  local value = stack[first]
  stack[first] = nil        -- to allow garbage collection
  stack.first = first + 1
  return value
end

function popright (stack)
  local last = stack.last
  if stack.first > last then return nil end
  local value = stack[last]
  stack[last] = nil         -- to allow garbage collection
  stack.last = last - 1
  return value
end

function printstack (stack)
  for k, v in pairs(stack) do
    if k ~= "first" and k ~= "last" then
      print(k, " => ", v.position.x,v.position.y )
    end
  end
end

function getSize (stack)
  local size = 0
  for k, v in pairs(stack) do
    if k ~= "first" and k ~= "last" then
      size = size + 1
    end
  end
  return size
end

function sortstack(stack)
  tempArray = {}
  local oldIndex = nil
  local oldRes = ""
  for i=getSize(stack),1,-1 do
    for k, v in pairs(stack) do
      if k ~= "first" and k ~= "last" then
        if oldRes == "" and oldIndex == nil then
          print("--key " .. k .. " , " .. v)
          oldRes = v
          oldIndex = k
        else
          print("OLDkey " .. oldIndex .. " , " .. oldRes)
          print("key " .. k .. " , " .. v)
          if string.byte(oldIndex) < string.byte(v) then
            print("SWAP")
            temp = stack[oldIndex]
            stack[oldIndex] = v
            stack[k] = oldRe
          end
        end
      end
    end
  end
end

--#################################################################
-- Package end
--#################################################################

-- Let us make abstraction of the namespace prefixe for each function.
-- All the functions here are public outside the package
stack = {
  new = new,
  pushleft = pushleft,
  pushright = pushright,
  popleft = popleft,
  popright = popright,
  printstack = printstack,
  getSize = getSize,
  sortstack = sortstack,
}

return stack