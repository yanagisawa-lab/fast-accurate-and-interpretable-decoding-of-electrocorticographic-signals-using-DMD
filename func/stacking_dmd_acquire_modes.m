function [ mode_st ] = stacking_dmd_acquire_modes( svd_st, dmd_rank )
% calculate dynamic modes from SVD components
% Usage:
%   [ mode_st ] = stacking_dmd_acquire_modes( svd_st, dmd_rank )
% Input:
%   svd_st          
%   dmd_rank        # of SVD components to use
%                   specify -1 to use all components
% Output:
%   mode_st
%     .phi          dynamic modes (channel * dmd_rank)
%     .lambda       (dmd_rank * 1)
%     .omega        (dmd_rank * 1)
%     .freq         (dmd_rank * 1)
%     .r            decay/growth rate (dmd_rank * 1)
%     .phi_full     (stacked channel * dmd_rank)

% acquire SVD components to calculate dynamic modes
if (dmd_rank==-1)
    % to caluclate dynamic modes using all SVD components, SVD must be performed with full rank
    if (svd_st.params.svd_rank~=-1)
        error('%s: svd_st do not contain full SVD components',mfilename());
    end
    Ur = svd_st.U;
    Sr = svd_st.S;
    Vr = svd_st.V;
else
    % acquire first dmd_rank SVD components
    Ur = svd_st.U(:, 1:dmd_rank); 
    Sr = svd_st.S(1:dmd_rank, 1:dmd_rank);
    Vr = svd_st.V(:, 1:dmd_rank);
end
% X2 is not affected by dmd_rank
X2 = svd_st.X2;
% neither, dt
dt = svd_st.params.dt;

% calculate dynamic modes
Atilde = Ur'*X2*Vr/Sr;
[W, D] = eig(Atilde);
Phi = X2*Vr/Sr*W; % dynamic modes

% calculate lambda/omega
lambda = diag(D);
omega = log(lambda)/dt;

mode_st = [];
mode_st.phi         = Phi(1:svd_st.params.nb_elec,:); % first nb_elec dynamic modes corresponding to the original signal
mode_st.lambda      = lambda;
mode_st.omega       = omega;
mode_st.freq        = abs(imag(omega)/(2*pi));
mode_st.r           = abs(lambda).^(1/dt);
mode_st.phi_full    = Phi; % dynaic modes corresponding to the stacked signal

end
