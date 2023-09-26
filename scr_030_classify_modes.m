% 
% This script performs classification of the signals using spatial DM features with L1-SVM
% 

clear variables;

% component of sDM feature matrix to use for classification
feature_type = 'edge'; % 'edge', 'network', 'both', or 'full'

% directory to load/save results
work_dir = './data';

% path to liblinear library
addpath('path-to-liblinear-library');

% load modes to classify
S_load = load(fullfile(work_dir,'modes.mat'));

% acquire spatial DM feature matrix (channel * channel for each trial)
sDMmat_trn = cellfun(@(x) modes2sDMmat(x),S_load.mode_st.trn,'UniformOutput',false);
sDMmat_val = cellfun(@(x) modes2sDMmat(x),S_load.mode_st.val,'UniformOutput',false);

% acquire components of sDM feature as a vector
vec_feat_trn = cellfun(@(x) sDMmat2vecfeat(x,feature_type),sDMmat_trn,'UniformOutput',false);
vec_feat_val = cellfun(@(x) sDMmat2vecfeat(x,feature_type),sDMmat_val,'UniformOutput',false);

% concatenate features among trials (trial * component)
vec_feat_trn = cat(1,vec_feat_trn{:});
vec_feat_val = cat(1,vec_feat_val{:});

% train liblinear model
% -s 6      : L1-regularized logistic regression
% -c 100    : cost
model = train(S_load.labels.trn,sparse(vec_feat_trn),'-s 6 -c 100');

% predict using the trained model
class_id_pred = predict(S_load.labels.val,sparse(vec_feat_val),model,'');

% evaluate (although accuracy is already shown by the pred function above)
fprintf('accuracy is %5.2f%% (rank = %d)\n',100*mean(class_id_pred==S_load.labels.val),S_load.params.svd_rank);
