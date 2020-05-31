clear all; close all
addpath(genpath('helper_ftn'));
addpath('C:\Users\Ione Fine\Documents\code\UWToolbox\UWToolbox\optimization');
addpath(genpath('C:\Users\Ione Fine\Documents\code\plasticity_review_code\helper_ftn'));
p.t = 0:.1:60;
p.g = 0.0;  %chance performance
p.e = .5;  %threshold performance (50%)
e = 0; i = 0; ei = 0; ss = 0; s = 0; a = 0; 
p.asymptote = 1;
p.freeList = {'thresh', 'beta'};
p.thresh = 10; p.beta = 4; p.shift = 10; p.tau = 10;

%% EXCITATORY

Ecmap = flipud(cbrewer('seq', 'YlOrRd',4)); 
p.plot = 1;
e = e+1; p.color = Ecmap(e, :); 
cp(e+i+ss+a+s+ei+ei) = pr.pyr_spine_density(p); % Spine density, Boothe

e = e+1; p.color = Ecmap(e, :);  
cp(e+i+ss+a+s+ei) = pr.pyr_conversion_stellate(p); % Developmental sculpting of dendritic morphology, Calloway

p.thresh = 20; p.beta = 4;
e = e+1; p.color = Ecmap(e, :); 
cp(e+i+ss+a+s+ei)  = pr.NMDA_gluN1(p);

p.thresh = 20; p.beta = 4;
e = e+1; p.color = Ecmap(e, :); 
cp(e+i+ss+a+s+ei)  = pr.pyr_nmda(p); % Time-course of NMDA receptor-mediated EPSP, Iwakiri


%% INHIBITION
Icmap = flipud(cbrewer('seq', 'YlGn', 5)); 
p.plot = 2;
i = i+1;  p.color = Icmap(i, :); 
cp(e+i+ss+a+s+ei) = pr.psa(p);

p.thresh = 15; p.beta = 1;
i = i+1;  p.color = Icmap(i, :); 
cp(e+i+ss+a+s+ei) = pr.PV_number(p);

i = i+1;  p.color = Icmap(i, :); 
cp(e+i+ss+a+s+ei) = pr.GABAA_expression(p);

i = i+1; p.color = Icmap(i, :); 
cp(e+i+ss+a+s+ei) =  pr.GAD65_expression(p);


%% E/I balance
ei = ei+1; p.plot = 3;
p.a = [1, 1-.14]; p.mu = 14; p.sigma = [6.5 1]; p.c = [0 0.14];
p.freeList = {'sigma', 'c'};
p.color = 'c'; 
cp(e+i+ss+a+s+ei) = pr.E_I_balance(p);


%% silent synapses & structural stabilization
SScmap = flipud(cbrewer('seq', 'Blues', 6)); 
p.plot = 4;
p.freeList = {'thresh', 'beta'};
ss = ss+1;  p.color = SScmap(ss, :); 
cp(e+i+ss+a+s+ei) = pr.SS_propn(p);


p.thresh = 20; p.beta = 4;
ss = ss+1;  p.color = SScmap(ss, :); 
cp(e+i+ss+a+s+ei) = pr.spines_filopodia(p);

ss = ss+1;  p.color = SScmap(ss, :); 
cp(e+i+ss+a+s+ei) = pr.PSD_95(p);

i = i+1; p.color = [.0 .5 .5];  
cp(e+i+ss+a+s+ei) = pr.BDNF(p);

p.thresh = 20; p.beta = 5;
ss = ss+1;  p.color = SScmap(ss, :); 
cp(e+i+ss+a+s+ei) = pr.PNN(p);


%% VISUAL ACUITY
Acmap = flipud(cbrewer('seq', 'Reds', 6)); 
p.plot =5;
p.a = 1; p.mu = 23.5+5; p.sigma = [6.5 4];
a = a+1;  p.color = 'k'; p.plot = 5;
cp(e+i+ss+a+s+ei) = pr.OD_sensitivity(p);

a = a+1;  p.color = Acmap(a, :); 
cp(e+i+ss+a+s+ei) = pr.OSI(p);

a = a+1; p.color = Acmap(a, :);  
cp(e+i+ss+a+s+ei) = pr.visual_acuity(p);

%% synaptic density
Scmap = flipud(cbrewer('seq', 'Purples', 6));
p.plot = 6;
p.mu = 29; p.sigma = [6.5 1]; p.c = [0 0.9];
p.freeList = {'sigma', 'c'};
s = s+1;  p.color = Scmap(s, :); 
cp(e+i+ss+a+s+ei) = pr.synaptic_density2(p);p.freeList = {'thresh', 'beta'};

%%  plot it
% block shading
% h = area([16 16 26 26],[ 0 1 1 0]); hold on
% set(h, 'FaceColor', [ .7 .7 .7],  'EdgeColor', [ .7 .7 .7]) hold on

% end
for f = 1:6
    subplot(6, 1, f)
    th = text(log(9),.65, 'eye opening'); hold on
    l = line([ log(9) log(9)], [0 1]); set(l, 'LineStyle', ':');
    ind  = find(cat(1, cp(:).plot) == f);
    clear ii m h tt;
    for ii = 1:length(ind)
        m = ind(ii);
        if strcmp(cp(m).title, 'OD Sensitivity')
            pred = cp(m).curve;
            t = cp(m).p.t;
            for t1 = 1:length(t)
                if pred(t1)>0.001
                    col_ind = pred(t1);
                    x = [t(t1)-5 t(t1)+5 t(t1)-5 t(t1)+5];
                    y = [pred(t1) pred(t1) pred(t1+3) pred(t1+3)];
                    p =  patch(log(x),y,[.6 .6 .6],  'EdgeColor', 'none', 'FaceAlpha', 0.5);
                end
            end
            
        elseif  strcmp(cp(m).title, 'E/I ratio')
            cp(m).curve = cp(m).curve.*0.7803; % no need to scale
            cp(m).data(:, 2) =  cp(m).data(:, 2).*0.7803;
        elseif strcmp(cp(m).title, 'synaptic density')
            cp(m).curve = cp(m).curve.*57.80; % no need to scale
            cp(m).data(:, 2) =  cp(m).data(:, 2).*57.80;
        end
        h(ii) = plot(log(cp(1).p.t), cp(m).curve, 'Color', cp(m).color, 'LineWidth', 2, 'LineStyle', cp(m).LineStyle); hold on
        if ~isempty(cp(m).data)
            plot(log(cp(m).data(:, 1)), cp(m).data(:, 2), '.', ...
                'MarkerSize', 25, 'Color', cp(m).color, 'LineWidth', 2);
        end
        
        
        tt(ii).title = cp(m).title;
        logx2raw;
        set(th, 'Rotation', 90);
        set(gca, 'XLim', [log(5) log(max(cp(1).p.t))]);
        set(gca, 'XTick', log([10 20 30 50]));
        set(gca, 'XTickLabel', { '10 (6)', '20 (1 yr)', '30 (1.5 yrs)', '50 (4 yrs)' })
        set(gca, 'XLim', [log(5) log(max(cp(1).p.t))]);
        set(gca, 'YLim', [ 0 1.1]);
        legend(h, tt(:).title, 'Location', 'eastoutside');
        if  strcmp(cp(m).title, 'E/I ratio')
            set(gca, 'YLim', [ 0 1]);
            l = line([log(14) log(60)], [1 1 ]);
            set(l, 'LineStyle', ':')
        elseif strcmp(cp(m).title, 'synaptic density')
            set(gca, 'YLim', [0 70]);
            set(gca, 'YTick', [ 0:20:60])
        end
            
        end
    end



return

%
% %% plot OD sensitivity period
% mu = 23.5; a = 1; sigma = [6.5 4];
% pred = zeros(size(t));
% pred(t<=mu) = a*exp(-(t(t<=mu)-mu).^2/(2*sigma(1)^2));
% pred(t>mu) = a*exp(-(t(t>mu)-mu).^2/(2*sigma(2)^2));
% subplot(3, 1, 3)
% gv = find(pred>.05);
% col = redblue(256*2);
% col = flipud(col(1:256,:));
% cmap(col);
% for t1 = 1:length(t)
%     if pred(t1)>0.001
%         col_ind = pred(t1);
%         x = [t(t1) t(t1)+10 t(t1)+10 t(t1)];
%         y = [pred(t1) pred(t1) pred(t1+1) pred(t1+1)];
%         p =  patch(x,y,repmat(col_ind, 1,length(x)),  'EdgeColor', 'none');%'FaceAlpha', 0.5,
%     end
% end
% cp(m).plot = 4;
%
%% E/I balance



