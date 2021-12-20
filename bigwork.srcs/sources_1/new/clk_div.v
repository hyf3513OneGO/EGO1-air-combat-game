`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/13 21:31:52
// Design Name: 
// Module Name: simtest
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


module clk_div(
    cp,
    rst,
    div_1hz,
    div_10000hz,
    div_1Mhz,
    div_6Mhz
    );
    input wire cp;
    output reg div_1hz;
    output reg div_10000hz;
    output reg div_1Mhz;
    output reg div_6Mhz;
    input wire rst;
    reg [23:0] counter_10000hz;
    reg [23:0] counter_1hz;
    reg [7:0] counter_1Mhz;
    reg [4:0] counter_6Mhz; 
    //10000hz
    always@(posedge cp or posedge rst)
        begin
                    if(rst)
                        begin
                            counter_10000hz=0;
                            div_10000hz=0;
                        end
                   else
                        begin
                            if(counter_10000hz==5000)
                                begin
                                    counter_10000hz=0;
                                    div_10000hz=~div_10000hz;
                                end
                            else
                                counter_10000hz=counter_10000hz+1;
                            end
        end
             //1Mhz
    always@(posedge cp or posedge rst)
        begin
            if(rst)
                begin
                    counter_1Mhz=0;
                    div_1Mhz=0;
                end
           else
                begin
                     if(counter_1Mhz==50)
                        begin
                            counter_1Mhz=0;
                            div_1Mhz=~div_1Mhz;
                        end
                     else
                        counter_1Mhz=counter_1Mhz+1;     
                end
        end
        //1hz
    always@(posedge div_10000hz or posedge rst)
        begin
            if(rst)
                begin
                    counter_1hz=0;
                    div_1hz=0;
                end
                
            else begin
            if(counter_1hz==5000)
                begin
                    counter_1hz=0;
                    div_1hz=~div_1hz;
                end
            else
                counter_1hz=counter_1hz+1;
     end
    end
     
    always@(posedge div_1Mhz or posedge rst)
        begin
           if(rst)
                begin
                    counter_6Mhz=0;
                    div_6Mhz=0;
                end 
            else begin
                if(counter_6Mhz==3)
                    begin
                     counter_6Mhz=0;
                     div_6Mhz=~div_6Mhz;   
                    end
                else
                    counter_6Mhz=counter_6Mhz+1;
            end
        end
endmodule
