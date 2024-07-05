% Script to implement a mamdani's fuzzy infernece system for archaeological review decisions in function of the annotator's expertise vagueness with multiple sites

% Fuzzy Logic Toolbox
addpath(fullfile(matlabroot, 'toolbox', 'fuzzy'));

% 1.  (FIS)
fis = newfis('ArqueologiaRevisor', 'mamdani');

% Input 1: archaeological case USE linguistic tags
fis = addvar(fis, 'input', 'Use', [0 1]);
fis = addmf(fis, 'input', 1, 'Low', 'trapmf', [0 0 0.3 0.5]);
fis = addmf(fis, 'input', 1, 'Medium', 'trimf', [0.3 0.5 0.7]);
fis = addmf(fis, 'input', 1, 'High', 'trapmf', [0.5 0.7 1 1]);

% Input 2: archaeological case CHRONOLOGY linguistic tags
fis = addvar(fis, 'input', 'Chronology', [0 1]);
fis = addmf(fis, 'input', 2, 'Low', 'trapmf', [0 0 0.3 0.5]);
fis = addmf(fis, 'input', 2, 'Medium', 'trimf', [0.3 0.5 0.7]);
fis = addmf(fis, 'input', 2, 'High', 'trapmf', [0.5 0.7 1 1]);

% Input 3: archaeological case USE EXPERTISE linguistic tags
fis = addvar(fis, 'input', 'ExpertiseUse', [0 1]);
fis = addmf(fis, 'input', 3, 'Low', 'trapmf', [0 0 0.3 0.5]);
fis = addmf(fis, 'input', 3, 'Medium', 'trimf', [0.3 0.5 0.7]);
fis = addmf(fis, 'input', 3, 'High', 'trapmf', [0.5 0.7 1 1]);

% Input 4 4: archaeological case USE CHRONOLOGY linguistic tags
fis = addvar(fis, 'input', 'ExpertiseChronology', [0 1]);
fis = addmf(fis, 'input', 4, 'Low', 'trapmf', [0 0 0.3 0.5]);
fis = addmf(fis, 'input', 4, 'Medium', 'trimf', [0.3 0.5 0.7]);
fis = addmf(fis, 'input', 4, 'High', 'trapmf', [0.5 0.7 1 1]);

% Membership functions for each type of defined USE
fis = addMF(fis, 'Use', 'gaussmf', [0.1 1], 'Name', 'Basilica');
fis = addMF(fis, 'Use', 'gaussmf', [0.1 1], 'Name', 'Roman Villa');
fis = addMF(fis, 'Use', 'gaussmf', [0.1 1], 'Name', 'Fortification');
fis = addMF(fis, 'Use', 'gaussmf', [0.1 1], 'Name', 'Habitat');
fis = addMF(fis, 'Use', 'gaussmf', [0.1 1], 'Name', 'Farm');
fis = addMF(fis, 'Use', 'gaussmf', [0.1 1], 'Name', 'Funeral Space');

% Membership functions for each type of defined CHRONOLOGY
fis = addMF(fis, 'Chronology', 'gaussmf', [0.1 1], 'Name', 'c1: Middle Ages');
fis = addMF(fis, 'Chronology', 'gaussmf', [0.1 1], 'Name', 'c2: Late Middle Ages');
fis = addMF(fis, 'Chronology', 'gaussmf', [0.1 1], 'Name', 'c3: Early Middle Ages');
fis = addMF(fis, 'Chronology', 'gaussmf', [0.1 1], 'Name', 'c4: Roman Imperial');
fis = addMF(fis, 'Chronology', 'gaussmf', [0.1 1], 'Name', 'c5: Roman High Imperial');
fis = addMF(fis, 'Chronology', 'gaussmf', [0.1 1], 'Name', 'c6: Late Antiquity');

% Membership functions for each type of defined EXPERTISE IN USE
fis = addMF(fis, 'ExpertiseUse', 'gaussmf', [0.1 0.4], 'Name', 'NonExpert');
fis = addMF(fis, 'ExpertiseUse', 'gaussmf', [0.4 0.7], 'Name', 'Medium Expert');
fis = addMF(fis, 'ExpertiseUse', 'gaussmf', [0.7 1], 'Name', 'Expert');

% Membership functions for each type of defined EXPERTISE IN CHRONOLOGY
fis = addMF(fis, 'ExpertiseChronology', 'gaussmf', [0.1 0.4], 'Name', 'NonExpert');
fis = addMF(fis, 'ExpertiseChronology', 'gaussmf', [0.4 0.7], 'Name', 'Medium Expert');
fis = addMF(fis, 'ExpertiseChronology', 'gaussmf', [0.7 1], 'Name', 'Expert');

% Output: REVIEW DECISION
fis = addvar(fis, 'output', 'Decision', [0 1]);
fis = addmf(fis, 'output', 1, 'No Review', 'trimf', [0 0 0.5]);
fis = addmf(fis, 'output', 1, 'Review', 'trimf', [0.5 1 1]);

% 2. Fuzzy Mandani's rule system. Definition

rule1=[0 0 1 1 2 1 1]; % IF expertise_use is Low AND expertise_chronology is Low THEN Review
rule2=[0 0 1 2 2 1 1]; % IF expertise_use is Low AND expertise_chronology is Medium THEN Review
rule3=[0 0 2 1 2 1 1]; % IF expertise_use is Medium AND expertise_chronology is Low THEN Review
rule4=[0 0 3 3 1 1 1]; % IF expertise_use is High AND expertise_chronology is High THEN No Review
rule5=[0 0 3 2 1 1 1]; % IF expertise_use is High AND expertise_chronology is Medium THEN No Review
rule6=[0 0 3 3 1 1 1]; % IF expertise_use is High AND expertise_chronology is High THEN No Review
rule7=[0 0 3 1 2 1 1]; % IF expertise_use is High AND expertise_chronology is Low THEN No Review
rule8=[0 0 1 3 2 1 1]; % IF expertise_use is Low AND expertise_chronology is High THEN No Review
rule9=[0 0 2 3 2 1 1]; % IF expertise_use is Medium AND expertise_chronology is High THEN No Review
rule0=[0 0 2 2 1 1 1]; % IF BOTH EXPERTISES ARE MEDIUM, THEN NO REVIEW


fis = addRule(fis, [rule1; rule2; rule3; rule4; rule5; rule6; rule7; rule8; rule9; rule0]);

% 3. Process function for multievaluate input
function [valor_maximo, indice_maximo] = procesar_entrada_multivaluada(vector_difuso)
    [valor_maximo, indice_maximo] = max(vector_difuso);
end

% 4. function for apply cusomized inference rules
function decision_custom = custom(uso, expertise_uso)
    if all(uso <= 0.9) && all(expertise_uso < 0.4)
        decision_custom = 1; % Review
    else
        decision_custom = 0; % No Review
    end
end

% 5. Illustration example, list of archaeological sites: Y1 Fortunatus,
% Y2 Guzmán, Y3 El Mandalor, Y4 Las Penas
sites = {
    % Y1_use, Y1_chronology, Y1_expertise_use, chronology
    {[1, 1, 0, 0, 0, 0], [0, 0, 0.5, 0, 0, 1], [0.5, 0.5, 0, 0, 0, 0], [1, 1, 0.2, 0.2, 0.2, 0.2]},
    {[0, 0, 1, 0.25, 0, 0], [1, 0.5, 1, 0, 0, 0.25], [0.5, 0.4, 0.5, 0.3, 0.3, 0.3], [0.5, 0.5, 0.5, 0, 0, 0.5]},
    {[0, 0.75, 0, 0.8, 0.5, 0], [0, 0, 0, 0.75, 0.75, 0.75], [0, 1, 0, 1, 0.5, 0], [0, 0, 0, 0,4, 0.4, 0.25]},
    {[0, 0, 0, 0.25, 0, 1], [0.4, 0, 1, 0.2, 0, 0.2], [0, 0, 0, 1, 0, 1], [0.3, 0.3, 1, 0.4, 0.2, 0.6]},
};

% 6. Archaeological sites fis evaluation
results = cell(length(sites), 1);

for i = 1:length(sites)
    Y_use = sites{i}{1};
    Y_chron = sites{i}{2};
    Y_expertise_use = sites{i}{3};
    Y_expertise_chron = sites{i}{4};
    
    [use_max, ~] = procesar_entrada_multivaluada(Y_use);
    [chron_max, ~] = procesar_entrada_multivaluada(Y_chron);
    [expertise_use_max, ~] = procesar_entrada_multivaluada(Y_expertise_use);
    [expertise_chron_max, ~] = procesar_entrada_multivaluada(Y_expertise_chron);
    
    input = [use_max, chron_max, expertise_use_max, expertise_chron_max];
    %fis.DefuzzificationMethod = "centroid";
    output_fis = evalfis(input, fis);
    
    decision_custom = custom(Y_use, Y_expertise_use);
    
    results{i} = struct('use', Y_use, 'chronology', Y_chron, ...
        'expertise_use', Y_expertise_use, 'expertise_chronology', Y_expertise_chron, ...
        'decision_fis', output_fis, 'decision_custom', decision_custom);
end

% 7. Showing results
for i = 1:length(results)
    fprintf('Site %d:\n', i);
    fprintf('Use: [%.2f, %.2f, %.2f, %.2f]\n', results{i}.use);
    fprintf('Chronology: [%.2f, %.2f, %.2f]\n', results{i}.chronology);
    fprintf('Expertise Use: [%.2f, %.2f, %.2f, %.2f]\n', results{i}.expertise_use);
    fprintf('Expertise Chronology: [%.2f, %.2f, %.2f]\n', results{i}.expertise_chronology);
    fprintf('Decision FIS: ');
    if results{i}.decision_fis > 0.5
        fprintf('REVIEW\n');
    else
        fprintf('NO REVIEW\n');
    end
   % fprintf('Custom rule decision: ');
   % if results{i}.decision_custom == 1
   %     fprintf('REVIEW\n');
   % else
   %     fprintf('NO REVIEW\n');
   % end
    fprintf('\n');
end

% 8. Visualización
% Gráficos de barras para cada yacimiento
for i = 1:length(results)
    figure;
    subplot(2,2,1);
    bar(results{i}.use);
    title(sprintf('Use - SITE %d', i));
    ylim([0 1]);
    xlabel('Use categories');
    ylabel('Membership degrees');
    
    subplot(2,2,2);
    bar(results{i}.chronology);
    title(sprintf('Chronology - SITE %d', i));
    ylim([0 1]);
    xlabel('Chronology categories');
    ylabel('Membership degreesa');
    
    subplot(2,2,3);
    bar(results{i}.expertise_use);
    title(sprintf('Use expertise - SITE %d', i));
    ylim([0 1]);
    xlabel('Use EXPERTISE categories');
    ylabel('Membership degrees');
    
    subplot(2,2,4);
    bar(results{i}.expertise_chronology);
    title(sprintf('CHRONOLOGY EXPERTISE Cronología - SITE %d', i));
    ylim([0 1]);
    xlabel('CChronology EXPERTIS categories');
    ylabel('Membership degrees');
end

%Superficie de decisión combinada??
% Visualizar el sistema difuso
figure;
subplot(2,2,1), plotmf(fis, 'input', 1);
title('Membership functions for Use');
subplot(2,2,2), plotmf(fis, 'input', 2);
title('Membership functions for Chronology');
subplot(2,2,3), plotmf(fis, 'input', 3);
title('Membership functions for Expertis in Use');
subplot(2,2,4), plotmf(fis, 'input', 4);
title('Membership functions for Expertis in Chronology');
subplot(2,2,1), plotmf(fis, 'output', 1);
title('Membership functions for Revision Output');