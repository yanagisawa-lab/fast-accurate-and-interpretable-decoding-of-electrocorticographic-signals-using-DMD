function [ svd_st ] = stacking_dmd_preproc( X, dt, svd_rank )
% perform preprcessing of DMD (SVD) with signal stacking
% Usage:
%   [ svd_st ] = stacking_dmd_preproc( X, dt, svd_rank )
% Input:
%   X               signal (channel * time)
%   dt              sampling interval (s)
%   svd_rank        rank for SVD. if -1 is specified, full decomposition will be performed
% Output:
%   svd_st
%     .U            
%     .S            
%     .V            
%     .X2           
%     .params
%       .dt
%       .nb_elec
%       .nb_sample
%       .svd_rank
%       .nb_stack

% acquire # of channels and samples
nb_elec = size(X,1);
nb_sample = size(X,2);

% determine # of stack
nb_stack_applied = ceil((nb_sample+1)/(nb_elec+1));

% create stacked signal
Xstack = stack_signal(X,nb_stack_applied);

% create X1 and X2
X1 = Xstack(:,1:end-1);
X2 = Xstack(:,2:end);

% perform SVD
if (svd_rank==-1)
    [U,S,V] = svd(X1, 'econ');
else
    [U,S,V] = svds(X1, svd_rank);
end

% save to structure
svd_st = [];

svd_st.U = U;
svd_st.S = S;
svd_st.V = V;
svd_st.X2 = X2; % required to calculate dynamic modes

svd_st.params.dt = dt;
svd_st.params.nb_elec = nb_elec;
svd_st.params.nb_sample = nb_sample;
svd_st.params.svd_rank = svd_rank;
svd_st.params.nb_stack = nb_stack_applied;

end
