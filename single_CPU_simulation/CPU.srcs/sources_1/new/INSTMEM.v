module INSTMEM(
    input[31:0]ReadAddr,//ָ���ַ
    output reg[31:0]InstMem//���ָ�����
);//ָ��洢��

     reg [7:0] mem [0:127];
     initial begin
        //ÿ��mem�洢��Ԫ��8λ��һ��128���洢��Ԫ��Ҳ���Ǽ��±�һ����һ���洢��Ԫ�����д洢��Ԫ��һ��ָ�
        $readmemb("C:/Users/drifter/Downloads/CPU_design/single_CPU_simulation/instructions.txt", mem); 
        //addi $0,$1,7  $1=7
        //andi $1,$2,4  $2=4
        //ori $2,$3,8   $3=12
        //xori $3,$4,b  $4=7
        //lw $4,$5,3    $5=10
        //sw $1,$2,2    memory[7+2]=4
        //beq $1,$4,2   if $1==$2   then branch �ر�ע��:�����offset�����PC+4��ƫ����,����ƫ�Ƶ���offset<<2��Ҳ����4*offset
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //add $4,$5,$6  $6=17
        //bne $1,$2,2   $7=-3
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //sub $2,$1,$7  
        //lui $8,12     $8=12
        //and $1,$2,$9  $9=4
        //or $2,$5,$10  $10=14
        //xor $3,$4,$11 $11=11
        //nor $3,$9,$12
        //sll $13,$3,2  $13=48
        //srl $14,$13,3  $14=3
        //sra $15,$12,2
        //addi $16,$13,52 $16=100
        //0x5c:      //jr $16
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //0x64:      //j 112 
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //0x6c:     //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //xxxxxxxx
        //0x70:      //jal 120
     end
     
     always @(ReadAddr)begin
        InstMem[31:24] = mem[ReadAddr|2'b00];//0
        InstMem[23:16] = mem[ReadAddr|2'b01];//1
        InstMem[15:8] = mem[ReadAddr|2'b10];//2
        InstMem[7:0] = mem[ReadAddr|2'b11];//3
     end
endmodule
