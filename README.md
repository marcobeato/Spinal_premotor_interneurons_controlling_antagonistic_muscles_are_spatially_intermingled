# Spinal_premotor_interneurons_controlling_antagonistic_muscles_are_spatially_intermingled
MATLAB live scripts to run an executable version of Ronzano et al 2022 eLife and its associated supplementary materials.
The code has been tested on Matlab version 2022a. 

In order to run the code, download to your local computer the entire list of the directories in the repository (data, data_raw, dependencies, m). The data and data_raw folders contain the whole set of data from the paper in normalized (data) and non normalized (data_raw) versions. THe 'data' folder contains the normalized coordinates for each experiment, with folder names coding muscle (LG,MG,TA,PL,GS), titre (high, low), neuron phenotype (exc, inh), method of transynaptic tracing (chat, Olig2, AAV_wt, AAV-chat, PRV)

The folder 'dependencies' contains functions and classes required to run the code. You will have to add the folder 'dependencies' to your MATLAB path. 
The folder 'm' contains two files that include the whole paper (Spinal_premotor_interneurons_are_intermingled.mlx) and some data files required to plot the profile of the spinal cord. The subfolder 'split_figures' contains code for each individual figure split by panel (individual figure panels run faster than the whole manuscript file). The supplementary material are in Spinal_premotor_interneurons_are_intermingled_supplementary.mlx. 

In the same directories, live scripts are provided for each figure panel separately (separate live scripts run more quickly than the script containing the whole paper)

In order to run the code you will have to change the path of the master directory at line 1
masterdir = 'F:\documents\master\data\'; to the path where you have downladed the data

The paramenter nruns determines the number of replicas in the hyerarchical bootstrap (see details in the paper). The data from the paper were obtained from 5000 replicas. but the variable 'nruns' is currently set at 50. The code can run in Windows 10 on a Processor	Intel(R) Xeon(R) Gold 5120 CPU @ 2.20GHz, 2195 Mhz, 14 Core(s), 28 Logical Processor(s) with 160 Gb of RAM in approximately 10 minutes when 'nruns'=5000, and in approximately 3 minutes when 'nruns'= 50. 

The script can be run in its entirety, or one section at a time, where one section is typicaly one panel of the corresponding figure in the paper. 

Individual figures representing the distribution of interneurons are interactive and the user can change the size of the guassian kernel resolution (expressed as a proportion of the SD of the data). The number of contour levels can be chosen and the data can be represented as either contours or dots. In individual experiments the position of motoneurons (when available) can be plotted or hidden.

The supplements to Figure 12 can be reproduced one by one using the provided menu that allows to pick a method of transynaptic tracing, followed by one (or two) muscles. This will open a window in the corresponding directory that allows to pick one (or more) file for each muscles. If multiple files are chosen, they can be concatenated or overlapped in different shades of color. If one wants to overlay the two muscles in the double injection experiments, it is sufficient to pick one experiment from the first muscle and the one with the same name for the other muscle (for those experiemnts in which double injections were performed)

A R executable version of the paper is available at https://mybinder.org/v2/gh/rronzano/Spinal_premotor_interneurons_controlling_antagonistic_muscles_are_spatially_intermingled.git/HEAD?urlpath=rstudio
 
