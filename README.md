# Fast, accurate, and interpretable decoding of electrocorticographic signals using dynamic mode decomposition

This project contains functions and sample scripts to acquire spatial dynamic mode (sDM) features and classify them.

## Getting Started

### Prerequisites

- Matlab
- LIBLINEAR for Matlab (https://www.csie.ntu.edu.tw/~cjlin/liblinear/)

The codes are tested with Matlab R2017b and LIBLINEAR 1.8.

### Installing

Download the entire repository.


## Running the tests

For the test scipts, modify the following line in scr_030_classify_modes.m so that mex files are visible from Matlab on your environment.
```
addpath('path-to-liblinear-library');
```

Then, run the script files in following order:


```
% generate test signals
scr_010_generate_signals

% calculate modes
scr_020_calculate_modes

% classify modes by L1-SVM
scr_030_classify_modes
```

## Dependency

* [Matlab](http://jp.mathworks.com/) - Calculation of dynamic modes
* [LIBLINEAR](https://www.csie.ntu.edu.tw/~cjlin/liblinear/) - Classification of dynamic modes

## License

To be determined.

## Acknowledgments

