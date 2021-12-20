
for i in range(8):
    print('case ({a['+str(7-i)+'],b['+str(7-i)+'],c['+str(7-i)+']})')
    model_string =f'''
          3'b000: get_x[{63-8*i}:{56-8*i}]=8'h10;
          3'b100: get_x[{63-8*i}:{56-8*i}]=8'h11;
          3'b010: get_x[{63-8*i}:{56-8*i}]=8'h12;
          3'b001: get_x[{63-8*i}:{56-8*i}]=8'h13;
          3'b110: get_x[{63-8*i}:{56-8*i}]=8'h14;
          3'b011: get_x[{63-8*i}:{56-8*i}]=8'h15;
          3'b101: get_x[{63-8*i}:{56-8*i}]=8'h16;
          3'b111: get_x[{63-8*i}:{56-8*i}]=8'h17;
            default: get_x[{63-8*i}:{56-8*i}]=8'h10;
        endcase'''
    print(model_string)