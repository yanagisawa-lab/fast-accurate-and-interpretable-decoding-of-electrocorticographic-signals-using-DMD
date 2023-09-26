function [ f ] = generate_signal_sech( xi, t, signal_params )
% Generate dummy signal composed of two components
%   1. sinusoidal signal with spatial distribution determined by the sech function
%   2. Gaussian noise with uniform spatial distribution
% Usage:
%   [ f ] = generate_signal_sech( xi, t, signal_params )
% Input
%   xi                      vector denoting the position of the observation point [1*(# of observation points)]
%   t                       vector representing sampling time (s) [1*(# of samples)]
%   signal_params
%     .noise_amplitude      amplitude for Gaussian noise [1*1]
%     .signal_frequnecy     frequnecy of sinusoidal signal [1*1]
%     .signal_amplitude     amplitude of sinusoidal signal [1*1]
%     .signal_phase_range   range of the initial phase of the sinusoidal signal [1*2]
% Output:
%   f                       generated signal [(# of samples)*(# of observation points)]

% generate grid of xi and t
[xi_grid,t_grid] = meshgrid(xi,t);

% determine initial phase of the sinusoidal signal
phase0 = (signal_params.signal_phase_range(2) - signal_params.signal_phase_range(1)) * rand(1,length(xi)) + signal_params.signal_phase_range(1);

% generate the sinusoidal signal
f = signal_params.signal_amplitude * sech(xi_grid) .* sin(repmat(phase0,length(t),1) + 2 * pi * signal_params.signal_frequnecy * t_grid);

% add Gaussian noise
f = f + signal_params.noise_amplitude * randn(length(t),length(xi));

end
