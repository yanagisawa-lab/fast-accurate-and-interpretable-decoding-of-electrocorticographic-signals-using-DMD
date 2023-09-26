function Y = stack_signal( X, nb_stack )
% stack signal
% Usage:
%   Y = stack_signal(X, nb_stack)
% Input:
%   X           signal (channel * time)
%   nb_stack    number of stack
% Output:
%   Y           stacked signal (stacked channel * time)

Y = cell(1,nb_stack);

for i=1:nb_stack
    Y{i} = X(:,i:end-(nb_stack-i));
end
Y = cat(1,Y{:});

end