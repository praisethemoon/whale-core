-- Matrix utilities

require('whale.Vector')


--[[
  Initizalizer, creates a Matrix
  
  @param mdata raw lua table of table of data (numbers)
  @param rows number of rows (optional)
  @param cols number of colomns (optional)
  @param value default value for uninitialized vector (optional)
  
  returns a new vector
]]
function matrix(mdata, rows, cols, value)
  value = 0 or value
  -- function overloading
  local meta = {}
  
  -- call, returns row or element in read only  
  meta.__call = function(table, i, j)  
    if (j == nil) and (type(i) == "number") then
      return vector(table[i])
    elseif (type(i) == "number")  then
      assert(type(j) == "number")
      return table[i][j]
    elseif i.type == "vector" then
      if j ~= nil then
        assert(j.type == "vector", "Expecting a vector, since the first parameter is vector too")
      end
      return subMat(table, i, j)
    end
  end

  -- add operator
  meta.__add = function(lhs, rhs)
    return addMM(lhs,rhs)
  end
  
  -- substract operator
  meta.__sub = function(lhs, rhs)
    return subMM(lhs,rhs)
  end
  
  -- muliply operator
  meta.__mul = function(lhs, rhs)
    if type(lhs) == "number" then
      return multSM(lhs,rhs)
    elseif type(rhs) == "number" then
      return multMS(lhs,rhs)
    elseif rhs.type == "vector" then
      return multMV(lhs, rhs)  
    else
      return multMM(lhs, rhs)
    end
  end 
  
  meta.__type = "matrix"
  
  local m = mdata
  
  setmetatable(m, meta)
  m.type = "matrix"
    
  if (cols ~= nil) and (rows ~= nil) then
    for i=1,rows do
      table.insert(m,{})
      for j=1, cols do
        table.insert(m[i], value)
      end
    end
  end
  return m
end

function randomMatrix(rows, cols)
  local m = matrix({})
  for i=1,rows do
    table.insert(m,{})
    for j=1,cols do
      table.insert(m[i], (2/100)*math.random() - 0.01)
    end
  end
  
  return m
end

-- Identity matrix rows x rows
function eye(rows)
  local fns = {function() return 0 end, function() return 1 end}
  
  local m = matrix({})
  for i=1,rows do
    table.insert(m,{})
    for j=1,rows do
      table.insert(m[i], fns[ ((i==j) and 1 or 0)+1]())
    end
  end
  
  return m
end

--[[
  Adds a column to the given matrix.
  This DOES change the given matrix.
  
  @param m matrix
  @param pos insert position
  @param col column to insert
  
  Returns nothing
]]
function addCol(m, pos, col)
  assert(#col == #m, "Cannot append col of size "..#col.." to a Matrix of size"..#m.."x"..#m(1))
  for i=1, #m do
    table.insert(m[i], pos, col[i])
  end
end

--[[ 
	Removes a row by its index 
	This DOES change the given matrix.

	@param m Matrix
	@param i index
]]

function delRow(m, i)
	assert((i <= #m) and (i >= 0), "Cannot delte Row "..i.." from a Matrix of size "..#m.."x"..#m(1))
	table.remove(m, i)
end

--[[
  Adds a row to the given matrix.
  This DOES change the given matrix.

  @param m matrix
  @param pos insert position
  @param col column to insert
  
  Returns nothing
]]
function addRow(m, pos, row)
  assert(#row == #m(1), "Cannot append Row of size "..#row.." to a Matrix of size "..#m.."x"..#m(1))
  assert(pos <= #m(1), "Position of row "..row.." is out of bounds of matrix of size "..#m.."x"..#m(1))
  table.insert(m, pos, row)
end

--[[
  Removes a row from the given matrix and returns it.
  This DOES change the given matrix.
  
  @param m matrix
  @param pos position
  
  returns nothing
]]

function getDelRow(m, pos)
	assert((pos <= #m) and (pos >= 0), "Position of row "..pos.." is out of bounds of matrix of size "..#m.."x"..#m(1))
	local row = m[pos]
	table.remove(m, pos)

	return row
end

--[[
  Removes a col from the given matrix and returns it.
  This DOES change the given matrix.
  
  @param m matrix
  @param pos position
  
  returns nothing
]]
function getDelCol(m, pos)
  assert(pos <= #m, "Position of col "..pos.." is out of bounds of matrix of size "..#m.."x"..#m(1))
  local col = vector({}, #m)
  for i=1,#m do
    col[i] = m[i][pos]
    table.remove(m[i], pos)
  end
  return col
end

--[[
  Returns a column at a given position
  
  @param m matrix
  @param pos
  
  returns Column at position pos 
]]
function getCol(m, pos)
  local col = vector({}, #m)
  for i=1,#m do
    col[i] = m[i][pos]
  end
  return col
end


--[[
  Size of a matrix in form a Vector
  
  @param m Matrix
  
  returns 2-dim Vector (rows, cols)
]]
function mSize(m)
  assert(m.type == "matrix", "Non matrix type passed to mSize")
  return vector({#m, #m[1]})
end

--[[
  Prints a matrix
  
  @param m Matrix
  
  returns nothing
]]
function printMatrix(m)
  assert(m.type == "matrix", "Non matrix type passed to printMatrix")
  for i, v in ipairs(m) do
    printVector(vector(v))
  end
end

--[[
  Transposes a matrix
  This does not change the given matrix
  
  @param m Matrix
  
  returns Transposed version of m
]]
function mT(m)
  assert((m.type == "matrix") or (m.type == "vector") , "Non matrix type passed to matrixT")
  if m.type == "vector" then
    return matrix({m})
  end
  
  local v = mSize(m)
  local m2 = matrix({}, v[2], v[1])
  
  for i, v in ipairs(m) do
    for j, w in ipairs(v) do
      m2[j][i] = w
    end
  end
  
  return m2;
end

--[[ 
	element-wise multiplication between two matrices
	return new matrix 

	@param m1 Matrix
	@param m2 Matrix

	return m1 .* m2
]]
function dot(m1, m2)
	if m1.type == 'vector' then
		if m2.type == 'vector' then
			return vdot(m1, m2)
		else
			assert(1==0)
		end
	end


	if m1.type == 'number' then
		if m2.type == 'number' then
			return (m1 * m2)
		else
			assert(1==0)
		end
	end

	assert( #m1 == #m2 )
	assert( #(m1(1)) == #(m2(1)) )
	
	local m3 = matrix( {}, #m1, #(m1(1)) )

	for i, v in ipairs(m1) do
		for j, w in ipairs(v) do
			m3[i][j] = m1[i][j] * m2[i][j]
		end
	end
	return m3
end

--[[
  Adds two N-M Matrices, assert same size
  This does not change the given Matrices
  
  @param m1: Left operand Matrix
  @param m2: Right operand Matrix
  
  return m1 + m2
]]
function addMM(m1, m2)
  assert((#m1 == #m2) and (#m1[1] == #m2[1]), "Incompatible matrix sizes passed to addMM")
  assert((m1.type == "matrix") and (m2.type == "matrix"), "Non matrix type passed to mSize")
  
  local m3 = matrix({}, #m1, #m1[1])
  for i=1,#m1 do
    for j=1,#m1[1] do
      m3[i][j] = m1[i][j] + m2[i][j]
    end
  end
  
  return m3
end

--[[
  Substracts two N-M matrices, assert same size
  This does not change the given Matrices
  
  @param m1: Left operand Matrix
  @param m2: Right operand Matrix
  
  return m1 - m2
]]
function subMM(m1, m2)
  assert((#m1 == #m2) and (#m1[1] == #m2[1]), "Incompatible matrix sizes passed to addMM")
  assert((m1.type == "matrix") and (m2.type == "matrix"), "Non matrix type passed to mSize")
  
  local m3 = matrix({}, #m1, #m1[1])
  for i=1,#m1 do
    for j=1,#m1[1] do
      m3[i][j] = m1[i][j] - m2[i][j]
    end
  end
  
  return m3
end

--[[
  Multiply a Matrix by a scalar
  This does not change the given matrix
  
  @param m: Left operand Matrix
  @param s: Right operand scalar
  
  return m * s
]]
function multMS(m, s)
  assert(m.type == "matrix", "Non matrix type passed to multMs")
  local m3 = matrix({}, #m, #m[1])
  for i=1,#m do
    for j=1,#m[1] do
      m3[i][j] = m[i][j] * s
    end
  end
  
  return m3
end

--[[
  Multiply a scalar by a Matrix
  This does not change the given matrix
  
  @param s: Left operand scalar
  @param m: Right operand Matrix
  
  return s * m
]]
function multSM(s, m)
  assert(m.type == "matrix", "Non matrix type passed to multMs")
  local m3 = matrix({}, #m, #m[1])
  for i=1,#m do
    for j=1,#m[1] do
      m3[i][j] =  s * m[i][j]
    end
  end
  
  return m3
end


--[[
  Devide a Matrix by a scalar
  This does not change the given matrix
  
  @param m: Left operand Matrix
  @param s: Right operand scalar
  
  return m / s
]]
function divMS(m, s)
  assert(m.type == "matrix", "Non matrix type passed to multMs")
  local m3 = matrix({}, #m, #m[1])
  for i=1,#m do
    for j=1,#m[1] do
      m3[i][j] = m[i][j] / s
    end
  end
  
  return m3
end

--[[
  Multiply a M-N Matrix by a N-dim Vector
  This does not change the given parameters
  
  @param m: Left operand Matrix
  @param v: Right operand Vector
  
  return m / s
]]
function multMV(m, v)
  local msize = mSize(m)
  local vsize = vSize(v)
  assert(msize[2] == vsize, "Cannot multiply "..msize[1]..'x'..msize[2]..' Matrix by a '..vsize.. 'x1 Vector')
  local vect = vector({}, msize[1])
  
  for i = 1,msize[1] do
    for j=1,vsize do
      vect[i] = vect[i] + m[i][j] * v[j]
    end
  end
  return vect
end



--[[
  Multiply a M-N Matrix by another N-O Matrix
  This does not change the given parameters
  
  @param m1: Left operand Matrix
  @param m2: Right operand Matrix
  
  return m1*m2
]]
function multMM(m1, m2)
  local m1size = mSize(m1)
  local m2size = mSize(m2)
  
  assert(m1size[2] == m2size[1], "Cannot multiply "..m1size[1]..'x'..m1size[2]..' Matrix by a '..m2size[1].. 'x'..m2size[2].. ' Matrix')
  
  local m3 = matrix({}, m1size[1], m2size[2])
  
  for i=1,m1size[1] do
    for j=1,m2size[2] do
      for k=1,m1size[2] do
        --print(i..", "..j..", "..k)
        m3[i][j] = m3[i][j] + m1[i][k] * m2[k][j]
      end
    end
  end
  
  return m3
end

--[[
  Extract a sub-matrix
  Does not change input matrix
  
  @param m Matrix
  @param rows: Vector of rows to extract
  @param cols: Vector of cols to extract (if nil then it's set to all cols of m)
  
  return submatrix m(rows, cols)
]]
function subMat(m, rows, cols)
  cols = cols or fillVector(1,#m(1))
  local mat = matrix({}, #rows, #cols)
  for i,v in ipairs(rows) do
    for j,w in ipairs(cols) do
      mat[i][j] = m[v][w]
    end
  end
  return mat
end

--[[
  Mean-Normalize all columns of a given matrix
  Substracts each element with the mean (of the col) and devides by standard deviation (of the same col)
  This DOES change the given matrix
  
  @param m: Left operand Matrix
  
  return a normalized columns matrix
]]
function mnorm(m)
  local mus = vector({}, #m(1))
  local sigmas = vector({}, #m(1))
  
  for i=1,#m(1) do
    local col = getCol(m,i)
    local ncol, mu, sigma = vnorm(col)
    mus[i] = mu
    sigmas[i] = sigma
    for j=1,#m do
      m[j][i] = ncol[j]
    end
  end
  return mus, sigmas
end


--[[
  Copy a Matrix
  This does not change the given Matrix 
  
  @param m Matrix
  
  return a copy of m
]]
function mcopy(m)
  local mat = matrix({}, #m, #(m(1)))
  for i=1, #m do
		mat[i] = vcopy(m(i))
  end
  
  return mat
end


--[[
	Converts Matrix to json string format

	@param m Matrix
	
	return json format of m
]]
function mjson(m)
	local str = '['
	for i, w in ipairs(m) do
		str = str .. vjson(w)
		if i < #m then
			str = str ..', '
		end
	end
	return str..']'
end

--[[ 
	Applies a function to all elements of a Matrix

	@param m1 Matrix
	@param f Function to apply

	return f(m1)
]]
function mmap(m1, f)
	--assert(m1.type == 'matrix')

	local m3 = matrix( {}, #m1, #(m1(1)) )

	for i, v in ipairs(m1) do
		for j, w in ipairs(v) do
			m3[i][j] = f(m1[i][j])
		end
	end
	return m3
end

function matrixFromVect(v)
  local m = matrix({}, #v, 1)
  for i = 1, #v do
    m[i][1] = v[i]
  end

  return m
end

--[[
  Matix element wise multiplication by vector
  @param m matrix
  @param v vector
  returns m .* v
]]
function mewmult(m, v)
  assert(m.type == "matrix")
  assert(v.type == "vector")
  assert(#m[1] == #v)

  local m2 = matrix{}
  
  for i=1,#m do
    m2[i] = {}

    for j = 1, #m[1] do
      m2[i][j] = m[i][j] * v[j]
    end
  end
  
  return m2
end

