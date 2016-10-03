require 'whale.Matrix'
require 'whale.Vector'

local LinearRegression = require 'whale.ml.LinearRegression'
local LogisticRegression = require 'whale.ml.LogisticRegression'


--[[
  computes gradient descent 
  @param X design matrix
  @param y result vector
  @param alpha learning rate
  @param n_iter number of iterations
  @param hyp hypethsis function to use (dependent of theta and x which is a feature vector )
  @param costFn cost function to use
  
  return [theta, costJ] optimal theta and the various costs of J until the optimal value
]]
function GradientDescent(X, y, theta, alpha, n_iter, hyp, costFn)

  -- number of elements in the dataset
  local m = #y
  -- number of features
  local n = #X(1)
  
  local costJ = vector({}, n_iter)
  local line = fillVector(1,n_iter)
  
  for w=1, n_iter do
  
    local t = vcopy(theta)
    --printVector(t)
    for j=1,#theta do
    
      local sum = 0
      sum = 0
      for i=1,m do
        sum = sum + ((hyp(theta, X(i))) - y(i))*X(i, j)
      end

      t[j] = t[j] - alpha*(1/m)*sum
    end
    theta = t
    
    costJ[w] = costFn(X,y,theta, hyp)
  end
  return theta, costJ  
end

function RegularizedGradientDescent(X, y, theta, alpha, lambda, n_iter, hyp, costFn)
  -- number of elements in the dataset
  local m = #y
  -- number of features
  local n = #X(1)
  
  local costJ = vector({}, n_iter)
  local line = fillVector(1,n_iter)
  
  for w=1, n_iter do

    local t = vcopy(theta)
    --printVector(t)

    -- first iteration for theta[1]
    --for j=1,1 do
      local sum = 0
      sum = 0
      for i=1,m do
        sum = sum + ((hyp(theta, X(i))) - y(i))*X(i, 1) 
      end

      t[1] = t[1] - alpha*(1/m)*sum
    --end

    for j=2,#theta do
    
      local sum = 0
      sum = 0
      for i=1,m do
        sum = sum + ((hyp(theta, X(i))) - y(i))*X(i, j) 
      end

      t[j] = t[j] - alpha*(1/m)* (sum + (lambda/m)*theta(j))
    end
    theta = t
    
    costJ[w] = costFn(X,y,theta, hyp)
  end
  return theta, costJ  
end

function LinearGradientDescent(X, y, theta, alpha, n_iter)
  return GradientDescent(X,y,theta,alpha,n_iter,LinearRegression.hyp,LinearRegression.cost)
end

function LogisticGradientDescent(X, y, theta, alpha, n_iter)
  return GradientDescent(X,y,theta,alpha,n_iter,LogisticRegression.hyp,LogisticRegression.cost)
end













