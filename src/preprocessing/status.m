function status(labels, completedImages, tileCols, tileRows)
% Displays the status of the tiles in each labeled image part so far.

    % calculate the tiles in each class so far
    cloud = sum(sum(sum(sum(squeeze(labels(1:completedImages, :, :, :)) == 1))));
    ground = sum(sum(sum(sum(squeeze(labels(1:completedImages, :, :, :)) == 0))));
    indecisive = sum(sum(sum(sum(squeeze(labels(1:completedImages, :, :, :)) == 2))));

    % display the percent of cloudy examples in the data set so far
    allLabels = cloud + ground + indecisive;
    fprintf('cloud: %d percent: %f\n', cloud, (100 * cloud / allLabels));
    fprintf('ground: %d percent: %f\n', ground, (100 * ground / allLabels));
    fprintf('indecisive: %d percent: %f\n', indecisive, (100 * indecisive / allLabels));

    % make sure that there are no invalid labels so far
    assert(allLabels / (completedImages * 4) == tileCols * tileRows);
end

