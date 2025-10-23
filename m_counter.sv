`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2025 09:19:16 PM
// Design Name: 
// Module Name: m_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module m_counter(
    input logic clk ,
    input logic rst ,
    output logic tic
    );
    parameter MAXCOUNT = 99_999; // 100_000 cycles of 0 to 99_999
    logic sig;
    
    logic [$clog2(MAXCOUNT+1)-1:0] count;
    
    always_ff @(posedge(clk), posedge(rst)) begin
        if (rst) begin
            count <= 0;
            sig <= 0;
        end
        else begin
            if (count == MAXCOUNT) begin
                count <= 0;
                sig <= 1'b1;
            end
            else begin
                count <= count + 1;
                sig <= 1'b0;
            end
        end
    end
    
    assign tic = sig;
endmodule
