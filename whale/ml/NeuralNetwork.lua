--[[
	YES! Finally, neural networks.
]]

local class = require 'middleclass'


require 'scimoon.Matrix'
require 'scimoon.Vector'

local NeuralNetwork = class [[NeuralNetwork]]

local sigmoid = function (x)
  return 1 / (1 + math.exp(-x))
end


--[[
	input, output and hidden layers needs to be set manually
]]
function NeuralNetwork:initialize()
	self.input = {}
	self.output = {}
	self.layers = {}
	self.thetas = {}
end

-- forward propagation
function NeuralNetwork:fpb()
	local layers = self.layers
	table.insert(layers, 1, self.input)
	table.insert(layers, #layers+1, self.output)
	
	for i=2, #layers do
		local layer1 = vcopy(layers[i-1])
		local layer2 = layers[i]
		local theta = thetas[i-1]

		-- adding bias unit
		table.insert(layer1, 1, 1)

		assert(#theta == #layer2, "Error 1")
		assert(#(theta[1]) == (#layer1), "Error 1")

		local t = theta(i-1)
		
		local z = t*layer1
		
		layer2 = vmap(z, sigmoid)
	end
end

local s = NeuralNetwork:new()

s.input = vector{0, 0}
s.output = vector{0}

s.theta= {
	matrix{ 
		{-30, 20, 20}, 
		{10, -20, -20}},
	matrix{
		{-10, 20, 20}
		}
}

s:fpb()


















