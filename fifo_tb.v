module scan_tb();
reg clk, rst, read, write, enable;
reg [9:0] d_in;
reg TM, SI;
wire empty, full, data;
wire [9:0] d_out;
wire [3:0] count;
wire SO;

FIFO_final U1(clk, d_in, rst, read, write, d_out, empty, full, count, TM, SI, SO);


initial
begin
	clk=0;
	d_in=1;
	rst=1;
	#5 rst = 0;
	TM = 1;
	SI = 1;
	read = 0;
	write = 1;

end
always @(posedge clk) begin
	d_in = #1 $random;
end

always #5 TM = ~TM;
always #5 read = ~read;
always #5 write = ~write;
always #1 clk = ~clk;

initial
begin
	#100 $finish;
end

endmodule    
