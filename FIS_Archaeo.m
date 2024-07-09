% 


addpath(fullfile(matlabroot, 'toolbox', 'fuzzy'));

%  
fis = newfis('ArqueologiaRevisor', 'mamdani');

%  
fis = addvar(fis, 'input', 'Use', [0 1]);
fis = addmf(fis, 'input', 1, 'Low', 'trapmf', [0 0 0.3 0.5]);
fis = addmf(fis, 'input', 1, 'Medium', 'trimf', [0.3 0.5 0.7]);
fis = addmf(fis, 'input', 1, 'High', 'trapmf', [0.5 0.7 1 1]);

fis = addvar(fis, 'input', 'Chronology', [0 1]);
fis = addmf(fis, 'input', 2, 'Low', 'trapmf', [0 0 0.3 0.5]);
fis = addmf(fis, 'input', 2, 'Medium', 'trimf', [0.3 0.5 0.7]);
fis = addmf(fis, 'input', 2, 'High', 'trapmf', [0.5 0.7 1 1]);

fis = addvar(fis, 'input', 'ExpertiseUse', [0 1]);
fis = addmf(fis, 'input', 3, 'Low', 'trapmf', [0 0 0.3 0.5]);
fis = addmf(fis, 'input', 3, 'Medium', 'trimf', [0.3 0.5 0.7]);
fis = addmf(fis, 'input', 3, 'High', 'trapmf', [0.5 0.7 1 1]);

fis = addvar(fis, 'input', 'ExpertiseChronology', [0 1]);
fis = addmf(fis, 'input', 4, 'Low', 'trapmf', [0 0 0.3 0.5]);
fis = addmf(fis, 'input', 4, 'Medium', 'trimf', [0.3 0.5 0.7]);
fis = addmf(fis, 'input', 4, 'High', 'trapmf', [0.5 0.7 1 1]);

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

% 3. Definir la variable de salida
fis = addvar(fis, 'output', 'Decision', [0 1]);
fis = addmf(fis, 'output', 1, 'No Review', 'trimf', [0 0 0.5]);
fis = addmf(fis, 'output', 1, 'Review', 'trimf', [0.5 1 1]);

% 4. Definir las reglas
rules = [
    0 0 1 1 2 1 1  % IF expertise_use is Low AND expertise_chronology is Low THEN Review
    0 0 1 2 2 1 1  % IF expertise_use is Low AND expertise_chronology is Medium THEN Review
    0 0 2 1 2 1 1  % IF expertise_use is Medium AND expertise_chronology is Low THEN Review
    0 0 3 3 1 1 1  % IF expertise_use is High AND expertise_chronology is High THEN No Review
    0 0 3 2 1 1 1  % IF expertise_use is High AND expertise_chronology is Medium THEN No Review
    0 0 3 1 1 1 1  % IF expertise_use is High AND expertise_chronology is Low THEN No Review
    0 0 1 3 1 1 1  % IF expertise_use is Low AND expertise_chronology is High THEN No Review
    0 0 2 3 1 1 1  % IF expertise_use is Medium AND expertise_chronology is High THEN No Review
    0 0 2 2 1 1 1  % IF BOTH EXPERTISES ARE MEDIUM, THEN NO REVIEW
];

fis = addRule(fis, rules);

% 5. defuzzification
fis = setfis(fis, 'defuzzmethod', 'centroid');

% 6. centroid
function centroid = calculate_centroid(vector_difuso)
    x = linspace(0, 1, length(vector_difuso));
    centroid = sum(x .* vector_difuso) / sum(vector_difuso);
end

% 7. Archaeological sites
sites = {
    {[1, 1, 0, 0, 0, 0], [0, 0, 0.5, 0, 0, 1], [0.5, 0.5, 0, 0, 0, 0], [1, 1, 0.2, 0.2, 0.2, 0.2]},
    {[0, 0, 1, 0.25, 0, 0], [1, 0.5, 1, 0, 0, 0.25], [0.5, 0.4, 0.5, 0.3, 0.3, 0.3], [0.5, 0.5, 0.5, 0, 0, 0.5]},
    {[0, 0.75, 0, 0.8, 0.5, 0], [0, 0, 0, 0.75, 0.75, 0.75], [0, 1, 0, 1, 0.5, 0], [0, 0, 0, 0.4, 0.4, 0.25]},
    {[0, 0, 0, 0.25, 0, 1], [0.4, 0, 1, 0.2, 0, 0.2], [0, 0, 0, 1, 0, 1], [0.3, 0.3, 1, 0.4, 0.2, 0.6]},
};

% 8. 
results = cell(length(sites), 1);

for i = 1:length(sites)
    Y_use = sites{i}{1};
    Y_chron = sites{i}{2};
    Y_expertise_use = sites{i}{3};
    Y_expertise_chron = sites{i}{4};
    
    use_centroid = calculate_centroid(Y_use);
    chron_centroid = calculate_centroid(Y_chron);
    expertise_use_centroid = calculate_centroid(Y_expertise_use);
    expertise_chron_centroid = calculate_centroid(Y_expertise_chron);
    
    input = [use_centroid, chron_centroid, expertise_use_centroid, expertise_chron_centroid];
    fprintf(' YACIMIENTO %f: Centroides antes de tomar decision: [%f, %f, %f, %f]', i, use_centroid, chron_centroid, expertise_use_centroid, expertise_chron_centroid);
    output = evalfis(input, fis);
    
    results{i} = struct('use', Y_use, 'chronology', Y_chron, ...
        'expertise_use', Y_expertise_use, 'expertise_chronology', Y_expertise_chron, ...
        'decision_value', output);
end

% 9. Results in Spanish
for i = 1:length(results)
    fprintf('Sitio %d:\n', i);
    fprintf('Uso: [%.2f, %.2f, %.2f, %.2f, %.2f, %.2f]\n', results{i}.use);
    fprintf('Cronología: [%.2f, %.2f, %.2f, %.2f, %.2f, %.2f]\n', results{i}.chronology);
    fprintf('Experiencia en Uso: [%.2f, %.2f, %.2f, %.2f, %.2f, %.2f]\n', results{i}.expertise_use);
    fprintf('Experiencia en Cronología: [%.2f, %.2f, %.2f, %.2f, %.2f, %.2f]\n', results{i}.expertise_chronology);
    fprintf('Valor de Decisión: %.2f\n', results{i}.decision_value);
    if results{i}.decision_value > 0.5 
        fprintf('Decisión: REVIEW\n');
    else
        fprintf('Decisión: NO REVIEW\n');
    end
    fprintf('\n');
end



%  Showing results
for i = 1:length(results)
    fprintf('Site %d:\n', i);
    fprintf('Use: [%.2f, %.2f, %.2f, %.2f]\n', results{i}.use);
    fprintf('Chronology: [%.2f, %.2f, %.2f]\n', results{i}.chronology);
    fprintf('Expertise Use: [%.2f, %.2f, %.2f, %.2f]\n', results{i}.expertise_use);
    fprintf('Expertise Chronology: [%.2f, %.2f, %.2f]\n', results{i}.expertise_chronology);
    fprintf('Decision FIS: ');
    if results{i}.decision_value > 0.5
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

% 
% Bar plots by archaeological site
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
    ylabel('Membership degrees');

    subplot(2,2,3);
    bar(results{i}.expertise_use);
    title(sprintf('Use expertise - SITE %d', i));
    ylim([0 1]);
    xlabel('Use EXPERTISE categories');
    ylabel('Membership degrees');

    subplot(2,2,4);
    bar(results{i}.expertise_chronology);
    title(sprintf('Chronology EXPERTISE - SITE %d', i));
    ylim([0 1]);
    xlabel('Chronology EXPERTISE categories');
    ylabel('Membership degrees');
end



%Visualizing the fis
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

%Combined expertise-based decision surface
% FIRST ARCHAEOLOGICAL SITE
site = sites{1};

% Calculate centroids for fixed values
use_centroid = calculate_centroid(site{1});
chron_centroid = calculate_centroid(site{2});
expertise_use_centroid = calculate_centroid(site{3});
expertise_chron_centroid = calculate_centroid(site{4});

% Range value for ExpertiseUse and ExpertiseChronology
expertise_range = linspace(0, 1, 101);

% Results matriz initialization
z = zeros(101, 101);

% Calculate the output values ​​for each combination of ExpertiseUse and ExpertiseChronology
for i = 1:101
    for j = 1:101
        input = [use_centroid, chron_centroid, expertise_range(i), expertise_range(j)];
        z(i, j) = evalfis(input, fis);
    end
end

% Surface plot
figure;
surf(expertise_range, expertise_range, z');


title('Archaeological Site 1 Fortunatus: ExpertiseUse vs ExpertiseChronology');
xlabel('ExpertiseUse');
ylabel('ExpertiseChronology');
zlabel('Decisión');
colorbar;

% Archaeological site representation
hold on;
plot3(expertise_use_centroid, expertise_chron_centroid, ...
    interp2(expertise_range, expertise_range, z', expertise_use_centroid, expertise_chron_centroid), ...
    'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
hold off;

% Centroid's values
fprintf('Archaeological Site 1 Fortunatus Centroids:\n');
fprintf('Use: %.2f\n', use_centroid);
fprintf('Chronology: %.2f\n', chron_centroid);
fprintf('ExpertiseUse: %.2f\n', expertise_use_centroid);
fprintf('ExpertiseChronology: %.2f\n', expertise_chron_centroid);


% SECOND ARCHAEOLOGICAL SITE
site = sites{2};

% Calculate centroids for fixed values
use_centroid = calculate_centroid(site{1});
chron_centroid = calculate_centroid(site{2});
expertise_use_centroid = calculate_centroid(site{3});
expertise_chron_centroid = calculate_centroid(site{4});

% Range value for ExpertiseUse and ExpertiseChronologyy
expertise_range = linspace(0, 1, 101);

% Results matriz initialization
z = zeros(101, 101);

% Calculate the output values ​​for each combination of ExpertiseUse and ExpertiseChronology
for i = 1:101
    for j = 1:101
        input = [use_centroid, chron_centroid, expertise_range(i), expertise_range(j)];
        z(i, j) = evalfis(input, fis);
    end
end

% Surface plot
figure;
surf(expertise_range, expertise_range, z');


title('Archaeological Site 2 Guzmán: ExpertiseUse vs ExpertiseChronology');
xlabel('ExpertiseUse');
ylabel('ExpertiseChronology');
zlabel('Decisión');
colorbar;

% Archaeological site representation
hold on;
plot3(expertise_use_centroid, expertise_chron_centroid, ...
    interp2(expertise_range, expertise_range, z', expertise_use_centroid, expertise_chron_centroid), ...
    'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
hold off;

% Centroid's values
fprintf('Archaeological Site 2 Guzmán Centroids:\n');
fprintf('Use: %.2f\n', use_centroid);
fprintf('Chronology: %.2f\n', chron_centroid);
fprintf('ExpertiseUse: %.2f\n', expertise_use_centroid);
fprintf('ExpertiseChronology: %.2f\n', expertise_chron_centroid);

% THIRD ARCHAEOLOGICAL SITE
site = sites{3};

%Calculate centroids for fixed values
use_centroid = calculate_centroid(site{1});
chron_centroid = calculate_centroid(site{2});
expertise_use_centroid = calculate_centroid(site{3});
expertise_chron_centroid = calculate_centroid(site{4});

% Range value for ExpertiseUse and ExpertiseChronology
expertise_range = linspace(0, 1, 101);

% Results matriz initialization
z = zeros(101, 101);

% Calculate the output values ​​for each combination of ExpertiseUse and ExpertiseChronology
for i = 1:101
    for j = 1:101
        input = [use_centroid, chron_centroid, expertise_range(i), expertise_range(j)];
        z(i, j) = evalfis(input, fis);
    end
end

% Surface plot
figure;
surf(expertise_range, expertise_range, z');


title('Archaeological Site 3 El Mandalor: ExpertiseUse vs ExpertiseChronology');
xlabel('ExpertiseUse');
ylabel('ExpertiseChronology');
zlabel('Decisión');
colorbar;

% Archaeological site representation
hold on;
plot3(expertise_use_centroid, expertise_chron_centroid, ...
    interp2(expertise_range, expertise_range, z', expertise_use_centroid, expertise_chron_centroid), ...
    'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
hold off;

% Centroid's values
fprintf('Archaeological Site 3 El Mandalor Centroids:\n');
fprintf('Use: %.2f\n', use_centroid);
fprintf('Chronology: %.2f\n', chron_centroid);
fprintf('ExpertiseUse: %.2f\n', expertise_use_centroid);
fprintf('ExpertiseChronology: %.2f\n', expertise_chron_centroid);

% FOURTH ARCHAEOLOGICAL SITE
site = sites{4};

% Calculate centroids for fixed values
use_centroid = calculate_centroid(site{1});
chron_centroid = calculate_centroid(site{2});
expertise_use_centroid = calculate_centroid(site{3});
expertise_chron_centroid = calculate_centroid(site{4});

% Range value for ExpertiseUse and ExpertiseChronology
expertise_range = linspace(0, 1, 101);

% Results matriz initialization
z = zeros(101, 101);

% Calculate the output values ​​for each combination of ExpertiseUse and ExpertiseChronology
for i = 1:101
    for j = 1:101
        input = [use_centroid, chron_centroid, expertise_range(i), expertise_range(j)];
        z(i, j) = evalfis(input, fis);
    end
end

% Surface plot
figure;
surf(expertise_range, expertise_range, z');


title('Archaeological Site 4 Las Penas: ExpertiseUse vs ExpertiseChronology');
xlabel('ExpertiseUse');
ylabel('ExpertiseChronology');
zlabel('Decision');
colorbar;

% Archaeological site representation
hold on;
plot3(expertise_use_centroid, expertise_chron_centroid, ...
    interp2(expertise_range, expertise_range, z', expertise_use_centroid, expertise_chron_centroid), ...
    'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
hold off;

% Centroid's values
fprintf('Archaeological Site 4 Las Penas Centroids:\n');
fprintf('Use: %.2f\n', use_centroid);
fprintf('Chronology: %.2f\n', chron_centroid);
fprintf('ExpertiseUse: %.2f\n', expertise_use_centroid);
fprintf('ExpertiseChronology: %.2f\n', expertise_chron_centroid);
