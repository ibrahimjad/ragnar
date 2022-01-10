classdef TokenBucket < handle
    properties
        Tn {mustBeNumeric}
        M {mustBeNumeric}
        L {mustBeNumeric}
        Q {mustBeNumeric}
        Fcn
        MeanQ {mustBeNumeric}
        MaxQ {mustBeNumeric}
        CallTimes {mustBeNumeric}
        WaitingTimes
        WaitingTimeStarted
        WaitingTimeStamp
        MeanWaitingT {mustBeNumeric}
        MaxWaitingT {mustBeNumeric}
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
            bucket.MeanQ = 0;
            bucket.MaxQ = 0;
            bucket.WaitingTimes = [];
            bucket.MeanWaitingT = 0;
            bucket.MaxWaitingT = 0;
            bucket.CallTimes = 0;
            bucket.WaitingTimeStarted = zeros(3);
            bucket.WaitingTimeStamp = 0;
        end
        function Arrive(bucket)
            bucket.CallTimes = bucket.CallTimes + 1;
            if (bucket.Tn > 0)
                bucket.Tn = bucket.Tn - 1;
                bucket.Fcn();
            elseif (bucket.Tn == 0 && bucket.Q < bucket.L)
                bucket.Q = bucket.Q + 1;

                if (length(bucket.WaitingTimeStarted) < bucket.Q || ~bucket.WaitingTimeStarted(bucket.Q))
                    bucket.WaitingTimeStarted(bucket.Q) = true;
                    bucket.WaitingTimeStamp(bucket.Q) = ttCurrentTime;
                end

                if (bucket.Q > bucket.MaxQ)
                    bucket.MaxQ = bucket.Q;
                end
            end
            bucket.MeanQ = bucket.MeanQ + bucket.Q - bucket.Tn;
        end
        function ReplinishToken(bucket)
            q = bucket.Q;
            if (bucket.Q > 0)
                
                bucket.Q = bucket.Q -1;
                bucket.Fcn();
            elseif (bucket.Q == 0 && bucket.Tn < bucket.M)
                bucket.Tn = bucket.Tn + 1;
            end

            if (q > 0 && bucket.WaitingTimeStarted(1))
                bucket.WaitingTimes(end+1) = ttCurrentTime - bucket.WaitingTimeStamp(1);
                if (length(bucket.WaitingTimeStarted) > 1)
                    bucket.WaitingTimeStamp = bucket.WaitingTimeStamp(2:end);
                    bucket.WaitingTimeStarted = bucket.WaitingTimeStarted(2:end);
                else
                    bucket.WaitingTimeStarted = [];
                end
            end
        end
        function delete(bucket)
            disp('Bucket MeanQ size')
            disp(bucket.MeanQ/bucket.CallTimes)
            disp('Bucket MaxQ size')
            disp(bucket.MaxQ)
            disp('Bucket MeanWaitingT')
            bucket.MeanWaitingT = sum(bucket.WaitingTimes) / length(bucket.WaitingTimes);
            disp(bucket.MeanWaitingT)
            disp('Bucket MaxWaitingT')
            bucket.MaxWaitingT = max(bucket.WaitingTimes);
            disp(bucket.MaxWaitingT)
        end
    end
end
