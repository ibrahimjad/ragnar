clear all

cvx_begin
variable V(1,6)

miminize(CondMountValFunction(V))
subject to
    -0.1 <= V(1)
    V(1) <= 0.1

    -0.1 <= V(2)
    V(2) <= 0.1

    -0.1 <= V(3)
    V(3) <= 0
   
    -0.1 <= V(4)
    V(4) <= 0.1

    -0.1 <= V(5)
    V(5) <= 0.1

     -0.1 <= V(6)
    V(6) <= 0
cvx_end
