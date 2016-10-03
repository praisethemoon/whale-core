-- vector utilities
--[[
  Initizalizer, creates a vector
  
  @param vdata raw lua table of data (numbers)
  @param size vector requested size (optional)
  @param value default value for uninitialized vector (optional)
  
  returns a new vector
]]


local Table = table

function vector(vdata, size, value)
  local v = vdata or {}
  val = value or 0
  v.type = "vector"
  
  
  local meta = {}
  
  meta.__call = function(table, i)
    return table[i]
  end
  
  
  meta.__mul = function(lhs, rhs)
    if type(lhs) == "number" then
      return multSV(lhs,rhs)
    elseif type(rhs) == "number" then
      return multVS(lhs,rhs)
	else
		assert(type(rhs) == "number")
    end
  end
  
  meta.__add = function(lhs, rhs)
    if type(lhs) == "number" then
      return addSV(lhs,rhs)
    elseif type(rhs) == "number" then
      return addVS(lhs,rhs)
    else
      return addVV(lhs, rhs)
    end
  end
  
  meta.__sub = function(lhs, rhs)
    if type(lhs) == "number" then
      return subSV(lhs,rhs)
    elseif type(rhs) == "number" then
      return subVS(lhs,rhs)
    else
      return subVV(lhs, rhs)
    end
  end
  
  meta.__unm = function(lhs)
    local v = vector({}, #lhs)
    for i = 1,#lhs do
      v[i] = -lhs[i]
    end
    
    return v
  end
  
  setmetatable(v, meta)
  
  if size ~= nil then
    for i=1,size do
      Table.insert(v, val)
    end
  end
  
  return v;
end

--[[ 
	map applies a function to all elements of the vector and 
	returns a new one containing the result

	@param v Vector
	@param f function to apply

	return f(v)
]]

function vmap(v, f)
	local vect = vector{}

	for i, w in ipairs(v) do
		vect[#vect+1] = f(w)
	end

	return vect
end

--[[
  Vector size
  
  @param v Vector
  
  return vector size, a scalar
]]
function vSize(v)
  assert(v.type == "vector", "Non vector type passed to vSize")
  return #v
end

--[[
  Prints a vector
  
  @param v Vector
  
  return nothing
]]
function printVector(v)
  assert(v.type == "vector", "Non vector type passed to printVector")
  
  local fn = {function() io.write(", ") end, function() print("") end}
  local size = #v
  for i,w in ipairs(v) do
    io.write(w)
    fn[ (((i % size) == 0) and 1 or 0)+1]()
    --print("qsdqsd "..(((i % size) == 0) and 1 or 0))
  end
end

--[[
  Creates a Vector and fills it with given parameters
  
  @param from initial value
  @param to final value
  @param step difference between each two cons
  
  return vector size, a scalar
]]
function fillVector(from, to, step)
  local v = vector({})
  
  function inc(v, step)
    return v + step
  end
  
  function dec(v, step)
    return v - step
  end
  
  function cmp1(v, v2)
    return v > v2
  end
  
  function cmp2(v, v2)
    return v < v2
  end
  
  local fnInc = {inc, dec}
  local fnCmp = {cmp1, cmp2}
  
  local fni = 1
  
  if from > to then
    fni = 2
  end
  
  assert((from ~= nil) and (to ~= nil))
  local s = step or 1
  repeat
    v[#v+1] = from
    from = fnInc[fni](from, s)
  until fnCmp[fni](from, to)
  return v
end


--[[
  Multitplies a Vector by a scalar 
  
  @param v left operand Vector
  @param s right operand scalar
  
  return v*s
]]
function multVS(v, s)
  local vect = vector({}, #v)
  
  for i=1, #v do
    vect[i] = v[i] * s
  end
  
  return vect
end


--[[
  Multitplies a scalar by a Vector 
  
  @param s left operand scalar
  @param v right operand Vector
  
  return s*v
]]
function multSV(s, v)
  return multVS(v,s)
end

--[[
  Adds a Vector to a scalar   
  
  @param v left operand Vector
  @param s right operand scalar
  
  return v+s
]]
function addVS(v, s)
  local vect = vector({}, #v)
  
  for i=1, #v do
    vect[i] = v[i] + s
  end
  
  return vect
end


--[[
  Adds a scalar to a Vector  
  
  @param s left operand scalar
  @param v right operand Vector
  
  return s+v
]]
function addSV(s, v)
  return addVS(v, s)
end

--[[
  Adds a N-dim Vector to another N-dim Vector  
  
  @param v1 left operand Vector
  @param v2 right operand Vector
  
  return v1+v2
]]
function addVV(v1, v2)
  assert(#v1 == #v2, "Cannot add Vector of size"..#v1.." with vector of size "..#v2.." in addVV")
  
  local vect = vector({}, #v1)
  
  for i=1, #v1 do
    vect[i] = v1[i] + v2[i] 
  end
  
  return vect
end

--[[
  Substract a Vector from a scalar   
  
  @param v left operand Vector
  @param s right operand scalar
  
  return v-s
]]
function subVS(v, s)
  local vect = vector({}, #v)
  
  for i=1, #v do
    vect[i] = v[i] - s
  end
  
  return vect
end


--[[
  Substract a scalar from a Vector   
  
  @param s left operand scalar
  @param v right operand Vector
  
  return s-v
]]
function subSV(s, v)
  local vect = vector({}, #v)
  
  for i=1, #v do
    vect[i] = s - v[i]
  end
  
  return vect
end

--[[
  Substract a N-dim Vector from another N-dim Vector  
  
  @param v1 left operand Vector
  @param v2 right operand Vector
  
  return v1-v2
]]
function subVV(v1, v2)
  assert(#v1 == #v2, "Cannot substract Vector of size "..#v1.." from vector of size "..#v2.." in addVV")
  
  local vect = vector({}, #v1)
  
  for i=1, #v1 do
    vect[i] = v1[i] - v2[i] 
  end
  
  return vect
end

--[[
  Sum of elements of a vector
  
  @param v Vector
  
  return Sum_i V[i]
]]
function vsum(v)
  local sum = 0
  for i=1, #v do
    sum = sum + v[i] 
  end
  return sum
end

--[[
  Mean of elements of a vector
  
  @param v Vector
  
  return SUM_i V[i] / N
]]
function vmean(v)
  local mean = 0
  for i=1, #v do
    mean = mean + v[i]
  end
  return mean/#v
end

--[[
  Standard Deviation 
  as seen https://www.gnu.org/software/octave/doc/v4.0.1/Descriptive-Statistics.html#XREFstd 
  (default implementation only; no other parameters other than the vector)
  
  @param v Vector
  
  return sqrt ( 1/(N-1) SUM_i (x(i) - mean(x))^2 
]]
function vstd(v)
  local m = vmean(v)
  local vect = vector({}, #v)
  for i=1, #v do
    vect[i] = math.pow(v[i] - m, 2)
  end
  
  return math.sqrt(vsum(vect)/(#v-1))  
end

--[[
  Mean-Normalize a Vector
  This does not change the given vector 
  v[i] = (v[i] - mean(v)) / vstd(v)
  
  @param v Vector
  
  return a mean-normalized version of v
]]
function vnorm(v)
  local vect = vector({}, #v)
  local min, max = v[1], v[1]
  for _, v in ipairs(v) do
    if v < min then
      min = v
    elseif v > max then
      max = v
    end
  end
  
  local mu = vmean(v)
  local sigma = vstd(v)
  
  for i, v in ipairs(v) do
    vect[i] = (v - mu) / sigma
  end
  
  return vect, mu, sigma
end

--[[
  Copy a Vector
  This does not change the given vector 
  
  @param v Vector
  
  return a copy of v
]]
function vcopy(v)
  local vect = vector({}, #v)
  for i=1, #v do
    vect[i] = v[i]
  end
  
  return vect
end

--[[
  finds elements by value
  
  @param v Vector
  @param e element to search for (usually a scalar)
  
  returns a vector containing all position of e in v
]]
function vfind(v, e)
  local vect = vector{}
  for i,w in ipairs(v) do
    if w ==e then
      vect[#vect + 1] = i
    end
  end
  
  return vect
end

--[[
	Search for the minimum value of vector v

	@param v vector

	return min(v)
]]
function vmin(v)
	local min = v(1)
	for _, w in ipairs(v) do
		if w < min then
			min = w
		end
	end

	return min
end

--[[
	Search for the maximum value of vector v

	@param v vector

	return max(v)
]]
function vmax(v)
	local max = v(1)
	for _, w in ipairs(v) do
		if w > man then
			max = w
		end
	end

	return max
end

--[[
  Search for both min and max values
  
  @param v Vector
  
  return min, max
]]
function vmimax(v)
	local min, max = v[1], v[1]
	for _, w in ipairs(v) do
		if w < min then
			min = w
		elseif w > max then
			max = w
		end
	end
	return min, max
end

--[[
	not sure if this works as intented .. 
	returns a vector of N linearly seperated values ranging [from .. to]

	@param from initial value
	@param to final value
	@param N number of elements

	returns vlinspace(from, to, N)
]]
function vlinspace(from, to, N)
	local space = (to - from)/N
	return fillVector(from, to, space)
end

--[[

]]

function vdot(v1, v2)
	assert(#v1 == #v2)
	
	local v3 = vector({}, #v1)

	for i, v in ipairs(v1) do
		v3[i] = v1[i] * v2[i]
	end

	return v3
end

--[[
	Converts vector to json string format

	@param v Vector
	
	return json format of v
]]
function vjson(v)
	local str = '['
	for i, w in ipairs(v) do
		str = str .. w
		if i < #v then
			str = str ..', '
		end
	end
	return str..']'
end

--[[
	TODO
	removes elements from vector
	
	@param v Vector
	@param t element or array of elements to remove
]]

function vfilter(v, t)

end






