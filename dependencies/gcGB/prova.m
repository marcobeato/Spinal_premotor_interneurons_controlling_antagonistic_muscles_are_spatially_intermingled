

%aaa defined as one of the 3 dimensional data set

gck1 = gckernel();
setKernel(gck1,[3,3]);
setResd(gck1,[10,10]);
gck1.convolve(aaa(:,1)');


fh = figure;
set(fh, 'Name', '1D Gaussian convolution example')

subplot(2, 2, 1);
hist(aaa(:,1), 50);
axis tight;
title('Coarse histogram');

subplot(2, 2, 2);
plot(gck1.xx, gck1.h);
axis tight;
title('Fine histogram');

subplot(2, 2, 3);
plot(gck1.cx);
%set(gca,'XLim',[-150000,150000]);
%axis tight;
% axis off;
title('Gaussian kernel');

subplot(2, 2, 4);
plot(gck1.x, gck1.p);
set(gca,'XLim',[-0.5000,0.5000]);
%axis tight;
title('Convolved PMF');

% 2D EXAMPLE
qqq


gck2 = gckernel();
gck2.convolve([aaa(:,1)';aaa(:,2)']);

fh = figure();
set(fh, 'Name', '2D Gaussian convolution example')

subplot(2, 2, 1);
plot(aaa(:,1),aaa(:,2), '.');
axis tight;
title('Raw scatter');

subplot(2, 2, 2);
pcolor(gck2.xx, gck2.yy, gck2.H);
shading interp;
axis tight;
title('Fine histogram');

subplot(2, 2, 3);
pcolor(gck2.C);
shading interp;
axis tight;
axis off;
title('Gaussian kernel');

subplot(2, 2, 4);
pcolor(gck2.x, gck2.y, gck2.P);
shading interp;
axis tight;
title('Convolved PMF');