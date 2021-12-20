`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/15 19:19:06
// Design Name: 
// Module Name: bin2bcd
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/25 18:13:53
// Design Name: 
// Module Name: binbcd8
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


module binbcd8 (
  input wire [7:0] b,
  output reg [9:0] p
);
  // 中间变量 
  reg [17:0] z;
  integer i;
  always @ ( * )
    begin 
      for (i = 0; i <=17; i = i + 1)
        z[i] = 0;
      z[10:3] = b;   // 向左移3位
      repeat (5)                           // 重复5次
        begin 
          if (z[11:8] > 4)                     // 如果个位大于4
            z[11:8] = z[11:8] +3;              // 加3
          if (z[15:12] > 4)                    // 如果十位大于4 
            z[15:12] = z[15:12] +3;            // 加3
          z[17:1] = z[16:0];                   // 左移一位
        end
    p = z[17:8];                          // BCD 
    end
endmodule


