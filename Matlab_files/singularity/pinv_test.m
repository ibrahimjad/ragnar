clear all
close all
syms a b c d e f g h i j k
A = [a b;c d;e f]
B = [a b c;d e f;g h i;i j k]
pinv(A)
% pinv(B) % 30 sek
% assume(B,'real')
% pinv(B) % 10 sek


B = [1 2 3;1 2 3;g h i;i j k]
pinv(A)
pinv(B) % 10 sek
assume(B,'real')
pinv(B) % 3 sek