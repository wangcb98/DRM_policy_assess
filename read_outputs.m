% This script plots various figures in the manuscript "A geophysics-informed pro-poor approach to earthquake risk management"
% created by Chenbo Wang on April 20 2024

clear
clc
cd("/Users/patrick/Library/CloudStorage/Dropbox/Tomorrow's Cities Risk Work - UCL Team/Chenbo Work/Work with Himanshu")
%% read data and extract relevant information
for policy = 0:5
    fname="Di_p"+num2str(policy)+".xlsx";
    var_name="Di_p"+num2str(policy);
    data.(var_name) = readmatrix(fname);
end
data.Di_p0=data.Di_p0(2:end);
data.Di_p1=data.Di_p1(2:end);
data.Di_p2=data.Di_p2(2:end);
data.Di_p3=data.Di_p3(2:end);
data.Di_p4=data.Di_p4(2:end);
data.Di_p5=data.Di_p5(2:end);


data.delta_all = readmatrix("delta_all.xlsx");
data.delta_low = readmatrix("delta_low.xlsx");
data.bcr_all = readmatrix("bcr_all.xlsx");
data.bcr_low = readmatrix("bcr_low.xlsx");

bldPort_TV0=readgeotable("bldPort_TV0_siteclasses.shp");

% extract income group information
idx_low=find(bldPort_TV0.polytype=="lowIncome");
idx_mid=find(bldPort_TV0.polytype=="midIncome");
idx_high=find(bldPort_TV0.polytype=="highIncome");

% extract site class information
idx_sc_1=find(bldPort_TV0.cluster==0);
idx_sc_2=find(bldPort_TV0.cluster==1);
idx_sc_3=find(bldPort_TV0.cluster==2);

% extract building typology information
idx_T_1=find(bldPort_TV0.vulnStrEQ=="BrM+LC+LR");
idx_T_2=find(bldPort_TV0.vulnStrEQ=="BrCfl+LC+LR");
idx_T_3=find(bldPort_TV0.vulnStrEQ=="BrCri+LC+LR");

%%
load poly_TV_0.mat; 
PolyIDLow = []; PolyIDMid = []; PolyIDHigh = [];
for poly = 1:size(poly_TV_0,1)
    if contains(poly_TV_0(poly).typeSocial,'low') == 1
        PolyIDLow = [PolyIDLow,poly];
    elseif contains(poly_TV_0(poly).typeSocial,'mid') == 1
        PolyIDMid = [PolyIDMid,poly];
    elseif contains(poly_TV_0(poly).typeSocial,'high') == 1
        PolyIDHigh = [PolyIDHigh,poly];
    end
end

%% TV0 -- building typology
figure()
mapshow(poly_TV_0, 'Facecolor', 'none','LineWidth',1.0,'LineStyle','--')
hold on
mapshow(poly_TV_0(PolyIDLow), 'Facecolor', 'none', 'EdgeColor', [117,107,177]./255,'LineWidth',1.5)
mapshow(poly_TV_0(PolyIDMid), 'Facecolor', 'none', 'EdgeColor', [197,27,138]./255,'LineWidth',1.5)
mapshow(poly_TV_0(PolyIDHigh), 'Facecolor', 'none', 'EdgeColor', [49,163,84]./255,'LineWidth',1.5)
mapshow(bldPort_TV0(idx_T_3,:), 'Facecolor', [0 0.4470 0.7410],'EdgeColor', [0 0.4470 0.7410]);
mapshow(bldPort_TV0(idx_T_2,:), 'Facecolor', [0.9290 0.6940 0.1250],'EdgeColor', [0.9290 0.6940 0.1250]);
mapshow(bldPort_TV0(idx_T_1,:), 'Facecolor', [0.8500 0.3250 0.0980],'EdgeColor', [0.8500 0.3250 0.0980]);
ylim([3055500 3059000])
box on
xlabel('Easting')
ylabel('Northing')
clear L
L(1) = plot(nan, nan, '-k','LineWidth',1.0,'LineStyle','--');
L(2) = plot(nan, nan, '-','Color',[117,107,177]./255,'LineWidth',1.5);
L(3) = plot(nan, nan, '-','Color',[197,27,138]./255,'LineWidth',1.5);
L(4) = plot(nan, nan, '-','Color',[49,163,84]./255,'LineWidth',1.5);
L(5) = scatter(nan,nan,10,[0.8500 0.3250 0.0980],'s','filled');
L(7) = scatter(nan,nan,10,[0 0.4470 0.7410],'s','filled');
L(6) = scatter(nan,nan,10,[0.9290 0.6940 0.1250],'s','filled');
hold off
scalebar('Location',[3.3475e+5,3055700],'Bold','True','Unit','meter')
lgd = legend(L,{'non-residential polygon','low-income polygon','middle-income polygon','high-income polygon','T1 buildings', 'T2 buildings', 'T3 buildings'});
lgd.NumColumns = 2;
set(gca,'FontSize',16,'XTick',[],'YTick',[])

%% Barplot -- building typology 
count_typologies=[1706 174 170; 93 51 54; 111 45 44];
count_typologies=count_typologies./sum(count_typologies,2);
figure
b=bar(count_typologies,0.6,'stacked');
set(gca,'FontSize',16)
xticklabels({'Low-income','Middle-income','High-income'})
ylabel("Proportion of buildings")
yticks(0:0.2:1.0)
legend('T1 buildings', 'T2 buildings', 'T3 buildings')
b(1).FaceColor = [0.8500 0.3250 0.0980];
b(2).FaceColor = [0.9290 0.6940 0.1250];
b(3).FaceColor = [0 0.4470 0.7410];
%% TV0 -- site classification
figure()
mapshow(poly_TV_0, 'Facecolor', 'none','LineWidth',1.0,'LineStyle','--')
hold on
mapshow(poly_TV_0(PolyIDLow), 'Facecolor', 'none', 'EdgeColor', [84,39,143]./255,'LineWidth',1.5)
mapshow(poly_TV_0(PolyIDMid), 'Facecolor', 'none', 'EdgeColor', [197,27,138]./255,'LineWidth',1.5)
mapshow(poly_TV_0(PolyIDHigh), 'Facecolor', 'none', 'EdgeColor', [49,163,84]./255,'LineWidth',1.5)
mapshow(bldPort_TV0(idx_sc_1,:), 'Facecolor', [0,109,44]./255,'EdgeColor', [0,109,44]./255);
mapshow(bldPort_TV0(idx_sc_2,:), 'Facecolor', [4,90,141]./255,'EdgeColor', [4,90,141]./255);
mapshow(bldPort_TV0(idx_sc_3,:), 'Facecolor', [165,15,21]./255,'EdgeColor', [165,15,21]./255);
ylim([3055500 3059000])
box on
xlabel('Easting')
ylabel('Northing')
clear L
L(1) = plot(nan, nan, '-k','LineWidth',1.0,'LineStyle','--');
L(2) = plot(nan, nan, '-','Color',[84,39,143]./255,'LineWidth',1.5);
L(3) = plot(nan, nan, '-','Color',[197,27,138]./255,'LineWidth',1.5);
L(4) = plot(nan, nan, '-','Color',[49,163,84]./255,'LineWidth',1.5);
L(5) = scatter(nan,nan,10,[0,109,44]./255,'s','filled');
L(6) = scatter(nan,nan,10,[4,90,141]./255,'s','filled');
L(7) = scatter(nan,nan,10,[165,15,21]./255,'s','filled');
hold off
scalebar('Location',[3.3475e+5,3055700],'Bold','True','Unit','meter')
lgd = legend(L,{'non-residential polygon','low-income polygon','middle-income polygon','high-income polygon','Site class 1', 'Site class 2', 'Site class 3'});
lgd.NumColumns = 2;
set(gca,'FontSize',16,'XTick',[],'YTick',[])

%% Histogram -- site classes
figure()
histogram(bldPort_TV0{idx_sc_1,'aj'},-0.8:0.025:1.5,'FaceColor',[0,109,44]./255,'FaceAlpha',0.5,'EdgeColor', [0,109,44]./255)
hold on
histogram(bldPort_TV0{idx_sc_2,'aj'},-0.8:0.025:1.5,'FaceColor',[4,90,141]./255,'FaceAlpha',0.5,'EdgeColor', [4,90,141]./255)
histogram(bldPort_TV0{idx_sc_3,'aj'},-0.8:0.025:1.5,'FaceColor',[165,15,21]./255,'FaceAlpha',0.5,'EdgeColor', [165,15,21]./255)
xlim([-0.8,1.5])
ylim([0,300])
xlabel("\it{lnA_s}")
ylabel("No. of buildings")
legend("Site class 1","Site class 2","Site class 3")
set(gca,'FontSize',16)

%% Plot fragility curves related to three building typologies
C_DS=[35/255,139/255,69/255;
    0.9290 0.6940 0.1250;
    0.8500 0.3250 0.0980;
    0.6350 0.0780 0.1840];
Theta = [0.057,0.098,0.147,0.223;
    0.057,0.119,0.214,0.361;
    0.124,0.175,0.295,0.445];
Beta = [0.406	0.404	0.358	0.31
    0.451	0.349	0.286	0.247
    0.326	0.3	0.254	0.254];
IM = 0:0.001:1.0;
styles = ["-",":","--","-."];
for typology = 1:3
    P_DS=zeros(4,length(IM));
    P_DS_p=zeros(4,length(IM));
    figure(typology)
    hold on
    for DS = 1:4
        beta = Beta(typology,DS); theta = Theta(typology,DS);
        P_DS(DS,:) = normcdf((1/beta)*log(IM./theta));
        P_DS_p(DS,:) = normcdf((1/beta)*log(IM./(1.2*theta)));
        plot(IM,P_DS(DS,:),'Color',C_DS(DS,:),'LineWidth',2.0,'LineStyle','-')
        if typology < 3
            plot(IM,P_DS_p(DS,:),'Color',C_DS(DS,:),'LineWidth',2.0,'LineStyle',':')
        end
    end
    xlabel("PGA [g]")
    yticks(0:0.2:1.0)
    ylabel("\it{P(DS \geq ds_j|PGA=pga_k )}")
    set(gca,'FontSize',16)
    grid on
    if typology == 1
        clear L
        L(1) = plot(nan, nan, 'Color','k','LineWidth',2.0,'LineStyle','-');
        L(2) = plot(nan, nan, 'Color','k','LineWidth',2.0,'LineStyle',':');
        L(3) = plot(nan, nan, 'Color',C_DS(1,:),'LineWidth',2.0,'LineStyle','-');
        L(4) = plot(nan, nan, 'Color',C_DS(2,:),'LineWidth',2.0,'LineStyle','-');
        L(5) = plot(nan, nan, 'Color',C_DS(3,:),'LineWidth',2.0,'LineStyle','-');
        L(6) = plot(nan, nan, 'Color',C_DS(4,:),'LineWidth',2.0,'LineStyle','-');
        lgd = legend(L,{'o','p','DS1','DS2','DS3','DS4'});
        lgd.NumColumns = 1;
    end
end

%% Plot F(di) CDF curves for (a) all site classes, (b) site class 1, (c) site class 2, and (d) site class 3

% all site classes
[f_0,x_0]=ecdf(data.Di_p0);
[f_1,x_1]=ecdf(data.Di_p1);
[f_2,x_2]=ecdf(data.Di_p2);
[f_3,x_3]=ecdf(data.Di_p3);
[f_4,x_4]=ecdf(data.Di_p4);
[f_5,x_5]=ecdf(data.Di_p5);
figure
plot(x_0,f_0,'LineStyle',':','Color','k','LineWidth',2.0)
hold on
plot(x_1,f_1,'LineStyle',':','Color',[178,24,43]./255,'LineWidth',2.0)
plot(x_2,f_2,'LineStyle','-.','Color',[177,89,40]./255,'LineWidth',2.0)
plot(x_3,f_3,'LineStyle','--','Color',[255,127,0]./255,'LineWidth',2.0)
plot(x_4,f_4,'LineStyle','--','Color',[51,160,44]./255,'LineWidth',2.0)
plot(x_5,f_5,'LineStyle','--','Color',[106,61,154]./255,'LineWidth',2.0)
xticks(0.0:0.2:1.0)
yticks(0:0.2:1.0)
xlabel('\it{d_i}')
ylabel('\it{F(d_i )}')
grid on
legend("No policy","Policy #1","Policy #2","Policy #3","Policy #4","Policy #5")
set(gca,'FontSize',18)

% site class 1
[f_0,x_0]=ecdf(data.Di_p0(idx_sc_1));
[f_1,x_1]=ecdf(data.Di_p1(idx_sc_1));
[f_2,x_2]=ecdf(data.Di_p2(idx_sc_1));
[f_3,x_3]=ecdf(data.Di_p3(idx_sc_1));
[f_4,x_4]=ecdf(data.Di_p4(idx_sc_1));
[f_5,x_5]=ecdf(data.Di_p5(idx_sc_1));
figure
plot(x_0,f_0,'LineStyle',':','Color','k','LineWidth',2.0)
hold on
plot(x_1,f_1,'LineStyle',':','Color',[178,24,43]./255,'LineWidth',2.0)
plot(x_2,f_2,'LineStyle','-.','Color',[177,89,40]./255,'LineWidth',2.0)
plot(x_3,f_3,'LineStyle','--','Color',[255,127,0]./255,'LineWidth',2.0)
plot(x_4,f_4,'LineStyle','--','Color',[51,160,44]./255,'LineWidth',2.0)
plot(x_5,f_5,'LineStyle','--','Color',[106,61,154]./255,'LineWidth',2.0)
xticks(0.0:0.01:0.04)
yticks(0:0.2:1.0)
xlabel('\it{d_i}')
ylabel('\it{F(d_i )}')
grid on
set(gca,'FontSize',18)

% site class 2
[f_0,x_0]=ecdf(data.Di_p0(idx_sc_2));
[f_1,x_1]=ecdf(data.Di_p1(idx_sc_2));
[f_2,x_2]=ecdf(data.Di_p2(idx_sc_2));
[f_3,x_3]=ecdf(data.Di_p3(idx_sc_2));
[f_4,x_4]=ecdf(data.Di_p4(idx_sc_2));
[f_5,x_5]=ecdf(data.Di_p5(idx_sc_2));
figure
plot(x_0,f_0,'LineStyle',':','Color','k','LineWidth',2.0)
hold on
plot(x_1,f_1,'LineStyle',':','Color',[178,24,43]./255,'LineWidth',2.0)
plot(x_2,f_2,'LineStyle','-.','Color',[177,89,40]./255,'LineWidth',2.0)
plot(x_3,f_3,'LineStyle','--','Color',[255,127,0]./255,'LineWidth',2.0)
plot(x_4,f_4,'LineStyle','--','Color',[51,160,44]./255,'LineWidth',2.0)
plot(x_5,f_5,'LineStyle','--','Color',[106,61,154]./255,'LineWidth',2.0)
xticks(0:0.1:0.7)
yticks(0:0.2:1.0)
xlabel('\it{d_i}')
ylabel('\it{F(d_i )}')
grid on
set(gca,'FontSize',18)

% site class 3
[f_0,x_0]=ecdf(data.Di_p0(idx_sc_3));
[f_1,x_1]=ecdf(data.Di_p1(idx_sc_3));
[f_2,x_2]=ecdf(data.Di_p2(idx_sc_3));
[f_3,x_3]=ecdf(data.Di_p3(idx_sc_3));
[f_4,x_4]=ecdf(data.Di_p4(idx_sc_3));
[f_5,x_5]=ecdf(data.Di_p5(idx_sc_3));
figure
plot(x_0,f_0,'LineStyle',':','Color','k','LineWidth',2.0)
hold on
plot(x_1,f_1,'LineStyle',':','Color',[178,24,43]./255,'LineWidth',2.0)
plot(x_2,f_2,'LineStyle','-.','Color',[177,89,40]./255,'LineWidth',2.0)
plot(x_3,f_3,'LineStyle','--','Color',[255,127,0]./255,'LineWidth',2.0)
plot(x_4,f_4,'LineStyle','--','Color',[51,160,44]./255,'LineWidth',2.0)
plot(x_5,f_5,'LineStyle','--','Color',[106,61,154]./255,'LineWidth',2.0)
xticks(0:0.2:1.0)
yticks(0:0.2:1.0)
xlabel('\it{d_i}')
ylabel('\it{F(d_i )}')
grid on
set(gca,'FontSize',18)


%% Plot F(di) for low-income vs all for no policy and five policies
% all
[f_0,x_0]=ecdf(data.Di_p0);
[f_1,x_1]=ecdf(data.Di_p1);
[f_2,x_2]=ecdf(data.Di_p2);
[f_3,x_3]=ecdf(data.Di_p3);
[f_4,x_4]=ecdf(data.Di_p4);
[f_5,x_5]=ecdf(data.Di_p5);
% low-income
[f_0_low,x_0_low]=ecdf(data.Di_p0(idx_low));
[f_1_low,x_1_low]=ecdf(data.Di_p1(idx_low));
[f_2_low,x_2_low]=ecdf(data.Di_p2(idx_low));
[f_3_low,x_3_low]=ecdf(data.Di_p3(idx_low));
[f_4_low,x_4_low]=ecdf(data.Di_p4(idx_low));
[f_5_low,x_5_low]=ecdf(data.Di_p5(idx_low));

for p = 0:5
    switch p
        case 0
            f=f_0;x=x_0;f_low=f_0_low;x_low=x_0_low;
        case 1
            f=f_1;x=x_1;f_low=f_1_low;x_low=x_1_low;
        case 2
            f=f_2;x=x_2;f_low=f_2_low;x_low=x_2_low;
        case 3
            f=f_3;x=x_3;f_low=f_3_low;x_low=x_3_low;
        case 4
            f=f_4;x=x_4;f_low=f_4_low;x_low=x_4_low;
        case 5
            f=f_5;x=x_5;f_low=f_5_low;x_low=x_5_low;
    end
    figure
    plot(x,f,'LineStyle','-','Color',[8,48,107]./255,'LineWidth',2)
    hold on
    plot(x_low,f_low,'LineStyle','-','Color',[103,0,13]./255,'LineWidth',2)
    if p==0
        legend("\it{d_{i}}","\it{d_{i,low}}")
    end
    xlabel("\it{d_{x}}")
    ylabel("\it{F(d_{x} )}")
    xlim([0,1.0])
    ylim([0,1.0])
    xticks(0:0.2:1.0)
    yticks(0:0.2:1.0)
    grid on
    set(gca,'FontSize',20)
end

%% Plot BCR_x and Delta_x for five policies considered
delta=[data.delta_all(2:end),data.delta_low(2:end)];
delta=sort(delta,'descend'); %can do this because ranking is consistent for delta_all and delta_low
bcr=[data.bcr_all(2:end),data.bcr_low(2:end)];
bcr=sort(bcr,'descend');%can do this because ranking is consistent for delta_all and delta_low

figure
b=bar(delta,0.9);
set(gca,'FontSize',16)
xticklabels(["Policy #1","Policy #2","Policy #5","Policy #4","Policy #3"])
ylabel("Benefit, \Delta_{x}")
legend('\Delta_{all}', '\Delta_{low}')
b(1).FaceColor = [8,48,107]./255;
b(2).FaceColor = [103,0,13]./255;

figure
b=bar(bcr,0.9);
set(gca,'FontSize',16)
xticklabels(["Policy #3","Policy #4","Policy #5","Policy #2","Policy #1"])
ylabel("Benefit-Cost Ratio, \it{BCR_x}")
yticks([0:0.00002:0.0001,1.1e-4])
ylim([0 1.1e-4])
legend('\it{BCR_{all}}', '\it{BCR_{low}}')
b(1).FaceColor = [8,48,107]./255;
b(2).FaceColor = [103,0,13]./255;

%% illustrative Delta_x plot 
X=0:0.01:1.0;
Y1=X.^(1/2);
Y2=X.^2;
figure 
hold on;
upperBoundary = max(Y1, Y2);
lowerBoundary = min(Y1, Y2);
plot(X,Y2, 'K-','LineWidth', 3);
plot(X,Y1, 'k:','LineWidth', 3);
patch([X fliplr(X)], [upperBoundary  fliplr(lowerBoundary)], [189,189,189]./255);
xlabel('\it{d_{x}}');
ylabel('\it{F(d_{x} )}');
legend('\it{F(d_{x} )_{o}}', '\it{F(d_{x} )_{p}}','\Delta_{x}');
set(gca,'FontSize',16)


