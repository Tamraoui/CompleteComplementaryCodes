function PW_DATA=resize_cell(PW_DATA)
    sizes = cellfun(@height,PW_DATA,'UniformOutput',false);
    max_size=max([sizes{:}]);
    for i=1:numel(PW_DATA)
        PW_DATA{i}=[PW_DATA{i};zeros(max_size-size(PW_DATA{i},1),size(PW_DATA{i},2))];
    end
end