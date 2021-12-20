`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/12/14 10:02:41
// Design Name:
// Module Name: main
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


module main(input wire rst,
            input wire start,
            input wire left,
            input wire right,
            input wire emit,
            input wire cp,
            input wire soft_rst,
            output [7:0] an,
            output [6:0]a_to_g0,
            output [6:0]a_to_g1,
            output [7:0]test_led,
            output [7:0]result_led
            );
    wire div_1hz;
    wire div_10000hz;
    wire div_1Mhz;
    wire div_6Mhz;
    reg [7:0] emit_bar=8'b00000000;
    wire [63:0]x;
    wire key_left;
    wire key_right;
    wire key_emit;
    reg [7:0] score;
    wire [9:0]decimal_num;
    wire key_rst;
    clk_div  clk_div0 (
    .cp                      (cp),
    .rst                     (rst),
    .div_1hz                 (div_1hz),
    .div_10000hz             (div_10000hz),//10000:1s,1000:0.1s,100:0.01s;
    .div_1Mhz                (div_1Mhz),
    .div_6Mhz                (div_6Mhz)
    );
    
    digit_dislpay  digit0 (
    .clk_100M                (cp),
    .clr                     (rst),
    .x             (x[63:32]),
    .a_to_g          (a_to_g0),
    .an              (an[7:4])
    );
    digit_dislpay  digit1 (
    .clk_100M                (cp),
    .clr                     (rst),
    .x             (x[31:0]),
    .a_to_g          (a_to_g1),
    .an              (an[3:0])
    );
    keyscan get_key_left(
    .clk(cp),
    .rst_n(rst),
    .sw_in(left),
    .sw_out(key_left)
    );
    keyscan get_key_right(
    .clk(cp),
    .rst_n(rst),
    .sw_in(right),
    .sw_out(key_right)
    );
    keyscan get_key_emit(
    .clk(cp),
    .rst_n(rst),
    .sw_in(emit),
    .sw_out(key_emit)
    );
    binbcd8 bcd1 (
    .b(score),
    .p(decimal_num)
    );
    keyscan_h get_key_rst(
    .clk(cp),
    .rst_n(rst),
    .sw_in(soft_rst),
    .sw_out(key_rst)
    );
    parameter s0 = 2'b00 ;
    parameter s1 = 2'b01 ;
    parameter s2 = 2'b10 ;
    reg [1:0] current_state,next_state;
    reg [7:0] bullet;
    reg [2:0] score_counter;
    reg [63:0]temp_x;
    reg [32:0]counter_a,counter_b,counter_c;
    reg [7:0]a,b,c;
    reg [32:0] seed_counter;
    reg [32:0] seed;
    reg [32:0] random_counter;
    reg [1:0] p;
    reg [2:0] random_arr;
    reg led;
    reg p_left;
    reg p_right;
    reg key_en;
    reg [32:0]key_counter;
    reg isfail;
    reg isback;
    reg [32:0]score_display;
    reg isfire;
    reg isemit=0;
    reg emit_clear;
    reg [32:0]emit_counter;
    reg [32:0]clear_counter;
    reg bulltet_control;
    reg [7:0]energy_indicator;
    //生成随机种子
    always @(posedge cp) begin
        if (seed_counter == {32{1'b1}})
        begin
            seed_counter <= 0;
        end
        else
        begin
            seed_counter = seed_counter+1;
        end
    end
    
    always@(posedge div_10000hz)
    begin
        if (~start)
            begin
                a      <= {seed_counter[7],1'b0,seed_counter[3],1'b0,4'b0};
                b      <= {~seed_counter[7],1'b0,~seed_counter[3],1'b0,'b0};
                c      <= {seed_counter[7],1'b0,~seed_counter[4],1'b0,4'b0};
                
                temp_x <= {8'h26,8'h24,8'h27,8'h27,8'h29,8'h10,8'h10,8'h10};
                isfail = 0;
                score<=0;
                
            end
        else
        begin
            if (isfail||(a[1]&&(p == 2'b10))||(b[1]&&(p == 2'b01)||(c[1]&&(p == 2'b00))))
            begin
                isfail = 1;
                score_display[7:0] = get_digit(decimal_num[3:0]);
                score_display[15:8] = get_digit(decimal_num[7:4]);
                score_display[23:16] = get_digit({2'b00,decimal_num[9:8]});
                temp_x = {8'h23,8'h24,8'h20,8'h23,8'h10,score_display[23:16],score_display[15:8],score_display[7:0]};
                
            end
                
            else
            begin
                current_state <= next_state;
                random_arr = random(seed,random_counter);
                begin
                    if (counter_a == 32'd5000)
                        begin
                            bulltet_control=bulltet_control+1;
                            if (isemit) begin
                                a         <= 8'b00000000;
                                b         <= 8'b00000000;
                                c         <= 8'b00000000;

                            end
                            else
                                begin
                                    if (bulltet_control%2==1) begin
                                        a         <= {1'b0,a[7:1]};
                                        b         <= {1'b0,b[7:1]};
                                        c         <= {1'b0,c[7:1]};
                                    end
                                    else
                                    begin
                                        a         <= {random_arr[2],a[7:1]};
                                        b         <= {~random_arr[2],b[7:1]};
                                        c         <= {random_arr[0],c[7:1]};
                                    end

                                    counter_a <= 0;
                            if (score_counter==3'd2) begin
                                begin
                                    score_counter<=0;
                                    score=score+1;
                                end
                            end
                            else
                            score_counter = score_counter+1;
                            end
                        end
                    else counter_a = counter_a+1;
                end
            temp_x <= get_x(a,b,c,p);
            end
        end
    end
    always @(key_left or  key_en)
    begin
        p_left = 0;
        if (key_left)
        begin
            p_left = 1;
        end
    end
    
    always @(key_right or  key_en)
    begin
        p_right = 0;
        if (key_right)
        begin
            p_right = 1;
        end
    end
    
    always @(posedge div_10000hz) begin
        if (start) begin
            if (key_counter == 32'd1200) begin
            case (p)
                2'b10:p    = p-p_left;
                2'b00:p    = p+p_right;
                2'b11:;
                default: p = p-p_left+p_right;
            endcase
                key_counter = 0;
                key_en      = 0;
            end
            else
                begin
                    key_counter = key_counter+1;
                end
            end
        else
            // p_left<=2'b00;
            p<=2'b00;
            // p_right<=2'b00;

        
    end
    always @(key_emit or emit_clear) begin
        if (emit_clear)
        begin
            isemit<=0;
        end
        
        else if(key_emit)
        begin
            isemit<=1;
        end
    end
    always@(posedge div_10000hz )
    begin
        if ((!isfail)&&start) 
        begin
            if (emit_counter==32'd10000) begin
                emit_counter<=0;
                emit_bar = {emit_bar[6:0],1'b1};
            end
            else
            begin
                if (!isemit) begin
                    emit_counter = emit_counter+1;
                end
                
            end
            if (emit_bar ==8'b11111111) begin
                    emit_clear<=0;
                    emit_counter<=32'h00000000;
                    energy_indicator<=8'b11111111;
                end//emit_clear<=1;
            if (isemit) begin
                emit_bar <= 8'b00000000;
                if(clear_counter==32'd20000)
                begin
                    emit_clear<=1;
                    clear_counter<=0;
                end
                else
                    clear_counter = clear_counter+1;
                    if (clear_counter%2500==1) begin
                        energy_indicator<=energy_indicator>>1;
                    end
            end
            
        end
        else
            emit_bar=8'b00000000;
    end

    always@(current_state or start or isfail)
    begin
        case (current_state)
            s0  :begin
                if (start == 0)
                begin
                    
                    next_state <= s0;
                end
                else
                begin
                    seed       <= seed_counter;
                    next_state <= s1;
                end
            end
            s1  :begin
                if (start == 0)
                begin
                    next_state <= s0;
                end
                else
                begin
                    if (~isfail) begin
                        next_state <= s1;
                    end
                    else
                        next_state <= s2;
                end
            end
            s2  :begin
                if(isback)
                next_state = s0;
            end
            default: begin
                next_state = s0;
            end
        endcase
    end

    always@(cp or key_left or key_right)
    begin
        if (random_counter == {32{1'b1}})
            random_counter <= 0;
        else
            random_counter = random_counter+1;
    end
    
    assign x             = temp_x;
    assign test_led = energy_indicator;

    assign result_led = emit_bar;
    //
    function [63:0] get_x;
        input [7:0] a;
        input [7:0] b;
        input[7:0]c;
        input [2:0]p;
        
        begin
            case ({a[7],b[7],c[7]})
                
                3'b000: get_x[63:56]  = 8'h10;
                3'b100: get_x[63:56]  = 8'h11;
                3'b010: get_x[63:56]  = 8'h12;
                3'b001: get_x[63:56]  = 8'h13;
                3'b110: get_x[63:56]  = 8'h14;
                3'b011: get_x[63:56]  = 8'h15;
                3'b101: get_x[63:56]  = 8'h16;
                3'b111: get_x[63:56]  = 8'h17;
                default: get_x[63:56] = 8'h10;
            endcase
            case ({a[6],b[6],c[6]})
                
                3'b000: get_x[55:48]  = 8'h10;
                3'b100: get_x[55:48]  = 8'h11;
                3'b010: get_x[55:48]  = 8'h12;
                3'b001: get_x[55:48]  = 8'h13;
                3'b110: get_x[55:48]  = 8'h14;
                3'b011: get_x[55:48]  = 8'h15;
                3'b101: get_x[55:48]  = 8'h16;
                3'b111: get_x[55:48]  = 8'h17;
                default: get_x[55:48] = 8'h10;
            endcase
            case ({a[5],b[5],c[5]})
                
                3'b000: get_x[47:40]  = 8'h10;
                3'b100: get_x[47:40]  = 8'h11;
                3'b010: get_x[47:40]  = 8'h12;
                3'b001: get_x[47:40]  = 8'h13;
                3'b110: get_x[47:40]  = 8'h14;
                3'b011: get_x[47:40]  = 8'h15;
                3'b101: get_x[47:40]  = 8'h16;
                3'b111: get_x[47:40]  = 8'h17;
                default: get_x[47:40] = 8'h10;
            endcase
            case ({a[4],b[4],c[4]})
                
                3'b000: get_x[39:32]  = 8'h10;
                3'b100: get_x[39:32]  = 8'h11;
                3'b010: get_x[39:32]  = 8'h12;
                3'b001: get_x[39:32]  = 8'h13;
                3'b110: get_x[39:32]  = 8'h14;
                3'b011: get_x[39:32]  = 8'h15;
                3'b101: get_x[39:32]  = 8'h16;
                3'b111: get_x[39:32]  = 8'h17;
                default: get_x[39:32] = 8'h10;
            endcase
            case ({a[3],b[3],c[3]})
                
                3'b000: get_x[31:24]  = 8'h10;
                3'b100: get_x[31:24]  = 8'h11;
                3'b010: get_x[31:24]  = 8'h12;
                3'b001: get_x[31:24]  = 8'h13;
                3'b110: get_x[31:24]  = 8'h14;
                3'b011: get_x[31:24]  = 8'h15;
                3'b101: get_x[31:24]  = 8'h16;
                3'b111: get_x[31:24]  = 8'h17;
                default: get_x[31:24] = 8'h10;
            endcase
            case ({a[2],b[2],c[2]})
                3'b000: get_x[23:16]  = 8'h10;
                3'b100: get_x[23:16]  = 8'h11;
                3'b010: get_x[23:16]  = 8'h12;
                3'b001: get_x[23:16]  = 8'h13;
                3'b110: get_x[23:16]  = 8'h14;
                3'b011: get_x[23:16]  = 8'h15;
                3'b101: get_x[23:16]  = 8'h16;
                3'b111: get_x[23:16]  = 8'h17;
                default: get_x[23:16] = 8'h10;
            endcase
            case ({a[1],b[1],c[1],p[1],p[0]})
                5'b00000:get_x[15:8] = 8'h13;
                5'b00001:get_x[15:8] = 8'h12;
                5'b00010:get_x[15:8] = 8'h11;
                5'b10000:get_x[15:8] = 8'h16;
                5'b10001:get_x[15:8] = 8'h14;
                5'b10010:get_x[15:8] = 8'h11;
                5'b01000:get_x[15:8] = 8'h15;
                5'b01001:get_x[15:8] = 8'h12;
                5'b01010:get_x[15:8] = 8'h14;
                5'b00100:get_x[15:8] = 8'h13;
                5'b00101:get_x[15:8] = 8'h15;
                5'b00110:get_x[15:8] = 8'h16;
                5'b01100:get_x[15:8] = 8'h15;
                5'b01101:get_x[15:8] = 8'h15;
                5'b01110:get_x[15:8] = 8'h17;
                5'b10100:get_x[15:8] = 8'h16;
                5'b10101:get_x[15:8] = 8'h17;
                5'b10110:get_x[15:8] = 8'h16;
                5'b11000:get_x[15:8] = 8'h17;
                5'b11001:get_x[15:8] = 8'h14;
                5'b11010:get_x[15:8] = 8'h14;
                5'b00011:get_x[15:8] = 8'h30;
                5'b00111:get_x[15:8] = 8'h30;
                5'b01011:get_x[15:8] = 8'h30;
                5'b10011:get_x[15:8] = 8'h30;
                5'b01111:get_x[15:8] = 8'h30;
                5'b10111:get_x[15:8] = 8'h30;
                5'b11011:get_x[15:8] = 8'h30;
                5'b11111:get_x[15:8] = 8'h30;
                default:get_x[15:8]  = 8'h30;
                
                
            endcase
            case ({a[0],b[0],c[0]})
                3'b000: get_x[7:0]  = 8'h10;
                3'b100: get_x[7:0]  = 8'h11;
                3'b010: get_x[7:0]  = 8'h12;
                3'b001: get_x[7:0]  = 8'h13;
                3'b110: get_x[7:0]  = 8'h14;
                3'b011: get_x[7:0]  = 8'h15;
                3'b101: get_x[7:0]  = 8'h16;
                3'b111: get_x[7:0]  = 8'h17;
                default: get_x[7:0] = 8'h10;
            endcase
            
            
            
            
        end
    endfunction
    function [2:0] random;
        input[32:0] seed;
        input [32:0] random_counter;
        begin
            random[0] = seed[16]^random_counter[3];
            random[1] = seed[5]^random_counter[5];
            random[2] = seed[8]^random_counter[8];
        end
    endfunction
    function [7:0] get_digit;
        input [3:0] raw;
        case (raw)
            4'b0000:get_digit = 8'h00;
            4'b0001:get_digit = 8'h01;
            4'b0010:get_digit = 8'h02;
            4'b0011:get_digit = 8'h03;
            4'b0100:get_digit = 8'h04;
            4'b0101:get_digit = 8'h05;
            4'b0110:get_digit = 8'h06;
            4'b0111:get_digit = 8'h07;
            4'b1000:get_digit = 8'h08;
            4'b1001:get_digit = 8'h09;
            default:get_digit = 8'h00;
        endcase
        
    endfunction
endmodule
