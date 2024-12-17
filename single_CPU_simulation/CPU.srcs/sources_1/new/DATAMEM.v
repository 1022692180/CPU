module DATAMEM(Addr,Din,MemWrite,MemRead,Dout);
    input [31:0]Addr,Din;
    input MemWrite;
    input MemRead;
    output reg[31:0]Dout;//����Addr��ַ�����ݴ洢����ȡ��������
    
    reg [31:0]ram[0:31];
    integer i;
    initial begin
        for (i = 0 ; i <= 31 ; i = i + 1) 
            ram [i] = i;
     end
     always @ (*) begin
         if(MemWrite)begin
            ram[Addr[4:0]] <= Din;
         end
         
         if(MemRead)begin
            Dout = ram[Addr[4:0]];
         end
     end
endmodule
