% Back-propagates recognition error for a pre-trained two-layer deep net,
% adding a third classification layer. This layer is trained alone for a 
% few iterations before the lower-layer weights are unfrozen.
%
% Includes both L1 and structured regularization terms on hidden layer 
% weights, and L1 and L2 penalties on classifier weights.
% 
% Runs classification on training and test set every few iterations and
% reports accuracy, to aid in tuning.
%
% Although grasping is a two-class problem, this code uses softmax
% regression/classification. This doesn't cause any problems for two
% classes, but would allow it to be used for multiclass problems as well.


% Based on code provided by Ruslan Salakhutdinov and Geoff Hinton, which
% comes with the following notice:
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our
% web page.
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.
%
% Original Salakhutdinov/Hinton code available at: 
% http://www.cs.toronto.edu/~hinton/MatlabForSciencePaper.html


% Need to add a small 'epsilon' to the inputs to softmax to avoid
% divide-by-zero errors
SOFTMAX_EPS = 1e-6;

% Number of training epochs to run. Each of these will consist of a number
% of training iterations (set below), followed by a report of the current
% accuracy
%
% Lowering this value will perform "early stopping," which may help combat
% overfitting for some problems
maxepoch=15;

% Number of epochs to train just the top-level classifier weights, keeping
% others fixed. This helps to keep the low-level weights from being skewed
% when the top-level weights are still mostly random.
INIT_EPOCHS = 5;

numclasses=size(trainClasses,2);

% Configure minFunc. L-BFGS typically gives the best performance. MaxIter
% will change the number of iterations of L-BFGS run for each training
% epoch
options.Method = 'lbfgs';
options.MaxFunEvals = Inf;
options.MaxIter = 10;

testbatchdata = testData;
testbatchtargets = testClasses;
batchdata = trainData;
batchtargets = trainClasses;

numdims = size(trainData,2);
numbatches = 1;
numcases = size(batchdata,1);
N=numcases; 

% Initialize hidden layer weights from pretrained values
load ../weights/graspWL1
w1 = W;

load ../weights/graspWL2
w2 = W;

% Randomly initialize classifier weights
w_class = 0.01*randn(size(w2,2)+1,numclasses);
 
% Record layer sizes and do some other setup
l1=size(w1,1)-1;
l2=size(w2,1)-1;
l3=size(w_class,1)-1;
l4=numclasses; 
test_err=[];
train_err=[];

% Main training loop
for epoch = 1:maxepoch

    % Compute training error
    err=0; 
    err_cr=0;
    counter=0;
    [numcases numdims numbatches]=size(batchdata);
    N=numcases;
    
    % Add up error for each batch (although the grasping code only makes 1
    % batch since the data is small enough)
    for batch = 1:numbatches
        data = [batchdata(:,:,batch)];
        target = [batchtargets(:,:,batch)];
        
        % Add bias to data
        data = [data ones(N,1)];
        
        % Forward-prop through network
        w1probs = 1./(1 + exp(-data*w1)); w1probs = [w1probs  ones(N,1)];
        w2probs = 1./(1 + exp(-w1probs*w2)); w2probs = [w2probs ones(N,1)];
        
        % Compute softmax classification
        targetout = exp(w2probs*w_class);
        targetout = targetout./repmat(sum(targetout,2),1,numclasses);
        
        % Compare predicted and ground-truth output
        [I J]=max(targetout,[],2);
        [I1 J1]=max(target,[],2);
        counter=counter+length(find(J==J1));
        err_cr = err_cr- sum(sum( target(:,1:end).*log(targetout))) ;
    end
    
    % Compute and record total training error
    train_err(epoch)=(numcases*numbatches-counter);
    train_crerr(epoch)=err_cr/numbatches;

    % Now, compute test error, identical to above except for test data
    err=0;
    err_cr=0;
    counter=0;
    [testnumcases testnumdims testnumbatches]=size(testbatchdata);
    N=testnumcases;
    
    for batch = 1:testnumbatches
      data = [testbatchdata(:,:,batch)];
      target = [testbatchtargets(:,:,batch)];
      data = [data ones(N,1)];
      w1probs = 1./(1 + exp(-data*w1)); w1probs = [w1probs  ones(N,1)];
      w2probs = 1./(1 + exp(-w1probs*w2)); w2probs = [w2probs ones(N,1)];
      targetout = exp(w2probs*w_class);
      targetout = targetout./repmat(sum(targetout,2),1,numclasses);

      [I J]=max(targetout,[],2);
      [I1 J1]=max(target,[],2);
      counter=counter+length(find(J==J1));
      err_cr = err_cr- sum(sum( target(:,1:end).*log(targetout))) ;
    end

    test_err(epoch)=(testnumcases*testnumbatches-counter);
    test_crerr(epoch)=err_cr/testnumbatches;
    
    % Print both training and test error. This gives a good idea of how
    % much the algorithm is overfitting, and when it starts doing so
    fprintf(1,'Before epoch %d Train # misclassified: %d from %d (%.2f%%). Test # misclassified: %d from %d (%.2f%%) \t \t \n',...
            epoch,train_err(epoch),numcases*numbatches,100*(1-(train_err(epoch)/(numcases*numbatches))),test_err(epoch),testnumcases*testnumbatches,100*(1-(test_err(epoch)/(testnumcases*testnumbatches))));

    
    tt=0;
    
    % Loop over batches and optimize training error (w/ regularization) for
    % each
    for batch = 1:numbatches
        fprintf(1,'epoch %d batch %d\r',epoch,batch);
        
        tt=tt+1; 
        data=batchdata(:,:,batch);
        targets=batchtargets(:,:,batch); 
        
        % For some number of epochs, just update top-level classification
        % weights, keeping others fixed
        if epoch <= INIT_EPOCHS
            
            N = size(data,1);
            
            % Forward-prop to get 2nd-layer features
            XX = [data ones(N,1)];
            w1probs = 1./(1 + exp(-XX*w1)); w1probs = [w1probs  ones(N,1)];
            w2probs = 1./(1 + exp(-w1probs*w2));
            
            % Optimize top-layer weights from 2nd-layer features
            VV = [w_class(:)']';
            Dim = [l3; l4];
            [X, fX, exitflag] = minFunc(@(theta) softmaxInitCost(theta,Dim,w2probs,targets), VV, options);
            w_class = reshape(X,l3+1,l4);

        else
            % Once top-layer weights have been optimized alone, use
            % back-prop to optimize all weights together
            VV = [w1(:)' w2(:)' w_class(:)']';
            Dim = [l1; l2; l3; l4];
            tic
            [X, fX, exitflag] = minFunc(@(theta) softmaxBackpropCostMultiReg(theta,Dim,data,targets,trainModes), VV, options);
            toc
            
            % Re-form weight matrices from the output of minFunc
            w1 = reshape(X(1:(l1+1)*l2),l1+1,l2);
            xxx = (l1+1)*l2;
            w2 = reshape(X(xxx+1:xxx+(l2+1)*l3),l2+1,l3);
            xxx = xxx+(l2+1)*l3;
            w_class = reshape(X(xxx+1:xxx+(l3+1)*l4),l3+1,l4);

        end
%%%%%%%%%%%%%%% END OF CONJUGATE GRADIENT WITH 3 LINESEARCHES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end

 save ~/backpropData/classify_weights w1 w2 w_class
 save ~/backpropData/classify_error test_err test_crerr train_err train_crerr;

end



