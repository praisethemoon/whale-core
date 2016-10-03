local LinearRegression = {}

--[[ 
  Hypothesis function
  define hypothesis function, dependent on X and theta

  @param theta vector theta  
  @param x a feature vector (a row of the design matrix)
  
  result scalar, hyp result
--]]
function LinearRegression.hyp(theta, x)
  return vsum(mT(theta)*x)
end

--[[
  Computes Linear Regression Cost
  
  @param X Design Matrix 
  @param y result Vector
  @param theta vector theta
  @param hyp hypothesis function
  
  return scalar cost of the linear regression of the given parameters
]]
function LinearRegression.cost(X, y, theta, hyp)
  local sum = 0
  -- number of elements in the dataset
  local m = #y
  -- number of features
  local n = #X
  
  for i=1,m do
    sum = sum + math.pow(((hyp(theta, X(i)) - y(i))), 2)
  end
  
  return sum*1/(2*m)
end

return LinearRegression