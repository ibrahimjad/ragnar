clear all
close all
syms a b c d e f g h i j k
B = [a b c;d e f;g h i;i j k]

% For this experiment we attempted to find the pinv of a 4x3 syms matrix.
% The elapsed computation time are listed below as well.

 pinv(B) % 30 sek
 assume(B,'real')
 pinv(B) % 10 sek


% If we have less syms and have numbers in some entries, it takes shorter
% time.
B = [1 2 3;1 2 3;g h i;i j k]
pinv(B) % 10 sek
assume(B,'real')
pinv(B) % 3 sek

%% This is essentielly how our B-matrix looks, regarding the size and 
%  entry type.
% It takes long time to compute this, if even possible.
% In our script, we attempted letting MATLAB run for 1.5 hour without any
% result in the end.

C = [1 2 3 4;1 2 3 4;1 2 3 4; 1 2 3 4;a b c d;e f g h]
pinv(C) % 5 min 46sek
assume(C,'real')
pinv(C) % 2 min