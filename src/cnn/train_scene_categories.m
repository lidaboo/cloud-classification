function [net, info] = train_scene_categories(directory, inputName)

    addpath ../../matconvnet/matlab
    vl_setupnn

    trainOpts.batchSize = 100;
    trainOpts.numEpochs = 200;
    trainOpts.continue = true;
    trainOpts.gpus = [];
    trainOpts.learningRate = 0.001;
    trainOpts.expDir = strcat(directory);
    
    imdb = load(strcat(directory, '/', inputName));
    net = scene_categories_init();
    fbatch = @(i,b) getBatch(trainOpts,i,b);
    [net,info] = cnn_train_dag(net, imdb, fbatch, trainOpts);

end

function [inputs] = getBatch(opts, imdb, batch)

    images = imdb.images.data(:,:,:,batch) ;
    images = 256 * images ;
    labels = imdb.images.label(1,batch) ;

    if opts.gpus > 0

      images = gpuArray(images) ;
    end
    inputs = {'input', images, 'label', labels};
end

