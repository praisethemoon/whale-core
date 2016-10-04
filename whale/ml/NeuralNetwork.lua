--[[
	YES! Finally, neural networks.
]]

if WhaleEditor ~= nil then
	print = WhaleEditor.logp
end

local FileReader = require 'whale.io.FileReader'
require 'whale.Matrix'
require 'whale.Vector'

local table = table

local class = require 'middleclass'

local NeuralNetwork = class [[NeuralNetwork]]

function sigmoid(x)
	if type(x) == 'number' then
		return 1 / (1 + math.exp(-x))
	elseif x.type == 'matrix' then
		return mmap(x, sigmoid)
	elseif x.type == 'vector' then
		return vmap(x, sigmoid)
	else
		assert(1==0, "Pass sigmoid a number, a matrix or a vector, not a "..type(x))
	end
end

local gradientSigmoid = function(x)
	return dot(sigmoid(x), (1-sigmoid(x)))
end

local function log(x)
	if type(x) == 'number' then
		return math.log(x)
	elseif x.type == "vector" then
		return vmap(x, log)
	end
end

--[[
	Neural Network Class

	input: matrix of mxn where m is number of elements in the dataset and n is the number of features.
	nbLayers: number of hidden layers
	nbUnits: number of Units per hidden layer
	output: vector, output.
]]
function NeuralNetwork:initialize(nbHiddenLayers, nbHiddenUnits, nbFeatures, nbOutputUnits, lambda)
	self.input = {}
	self.output = {}
	self.nbHiddenLayers = nbHiddenLayers
	self.nbHiddenUnits = nbHiddenUnits
	self.nbFeatures = nbFeatures
	self.nbOutputUnits = nbOutputUnits
	self.lambda = lambda or 0
	self.layers = {}
	self.nbLayers = 0
	self.thetas = {}
end

--[[
	starts neural network training
--]]
function NeuralNetwork:process(X, y)
	self.nbLayers = self.nbHiddenLayers + 2

	-- creating layers
	table.insert(self.layers, vector({}, self.nbFeatures, 0))

	for i = 1,self.nbHiddenLayers do
		table.insert(self.layers, vector({}, self.nbHiddenUnits, 0))
	end

	table.insert(self.layers, vector({}, self.nbOutputUnits, 0))

	-- creating thetas
	for i=1,#self.layers-1 do
		local theta = randomMatrix(#self.layers[i+1], #self.layers[i] + 1)
	end

end

return NeuralNetwork