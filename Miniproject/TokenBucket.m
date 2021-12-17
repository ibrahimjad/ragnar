classdef TokenBucket < handle
    properties
        Tn {mustBeNumeric}
        M {mustBeNumeric}
        L {mustBeNumeric}
        Q {mustBeNumeric}
        Tau {mustBeNumeric}
    end
    events
        Serve
    end
    properties (SetAccess = private)
      tm timer;
    end
    methods
        function bucket = TokenBucket(Tn, M, L, Q, Tau, start_now)
            if nargin == 6
                bucket.Tn = (Tn >= M) * M + (Tn < M) * Tn;
                bucket.M = M;
                bucket.L = L;
                bucket.Q = Q;
                bucket.Tau = Tau;
                bucket.tm = timer('ExecutionMode', 'fixedRate', 'Period', bucket.Tau);
                bucket.tm.TimerFcn = {@bucket.ReplinishToken, bucket};
                bucket.tm.StartDelay = ~start_now * bucket.Tau;
                start(bucket.tm);
            end
        end
        function delete(bucket)
            stop(bucket.tm);
            delete(bucket.tm);
        end
        function Arrive(bucket)
            if (bucket.Tn > 0)
                bucket.Tn = bucket.Tn - 1;
                bucket.ServeTokenEvent();
            elseif (bucket.Tn == 0 && bucket.Q < bucket.L)
                bucket.Q = bucket.Q + 1;
            end
        end
    end
    methods (Access = private)
        function ReplinishToken(bucket, varargin)
            if (bucket.Q > 0)
                bucket.Tn = bucket.Tn;
                bucket.Q = bucket.Q -1;
                bucket.ServeTokenEvent();
            elseif (bucket.Q == 0 && bucket.Tn < bucket.M)
                bucket.Tn = bucket.Tn + 1;
            end
        end
        function ServeTokenEvent(bucket)
            notify(bucket,'Serve');
        end
    end
end