`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/14 08:57:13
// Design Name: 
// Module Name: sim_audio_player
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


module tb_audio_player;

// audio_player Parameters
parameter PERIOD  = 10;


// audio_player Inputs
reg   clk_100M                             = 0 ;
reg   clr                                  = 0 ;

// audio_player Outputs
wire  [3:0]  an                            ;    
wire  [6:0]  a_to_g                        ;


initial
begin
    forever #(PERIOD/2)  clk_100M=~clk_100M;
end

initial
begin
    #(PERIOD*2) clr  =  1;
end

audio_player  u_audio_player (
    .clk_100M                ( clk_100M        ),
    .clr                     ( clr             ),

    .an                      ( an        [3:0] ),
    .a_to_g                  ( a_to_g    [6:0] )
);

initial
begin

    $finish;
end

endmodule
