--[[
  This is a simple unit testing file.
]]

require 'whale.Matrix'
require 'whale.Vector'
require 'whale.ml.GradientDescent'
local LinearRegression = require 'whale.ml.LinearRegression' 
local LogisticRegression = require 'whale.ml.LogisticRegression'



local v = vector({1, 2, 3, 4, 5, 6})

assert(#v == 6)

for i=1,#v do
  assert(v[i] == i)
  assert(v(i) == v[i])
end

v = vector({}, 10, 5)
for i=1,#v do
  assert(v(i) == 5)
end

v = fillVector(1,10,0.1)
local c = 1
for i=1, 10, 0.1 do
  assert(v(c) == i)
  c = c + 1
end

v = vector({1, 2, 3})

v = multVS(v, 2)
for i=1, #v do
  assert(v(i) == 2*i)
end

v = multSV(3, v)
for i=1, #v do
  assert(v(i) == 2*3*i)
end

v = addVS(v, 5)
for i=1, #v do
  assert(v(i) == 2*3*i+5)
end

v = addSV(7, v)
for i=1, #v do
  assert(v(i) == 2*3*i+5+7)
end
v = addVV(v, vector({1, 1, 1}))
for i=1, #v do
  assert(v(i) == 2*3*i+5+7+1)
end  
  
v = addVV(vector({2, 2, 2}), v)
for i=1, #v do
  assert(v(i) == 2*3*i+5+7+1+2)
end  
  
  
  
assert(#(vector({1, 2, 4, 10})) == 4)
assert(vsum(vector({1, 2, 4, 10})) == 17)
assert(vmean(vector({1, 2, 4, 10})) == 4.25)
assert(vstd(vector({1, 2, 4, 10}))- 4.0311288 < 0.0001)

local mat1 = matrix({{-1, -1, -1}, {8, 1, 6}, {3, 5, 7}, {4, 9, 2}})

assert(mat1(2, 1) == 8)
assert(mat1(4, 3) == 2)

local x, y = mnorm(mat1)


assert(LogisticRegression.hyp(vector{1, 2, 3},vector{-1, 0, -2}) - 0.000911 < 0.00001)

v = vfind(vector{1, 2, 1, 1, 5, 1}, 1)

assert((v(1)==1) and (v(2)==3) and (v(3)==4) and (v(4)==6) and (#v == 4))

local m1 = matrix {{1, 2, 3, 4}, {5, 6, 7, 8}}
local m2 = mcopy(m1)
m2[1][1] = 10
assert(m1(1, 1) == 1)

print("Done unit testing!")