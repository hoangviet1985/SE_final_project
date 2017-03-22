function features = extractHOGfeatures(sampleSet)
    funct = @(block_struct)HOGSupporter(block_struct);
    features = blockproc(sampleSet, [1 784], funct);
end