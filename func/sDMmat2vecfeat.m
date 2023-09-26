function [ vec_feat, sel_indices ] = sDMmat2vecfeat( sDMmat, feature_type )
% acquire specified components from spatial DM feature matrix as a vector
% Usage:
%   [ vec_feat, sel_indices ] = sDMmat2vecfeat( sDMmat, feature_type )
% Input:
%   sDMmat          spatial DM feature matrix (channel * channel)
%   feature_type    component to acuqire
%                   'edge':     spatial edge DM features (seDM features)
%                   'network':  spatial network DM features (snDM features)
%                   'both':     seDM and snDM features
%                   'full':     entire sDM features
% Output:
%   vec_feat        selected component (1 * component)
%   sel_indices     indices of the components in sDM feature matrix (1 * component)

% sDM feature matrix is always a square matrix
if (size(sDMmat,1)~=size(sDMmat,2))
    error('%s: sDM feature matrix must be a square matrix',mfilename());
end

% generate index to acquire
nb_channel = size(sDMmat,1);
switch feature_type
    case 'edge'
        % diagonal part
        sel_indices = diag(reshape([1:nb_channel^2],nb_channel,[]))';
    case 'network'
        % off-diagonal part
        sel_indices = find(triu(ones(nb_channel),1))';
    case 'both'
        % upper triangular part
        sel_indices = find(triu(ones(nb_channel),0))';
    case 'full'
        % entire matrix
        sel_indices = [1:nb_channel^2];
    otherwise
        error('%s: unknown feature_type',mfilename());
end

% acquire specified components
vec_feat = sDMmat(sel_indices);
