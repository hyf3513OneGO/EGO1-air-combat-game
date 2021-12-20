module digit_dislpay(
    input wire clk_100M,
    input wire clr,
    input wire[31:0]x,
    output reg[6:0]a_to_g,
    output reg[3:0]an
    );
    wire [1:0]s;
    reg[7:0]digit;
    reg[20:0]clkdiv;
    always @(posedge clk_100M or posedge clr)
        begin
            if (clr)
                clkdiv<=0;
            else
                clkdiv<=clkdiv+1;
        end
        assign s = clkdiv[20:19];
     always @(*)
        begin
            an = 4'b0000;
                an[s]=1;
        end
     always@(*)
        case(s)
            0:digit=x[7:0];
            1:digit=x[15:8];
            2:digit=x[23:16];
            3:digit=x[31:24];
            default:;
        endcase
     always@(*)
        case(digit)
             8'h00: a_to_g = 7'b1111110;//0
             8'h01: a_to_g = 7'b0110000;//1
             8'h02: a_to_g = 7'b1101101;//2
             8'h03: a_to_g = 7'b1111001;//3
             8'h04: a_to_g = 7'b0110011;//4
             8'h05: a_to_g = 7'b1011011;//5
             8'h06: a_to_g = 7'b1011111;//6
             8'h07: a_to_g = 7'b1110000;//7
             8'h08: a_to_g = 7'b1111111;//8
             8'h09: a_to_g = 7'b1111011;//9
             8'h10:a_to_g = 7'b0000000;
             8'h11:a_to_g = 7'b1000000;
             8'h12:a_to_g = 7'b0000001;
             8'h13:a_to_g = 7'b0001000;
             8'h14:a_to_g = 7'b1000001;
             8'h15:a_to_g = 7'b0001001;
             8'h16:a_to_g = 7'b1001000;
             8'h17:a_to_g = 7'b1001001;
             8'h20: a_to_g = 7'b1110111;//A
             8'h21: a_to_g = 7'b0011111;//B
             8'h22: a_to_g = 7'b1001110;//C
             8'h23: a_to_g = 7'b0111101;//d
             8'h24: a_to_g = 7'b1001111;//E
             8'h25: a_to_g = 7'b1000111;//F
             8'h26: a_to_g = 7'b0110111;//H
             8'h27: a_to_g = 7'b0001110;//L
             8'h28: a_to_g = 7'b1110110;//N
             8'h29: a_to_g = 7'b1111110;//O
             8'h30: a_to_g = 7'b0000111;//无敌状态
             default a_to_g=7'b1111110;
         endcase
            
endmodule