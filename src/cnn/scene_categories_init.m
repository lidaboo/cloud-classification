function net = scene_categories_init(varargin)

    opts.batchNormalization = true;
    opts.nClasses = 2;
    opts.reLUafterSum = true;
    opts = vl_argparse(opts, varargin); 
    nClasses = opts.nClasses;

    net = dagnn.DagNN();

    % Meta parameters
    net.meta.inputSize = [30 30 1] ;
    net.meta.trainOpts.weightDecay = 0.0001 ;
    net.meta.trainOpts.momentum = 0.9;
    net.meta.trainOpts.batchSize = 256 ;

    if opts.batchNormalization; 
      net.meta.trainOpts.learningRate = [0.1*ones(1,30) 0.01*ones(1,30) 0.001*ones(1,50)] ;
    else
      net.meta.trainOpts.learningRate = [0.01*ones(1,45) 0.001*ones(1,45) 0.0001*ones(1,75)] ;
    end

    net.meta.trainOpts.numEpochs = numel(net.meta.trainOpts.learningRate) ;

    block = dagnn.Conv('size',  [3 3 1 96], 'hasBias', true, 'stride', 1, 'pad', 0);
    net.addLayer('conv1', block, 'input', 'conv1', {['conv1' '_f'], ['conv1' '_b']});%data->input
    net.addLayer('relu1',  dagnn.ReLU('leak',0), 'conv1', 'relu1');
    block = dagnn.Pooling('poolSize', [2 2], 'method', 'max', 'pad', [0 0 0 0], 'stride', 2); 
    net.addLayer('pool1', block, 'relu1', 'pool1');
    add_layer_bn(net, 96, 'pool1', 'norm1', 0.1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    block = dagnn.Conv('size',  [3 3 96 256], 'hasBias', true, 'stride', 1, 'pad', 0);
    net.addLayer('conv2', block, 'norm1', 'conv2', {['conv2' '_f'], ['conv2' '_b']});
    net.addLayer('relu2',  dagnn.ReLU('leak',0), 'conv2', 'relu2');
    block = dagnn.Pooling('poolSize', [2 2], 'method', 'max', 'pad', [0 0 0 0], 'stride', 2); 
    net.addLayer('pool2', block, 'relu2', 'pool2');
    % add_layer_bn(net, 256, 'pool2', 'norm2', 0.1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    block = dagnn.Conv('size', [6 6 256 512], 'hasBias', true, 'stride', 1, 'pad', 0);
    net.addLayer('fc1', block, 'pool2', 'fc1', {['fc1' '_f'], ['fc1' '_b']});
    net.addLayer('relu4',  dagnn.ReLU('leak',0), 'fc1', 'relu4');
    net.addLayer('drop1',  dagnn.DropOut('rate', 0.5), 'relu4', 'drop1');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    block = dagnn.Conv('size', [1 1 512 512], 'hasBias', true, 'stride', 1, 'pad', 0);
    net.addLayer('fc2', block, 'drop1', 'fc2', {['fc2' '_f'], ['fc2' '_b']});
    net.addLayer('relu5',  dagnn.ReLU('leak',0), 'fc2', 'relu5');
    net.addLayer('drop2',  dagnn.DropOut('rate', 0.5), 'relu5', 'drop2');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    block = dagnn.Conv('size', [1 1 512 nClasses], 'hasBias', true, 'stride', 1, 'pad', 0);
    net.addLayer('fc3', block, 'drop2', 'fc3', {['fc3' '_f'], ['fc3' '_b']});

    net.addLayer('softmax', dagnn.SoftMax(), 'fc3', 'softmax');  
    net.addLayer('loss', dagnn.Loss('loss', 'log'), {'softmax', 'label'}, 'objective');%loss->objective
    net.addLayer('error', dagnn.Loss('loss', 'classerror'), {'softmax','label'}, 'error') ;

    net.initParams();

    net.meta.normalization.imageSize = net.meta.inputSize;
    net.meta.normalization.border = 256 - net.meta.inputSize(1:2) ;
    net.meta.normalization.interpolation = 'bicubic' ;
    net.meta.normalization.averageImage = [] ;
    net.meta.normalization.keepAspect = true ;
    net.meta.augmentation.rgbVariance = zeros(0,3) ;
    net.meta.augmentation.transformation = 'stretch' ;


    % Add a batch normalization layer
    function net = add_layer_bn(net, n_ch, in_name, out_name, lr)
        
        block = dagnn.BatchNorm('numChannels', n_ch);
        net.addLayer(out_name, block, in_name, out_name, ...
          {[out_name '_g'], [out_name '_b'], [out_name '_m']});
        pidx = net.getParamIndex({[out_name '_g'], [out_name '_b'], [out_name '_m']});
        net.params(pidx(1)).weightDecay = 0;
        net.params(pidx(2)).weightDecay = 0; 
        net.params(pidx(3)).learningRate = lr;
        net.params(pidx(3)).trainMethod = 'average';
    end
end