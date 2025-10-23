module chu_gpo
    #(parameter W = 8)
   (
    input  logic clk,
    input  logic reset,
    input  logic cs,
    input  logic read,
    input  logic write,
    input  logic [4:0] addr,
    input  logic [31:0] wr_data,
    output logic [31:0] rd_data,
    output logic [W-1:0] dout
   );

   localparam int ADDR_DATA  = 5'h00;
   localparam int ADDR_SPEED = 5'h01;

   logic [W-1:0] buf_reg;      // LED pattern
   logic [31:0] speed_reg;     // clock cycles
   logic blink_sig; 
   logic [31:0] blink_counter; // cycle counter
   logic blink_state;          
   logic wr_en_data;
   logic wr_en_speed;

   assign wr_en_data  = cs && write && (addr == ADDR_DATA);
   assign wr_en_speed = cs && write && (addr == ADDR_SPEED);

   always_ff @(posedge clk, posedge reset) begin
      if (reset)
         buf_reg <= '0;
      else if (wr_en_data)
         buf_reg <= wr_data[15:0];
   end

   // speed 
   always_ff @(posedge clk, posedge reset) begin
      if (reset)
         speed_reg <= 0;
      else if (wr_en_speed)
         speed_reg <= wr_data;
   end
   
   assign rd_data = 0; 

   blink_controller blink0(
    .clk(clk),
    .rst(reset),
    .speed(speed_reg),
    .led(blink_sig)
    ); 
    
    assign dout = buf_reg & {W{blink_sig}}; 
endmodule
       



