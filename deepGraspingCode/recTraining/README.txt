Files with parameters:

             runSAEMultiSparse includes parameters for pre-training the first
             layer weights

             runSAEBinary includes parameters for pre-training the second layer
             weights
             
             runBackpropMultiReg includes some parameters for back-propagation,
             mostly related to optimization. Cost function parameters are in
             the following two functions:

             softmaxInitCost includes parameters for the initialization
             phase of back-prop where only the softmax classifier weights
             are changing

             softmaxBackpropCostMultiReg includes parameters for the full
             back-propagation where all weights are changing.

             All parameter sets include a weight for an L1 regularization term.
             For SAE pretraining, there will also be a weight to the hidden
             unit sparsity term. For back-prop, there will be a weight to L2
             regularization of the classifier weights. For any function
             involving multimodal regularization, there will be an additional
             weight to that term.

             Some functions may include additional numerical parameters, which
             probably don't need to be changed.
