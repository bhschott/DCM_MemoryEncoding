function M = harmonic_mean(varargin)
numMatrices = nargin;
[rows, cols] = size(varargin{1});
M = zeros(rows, cols);

for i = 1:rows
    for j = 1:cols
        sumInv = 0;
        for k = 1:numMatrices
            value = varargin{k}(i, j);
            if value ~= 0
                sumInv = sumInv + (1 / value);
            end
        end
        M(i, j) = numMatrices / sumInv;
    end
end

