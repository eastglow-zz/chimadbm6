path = '/Users/donguk.kim/projects/chimadbm6/';
numrow = 1002;
numcol = 6;
colIDforx = 4;
colIDfory = 1;

fnames = ["c_b005.csv", "c_b010.csv", "c_b020.csv", "c_b050.csv", "c_b100.csv", "c_b200.csv", "c_b400.csv"];
linecolors = [[1-(1/6)*0, 0+(1/6)*0, 0], [1-(1/6)*1, 0+(1/6)*1, 0], [1-(1/6)*2, 0+(1/6)*2, 0], [1-(1/6)*3, 0+(1/6)*3, 0], [1-(1/6)*4, 0+(1/6)*4, 0], [1-(1/6)*5, 0+(1/6)*5, 0], [1-(1/6)*6, 0+(1/6)*6, 0]];

fig = figure('Color',[1,1,1],'position',[0 0 1000 450]);

for i=1:7
    disp(i);
    disp(fnames(i));
    path_fname = strcat(path, fnames(i));
    dataval = dlmread(path_fname, ',' ,[1 0 numrow-1 numcol-1]);
    
    xdat = dataval(1:numrow-1,colIDforx);
    ydat = dataval(1:numrow-1,colIDfory);
    
    col = [0+(1/6)*(i-1), 0, 1-(1/6)*(i-1)];
    plot(xdat,ydat,'color',col, 'linewidth',3);
    hold on;
end
xlabel('x', 'fontsize', 22);
ylabel('c along y=50', 'fontsize', 22);
%xtick = get(gca, 'xtick');
set(gca,'fontsize', 22);
xlim([0 100]);
ylim([0.25 0.75]);
legend({'t=5', 't=10', 't=20', 't=50', 't=100', 't=200', 't=400'},'Location','eastoutside');