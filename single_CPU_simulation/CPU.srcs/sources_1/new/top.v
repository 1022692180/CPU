module top(
    input clk,reset,//reset�Ǹ�λ�ź�
    output [31:0]result//ALU������
);
    
    reg [31:0]PC_data = 32'b0;
    wire[31:0]PC_addr;
    PC m_PC(
        .clk(clk),
        .Reset(reset),
        .Result(PC_data),
        .Address(PC_addr)
    );
    
    wire [31:0]next_data;
    PCAddFour m_PCAddFour(
        .PC(PC_addr),
        .PCAdd(next_data)
    );
    
    wire [31:0]instructions; 
    //ָ��Ĵ���
    INSTMEM m_INSTMEM(
        .ReadAddr(PC_addr),
        .InstMem(instructions)
    );
    
    //����ģ��ͼĴ���ģ��;
    wire [1:0]RegDst;
    wire Branch, MemRead;
    wire [1:0]MemToReg;
    wire [3:0]Aluc;
    wire Memwrite,ALUSrc1,ALUSrc2,RegWrite,Jump,Se,JR;
    wire [4:0]WriteReg;
    wire [31:0]writedata;
    wire [31:0]readdata1,readdata2;
    
    Control m_Control(
        .op(instructions[31:26]),
        .func(instructions[5:0]),
        .RegDst(RegDst),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .Aluc(Aluc),
        .Memwrite(Memwrite),
        .ALUSrc1(ALUSrc1),
        .ALUSrc2(ALUSrc2),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .Se(Se),
        .JR(JR)
    );
    
    wire [4:0]reg31 = 5'b11111;
    MUXWrAddr m_WrAddr(//д�Ĵ���
        .A1(instructions[20:16]),//rt
        .A2(instructions[15:11]),//rd
        .A3(reg31),//$31�żĴ���
        .S(RegDst),
        .Y(WriteReg)
    );
    
    Registers m_Registers(
        .ReadReg1(instructions[25:21]),
        .ReadReg2(instructions[20:16]),
        .WriteReg(WriteReg),
        .WriteData(writedata),
        .RegWrite(RegWrite),
        .clk(clk),
        .reset(reset),
        .Read1(readdata1),
        .Read2(readdata2)
    );
    
    //����λ��չģ��
    wire [31:0]sign_imm;
    
    SignExtend m_SignExtend(
        .X(instructions[15:0]),
        .Se(Se),
        .Y(sign_imm)
    );
    
    //ALU����ģ��
    wire [31:0]ALU1,ALU2;
    wire zero;
    
    //ALU��һ��������Դ
    MUX2X32 m_MUX_ALU1(
        .A1(readdata1),
        .A2(instructions),
        .S(ALUSrc1),
        .Y(ALU1)
    );
    
    //ALU�ڶ���������Դ
    MUX2X32 m_MUX_ALU2(
        .A1(readdata2),
        .A2(sign_imm),
        .S(ALUSrc2),
        .Y(ALU2)
    );
    
    //ALU������
    ALU m_ALU(
        .X(ALU1),
        .Y(ALU2),
        .Aluc(Aluc),
        .R(result),
        .Z(zero)
    );
    
     //���ݴ洢��
    wire [31:0]readdata;
    DATAMEM m_DATAMEM(
        .Addr(result),
        .Din(readdata2),
        .MemWrite(Memwrite),
        .MemRead(MemRead),
        .Dout(readdata)
    );
    
    //д������ѡ��
    MUXWrite m_MUX_Writeback(
        .A1(result),
        .A2(readdata),
        .A3(next_data),
        .S(MemToReg),
        .Y(writedata)
    );
    
    //branch
    wire [31:0]offset;
    wire [31:0]branch_addr;
    wire [2:0]PCSrc = {Branch, zero, instructions[26]};
                                                   
    //����ģ��
    SLX2 m_res_shift_left_2(
        .imm(sign_imm),
        .sl_imm(offset)
    );
    
    //branch��ת��ַ��ȡģ��
    wire [31:0]branch_result;
    BranchAdd m_BranchAdd(
        .PC(next_data),
        .imm(offset),
        .branch_addr(branch_addr)
    );
    
    //branch��ת
    MUXBranch m_Branch(
        .A1(next_data),
        .A2(branch_addr),
        .S(PCSrc),
        .Y(branch_result)
    );
    
    //jr��ָ��
    wire [31:0]jr_result;
    MUX2X32 m_jr(
        .A1(branch_result),
        .A2(readdata1),
        .S(JR),
        .Y(jr_result)
    );
    
    //jָ��
    wire [31:0]j_addr;
    assign j_addr = {6'b000000,instructions[25:0]};
  
    wire[31:0]j_result;
    
    //J��ָ����ת
    MUX2X32 m_j(
        .A1(jr_result),
        .A2(j_addr),
        .S(~Jump),
        .Y(j_result)
    );
    
    always@(j_result) begin
        PC_data <= j_result;
    end
    
endmodule
