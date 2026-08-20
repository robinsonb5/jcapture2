// JTAG Toplevel for panologic_g1

`default_nettype none

module top (
	input clk_i,
	output reg led_red,
	output reg led_green,
	output reg led_blue
);

wire sysclk=clk_i;


// Power-on reset
reg [7:0] resetctr=0;
always @(posedge sysclk) begin
	if(!(&resetctr))
		resetctr<=resetctr+1;
end
wire reset_n = resetctr[7];

reg jtag_reset=1'b0;

// Free-runnng counter
reg [31:0] counter;
always @(posedge sysclk) begin
	counter <= counter +1;
	if(jtag_reset)
		counter <= 0;
end


// Signals to be captured and sent to the host
wire [30:0] jcapture_d = counter[30:0];


// Commands and signals from the host
wire [3:0] j_user_ir;	// User-defined instruction from the host
wire [31:0] j_user_q;	// Value sent from the host
wire j_user_update;	// Strobe  

wire j_trigger_match;

localparam JTAG_I_RESET=4'd0;
localparam JTAG_I_LED=4'd1;

jcapture #(.capturewidth(31),.capturedepth(6)) capture (
	.clk(sysclk),
	.reset_n(reset_n),
	.capture_d(jcapture_d),
	.stb(1'b1),
	.trigger_match(j_trigger_match),
	.user_ir(j_user_ir),
	.user_q(j_user_q),
	.user_update(j_user_update)
);

always @(posedge sysclk) begin
	if(j_user_update) begin
		case (j_user_ir)
			JTAG_I_RESET : jtag_reset <= j_user_q[0];
			JTAG_I_LED: {led_red,led_green,led_blue} <= ~j_user_q[2:0];
			default: ;
		endcase
	end
	
	if(j_trigger_match)
		led_red <= 1'b0;
	
	if(!reset_n)
		jtag_reset<=1'b0;
end

endmodule

