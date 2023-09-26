% 
% This script caluculates modes from the generated signals
% 

clear variables;

% rank for SVD (which becomes # of dynamic modes acuired for each trial)
svd_rank = 2;

% directory to load/save results
work_dir = './data';

% load signals
S_load = load(fullfile(work_dir,'signals.mat'));

% interval of samples
dt = S_load.params.t(2) - S_load.params.t(1);

% calculate modes (training)
mode_st_trn = cell(1,length(S_load.signals.trn));
for trial_i=1:length(S_load.signals.trn)
    % perform SVD with signal stacking
    svd_st = stacking_dmd_preproc(S_load.signals.trn{trial_i}',dt,svd_rank);
    % caluclate modes
    mode_st_trn{trial_i} = stacking_dmd_acquire_modes(svd_st,svd_rank);
end

% calculate modes (evaluation)
mode_st_val = cell(1,length(S_load.signals.val));
for trial_i=1:length(S_load.signals.val)
    % perform SVD with signal stacking
    svd_st = stacking_dmd_preproc(S_load.signals.val{trial_i}',dt,svd_rank);
    % caluclate modes
    mode_st_val{trial_i} = stacking_dmd_acquire_modes(svd_st,svd_rank);
end

% delete phi_full to reduce result file size
mode_st_trn = cellfun(@(x) rmfield(x,{'phi_full'}),mode_st_trn,'UniformOutput',false);
mode_st_val = cellfun(@(x) rmfield(x,{'phi_full'}),mode_st_val,'UniformOutput',false);

% save
S_save = [];
S_save.mode_st.trn      = mode_st_trn;
S_save.mode_st.val      = mode_st_val;
S_save.labels           = S_load.labels;
S_save.params           = S_load.params;
S_save.params.svd_rank  = svd_rank;

save(fullfile(work_dir,'modes.mat'),'-v7.3','-struct','S_save');
