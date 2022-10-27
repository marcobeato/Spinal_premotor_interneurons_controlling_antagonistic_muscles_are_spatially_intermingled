function [bootstats, bootstats_sd, bootstats_size] = get_bootstrapped_stats(data,nruns,num_trials,param)
%perform bootstrapping n_runs times with an equal sample size of num_trials
%at the lower level
% MB added functionality to export SD in order to calculate effect size.
% Note that this way effect size will be calculated between the nth replica
% of each of the two samples

rng(110498); % use seed for reproducibility
bootstats = NaN(nruns,1);
bootstats_sd = NaN(nruns,1);
bootstats_size = NaN(nruns,1); % This is redundant because size is always num_trials*n of animals

for i =1:nruns
    a = size(data);
    num_lev1 = a(1);
    temp = NaN(num_lev1,num_trials);
    rand_lev1 = randi(num_lev1,num_lev1,1);
    for j = 1:length(rand_lev1)
        num_lev2 = find(~isnan(data(rand_lev1(j),:)),1,'last'); %We need to calculate this again here because there is a different number of trials for each neuron
        %this works only if all NaNs are at the end of the row (worth
        %modfying it to be more general or remember to apply sort before bootstrapping)
        rand_lev2 = randi(num_lev2,1,num_trials); %Resample only from trials with data but same number of sample trials for all
        temp(j,:) = data(rand_lev1(j),rand_lev2);
    end
    
    %Note that there should be no nans in these measures if sampling was
    %done correctly
    if strcmp(param,'mean')
        bootstats(i) = mean(temp(:));
    elseif strcmp(param,'median')
        bootstats(i) = median(temp(:));
    else
        disp('Unknown parameter. Use mean or median or write a new one.')
        return
    end
        bootstats_sd(i) = std(temp(:));
        bootstats_size(i) = numel(temp);
   % disp(['Sample ' num2str(i) ' completed.']);
    f = waitbar(0);
    waitbar(i/nruns, f, sprintf('Progress: %d %%', floor(i/nruns*100)));
end
close(f)
end