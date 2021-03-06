
--[[
	Test case
]]

local FileReader = require 'whale.io.FileReader'
local NeuralNetwork = require 'whale.ml.NeuralNetwork'
require 'whale.Matrix'
require 'whale.Vector'

classes = {}
classes["Iris-setosa"] = vector{1, 0, 0}
classes["Iris-versicolor"] = vector{0, 1, 0}
classes["Iris-virginica"] = vector{0, 0, 1}

local fn = function(line)
  local id, sl, sw, pl, pw, c = line:match('(%S+),(%S+),(%S+),(%S+),(%S+),(%S+)')
  return vector{tonumber(sl), tonumber(sw), tonumber(pl), tonumber(pw), classes[c]}
end

local data = matrix(FileReader.read("iris_example/Iris.csv", fn))

local X = mcopy(data)

-- first row is nil, contains headers
table.remove(X, 1)

local y = getDelCol(X, 5)
y.type = "matrix"

--printMatrix(y)

-- append theta0
--local col = vector({},#X,1)
--addCol(X,1,col)

local nn = NeuralNetwork:new{4, 4, 4, 3}
NeuralNetwork.cost(nn, X, y)
