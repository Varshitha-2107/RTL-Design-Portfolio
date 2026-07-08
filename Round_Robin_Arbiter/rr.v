module round_robin #(parameter N=4)(input clk, input rst, input [N-1:0]req,output reg [N-1:0]grant);
reg [$clog2(N)-1:0]pointer;
integer i;
integer index;
reg found;
always @(posedge clk)
begin
    if(rst)
    begin
        pointer<=0;
        grant<=0;
    end
    else
    begin
        grant<=0;
        found=0;
        for(i=0;i<N;i=i+1)
        begin
            index=(pointer + i)%N;
            if(req[index] && !found)
            begin
                grant[index]<=1;
                pointer<=(index +1)%N;
                found=1;
            end

        end
    end
end
endmodule
