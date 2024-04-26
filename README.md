# Locally Stationary Graph Processes Learning Algorithm

This repository provides a MATLAB-based framework for learning the parameters of Locally Stationary Graph Processes (LSGP) from datasets with missing entries. It implements the method described in Algorithm 1 of [[1]](#1) and includes a template to estimate these parameters using the provided Molene dataset.

## Requirements

- **MATLAB**: Tested on MATLAB R2022b Update 7.
- **CVX for MATLAB**: Required for optimization routines. See [CVX Installation Guide](http://cvxr.com/cvx/doc/install.html) for setup instructions.
- **Operating System**: Windows 11.


## Repository Structure

### Scripts and Functions

- `load_func.m`: Loads necessary function files. Assumes CVX is already set up.
- `datasetCreate.m`: Generates datasets with missing entries from provided input data. Outputs files in `mat_files/Output/X/MissingEntryType/` detailing the datasets with their respective missing entry configurations.
- `KQValidation.m`: Evaluates the best K and Q pairs for the estimation of missing entries. Outputs validation results in `mat_files/Output/X/MissingEntryType/validParameters/` including error metrics and optimal K, Q values.
- `muValidation.m`: Optimizes $\mu_1, \mu_2, \mu_3$ parameters based on the K, Q values determined by `KQValidation.m`. Results, including error metrics and optimal $\mu$ values, are saved in `mat_files/Output/X/MissingEntryType/findLSPcov/`.

### Directories

- **Functions**: Contains auxiliary functions used by the main scripts.
- **log**: Stores log files generated during the validation processes.
- **mat_files**: Houses the input and output datasets, including `meta_data_molene.mat` used for demonstration.

## Data Structure and Workflow

This section describes the data structure and the workflow of scripts within the repository, focusing on handling datasets named "X". These datasets are assumed to be stored in the `mat_files/Input/X/meta_data_X.mat` with the following structure:

- `m`: A struct containing all necessary information for the dataset:
  - `m.N`: Number of graph nodes.
  - `m.T`: Number of realizations.
  - `m.signal`: An \(m.N \times m.T\) matrix representing the graph signal.
  - `m.lambda`: Eigenvalues of the graph laplacian.
  - `m.laplacianMat`: Laplacian matrix of the graph.
  - `m.weightMat`: Weight matrix of the graph.

### Processing Datasets

#### Dataset Creation

`datasetCreate.m` processes the input dataset to simulate missing entries. It generates a series of output files in `mat_files/Output/X/MissingEntryType/`, named as `X_dataset_noise_type_MissingEntryType_numData_n.mat`, based on the number of data configurations specified in the [Configuration Files](#configuration-files).

**Output Structure**:
- `saveCell`: A cell array (Sweep Number, 1) that stores essential data for each dataset configuration:
  - `saveCell{i}.trainInfo`: Vector containing information on swept variables.
  - `saveCell{i}.dataStruct`: Contains the dataset with NaN values and a mask defining train, validation, and test splits:
    - `saveCell{i}.dataStruct.mask`: (0: test, 1: train, 2: validation). Setting this mask to ones(m.N, m.T) will use all data for model estimation. Please use with caution because it may cause some errors since the scripts are based on the assumption that the missing entries are present.

#### Validation of K and Q Parameters

`KQValidation.m` takes the output from `datasetCreate.m` and identifies the optimal K and Q values for the missing entries estimation.

**Generated File**:
- `mat_files/Output/X/MissingEntryType/validParameters/Q_Cl_choose_X_noise_type_MissingEntryType_cov_typeCovarianceType_numData_n.mat`:
  - `saveCell`: Contains validation outputs for each K, Q pair.
  - `saveCell{i}` includes:
    - `saveCell{i}.Q`: Optimal Q value.
    - `saveCell{i}.Cl`: Optimal K value.
    - `saveCell{i}.QClError`: Error matrix for parameter combinations.
    - `saveCell{i}.dataStruct.RxBulk`: Covariance matrix estimated, ignoring the missing entries.

#### μ Parameter Validation

`muValidation.m` requires the three `.mat` files mentioned above to optimize the μ parameters based on the K and Q values determined by `KQValidation.m`.

**Output File**:
- `mat_files/Output/X/MissingEntryType/findLSPcov/LSP_cov_X_noise_type_MissingEntryType_cov_typeCovarianceType_numData_n.mat`:
  - `saveCell`: Details the validation results for μ parameters.
  - `saveCell{i}` provides:
    - `saveCell{i}.error`: Error for the best μ parameters.
    - `saveCell{i}.dataStruct` includes:
      - `saveCell{i}.dataStruct.RxBulk`: As outputted by `KQValidation.m`.
      - `saveCell{i}.dataStruct.RxFound`: Covariance matrix from the best LSGP model.
      - `saveCell{i}.dataStruct.Gamma`: Second-order membership matrix.
      - `saveCell{i}.dataStruct.B`: Second-order filter parameter matrix.
    - `saveCell{i}.regStruct`: Contains the search iterations for μ parameters:
      - `saveCell{i}.regStruct.mu`: Best tuple of μ parameters.
      - `saveCell{i}.regStruct.optimal_f`: Optimal function value.
      - `saveCell{i}.regStruct.xVector`: Values of μ parameters over iterations.
      - `saveCell{i}.regStruct.fVector`: Function values corresponding to the μ values.

For detailed information on the structure and purpose of each configuration file, refer to the [Configuration Files](#configuration-files) section.

<!-- 
## Data Structure

Let us say we have a dataset named "X". The data for X will be included in mat_files folder. This project assumes that this data is in mat_files/Input/X/meta_data_X.mat with the following structure

* m: Struct containing all necessary information.
* m.N: Number of graph nodes
* m.T: Number of realizations
* m.signal: m.N x m.T graph signal matrix
* m.lambda: Eigenvalues of the underlying graph with size (1, m.N)
* m.laplacianMat: Laplacian matrix of the underlying graph
* m. weightMat: Weight matrix of the underlying graph

Once datasetCreate.m ran for the dataset X it generates series of files (by number of numData see [Configuration Files](#configuration-files)) mat_files/Output/X/MissingEntryType/X_dataset_noise_type_MissingEntryType_numData_n.mat. This file is required by KQValidation.m and muValidation.m. Contents of this file can be given by following 

* saveCell: (Sweep Number, 1) cell containing the necessary information (See [Configuration Files](#configuration-files) for Sweep Number)

and the required contents of the saveCell{i} can be given as

* saveCell{i}.trainInfo: (1, Sweep Number) vector containing information on swept variable
* saveCell{i}.dataStruct: Data structure containing mask and the data with NaN values.

Required content for saveCell{i}.dataStruct is

* saveCell{i}.dataStruct.mask: A mask showing train/validation/test location accross the dataset. (0: test, 1: train, 2: validation).

If all of the data will be used to estimate the LSGP model, then let saveCell{i}.dataStruct.mask = ones(m.N, m.T). Please note that this might create errors with estimateUnknownNew function. This function can be modified to get meaningful results for the metric specified by estimateUnknownNew. See [Parameter Estimation](#parameter-estimation) for more details.

If these parameters are given to KQValidation.m, the code produces the file mat_files/Output/X/MissingEntryType/validParameters/Q_Cl_choose_X_noise_type_MissingEntryType_cov_typeCovarianceType_numData_n.mat, which usually contains the following information:

* saveCell: (Sweep Number, 1) cell containing output information on validation procedure of variables K,Q

and the contents of the saveCell{i} are

* saveCell{i}.Q: This is the Q giving the best error returned by estimateUnknownNew for ith dataset
* saveCell{i}.Cl: This is the K giving the best error returned by estimateUnknownNew for ith dataset
* saveCell{i}.QClError: (param.MAX_Cl, param.MAX_Q) matrix containing errors given by estimateUnknownNew. See [Configuration Files](#configuration-files) for details of param struct.
* saveCell{i}.dataStruct: A structure containing data related information

Content of dataStruct is

* saveCell{i}.dataStruct.RxBulk: A covariance matrix estimated by the chosen estimation method param.covType ignoring the missing entries

Note that this validation step may be skipped by creating the file mat_files/Output/X/MissingEntryType/validParameters/Q_Cl_choose_X_noise_type_MissingEntryType_cov_typeCovarianceType_numData_n.mat and filling in the necessary information Q, Cl, dataStruct.RxBulk for each variable that is swept.

For muValidation, all 3 .mat files we specified above are needed. Upon successful execution, muValidation.m produces the following in file mat_files/Output/X/MissingEntryType/findLSPcov/LSP_cov_X_noise_type_MissingEntryType_cov_typeCovarianceType_numData_n.mat:

* saveCell: (Sweep Number, 1) cell containing output information on validation procedure of variables $\mu_1, \mu_2, \mu_3$.

and the contents of saveCell{i} are

* saveCell{i}.error: Error returned by estimateUnknownNew.m for best parameters.
* saveCell{i}.dataStruct:  A struct containing input and output data related information which contains the following information:
    * saveCell{i}.dataStruct.RxBulk: Same as saveCell{i}.dataStruct.RxBulk given as output of KQValidation.m
    * saveCell{i}.dataStruct.RxFound: Covariance matrix found by the best LSGP model
    * saveCell{i}.dataStruct.Gamma: Second order membership matrix, see [[1]](#1) for details.
    * saveCell{i}.dataStruct.B: Second order filter parameter matrix, see [[1]](#1) for details
* saveCell{i}.regStruct: A struct containing parameter search iterations of $\mu_1, \mu_2, \mu_3$.
    * saveCell{i}.regStruct.mu: Optimal $\mu_1, \mu_2, \mu_3$ tuple
    * saveCell{i}.regStruct.optimal_f: Optimal cost function value found by the parameter search algorithm
    * saveCell{i}.regStruct.xVector: (Iteration number, 3) vector of swept values of $\mu_1, \mu_2, \mu_3$. See [Configuration Files](#configuration-files) for Iteration number.
    * saveCell{i}.regStruct.fVector: (Iteration number, 1) vector of swept values of cost function corresponding to saveCell{i}.regStruct.xVector
    * saveCell{i}.mode: String denoting the parameter search algorithm -->

## Configuration Files

Configuration files are located under the directory `Functions/config_func` and are used to set up the experimentation parameters, divided into four categories: a template for configuration, general parameters for the LSGP learning algorithm, experiment-specific parameters, and application-specific configuration.

### Configuration Template

**Function**:
- `createConfigFunc.m`: Concatenates the experimental parameters.
    - **Input**: Application-specific configuration function handle `expFunc`.
    - **Output**: Experiment parameters struct `param`.

**Variables**:
- `iscreateDataset`: If `true`, bypasses experiment-specific configuration. Add user-specific function to the list if needed.
- `iscreateMeta`: If `true`, bypasses general parameters and experiment-specific configuration. Add user-specific function to the list if needed.
- `param.datasetType`: Name of the dataset "X", scripts will look into `mat_files/Input/X` and `mat_files/Output/X`.

### General Configuration Variables

**Function**:
- `generalParamsFunc.m`: Specifies general variables for experimentation.
    - **Output**: Experiment parameters struct `param`.

**Variables**:
- `param.maskType`: Defines the type of missing entry (values between 0-5). Used by `datasetCreate.m` to create a dataset given a type. Modify `datasetCreate.m` to introduce custom data loss.
    - `0`: SaltPepper - Random data loss as in [[1]](#1). Ratio of training entries specified by `param.trainArray`.
    - `1`: NewSinglePointMissing - Data loss at some nodes for all realizations. Train ratio determines what percentage of entries will be lost.
    - `2`: NeighborhoodMissing - Structured data loss as in [[1]](#1). Number of neighborhoods missing is specified by `param.trainArray`.
    - `3`: OldSinglePointMissing - Similar to NewSinglePointMissing but the training + validation + test split is the same for all realizations.
    - `4`: AWGN - Additive White Gaussian Noise added to entries. Noise power specified by `param.trainArray`.
    - `5`: None - Constructs LSGP realizations from m.b (Q,K) array and m.g (N,K) array specified in `meta_data_X.mat`.
- `param.trainArray`: Array used to specify the sweep number for the experiments.
- `param.numData`: Number of data sets.

### Experiment Specific Configuration Variables

**Function**:
- `experimentParamsFunc.m`: Specifies variables specific to an experimentation.
    - **Output**: Experiment parameters struct `param`.

**Variables**:
- `param.covType`: Specifies the method for covariance estimation (values between 0-4). Used by `KQValidation.m` to estimate covariance matrix.
    - `0`: Sample Covariance - Simple estimator ignoring missing correlations. May not yield positive eigenvalues.
    - `1`: Label Propagation - Fill missing values with label propagation algorithm as in [[2]](#2) and calculates the covariance matrix.
    - `2`: Corrected - Sparse correction of covariance values from Sample Covariance as specified in [[3]](#3)
    - `3`: Linear Interp -  Interpolate the node entries from neighbors and calculate Sample Covariance
    - `4`: Matlab Covariance - Uses MATLAB cov function to estimate Sample Covariance
- `MAX_ITERS`: Number of iterations for alternating optimization in [[1]](#1). Each update of the ($\Gamma$, B) tuple counts as 2 iterations.
- `param.MAX_Q`: Maximum Q value, used by `KQValidation.m`.
- `param.MAX_Cl`: Maximum K value, used by `KQValidation.m`.
- `param.numDataArray`: Specifies multiple realization of missing entries for running the simulation only for the values in this array.

### Application Specific Configuration

In some cases, additional parameters may be necessary for further experimentation. This section introduces the functions inputted as `expFunc` to `createConfigFunc.m`.

#### Dataset Creation

**Function**:
- `createDatasetFunc.m`: An empty function for compatibility.

#### Validation of K and Q Parameters

**Function**:
- `validParametersFunc.m`: Specifies additional parameters for the validation of K and Q parameters.

**Variables**:
- `mu_two, mu_three, mu_four`: $\mu_1, \mu_2, \mu_3$ kept constant throughout K, Q validation respectively.

#### μ Parameter Validation

**Function**:
- `findLSPCovParamsFunc.m`: Specifies additional parameters for $\mu$ parameter validation. Modify `gridAlternating.m` to introduce a new search algorithm for $\mu$ parameter search.

**Variables**:
- `param.lineParams.eps1, eps2, eps3`: Used for backward compatibility where line search was employed.
- `param.lineParams.max_iter`: Maximum iterations for the line search.
- `param.lineParams.gridInterval`: A (3,2) vector specifying the initial and final grid points for $\mu_1, \mu_2, \mu_3$ respectively.
- `param.lineParams.gridNums`: A (3,1) vector specifying the number of sampled points for each variable.


## Adding Different Functionalities

This section explains how to modify the main functions to create different scenarios and adapt the project to specific needs.

### Covariance Estimator

The script includes five predefined covariance estimators located in `allRxCalculator.m`. You are encouraged to extend this by adding new estimators.

**To Change**:
1. Add your estimator code to `allRxCalculator.m`.
2. Integrate the new estimator by updating `experimentParamsFunc.m` to include:
   - `covCell` ← New `CovarianceType`

### Validation Metric Specification

The current validation metric is the Mean Squared Error (MSE) of the estimation of variables. To use a different comparison metric, such as the cost of the optimization function:

**Procedure**:
1. Modify `estimateUnknownNew.m` to implement the new metric.
2. Ensure the output error, `err`, includes `err.rnmse`, which is the metric used for the algorithm.

### μ Parameter Search

The default search method for finding the optimal tuples $\mu_1, \mu_2, \mu_3$ is a grid search. To adopt a different parameter search method:

**Procedure**:
1. Replace the search algorithm in `gridAlternating.m`.
2. Adjust the output structure `saveStruct` to include:
   - `f_opt`: Optimal function value found.
   - `x_opt`: Optimal values of $\mu$ parameters.
   - `fVector`: Function values for each iteration.
   - `xVector`: Parameter values for each iteration.

These changes allow for greater flexibility and customization of the project to suit diverse research and experimental needs.


## Acknowledgements

I am grateful for the assistance provided by ChatGPT in refining the documentation of this project. The detailed responses and helpful suggestions were instrumental in enhancing the clarity and comprehensiveness of our README file.

## References
<a id="1">[1]</a> 
A. Canbolat and E. Vural, “Locally stationary graph processes,”
arXiv preprint arXiv:2309.01657, 2023.

<a id="2">[2]</a>
D. Zhou, O. Bousquet, T. N. Lal, J. Weston, and B. Sch€olkopf,
“Learning with local and global consistency,” in Proc. 16th Int.
Conf. Neural Inf. Process. Syst., 2003, pp. 321–328.

<a id="3">[3]</a>
K. Lounici, “High-dimensional covariance matrix estimation with missing observations,” Bernoulli, vol. 20, no. 3, pp. 1029 – 1058, 2014.