function [out]=translatingtime2(days, speciesIn, pflag, speciesOut)
%   TRANLATINGTIME(DAYS, SPECIES, PFLAG) 
%   TRANSLATINGTIME implements the Workman translating time model to translate time across
%   species
%   http://www.translatingtime.net/
%   TRANLATINGTIME(days, species, pflag) 
%   Note that the Workman model has interaction terms that aren't
%   implemented, so these numbers will be WRONG for cortical neurogenesis in
% or anything to do with cat retina.
% Input:
%       days: (postconception or postnatal) for the input species
%       speciesIn: cell containing name of the input species {'Rat'} 
%       pflag: ('PC' or 'PN' to represent post-conception or postnatal)
%      speciesOut: cell array containing the species to convert into
% Returns:
%       the Workman event score, and equivalent post-conception and postnatal days for 
%       for rat, ferret and human
% easy to add more species, using the numbers from this table%
%
% NOTE, doesn't accurately report neurogenesis events!!!
% http://www.translatingtime.net/species
if nargin < 4
    disp('Output species not specified, using default values');
    speciesOut = {'Mouse', 'Rat', 'Rhesus Macaque', 'Human'};
end

TT = makeTable;

if ~sum(strcmp(speciesIn{1}, TT.Properties.RowNames))
    disp('Species Input not recognized: acceptable species are: ...');
for i = 1:length( TT.Properties.RowNames)
    disp(TT.Properties.RowNames{i});
end
return
end

TTin = TT(speciesIn{1}, : );

if ~exist('pflag');  disp('using post-conception days'); pflag='PC'; end 
if strcmp(pflag, 'PC') pc = days;
elseif strcmp(pflag, 'PN') pc = days+TTin.Gestation; 
else error('third input argument not an accceptable value, should be PC (postconception or PN (postnatal)'); end
es = (log(pc)-TTin.Constant)./TTin.Slope; % es stands for the eventscale

%% display stuff
disp('........................')
disp(['Input species ' , speciesIn{1}]);
disp(['Post-conception day = ', num2str(pc)])
disp(['Post-natal day = ', num2str(pc - TTin.Gestation)]);
disp(['Event scale = ', num2str(es)]);

for i = 1:length(speciesOut)
    if ~sum(strcmp(speciesOut{i}, TT.Properties.RowNames))
        disp([speciesOut{i}, ' - Species out not recognized']);
    else
        TTout = TT(speciesOut{i}, : );
        out_PC = round(exp(TTout.Constant + TTout.Slope*es));
        disp(speciesOut{i})
         
         disp(['Post-conception day = ', num2str(out_PC)])
        disp(['Post-natal day = ', num2str(out_PC - TTout.Gestation)]);
        disp('........................')
    end
    out(i,:) = {speciesOut{i}, out_PC, (out_PC -TTout.Gestation), es};
end
  

function TT = makeTable

varNames = {'Species' ,'Species_Name','Constant',	'Slope' ,'Precocial_Score','Brain', 'Weight',	'Gestation'};
% brain in grams, weight in grams, gestation in days

var = {'Bush-TailedOpossum'	'Trichosurus vulpecula' 	2.793 	2.508 	0.871 	9.4 	3150 	17.5
'Cat' 	'Felis catus' 	2.784 	2.28 	0.61 	28.4 	4000 	65
'Dunnart' 	'Smithopsis crassicaudata' 	2.576 	2.508 	0.612 	0.3 	32 	13.5
'Ferret' 	'Mustela putorius' 	2.706 	2.174 	0.463 	7.1 	1900 	41
'Gerbil' 	'Meriones unguiculatus' 	2.532 	1.715 	0.401 	1.02 	70 	25
'Guinea_Pig' 	'Cavia porcellus' 	2.904 	1.573 	0.841 	4 	640 	68.5
'Hamster' 	'Mesocricetus auratus' 	2.189 	1.644 	0.336 	1.12 	108 	15.5
'Human' 	'Homo sapiens' 	3.167 	3.72 	0.654 	1350 	70000 	270
'Mouse' 	'Mus musculus' 	2.145 	1.894 	0.408 	0.45 	18 	18.5
'Quokka' 	'Setonix brachyurus' 	3.03 	2.508 	0.884 	13.9 	2700 	27
'Quoll' 	'Dasyurus hallucatus' 	2.759 	2.508 	0.65 	3.38 	650 	18
'Rabbit' 	'Oryctolagus cuniculus' 	2.382 	1.959 	0.537 	9.6 	2170 	31
'Rat' 	'Rattus norvegicus' 	2.31 	1.705 	0.445 	2 	207 	21
'Rhesus Macaque' 	'Macaca mulatta' 	3.27 	2.413 	0.761 	93.8 	5340 	165
'Sheep' 	'Ovis aries' 	2.909 	2.533 	0.822 	160 	45000 	147
'Short-Tailed Opossum' 	'Monodelphis domestica' 	2.261 	2.508 	0.717 	8 	105 	13.5
'Spiny Mouse' 	'Acomys cahirinus' 	2.82 	0.622 	1.356 	0.7 	42 	39
'Wallaby' 	'Macropus eugenii' 	3.141 	2.508 	0.949 	20 	115 	29.3};
TT = cell2table(var, 'VariableNames', varNames, 'RowNames', var(:, 1));
end
end
