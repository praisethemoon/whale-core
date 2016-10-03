
require 'whale.Matrix'
require 'whale.Vector'
require 'whale.ml.GradientDescent'

-- print = WhaleEditor.logp

local LinearRegression = require 'whale.ml.LinearRegression' 
local LogisticRegression = require 'whale.ml.LogisticRegression'
local FileReader = require 'whale.io.FileReader'


local alpha = 1;
local num_iters = 100;

local classes = {}

classes["Iris-setosa"] = 0
classes["Iris-versicolor"] = 1
classes["Iris-virginica"] = 2

local fn = function(line)
  local id, sl, sw, pl, pw, c = line:match('(%S+),(%S+),(%S+),(%S+),(%S+),(%S+)')
  return vector{tonumber(sl), tonumber(sw), tonumber(pl), tonumber(pw), classes[c]}
end

local data = matrix(FileReader.read("iris_example/Iris.csv", fn))

local X = mcopy(data)


-- first row is nil, contains headers
table.remove(X, 1)


local testCase = getDelRow(X, 3)
testCase[5] = nil
table.insert(testCase, 1, 1)

local testCase2 = getDelRow(X, 98)
testCase2[5] = nil
table.insert(testCase2, 1, 1)

local testCase3 = getDelRow(X, 148)
testCase3[5] = nil
table.insert(testCase3, 1, 1)


local y = getDelCol(X, 5)

-- append theta0
local col = vector({},#X,1)
addCol(X,1,col)

--[[
	Finding theta that seperates class 0 with the rest
]]

--[[ 
	turn 3 classes into 2 classes,
	1 => class we need
	0 => class we don't need
]]

local y0 = vcopy(y)

for i, v in ipairs(y0) do
	if v ~= 0 then
		y0[i] = 0
	else
		y0[i] = 1
	end
end

local theta = vector({}, #X(1), 0)
local alpha = 50
local num_iter = 500

local optTheta, j_hist = GradientDescent(X,y0,theta,alpha, num_iters, LogisticRegression.hyp, LogisticRegression.cost)

print(" class 0 ")

print((LogisticRegression.hyp(optTheta, testCase)).."\n")
print((LogisticRegression.hyp(optTheta, testCase2)).."\n")
print((LogisticRegression.hyp(optTheta, testCase3)).."\n")


local y1 = vcopy(y)

for i, v in ipairs(y1) do
	if v == 1 then
		y1[i] = 1
	else
		y1[i] = 0
	end
end

local theta = vector({}, #X(1), 0)
local alpha = 0.1
local num_iter = 500

local optTheta, j_hist = GradientDescent(X,y1,theta,alpha, num_iters, LogisticRegression.hyp, LogisticRegression.cost)

print(" class 1 ")
print((LogisticRegression.hyp(optTheta, testCase)).."\n")
print((LogisticRegression.hyp(optTheta, testCase2)).."\n")
print((LogisticRegression.hyp(optTheta, testCase3)).."\n")

local y2 = vcopy(y)

for i, v in ipairs(y2) do
	if v ~= 2 then
		y2[i] = 0
	else
		y2[i] = 1
	end
end

local theta = vector({}, #X(1), 0)
local alpha = 0.1
local num_iter = 500

local optTheta, j_hist = GradientDescent(X,y2,theta,alpha, num_iters, LogisticRegression.hyp, LogisticRegression.cost)


print(" class 2 ")

print((LogisticRegression.hyp(optTheta, testCase)).."\n")
print((LogisticRegression.hyp(optTheta, testCase2)).."\n")
print((LogisticRegression.hyp(optTheta, testCase3)).."\n")
