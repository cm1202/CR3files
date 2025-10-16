// chu_gpo_blink extends the vanilla GPO peripheral with a programmable
// blink generator. The slot exposes two registers:
//   * ADDR_DATA  - desired LED pattern
//   * ADDR_SPEED - number of clock cycles to hold each blink state
// When ADDR_SPEED is zero the output stays constantly on (no blinking).
module chu_gpo_blink
   #(parameter W = 8)
   (
    input  logic clk,
    input  logic reset,
    // slot interface
    input  logic cs,
    input  logic read,
    input  logic write,
    input  logic [4:0] addr,
    input  logic [31:0] wr_data,
    output logic [31:0] rd_data,
    // external port
    output logic [W-1:0] dout
   );

   localparam int ADDR_DATA  = 5'h00;
   localparam int ADDR_SPEED = 5'h01;

   logic [W-1:0] buf_reg;      // currently requested LED pattern
   logic [31:0] speed_reg;     // blink period expressed in clock cycles
   logic [31:0] blink_counter; // counts cycles within the current blink state
   logic blink_state;          // 1 = emit buf_reg, 0 = output zeros
   logic wr_en_data;
   logic wr_en_speed;

   assign wr_en_data  = cs && write && (addr == ADDR_DATA);
   assign wr_en_speed = cs && write && (addr == ADDR_SPEED);

   // Capture the latest pattern requested by software. When reset the LEDs are
   // cleared. Writes to ADDR_DATA update only the active bits of the pattern.
   always_ff @(posedge clk, posedge reset) begin
      if (reset)
         buf_reg <= '0;
      else if (wr_en_data)
         buf_reg <= wr_data[W-1:0];
   end

   // The speed register stores the number of cycles the LEDs stay lit or dark
   // before toggling. Zero disables blinking and keeps the LEDs constantly on.
   always_ff @(posedge clk, posedge reset) begin
      if (reset)
         speed_reg <= 32'd0;
      else if (wr_en_speed)
         speed_reg <= wr_data;
   end

   // Blink state machine: hold the pattern for 'speed_reg' cycles and then
   // switch between the active pattern and zeros. Any speed register update
   // resets the counter so changes take effect immediately.
   always_ff @(posedge clk, posedge reset) begin
      if (reset) begin
         blink_counter <= 32'd0;
         blink_state <= 1'b1;
      end else if (wr_en_speed) begin
         blink_counter <= 32'd0;
         blink_state <= 1'b1;
      end else if (speed_reg == 0) begin
         blink_counter <= 32'd0;
         blink_state <= 1'b1;
      end else if (blink_counter >= speed_reg) begin
         blink_counter <= 32'd0;
         blink_state <= ~blink_state;
      end else begin
         blink_counter <= blink_counter + 1;
      end
   end

   // Provide register contents when the host performs a read. The speed value
   // is returned unmodified while the pattern is zero-extended to 32 bits.
   always_comb begin
      if (cs && read) begin
         unique case (addr)
            ADDR_DATA:  rd_data = {{(32-W){1'b0}}, buf_reg};
            ADDR_SPEED: rd_data = speed_reg;
            default:    rd_data = 32'd0;
         endcase
      end else begin
         rd_data = 32'd0;
      end
   end

   // Drive the LED bank: when blink_state is high the stored pattern is sent
   // to the outputs; otherwise all LEDs are off.
   assign dout = blink_state ? buf_reg : {W{1'b0}};
endmodule
