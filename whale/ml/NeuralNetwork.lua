
local class = require 'middleclass'

-- Creating class
local NeuralNetwork = class [[NeuralNetwork]]


require 'whale.Matrix'
require 'whale.Vector'

local table = table

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
    Creates an empty Neural Network 
    @param layers: Array of integers, where first element is the size of the first layer, etc.
]]
function NeuralNetwork:initialize(layers)
    self.layers = {}
    self.theta = {}
    
    -- creating layers a(i, j)
    for i, v in ipairs(layers) do
        self.layers[i] = vector(nil, layers[i])
		--[[
		printVector(self.layers[i])
		print("----------------") 
		]]
    end
    
    -- creating theta matricies
    -- matrix theta should not be zero! rather, it should be close to zero
    for i = 1, #self.layers - 1 do
		-- not adding +1 because we assume bias unit is considered
        self.theta[i] = randomMatrix(#self.layers[i+1], #self.layers[i] --[[ +1 ]])
		--[[
		printMatrix(self.theta[i])
		print("----------------")
		]]
    end
    
end

--[[
    Trains for only one example where X is a vector.
    @param x: feature vector
    @param y: class
]]

function NeuralNetwork:trainSample(x, y)
    --assert(type(X) == "vector")
    assert(#self.layers[1] == #x)
    self.layers[1] = x
    
    self:forwardPropagation()
    self:backPropagation(y)
end

function NeuralNetwork:forwardPropagation()
    for i = 2, #self.layers do
		print(i)
        local zi = (self.theta[i-1]) * self.layers[i-1]
        self.layers[i] = sigmoid(zi)
    end
end

function NeuralNetwork:backPropagation(y)
    local d = vector(nil, #self.layers, 0)
    
    d[#self.layers] = self.layers[#self.layers] - y
    
    for i = #self.layers-1, 2 do
        d[i] = ewmult( mt(self.theta[i])*d[i+1], (self.layers[i] * (1-self.layers[i])))
    end
	
	d[1] = 0
	print(d[2])
    
end


-- returning object
return NeuralNetwork	