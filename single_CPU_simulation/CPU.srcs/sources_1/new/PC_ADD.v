module PCAddFour(PC, PCAdd);
  input [31:0] PC;
  output [31:0] PCAdd;
  
  wire [31:0]Y;
  wire Cin,Cout;
  
  assign Y = 32'b0000000000000100;
  assign Cin = 0;
  
  AS_32 PCadd32(PC, Y, Cin, PCAdd, Cout);//ÿ��ָ��洢�����ȡ�ĸ��洢��Ԫ
endmodule