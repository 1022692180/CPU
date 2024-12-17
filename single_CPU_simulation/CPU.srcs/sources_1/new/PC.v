module PC(clk,Reset,Result,Address);  
    input clk;//ʱ��
    input Reset;//�Ƿ����õ�ַ��0-��ʼ��PC����������µ�ַ       
    input[31:0] Result;
    output reg[31:0] Address;
  
    always @(posedge clk or negedge Reset)//ʱ�������ش���ָ��
    begin  
        if (Reset == 0) //���Ϊ0���ʼ��PC����������µ�ַ
            begin  
                Address <= 32'b00000000000000000000000000000000;  
            end  
        else   
            begin
                Address =  Result;
        end  
    end  
endmodule
