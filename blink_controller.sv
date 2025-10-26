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
    logic [15:0] count, ncount;
    
    m_counter myms_counter(
    .clk(clk),
    .rst(rst),
    .tic(tic)
    );
    
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            count <= '0;
            sig   <= 1'b0;
        end
        else begin
            count <= ncount;
            sig   <= nsig;
        end
    end

    always_comb begin
        ncount = count;
        nsig   = sig;

        if (tic) begin
            if (speed <= 16'd1) begin
                ncount = '0;
                nsig   = 1'b0;
            end
            else if (count >= (speed - 1)) begin
                ncount = '0;
                nsig   = ~sig;
            end
            else begin
                ncount = count + 16'd1;
            end
        end
    end

    assign led = sig;
                
    
            
endmodule
