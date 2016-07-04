--[[
	@author: Marx Wolf
	@time: 07.04.2016
	This is my first try in lua.
	Array-sort algorithm implementation in lua.
--]]

if (not arraySort) then arraySort = {}; end


-- @param arr is the input array, i and j is the element index that need to be swaped
-- swap the element at specified index of the input array
local function swap(arr,i,j)
	local temp = arr[i]
	arr[i] = arr[j]
	arr[j] = temp
end
arraySort.swap = swap

-- @param arr is the input array
local function selectSort(arr)
	for i = 1,#arr-1 do 
		local minIndex = i
		for j = i+1,#arr do
			if (arr[minIndex] > arr[j]) then
				minIndex = j
			end
		end
		if (arr[i] ~= arr[minIndex]) then
			arraySort.swap(arr, i, minIndex)
		end
	end
end
arraySort.selectSort = selectSort


local function insertSort(arr)
	for i = 2,#arr do
		currentValue = arr[i]
		index = i
		for j = i-1,1,-1 do
			if (currentValue < arr[j]) then
				arr[j+1] = arr[j]
				index = j
			end
		end
		arr[index] = currentValue
	end
end
arraySort.insertSort = insertSort

local function bubbleSort(arr)
	for i = 1,#arr do
		for j = 1,(#arr-i) do
			if (arr[j] > arr[j+1]) then
				arraySort.swap(arr,j,j+1)
			end
		end
	end
end
arraySort.bubbleSort = bubbleSort

-- reverse the input arrays
local function reversed(arr)
	for i = 1,#arr/2 do
		arraySort.swap(arr,i,#arr+1-i)
	end
end
arraySort.reversed = reversed

-- @param variable input parameters, with separetor "\t" and a newline at last  
function nowrapprint(...)
	local write = io.write
    local n = select("#",...)
    for i = 1,n do
        local v = tostring(select(i,...))
        write(v)
        if i~=n then write'\t' end
    end
    write'\n'
end

-- print array in the same line with the input separetor such as "/t" or " " or ","
function arrayprint(arr,sep)
	local nowraparray = ""
	for i = 1,#arr do
		nowraparray = nowraparray .. arr[i] .. sep
	end
	arr = nowraparray
	print(arr)
end


-------Test for the upper functions
arr = {11,22,433,555}
arr1 = {'abv','cad',17}
arrayprint(arr1," ")
for i = 1, #arr1 do
	print(arr1[i])
end



