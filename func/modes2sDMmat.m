function [ sDMmat ] = modes2sDMmat( mode_st )
% convert mode structure to spatial DM feature matrix
%   [ sDMmat ] = modes2sDMmat( mode_st )
% Input:
%   mode_st         structure containing modes
% Output:
%   sDMmat          sDM feature matrix (channel * channel)

% L2-normalise
% vecnorm function is available only for Matlab R2017b or later
norm_modes = mode_st.phi ./ repmat(sqrt(sum(abs(mode_st.phi).^2,1)),[size(mode_st.phi,1) 1]);

% convert to spatial DM features
sDMmat = norm_modes * norm_modes';

% dispose imaginary part caused by computational error
sDMmat = real(sDMmat);

end
