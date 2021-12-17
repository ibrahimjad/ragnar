function media_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
starttime = 0;
period = 0.04;

%bucket_media = TokenBucket(1,3,3,0,0.04,false);