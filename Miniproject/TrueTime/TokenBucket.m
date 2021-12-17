classdef TokenBucket < handle
    properties
        Tn {mustBeNumeric}
        M {mustBeNumeric}
        L {mustBeNumeric}
        Q {mustBeNumeric}
        Tau {mustBeNumeric}
    end
    methods
        function bucket = TokenBucket(Tn, M, L, Q, Tau)
            if nargin ~= 5
                disp('Missing argument')
                return
            end
            bucket.Tn = (Tn >= M) * M + (Tn < M) * Tn;
            bucket.M = M;
            bucket.L = L;
            bucket.Q = Q;
            bucket.Tau = Tau;
        end
        function Arrive(bucket)
            if (bucket.Tn > 0)
                bucket.Tn = bucket.Tn - 1;
                % serve
            elseif (bucket.Tn == 0 && bucket.Q < bucket.L)
                bucket.Q = bucket.Q + 1;
            end
        end
        function ReplinishToken(bucket, varargin)
            if (bucket.Q > 0)
                bucket.Q = bucket.Q -1;
                % serve
            elseif (bucket.Q == 0 && bucket.Tn < bucket.M)
                bucket.Tn = bucket.Tn + 1;
            end
        end
    end
end