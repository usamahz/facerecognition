function builddatabase()
training = imageSet('FaceDatabaseATT','recursive');
D = ['test/' date '/'];
absent = [];
test = dir(fullfile(D,'*.jpg'));
featureCount = 1;
for i=1:size(training,2)
    for j = 1:training(i).Count
        trainingFeatures(featureCount,:) = extractLBPFeatures(rgb2gray(read(training(i),j)));
        trainingLabel{featureCount} = training(i).Description;    
        featureCount = featureCount + 1;
    end
    personIndex{i} = training(i).Description;
end
 
faceClassifier = fitcecoc(trainingFeatures,trainingLabel);
error = resubLoss(faceClassifier)
 
ps = [];
for j = 1:length(test)
    queryImage = rgb2gray(imread(fullfile(D,test(j).name)));
    queryFeatures = extractLBPFeatures(queryImage);
    personLabel = predict(faceClassifier,queryFeatures);
    ps = [ps;personLabel];
    % Map back to training set to find identity
    booleanIndex = strcmp(personLabel, personIndex);
    integerIndex = find(booleanIndex);
end
absent = [absent; setdiff(personIndex,ps)];
save data_base ps faceClassifier personIndex absent
end
 
 


