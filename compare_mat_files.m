clear; clc; close all;

compare_mat_files('pa_data_old.mat','pa_data.mat',1e-11);

function compare_mat_files(fileA, fileB, tol)
%COMPARE_MAT_FILES Deep comparison of two MAT files
%
%   compare_mat_files('a.mat','b.mat',1e-12)
%
%   tol = numerical tolerance for floating point comparison

if nargin < 3
    tol = 1e-12;
end

fprintf('\n=============================================\n');
fprintf('Comparing:\n  %s\n  %s\n', fileA, fileB);
fprintf('Tolerance = %.2e\n', tol);
fprintf('=============================================\n');

A = load(fileA);
B = load(fileB);

namesA = fieldnames(A);
namesB = fieldnames(B);

%% Check variable list
onlyA = setdiff(namesA, namesB);
onlyB = setdiff(namesB, namesA);

if ~isempty(onlyA)
    fprintf('\nVariables only in %s:\n', fileA);
    disp(onlyA);
end
if ~isempty(onlyB)
    fprintf('\nVariables only in %s:\n', fileB);
    disp(onlyB);
end

common = intersect(namesA, namesB);

%% Compare variable contents
for k = 1:numel(common)
    name = common{k};
    a = A.(name);
    b = B.(name);

    fprintf('\nChecking variable: %s\n', name);

    if ~strcmp(class(a), class(b))
        fprintf('  ? Class mismatch: %s vs %s\n', class(a), class(b));
        continue;
    end

    if ~isequal(size(a), size(b))
        fprintf('  ? Size mismatch: %s vs %s\n', mat2str(size(a)), mat2str(size(b)));
        continue;
    end

    % Numeric
    if isnumeric(a)
        diff = abs(a - b);
        maxErr = max(diff(:));
        if maxErr > tol
            fprintf('  ? Numeric mismatch | max error = %.3e\n', maxErr);
        else
            fprintf('  ? Numeric equal (max error = %.3e)\n', maxErr);
        end

    % Char / string
    elseif ischar(a) || isstring(a)
        if isequal(a, b)
            fprintf('  ? Text equal\n');
        else
            fprintf('  ? Text mismatch\n');
        end

    % Cell
    elseif iscell(a)
        if isequal(a, b)
            fprintf('  ? Cell equal\n');
        else
            fprintf('  ? Cell mismatch\n');
        end

    % Struct
    elseif isstruct(a)
        if isequal(a, b)
            fprintf('  ? Struct equal\n');
        else
            fprintf('  ? Struct mismatch\n');
        end

    % Fallback
    else
        if isequal(a, b)
            fprintf('  ? Equal\n');
        else
            fprintf('  ? Mismatch\n');
        end
    end
end

fprintf('\nComparison complete.\n\n');
end
