% 
% This script generates sample data under ./signals
% 

clear variables;

% amplitude of the sinusoidal signal for condition 1 and 2
amp_cond1 = 1.0;
amp_cond2 = 0.5;


% # of trials (of each condition) for training and evaluation
trial_num_trn = 100;
trial_num_val = 100;

% sampling rate
sampling_rate = 1000;

% position of observation points
xi = [-20:1:20];
% time for observation (0-500 ms)
t = [0:499] / 1000;

% directory to save results
work_dir = './data';

% add path to func_generate_signal_sech
addpath('func');

% fix seed
rng(0);

% prepare common parameters to generate signals
signal_params = [];
signal_params.noise_amplitude       = 1.0; % amplitude of the Gaussian noise
signal_params.signal_frequnecy      = 100; % frequnecy of sinusoidal signal
signal_params.signal_amplitude      = []; % (To be set) amplitude of sinusoidal signal
signal_params.signal_phase_range    = [-1/6 1/6] * pi; % range of the initial phase of the sinusoidal signal

% generate signals for training
signals_trn_cond1 = cell(1,trial_num_trn);
signals_trn_cond2 = cell(1,trial_num_trn);
for trial_i=1:trial_num_trn
    signal_params.signal_amplitude = amp_cond1;
    signals_trn_cond1{trial_i} = generate_signal_sech(xi,t,signal_params);
    signal_params.signal_amplitude = amp_cond2;
    signals_trn_cond2{trial_i} = generate_signal_sech(xi,t,signal_params);
end
signals_trn = [signals_trn_cond1 signals_trn_cond2];

% generate signals for evaluation
signals_val_cond1 = cell(1,trial_num_val);
signals_val_cond2 = cell(1,trial_num_val);
for trial_i=1:trial_num_val
    signal_params.signal_amplitude = amp_cond1;
    signals_val_cond1{trial_i} = generate_signal_sech(xi,t,signal_params);
    signal_params.signal_amplitude = amp_cond2;
    signals_val_cond2{trial_i} = generate_signal_sech(xi,t,signal_params);
end
signals_val = [signals_val_cond1 signals_val_cond2];

% label for the training and evaluation signals
% 1: condition 1; 2: condition 2
labels_trn = [zeros(trial_num_trn,1) ; ones(trial_num_trn,1)] + 1;
labels_val = [zeros(trial_num_val,1) ; ones(trial_num_val,1)] + 1;

% save generated signals
S_save = [];
S_save.signals.trn  = signals_trn;
S_save.signals.val  = signals_val;
S_save.labels.trn   = labels_trn;
S_save.labels.val   = labels_val;
S_save.params                           = rmfield(signal_params,'signal_amplitude');
S_save.params.t                         = t;
S_save.params.xi                        = xi;
S_save.params.signal_amplitude_cond1    = amp_cond1;
S_save.params.signal_amplitude_cond2    = amp_cond2;

if exist(work_dir,'dir')~=7
    mkdir(work_dir);
end
save(fullfile(work_dir,'signals.mat'),'-v7.3','-struct','S_save');
