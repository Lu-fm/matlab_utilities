%ANIMATEPLOT
% create multiple line animation and export it as a vedio  
% example:
% xx1 and yy1 have the same length, but xx1 and xx2 can have different
% length.Note that xx1 and yy1 should be column vector, say, size of 
% [N, 1].Here is an example:
% 
% xx1 = linspace(-5,5,200);
% yy1 = sin(xx1*pi);
% xx2 = linspace(-5,7,300);
% yy2 = cos(xx2*pi/2);
% x  = {xx1(:),xx2(:)};
% y  = {yy1(:),yy2(:)};
% setup.speed = 20; % animate speed
% setup.xlabel = 'x ';
% setup.ylabel = 'y ';
% setup.filename = 'test';
% setup.legend = {'sin(\pi x)','cos(\pi/2 x)'};
% setup.xscale = 1e3; % magniude of axis value
% setup.yscale = 1e3;
% setup.color = {'r','b'}; % color for each line
% setup.location = 'southeast';
% setup.fontsize = 16;
% animatePlot( x, y, setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% author: lufangmin 
% email: lufangmin@zju.edu.cn
% date: 2023/06/05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function animatePlot(xset, yset, setup)

speed = setup.speed;
xla = setup.xlabel;
yla = setup.ylabel;
filename = setup.filename;
labels = setup.legend;
xscale = setup.xscale;
yscale = setup.yscale;
location = setup.location;
color = setup.color;
fontsize = setup.fontsize;

[x,y] = datacat(xset,yset);

figure(1)
obj = VideoWriter(filename);
obj.Quality = 100;
obj.FrameRate = 15;
open(obj);
ax = gcf();

numLine = size(y, 2);
h =  animatedline('Color',color{1},'LineWidth',2);
for i = 2:numLine
    h(end+1) = animatedline('Color',color{i},'LineWidth',2);
end

legend(labels,'Location', location);
grid on

xmin = min(x(:));
xmax = max(x(:));
ymin = min(y(:));
ymax = max(y(:));

xmin = sign(xmin) * ceil(abs(xmin/xscale))*xscale;
xmax = sign(xmax) * ceil(abs(xmax/xscale))*xscale;
ymax = sign(ymax) * ceil(abs(ymax/yscale))*yscale;
ymin = sign(ymin) * ceil(abs(ymin/yscale))*yscale;

axis([xmin, xmax, ymin, ymax])
xlabel(xla,'Interpreter','latex','FontSize',fontsize);
ylabel(yla,'Interpreter','latex','FontSize',fontsize);

numpoints = size(x,1);
for k = 1:speed:numpoints
    low = k;
    high = k + speed - 1;
%     if (high > numpoints)
%         high = numpoints;
%     end
%     for j = 1:numLine
%         axis([xmin, xmax, ymin, ymax])
%         plot(x(low:high,j),y(low:high,j),color{j},'LineWidth',2); hold on;
%     end
%     grid
    for j = 1:numLine
        if(high <= numpoints)
            xvec = x(low:high,j);
            yvec = y(low:high,j);
        else
            xvec = x(k:numpoints,j);
            yvec = y(k:numpoints,j);
        end        
        addpoints(h(j),xvec,yvec)
    end
%     if(i==1)
%         set(ax, 'XLimMode', 'manual', 'YLimMode', 'manual');
%     end

    drawnow
    f = getframe(ax); % gcf
    writeVideo(obj, f) ;
end

obj.close();

end


function [x,y] = datacat(xset,yset)

numLine = length(yset);
datalen = zeros(numLine,1);
for i = 1:numLine
    datalen(i) = length(yset{i});
end
mlen = max(datalen);
y = NaN*zeros(mlen,numLine);

if(length(xset)==1)
    x = NaN*zeros(mlen,1);
    x(1:datalen(i)) = xset{1};    
    for i = 1:numLine
        y(1:datalen(i),i) = yset{i};
    end
else
    x = NaN*zeros(mlen,numLine);
    for i = 1:numLine
        x(1:datalen(i),i) = xset{i};
        y(1:datalen(i),i) = yset{i};
    end    
end

end

