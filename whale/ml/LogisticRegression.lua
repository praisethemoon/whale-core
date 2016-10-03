local LogisticRegression = {}

--[[ 
  Hypothesis function
  define hypothesis function, dependent on X and theta

  @param theta vector theta  
  @param x a feature vector (a row of the design matrix)
  
  result scalar, hyp result
--]]
function LogisticRegression.hyp(theta, x)
  return 1 / (1 + math.exp(-vsum(mT(theta)*x)))
end

--[[
  Computes Linear Regression Cost
  
  @param X Design Matrix 
  @param y result Vector
  @param theta vector theta
  @param hyp hypothesis function
  
  return scalar cost of the linear regression of the given parameters
]]
function LogisticRegression.cost(X, y, theta, hyp)
  local sum = 0
  -- number of elements in the dataset
  local m = #y
  
  for i=1,m do
    local h = hyp(theta, X(i))
    sum = sum + (-y(i) * math.log(h) - (1-y(i))*math.log(1 - h))
  end
  
  return 1/m * sum
end

return LogisticRegression