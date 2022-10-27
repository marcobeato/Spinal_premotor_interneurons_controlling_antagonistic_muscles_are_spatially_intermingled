function [outputArg1,outputArg2] = poolfun(dn, concat)
%Takes a directories cell array (1, 2 or 3), reads all the data, split them
% into Mns and  Ins (sheet 2 and 1 respectviely)and outputs them as cell 
% array. Depending on the varaible concat
% the indivudal files in each directory can be pooled (concat = 1) or not 
% (concat = 0). The dimension of the cell array output will be 1  or
% nfiles, accordingly
%   

ndir = length(dn);
ext = 'xlsx';

for i = 1:ndir
files_{i} = dir([dn{i},'*.',ext]);
nfiles(i) = length(files_{i});
end

% First index is the directory, second is file
for i = 1:ndir
    for j = 1:nfiles(i)
    ins{i}{j} = readmatrix([dn{i},files_{i}(j).name], 'Sheet',1);
    mns{i}{j} = readmatrix([dn{i},files_{i}(j).name], 'Sheet',2);
    end
end

if concat == 0
    outputArg1 = ins;
    outputArg2 = mns;
else
    for  i = 1:ndir
        % the extra {1} is to make it compatible with codes using 
        % two indexes if files are not concatenated
        allins{i}{1} = vertcat(ins{i}{:}); 
        allmns{i}{1} = vertcat(mns{i}{:});
    end
     outputArg1 = allins;
     outputArg2 = allmns;
end

end

