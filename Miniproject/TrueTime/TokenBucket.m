classdef TokenBucket < handle
    properties
        Tn {mustBeNumeric}
        M {mustBeNumeric}
        L {mustBeNumeric}
        Q {mustBeNumeric}
        Fcn
    end
    methods
        function bucket = TokenBucket(Tn, M, L, Q, Fcn)
            if nargin ~= 5
                disp('Missing argument')
                return
            end
            bucket.Tn = (Tn >= M) * M + (Tn < M) * Tn;
            bucket.M = M;
            bucket.L = L;
            bucket.Q = Q;
            bucket.Fcn = Fcn;
        end
        function Arrive(bucket)
            if (bucket.Tn > 0)
                bucket.Tn = bucket.Tn - 1;
                bucket.Fcn();
            elseif (bucket.Tn == 0 && bucket.Q < bucket.L)
                bucket.Q = bucket.Q + 1;
            end
        end
        function ReplinishToken(bucket)
            if (bucket.Q > 0)
                bucket.Q = bucket.Q -1;
                bucket.Fcn();
            elseif (bucket.Q == 0 && bucket.Tn < bucket.M)
                bucket.Tn = bucket.Tn + 1;
            end
        end
    end
end