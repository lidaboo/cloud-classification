addpath ../../matlab
vl_setupnn

epoch=load('../../data/morph8/net-epoch-70.mat');
net = dagnn.DagNN.loadobj(epoch.net ) ;
net.mode = 'test' ;

load('../../data/morph8/imdb.mat');

indexOfFirstTestImage=1;
while(1)
   if(images.set(indexOfFirstTestImage)==2)
       break;
   end
   indexOfFirstTestImage=indexOfFirstTestImage+1
end

indexOfLastTestImage=size(images.set,2);
numberOfTestImages=indexOfLastTestImage-indexOfFirstTestImage+1;

resultsOfTestImages=zeros(numberOfTestImages, size(meta.classes,1) );

j=1;
for i=indexOfFirstTestImage: +1: indexOfLastTestImage
    im = 256 * images.data(:,:,1,i) ;
    
    net.eval({'input', im}) ;
    scores = net.vars(net.getVarIndex('softmax')).value ;
    resultsOfTestImages(j,:) = reshape(scores, 1, size(meta.classes,1));
    j=j+1
end

[~,indexesOfSortedResults]=sort(resultsOfTestImages(:,:),2,'descend');

results=zeros(size(meta.classes,1));

successOrFailCountTop1results=zeros(size(meta.classes,1), 2);
successOrFailCountNeighboursresults=zeros(size(meta.classes,1), 2);

j=1;
for i=indexOfFirstTestImage: +1: indexOfLastTestImage
    results(images.label(i), indexesOfSortedResults(j,1))=results(images.label(i), indexesOfSortedResults(j,1))+1;
    
    if(images.label(i)==indexesOfSortedResults(j,1))
        successOrFailCountTop1results(images.label(i),1)=successOrFailCountTop1results(images.label(i),1)+1;
    else
        successOrFailCountTop1results(images.label(i),2)=successOrFailCountTop1results(images.label(i),2)+1;
    end
    
    
    if(images.label(i)==1)
        if(   (indexesOfSortedResults(j,1)==1 ) || (indexesOfSortedResults(j,1)==2 ) )
            successOrFailCountNeighboursresults(images.label(i),1)=successOrFailCountNeighboursresults(images.label(i),1)+1;
        else
            successOrFailCountNeighboursresults(images.label(i),2)=successOrFailCountNeighboursresults(images.label(i),2)+1;
        end
    elseif(images.label(i)==size(meta.classes,1) )
        if(   (indexesOfSortedResults(j,1)==images.label(i) ) || (indexesOfSortedResults(j,1)==(images.label(i)-1) ) )
            successOrFailCountNeighboursresults(images.label(i),1)=successOrFailCountNeighboursresults(images.label(i),1)+1;
        else
            successOrFailCountNeighboursresults(images.label(i),2)=successOrFailCountNeighboursresults(images.label(i),2)+1;
        end
    else
        if(   (indexesOfSortedResults(j,1)==(images.label(i)-1) ) ||...
              (indexesOfSortedResults(j,1)==(images.label(i)) ) ||...
              (indexesOfSortedResults(j,1)==(images.label(i)+1) )  )
            successOrFailCountNeighboursresults(images.label(i),1)=successOrFailCountNeighboursresults(images.label(i),1)+1;
        else
            successOrFailCountNeighboursresults(images.label(i),2)=successOrFailCountNeighboursresults(images.label(i),2)+1;
        end
    end
    j=j+1
end

figure; bar3(results);
xlabel('Asil Sinif');   ylabel('Test Sonucu');
figure; bar(successOrFailCountTop1results);
title('Top 1 Success');
figure; bar(successOrFailCountNeighboursresults);
title('Komsu Siniflar Dahil Success');



