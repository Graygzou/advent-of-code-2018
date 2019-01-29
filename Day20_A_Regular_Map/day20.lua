--#################################################################
--# @author: Grégoire Boiron                                      #
--# @date: 25/01/2019                                             #
--#                                                               #
--# Main script for the day 20 of the AoC                         #
--#################################################################

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  day20 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (inputFile)

  local fileLine = helper.saveLinesToArray(inputFile);

  -- Retrieve the real string only (^ = start / $ = end)
  local regexp = string.match(fileLine[1], "%^(.*)%$")
  print("RegExp = ", regexp)

  local selection = string.match(regexp, '%([^()]*%)')

  while selection ~= nil do
    -- Parse it and choose the greatest option
    local biggestOption = ""
    if string.match(selection, '|%)') == nil then
      for token in string.gmatch(selection, "[^(|)]+") do
        if #token > #biggestOption then
          biggestOption = token
        end
      end
    end

    if string.match(biggestOption, '|') ~= nil or string.match(biggestOption, '%(') or string.match(biggestOption, '%)') then
      return -1
    end

    -- Find the previous selection in the string
    local replacementIndexStart, replacementIndexEnd = string.find(regexp, '%(' .. selection .. '%)')

    -- Replace it.
    regexp = regexp:sub(1, replacementIndexStart-1) .. biggestOption .. regexp:sub(replacementIndexEnd+1, #regexp)

    -- New selection
    selection = string.match(regexp, '%([^()]*%)')
  end

  return #regexp;
end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
local function partTwo (inputFile)
  local nbDoors = 5
  local nbRooms = 0

  local fileLine = helper.saveLinesToArray(inputFile);

  -- Retrieve the real string only (^ = start / $ = end)
  local regexp = string.match(fileLine[1], "%^(.*)%$")
  print("RegExp = ", regexp)

  local selection = string.match(regexp, '%([^()]*%)')
  print("Test v2", selection)

  local currentIteration = 0
  local nbIterationMax = 5000
  while selection ~= nil and currentIteration < nbIterationMax do
    -- Find the previous selection in the string
    local replacementIndexStart, replacementIndexEnd = string.find(regexp, '%(' .. selection .. '%)')

    beforeSelection = string.match(regexp:sub(1, replacementIndexStart-1), '[^|()][A-Z]*$')
    if beforeSelection == nil then
      beforeSelection = ""
    end
    --print(beforeSelection)

    afterSelection = string.match(regexp:sub(replacementIndexEnd+1, #regexp), '^[A-Z]*[^|()]')
    if afterSelection == nil then
      afterSelection = ""
    end
    --print(afterSelection)

    -- Parse it and choose the greatest option
    local newOptions = ""
    if string.match(selection, '|%)') == nil then
      -- For each possible option (token)
      --for token in string.gmatch(selection, "[^(|)]+") do
        --if #token >= nbDoors then
        --  print(token)
         -- nbRooms = nbRooms + 1
        --else
          -- Replace it and add it to the path array.
      --    newOptions = newOptions .. beforeSelection .. token .. afterSelection .. "|"
        --end
      --end
      print(string.gsub(selection, "([^%(%|%)]+)", function(w) return beforeSelection .. w .. afterSelection end))
      newOptions = newOptions .. string.gsub(selection, "([^%(%|%)]+)", function(w) return beforeSelection .. w .. afterSelection end)
      -- Remove the last '|'
      --newOptions = newOptions:sub(1,#newOptions-1)
    else
      newOptions = newOptions .. beforeSelection .. afterSelection
    end
    print("FINAL RESULT", newOptions)

    -- Replace it.
    regexp = regexp:sub(1, replacementIndexStart - #beforeSelection - 1) .. newOptions .. regexp:sub(replacementIndexEnd + #afterSelection + 1, #regexp)

    -- New selection
    selection = string.match(regexp, '%([^()]*%)')
    --print("Test v2", selection)

    currentIteration = currentIteration + 1
    print("Iteration n°" .. currentIteration)
  end

  print("FINAL", nbRooms, regexp)

  for possiblePath in string.gmatch(regexp, "[^(|)]+") do
    if #possiblePath >= nbDoors then
      nbRooms = nbRooms + 1
    end
  end

  return nbRooms
end

------------------------------------------------------------------------
local function partTwoddd (inputFile)
  local nbDoors = 1000
  local nbRooms = 0

  local fileLine = helper.saveLinesToArray(inputFile);

  -- Retrieve the real string only (^ = start / $ = end)
  local regexp = string.match(fileLine[1], "%^(.*)%$")
  local newRegexp = regexp
  print("RegExp = ", regexp)

  local currentIteration = 0
  local nbIterationMax = 2000
  repeat
    regexp = newRegexp

    newRegexp = string.gsub(regexp, '([A-Z]*)(%([^()]*%))([A-Z]*)', function(a, b, c)
      local string = ""
      if string.match(b, '|%)') == nil then
        for token in string.gmatch(b, "[^(|)]+") do
          string = string .. a .. token .. c .. '|'
        end
        string = string:sub(1, #string-1)
      else
        string = a .. c
      end
      return string
    end)
    currentIteration = currentIteration + 1

    print(currentIteration)
    --print(newRegexp)
  until currentIteration > nbIterationMax or regexp == newRegexp

  --print("FINAL", nbRooms, regexp)

  local paths = {}

  for possiblePath in string.gmatch(regexp, "[^(|)]+") do
    -- Check if the path is legit
    if #possiblePath >= nbDoors then
      -- Add the path
      table.insert(paths, possiblePath:sub(1000, #possiblePath))
      --print(possiblePath:sub(1000, #possiblePath))
    end
  end

  print("post-processing")

  -- Find unique rooms from the list
  while #paths > 0 do
    local i = 1
    local currentChar = nil
    repeat
      currentChar = paths[i]:sub(1,1)
      i = i + 1
    until currentChar == nil or i >= #paths

    print("Debug", currentChar, paths[i-1])

    -- Count the current room of the first path
    nbRooms = nbRooms + 1

    -- Remove that character from all the path (including the current one)
    for j = 1, #paths do
      -- Remove empty path from the list
      if paths[j] ~= nil then
        if #paths[j] <= 0 then
          table.remove(paths, j)
        elseif paths[j]:sub(1,1) == currentChar then
          paths[j] = paths[j]:sub(2, #paths[j])
        end
      end
    end
  end

  return nbRooms
end


--#################################################################
-- Main - Main function
--#################################################################
function day20Main (filename)

  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  --local partOneResult = partOne(inputFile)

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");

  local partTwoResult = partTwoddd(inputFile)

  -- Finally close the file
  inputFile:close();

  print("Result part one :", partOneResult);
  print("Result part two :", partTwoResult);

end

--#################################################################
-- Package end
--#################################################################

day20 = {
  day20Main = day20Main,
}

return day20