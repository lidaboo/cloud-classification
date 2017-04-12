function g = sigmoid(z)
%Computes the sigmoid functoon

	g = 1.0 ./ (1.0 + exp(-z));
end
