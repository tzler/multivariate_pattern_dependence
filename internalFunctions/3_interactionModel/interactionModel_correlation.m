function connectivityVector = interactionModel_correlation(parameters,data)

nRois = length(data);
nRuns = length(data{1});
for iRun=1:nRuns
    for iRoi = 1:nRois
        data_reformat{iRun}(iRoi,:) = data{iRoi}{iRun};
    end
end

for iRun = 1:nRuns
    functionalConnectivity(:,:,iRun) = corr(data_reformat{iRun}',data_reformat{iRun}');
end
connectivityMatrix = squeeze(mean(functionalConnectivity,3));
connectivityVector = connectivityMatrix(1,2:end);
end

