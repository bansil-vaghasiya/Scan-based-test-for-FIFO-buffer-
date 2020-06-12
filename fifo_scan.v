module FIFO_final(clk, datain, reset, r_en, w_en, dataout, empty, full, count, TM, SI, SO);
input clk;
input reset;
input [9:0]datain;
input r_en;
input w_en;
input SI, TM;

output [9:0]dataout;
output empty;
output full;
output [3:0]count; 
output reg SO;
reg [3:0]count;
reg [9:0]memory[0:15];
reg [3:0]wr_p = 0, rd_p = 0;
reg full, empty;
reg [9:0]dataout;

initial begin 
	$monitor("write = %b read = %b d_in = %d d_out = %d TM = %b SI = %b SO = %b", w_en, r_en, datain, dataout, TM, SI, SO);
	end

// reading data out from the FIFO
always @( posedge clk or posedge reset)
begin
   if( reset )
   begin
      dataout <= 0;
   end
   else
   begin
      if( r_en && !empty )
	if(TM) begin
         dataout <= memory[{rd_p[2:0], SI}];
	end
	else dataout <= memory[rd_p];
	else
         dataout <= dataout;

   end
end

//writing data in the FIFO
always @(posedge clk)
begin
   if( w_en && !full )
	if(TM) begin
      		memory[{wr_p[2:0], wr_p[3]}] <= datain;
		SO <= wr_p[3];
	end else begin memory[wr_p] <= datain; SO <= 1; end

   else
      memory[wr_p] <= memory[wr_p];
end



//pointer increment system
always @ (posedge clk or posedge reset)
begin 
	if(reset)
	begin
		wr_p <= 0;
		rd_p <= 0;
	end
	else
	begin
		if(!full && w_en)
		wr_p <= wr_p+1;
		else
		wr_p <= wr_p;
			
		if(!empty && r_en)
		rd_p <= rd_p+1;
		else
		rd_p <= rd_p;
	end
end

// code for counting
always @(posedge clk or posedge reset)
begin
   if( reset )
       count <= 0;

   else if( (!full && w_en) && ( !empty && r_en ) )
       count <= count;

   else if( !full && w_en )
       count <= count + 1;

   else if( !empty && r_en )
       count <= count - 1;
   else
      count <= count;
end

//for full and empty
always @(count)
begin
if(count==0)
  empty = 1 ;
  else
  empty = 0;

  if(count==8)
   full = 1;
   else
   full = 0;
end

endmodule