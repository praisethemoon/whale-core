
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
    @param layers: Array of integers, where first element is the size of the first layer, etc. This does not include bias unit.
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
        self.theta[i] = randomMatrix(#self.layers[i+1], #self.layers[i] +1 )
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
    printVector(x)
    printVector(self.layers[1])
    assert(#self.layers[1] == #x)
    self.layers[1] = vcopy(x)
    table.insert(self.layers[1], 1, 1)

    
    local z = self:forwardPropagation()
    return self:backPropagation(z, y)
end

--[[
     Performs forward propagation algorithm.
     returns z which is a table of all Z(i) where Z(i) = Theta(i-1)*a(i-1)
]]
function NeuralNetwork:forwardPropagation()
    local z = {}

    -- must not do this for h(x)
    for i = 2, #self.layers-1 do
		--print(i)
        z[i] = ((self.theta[i-1])) * self.layers[i-1]
        self.layers[i] = sigmoid(z[i])
        -- adding bias unit
        table.insert(self.layers[i], 1, 1)
    end

    -- final layer
    local i = #self.layers
    z[i] = ((self.theta[i-1])) * self.layers[i-1]
    self.layers[i] = sigmoid(z[i])

    --printVector(self.layers[#self.layers])

    return z
end

--[[
    Performs forward propagation.
    @param z list Z(i) returned by forwardPropagation
    @param y class result of the given training example for forwardPropagation
    returns Delta(l)
]]
function NeuralNetwork:backPropagation(z, y)
    local d = {}
    
    d[#self.layers] = self.layers[#self.layers] - y
    
    for i = #self.layers-1, 2,-1 do
        -- removing bias terms from theta
        --local theta = mcopy(self.theta[i])
        print(i)
        table.insert(z[i], 1, 1)
        
        local dtemp = d[i+1]
        if dtemp.type == "vector" then
            dtemp = mT(dtemp)
        end

        printMatrix(self.theta[i])
        d[i] = mewmult( dtemp*self.theta[i], vewmult(z[i], (1-z[i])) )
    end
	    
    return d
end

--[[
    Static function 
    Computes Neural Network cost.
    @param nn NeuralNetwork object
    @param X design matrix
    @param y vector of classes where y[i] is similar to {0, 0, 1, 0}
    @param n number of classes
]]
function NeuralNetwork.cost(nn, X, y, n)
    local D = vector({}, #nn.layers, 0)
    local m = #X
    
    for i = 1, m do
        local d = nn:trainSample(X[i], y[i])

        for l = 1, #nn.layers-1 do
            print("d:")
            printVector(d[l+1])
            print("a:")
            printVector(nn.layers[l])
            D[l] = D[l] + mT(d[l+1])*(nn.layers[l])
        end
    end

end

-- returning object
return NeuralNetwork