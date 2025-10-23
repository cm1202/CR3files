`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2025 09:21:46 PM
// Design Name: 
// Module Name: blink_controller
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


module blink_controller(
    input logic clk,
    input logic rst,
    input logic [15:0] speed,
    output logic led

    );
    logic tic; 
    logic sig, nsig;
    logic count, ncount;
    
    m_counter myms_counter(
    .clk(clk),
    .rst(rst),
    .tic(tic)
    );
    
    always_ff@(posedge(clk), posedge(rst)) begin
        if(rst) begin
            count<=0;
            sig<=0; 
            end
        else begin
            count <=ncount;
            sig <= nsig; 
        end
    end
    always_comb begin
        if(tic) begin
            ncount = ncount+1; 
            if(count>=(speed-1))begin
                nsig = ~sig; 
                ncount = 0; 
            end
            else begin
                nsig = sig; 
           end
           end
           else begin 
           ncount = count; 
           nsig = sig; 
           end 
           end 
           
           assign led = (speed ==16'd0) ? 1'b0: sig; 
                
    
            
endmodule
