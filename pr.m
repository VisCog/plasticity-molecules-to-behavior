% pr
%
% helper functions for plasticity review code
%
% functions can be called from outside with 'p2p_c.<function name>'

classdef pr
    methods(Static)
        %% EXCITATION
          function cp = pyr_spine_density(p)
            % Ronald G. Boothe William 1.IIi 1- i : i '
            %Greenough Jennifer S. Lund Kathy Wrege
            %Article Title: A quantitative investigation of spine and
            %dendrite development of neurons in visual cortex (area 17) of Macaca nemestrina monkeys
            % figure 4c, macaque weeks
            % macaque 145 days Fetal 160 days fetal 0,  1   3   5   8  12  24  30  36   adult
            % rat equivalent [-20 -5               16  17  19  21  24  28  40  45  50]
            cp.title = 'PYR: Spine Density'; cp.plot = p.plot; cp.color = p.color;
            %  cp.data = [15, 0.31; 16, 0.81; 17, 0.67; 19, 0.90; 21, 1.02; 24, 1.87; 28, 1.51; 40, 1.71; 50, 1.53];
            cp.data = [15, 0.31; 16, 0.81; 17, 0.67; 19, 0.90; 21, 1.02; 24, 1.87]; % remove declining data
            cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2));cp.LineStyle = '-';
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
            cp.curve = pr.cum_weibull(p); cp.p = p; 
          end
             function cp = pyr_conversion_stellate(p)
            % J Neurosci. 2011 May 18;31(20):7456-70. doi: 10.1523/JNEUROSCI.5222-10.2011.
            % Developmental sculpting of dendritic morphology of layer 4 neurons in visual cortex: influence of retinal input.
            % Callaway EM1, Borrell V.
            % Figure 3ione
            % Ferret Post-natal day = 14 18 22 26 30
            % Rat Post-natal day =  7   9  10  12  13 15 17
            % cp.data =   [7, 1; 9, 1.8; 10, 2.1; 12, 2.7; 13, 3]; %CHECK
            % data(m).data = [7, 1; 9, 4;   10, 4.3; 12, 12.9; 13, 19.3];
            % normalize so we can lump the data together
            % conversion of pyramids to stellate
            tmp1 = [ 7, 100; 9, 91; 10, 72.6; 12, 44.1;13, 35.8; 15, 33.4; 17, 21.5]; % pyr
            tmp2 = [7, 0;9, 9.7; 10, 27.4;12, 55.4;13, 63.4;15, 66.34;17, 78]; % stellates
            cp.data = tmp1;
            cp.data(:, 2) = tmp2(:, 2)./tmp1(:, 2);
            cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2)); cp.LineStyle = '-';
            cp.title = 'PYR: Conversion to Stellate'; cp.plot = p.plot; cp.color = p.color;
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data); cp.LineStyle = '-';
            cp.curve = pr.cum_weibull(p);  cp.p = p;    
        end
        function cp = pyr_nmda(p) % NMDA mediated EPSP
            % Postnatal development of NMDA receptor-mediated synaptic transmission in cat visual cortex
            % Michiyo Iwakiri and Yukio Komatsu
            % Figure 7A,  Time-course of NMDA receptor-mediated EPSP
            % dates in terms of postnatal cat, weeks: 1 5.5 8.8 18 adult
            cp.title = 'NMDA: EPSP'; cp.plot = p.plot; cp.color = p.color;
            cp.data = [10, 72; 19, 40; 26, 29; 43, 23; 100, 21];
            cp.data = pr.flip_data(cp.data); cp.LineStyle = ':';
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
            cp.curve = pr.cum_weibull(p);  cp.p = p;
        end
        
        function cp = NMDA_gluN1(p)
            % Huang X, Stodieck SK, Goetze B, Cui L, Wong MH, Wenzel C, Hosang L, Dong Y, Löwel S, Schlüter OM.
            % Figure 3C
            % mice, postnatal days 9 11, 14 19 25 38 90
            cp.title = 'NMDA: GluN1'; cp.plot = p.plot; cp.color = p.color;
            cp.data = [8, 59.56;10, 68.3;13, 75.4;17, 97.3;23, 102.6;34, 99.7;78, 101.4];
            cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2));cp.LineStyle = '-';
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
            cp.curve = pr.cum_weibull(p); cp.p = p;
        end
        %% SILENT SPINES
        function cp = SS_propn(p)
            % Progressive maturation of silent synapses governs the duration of a critical period.
            % Huang X, Stodieck SK, Goetze B, Cui L, Wong MH, Wenzel C, Hosang L, Dong Y, Löwel S, Schlüter OM.
            % Figure 2D
            % mice, postnatal days 11, 27.5 and 65
            
            %    An opposing function of paralogs in balancing developmental synapse maturation.
            % Favaro, Huang , Hosang , Stodieck ,Cui, Liu, Engelhardt, Schmitz,Dong,Löwel , Schlüter
            % mouse Figure S1
            % mouse days 4, 11, 20 25, 28 converts to 3  10  18  23  25
            cp.title = 'SS: Propn active'; cp.plot = p.plot; cp.color = p.color;
            cp.data = [10, 55.3; 25, 26.9; 57, 7.9]; % Huang
            cp.data = cat(1, cp.data, [3, 79.4; 10, 58.2; 18, 37.4; 25, 26.5]); % Favaro
            cp.data(:, 2) = 100-cp.data(:, 2); 
             cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2));cp.LineStyle = '-';
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
            cp.curve = pr.cum_weibull(p); cp.p = p;
        end
        function cp = unitaryEPSP(p)
            %    An opposing function of paralogs in balancing developmental synapse maturation.
            % Favaro, Huang , Hosang , Stodieck ,Cui, Liu, Engelhardt, Schmitz,Dong,Löwel , Schlüter
            % mouse
            % mouse days 4, 11, 20 25, 26
            cp.title = 'unitEPSP';  cp.plot = p.plot; cp.color = p.color;
            cp.data = [ 3, 6.8; 10, 8.2; 18, 8.5; 25, 18.2];
            cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2)); cp.LineStyle = '-';
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
            cp.curve = pr.cum_weibull(p); cp.p = p;
        end
        function cp = PSD_95(p)
            % Progressive maturation of silent synapses governs the duration of a critical period.
            % Huang X, Stodieck SK, Goetze B, Cui L, Wong MH, Wenzel C, Hosang L, Dong Y, Löwel S, Schlüter OM.
            % Figure 3A
            % mice, postnatal days 9 11, 14, 19, 25, 38 90
            % corresponds to rat 8  10  13  17  23  34  78
            cp.title = 'PSD 95'; cp.plot = p.plot; cp.color = p.color;
            cp.data = [ 8    3.7;  10    8.5; 13   16.2;   17   46; 23   67.6  ; 34   86.4000;   78  100.9];
            cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2)); cp.LineStyle = '-';
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
            cp.curve = pr.cum_weibull(p); cp.p = p;
        end
         function cp = spines_filopodia(p)
            %Long-term dendritic spine stability in the adult cortex.
            %by J Grutzendler - ‎2002 - ‎Cited by 1121 - ‎Related articles
            %Nature. 2002 Dec 19-26;420(6917):812-6.
            % Figure 1 ratio of filopodia to spines
            % Mouse months 1  1.5 2 4.5 converts to rat postnatal days 25   38   50  108
            
            cp.title = 'spines/filopodia %'; cp.plot = p.plot; cp.color = p.color;
            cp.data = [25, 11.9; 38,  4.6; 50, 0.4; 108, 0.3];
            cp.data(:, 2) = 100-cp.data(:, 2);
            cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2)); cp.LineStyle = '-';
            %cp.data = pr.flip_data(cp.data); cp.LineStyle = ':';
            freeList = {'thresh', 'beta'};
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
            cp.curve  = pr.cum_weibull(p); cp.p = p;
            cp.curve(p.t<25)=NaN;
         end
         
         %% INHIBITION
         
         function cp =  GAD65_expression(p)
             % data from P replotted in
             % Molecular basis of plasticity in the visual cortex
             % NicolettaBerardi12TommasoPizzorusso13Gian MicheleRatto1LambertoMaffei13
             % mouse 17 21 25 36
             cp.title = 'GABA: GAD65'; cp.plot = p.plot; cp.color = p.color;
             cp.data = [15, 18;19, 49;23, 50;32, 93];
             cp.data(:, 2) = cp.data(:, 2)./(max(cp.data(:, 2))); cp.LineStyle = '-';
             p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
             cp.curve = pr.cum_weibull(p); cp.p = p;
             
         end
              function cp =  GABAA_expression(p)
            % Progressive maturation of silent synapses governs the duration of a critical period.
            % Huang X, Stodieck SK, Goetze B, Cui L, Wong MH, Wenzel C, Hosang L, Dong Y, Löwel S, Schlüter OM.
            % Figure 3A
            % mice, postnatal days 9 11, 14, 19, 25, 38 90
            % corresponds to rat 8  a10  13  17  23  34  78
            cp.title = 'GABA: GREEK'; cp.plot = p.plot; cp.color = p.color;
            cp.data = [8   15.1000;  10   31.2000;  13   53.2000;  17  115.6000;   23  107.6000;   34  127.1000;   78   99.8000];
            cp.data(: , 2) = cp.data(:, 2)./max(cp.data(:, 2)); cp.LineStyle = '-';
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
            cp.curve = pr.cum_weibull(p);  cp.p = p;
              end
        
         
         function cp = psa(p)
             %              Activity-dependent PSA expression regulates inhibitory maturation and onset of critical period plasticity
             % G Di Cristo, B Chattopadhyaya, SJ Kuhlman, Y Fu… - Nature …, 2007
             % Figure 1
             % mouse postnatal 8  14  18  21  24  28  60
             cp.title = 'PSA'; cp.plot = p.plot; cp.color = p.color;
             cp.data = [ 7, 1; 13, 0.67; 16, 0.63;19, 0.1;22, 0.05;25 , 0.06;60, 0.03];
             cp.data(:, 2) = max(cp.data(:, 2))-cp.data(:, 2);  cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2)); cp.LineStyle = ':';
             
             p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
             cp.curve  = pr.cum_weibull(p); cp.p = p;
         end
         
         %% E/I Balance
         function cp = E_I_balance(p)
             %             Layer-specific Developmental Changes in Excitation and Inhibition in Rat Primary Visual Cortex
             % Roberta Tatti,1 Olivia K. Swanson,1,2 Melinda S. E. Lee,1 and Arianna Maffeicorresponding author1,2
             % Figure 3, rat, averaged data across all layers
             cp.title = 'E/I ratio'; cp.plot = p.plot; cp.color = p.color;
             %  cp.data = [10 0; 14 0.7803; 17  0.4328; 21  0.1439; 30   0.1385];
             cp.data = [14 0.7803; 17  0.4328; 21  0.1439; 30   0.1385];
             cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2)); 
             
             cp.LineStyle = '-';
             p = fit('pr.fit_synaptic_density', p, p.freeList, cp.data); cp.p = p;
             cp.curve = pr.cw_syn_density(p);
             cp.curve(p.t<14) = NaN;
         end
        
         
         %% POST SENSITIVE
         function cp = synaptic_density2(p)
             
             % Regional differences in synaptogenesis in human cerebral cortex
            % PR Huttenlocher, AS Dabholkar - Journal of comparative …, 1997
            % Fig 2, human [200, 12.6; 281, 25.8; 340, 26.4; 347, 312; 400, 50.7; 513, 57.8; 600, 56.0; 847, 49.2; 1670, 44.5; 4302, 35.3; 9395, 35.3];

            cp.title = 'synaptic density'; cp.plot = p.plot; cp.color = p.color;
            cp.data = [19, 12.6; 22, 25.8; 24, 26.4; 24, 32; 26, 50.7; 29, 57.8; 31, 56.0; 38, 49.2; 55, 44.5; 91, 35.3; 137, 35.3];
            cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2)); cp.LineStyle = '-';
            p = fit('pr.fit_synaptic_density', p, p.freeList, cp.data); cp.p = p;
            cp.curve = pr.cw_syn_density(p);
         end

        
        %% more
      
        function cp = munc13(p)
            % Progressive maturation of silent synapses governs the duration of a critical period.
            % Huang X, Stodieck SK, Goetze B, Cui L, Wong MH, Wenzel C, Hosang L, Dong Y, Löwel S, Schlüter OM.
            % Figure 3A
            % mice, postnatal days 9 11, 14, 19, 25, 38 90
            % corresponds to rat 8  10  13  17  23  34  78
            cp.title = 'Munc 13'; cp.plot = p.plot; cp.color = p.color;
            cp.data = [8   51; 10   59.8;  13   71.2;   17   87.7; 23   95.1; 34   99.6;  78  100.5];
            cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2)); cp.LineStyle = '-';
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
            cp.curve = pr.cum_weibull(p); cp.p = p;
            
        end
        
        function cp = BDNF(p)
            % BDNF Regulates the Maturation of Inhibition and the Critical Period of Plasticity in Mouse Visual Cortex
            % Huang et al. 1999
            % Figure 1 Expression of the BDNF Transgene
            % mouse postnatal = 2 7 15 21 28 35
            cp.title = 'BDNF'; cp.plot = p.plot; cp.color = p.color; % CHECK, BDNF also associated with Silent synapses
            cp.data = [2, 43;7, 96;15, 332;21, 350;28, 447;35, 518];
            cp.data(:, 2) = cp.data(:, 2)./(max(cp.data(:, 2))); cp.LineStyle = '-';
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
            cp.curve = pr.cum_weibull(p); cp.p = p;
        end
        function cp = PV_number(p)
            % BDNF Regulates the Maturation of Inhibition and the Critical Period of Plasticity in Mouse Visual Cortex
            % Huang et al. 1999
            % Figure 4B, Postnatal days mouse
            cp.title = 'PV Number'; cp.plot = p.plot; cp.color = p.color;
            cp.data = [ 11 1.7; 15, 39; 22 80; 32 74];
            cp.data(:, 2) = cp.data(:, 2)./(max(cp.data(:, 2))); cp.LineStyle = '-';
            freeList = {'thresh', 'beta'};
            p = fit('pr.fit_cum_weibull', p, freeList,cp.data);
            cp.curve = pr.cum_weibull(p); cp.p = p;
        end
         
        function cp = PNN(p)
            % Expression of Perineuronal Nets, Parvalbumin and Protein Tyrosine Phosphatase ? in the Rat Visual Cortex During Development and After BFD
            % Hui Liu, Haiwei Xu, Tao Yu, Junping Yao, Congjian Zhao & Zheng Qin Yin
            % Figure 6B
            % % PW1 (6–8 days, before eye opening),
            % PW3 (20–22 days, beginning of the critical period),
            % PW5 (34–36 days, middle to later stage of the critical period),
            % PW7 (48–50 days, end of the critical period) and
            % PW9 (62–64 days, adult).
            cp.title = 'PNN'; cp.plot = p.plot; cp.color = p.color;
            cp.data = [21, 31.6; 35, 74.9; 49, 67.4; 63, 82.3];
            cp.data(: , 2) = cp.data(:, 2)./max(cp.data(:, 2)); cp.LineStyle = '-';
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
            cp.curve = pr.cum_weibull(p); cp.p = p;
        end
     
        %% VISUAL ACUITY
        
        function cp = visual_acuity(p)
            %Functional Postnatal Development of the Rat
            % Primary Visual Cortex and the Role of Visual Experience: Dark Rearing and Monocular Deprivation
            % MICHELA FAGIOLINI,TOMMASO PIZZORUSSO,NICOLETTA BERARDI,LUCIANO DOMENICILAMBERTO MAFFEI
            % Figure 3B
            m = 9; cp.title = 'Visual Acuity'; cp.plot = p.plot; cp.color = p.color;
            cp.data = [22, 0.54; 26, 0.78; 30, 0.91; 45, 1.11];
            cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2)); cp.LineStyle = '-';
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
            cp.curve = pr.cum_weibull(p); cp.p = p;
        end
        function cp = OSI(p)
            %             The contribution of sensory experience to the maturation of orientation selectivity in ferret visual cortex
            %             LE White, DM Coppola, D Fitzpatrick - Nature, 2001
            %             Figure 2
            % postnatal weeks ferret 4 5 6 7 8 9 10 corresponds to
            % postnatal day in rates 12  15  18  20  23  25  27
            cp.title = 'OSI'; cp.plot = p.plot; cp.color = p.color;
            cp.data = [12, 3.5; 15, 6.5; 18, 17.8; 20, 26.7; 23, 27.6; 25, 32.0; 27, 26.1];
            cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2)); cp.LineStyle = '-';
            p = fit('pr.fit_cum_weibull', p, p.freeList,cp.data);
            cp.curve = pr.cum_weibull(p); cp.p = p;
        end
        
        function cp = OD_sensitivity(p)
            %Functional Postnatal Development of the Rat
            % Primary Visual Cortex and the Role of Visual Experience: Dark Rearing and Monocular Deprivation
            % MICHELA FAGIOLINI,TOMMASO PIZZORUSSO,NICOLETTA BERARDI,LUCIANO DOMENICILAMBERTO MAFFEI
            % Figure 6A, note used the beginning of the 10 day deprivation period for these
            % data
            cp.title = 'OD Sensitivity'; cp.plot = p.plot; cp.color = p.color;
            cp.data = [14+5, 0.19; 23+5, 0.54; 33+5, 0.039]; % add 5 days to get to mid-deprivation
            cp.data(:, 2) = cp.data(:, 2)./max(cp.data(:, 2)); cp.LineStyle = '-';
            pred = zeros(size(p.t));
            pred(p.t<=p.mu) = p.a*exp(-(p.t(p.t<=p.mu)-p.mu).^2/(2*p.sigma(1)^2));
            pred(p.t>p.mu) = p.a*exp(-(p.t(p.t>p.mu)-p.mu).^2/(2*p.sigma(2)^2));
            cp.curve = pred; cp.p = p;
        end
   

        
        %% FUNCTION FITTING
        
        function cw = cum_weibull(p)
            k = (-log( (1-p.e)/(1-p.g)))^(1/p.beta);
            cw = p.asymptote*(1 - (1-p.g)*exp(-(k.*p.t/p.thresh).^p.beta));
        end
           function err = fit_cum_weibull(p, D)
            p.t = D(:, 1);
            cw = pr.cum_weibull(p);
          %  err = -log(1-cw')*(1-D(:, 2))-log(cw')*D(:, 2);
            err = sum((cw-D(:, 2)).^2);
           end
        function cw = cw_syn_density(p)
            cw = zeros(size(p.t));
    
            cw(p.t<=p.mu) = exp(-(p.t(p.t<=p.mu)-p.mu).^2/(2*p.sigma(1)^2)) + p.c(1);
          %  cw(p.t<=p.mu)=  cw(p.t<=p.mu)./max( cw(p.t<=p.mu));
             
            cw(p.t>p.mu) =  (1-p.c(2)).*exp(-p.sigma(2) * (p.t(p.t>p.mu)-p.mu)) + p.c(2);
            %  cw(p.t>p.mu)= cw(p.t>p.mu)./max( cw(p.t>p.mu));
          %  cw(p.t>p.mu) =  (1-p.c(2)) * exp(-(p.t(p.t>p.mu)-p.mu).^2/(2*p.sigma(2)^2)) + p.c(2);
        end
        function err = fit_synaptic_density(p, D)
            p.t = D(:, 1);
            cw = pr.cw_syn_density(p);
            err = sum((cw-D(:, 2)).^2);
        end
      
        function D = flip_data(D)
            tmp = D(:, 2); %%  D(:, 2) = (max(D(:, 2))-D(:, 2)); D(:, 2) = D(:, 2)./max(D(:, 2));
            tmp = (max(tmp)-tmp) +min(tmp); % flip it
            D(:, 2) = pr.scale(tmp, 0, 1, 0 ,max(tmp));
        end
        function cw = flip_exp(p)
            cw = 1-exp(-(p.t-p.shift)/p.tau);
            cw(p.t<p.shift) = NaN;
        end
        function err = fit_flip_exp(p, D)
            p.t = D(:, 1);
            cw = pr.flip_exp(p);
            err = sum((cw-D(:, 2)).^2);
        end
         %% HELPERS
        function sim = scale(im, varargin)
            %  function sim = scaleif(im, newMin, newMax, oldMin, oldMax)
            %  Scales an image such that its lowest value attains newMin and
            %  it’s highest value attains newMax.  OldMin and oldMax are not
            %  necessary but are useful when you don't want to use the true
            %  min or max value.
            %
            % Adapted by Ione Fine, based on code from Rick Anthony
            % 6/5/2000
            
            if length(varargin)==0
                newMin=0;
                newMax=1;
                oldMin = min(im(:));   oldMax = max(im(:));
            elseif length(varargin)==2
                newMin=varargin{1};
                newMax=varargin{2};
                oldMin = min(im(:));
                oldMax = max(im(:));
            elseif length(varargin)==4
                newMin=varargin{1};
                newMax=varargin{2};
                oldMin=varargin{3};
                oldMax=varargin{4};
            else
                disp('Wrong number of input arguments')
                sim=NaN;   return
            end
            
            if (newMin>=newMax)
                disp('Sorry new min must be smaller than new max');
                sim=NaN;  return
            end
            
            if (oldMin>=oldMax)
                disp('Sorry old min must be smaller than old max');
                sim=NaN;
                return
            end
            delta = (newMax-newMin)/(oldMax-oldMin);
            sim = delta*(im-oldMin) + newMin;
        end
    end
end