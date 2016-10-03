
local FileReader = {}


--[[ 
	Reads a file line by line
	Calls fn on line which returns the data parsed from that line.
	Function returns the entire data collected as an array of data-per-line
	
	@param url file url
	@param fn line parsing function

	return array of parsed data (per-line)
]]
function FileReader.read(url, fn)
  f = io.open(url, "r")
  local data = {}
  for line in f:lines() do
    data[#data+1] = fn(line)
  end
  f:close()
  return data
end

return FileReader