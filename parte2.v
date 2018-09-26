//diagrama de estados
//Aluno : Wallace Ferancini Rosa Matrícula : 92545
/*                    0
  +----------------------------------^      Mátricula decimal : 92545
  |                                  |      octal : 264601
  |                      1           |        +-------+
  |          +-----------------------+        | 0 |010|
  |          |                      ||        | 2 |110|
+-v-+  1/0 +-v-+   0   +---+ 1/0  +---+       | 3 |100| Codificação
| 0 +------> 3 +------>+ 2 +----->+ 4 |       | 4 |000|
+---+      +-+-+       +-^-+      +---+       | 5 |001|
             |           |                    +-------+
             |1          |
             |           |1/0
           +-v-+         |
           | 5 +---------+
           +---+
 */

module ff ( input data, input c, input r, output q);
reg q;
always @(posedge c or negedge r) 
begin
 if(r==1'b0)
  q <= 1'b0; 
 else 
  q <= data; 
end 
endmodule //End 

// ----   FSM alto nível com Case
module stateCase(clk, reset, a, saida);
input clk,reset,a;
    output [2:0] saida;
    reg [2:0] estado;

    parameter zero = 3'b010, dois = 3'b110, tres = 3'b100, quatro = 3'b000, cinco = 3'b001;

    assign saida =  (estado == zero) ? 3'd0 :
                    (estado == dois) ? 3'd2 :
                    (estado == tres) ? 3'd3 :
                    (estado == quatro) ? 3'd4 : 3'd5;

    always @(posedge clk or  negedge reset) 
    begin
        if(reset == 0) estado = zero;
        else 
            case (estado)
                zero : estado = tres;
                dois : estado = quatro;
                tres : estado = (a == 1) ? cinco : dois;
                quatro : estado = (a == 1) ? tres : zero;
                cinco : estado = dois;
            endcase
    end
endmodule
// FSM com portas logicas
// programar ainda....
module statePorta(input clk, input res, input a, output [2:0] s);
wire [2:0] e; wire [2:0] p; wire [2:0] out;


assign out[0] = e[0] | e[2]&~e[1]  ; // 2 operadores
assign out[1] = e[2];
assign out[2] = ~e[1] & ~e[2]; // 1 operador
assign p[0]  =  ~e[1]&~e[2]&a; // 4 operadores
assign p[1]  =  e[0] | ~e[1]&~a; //4 operadores
assign p[2] =   e[0]| a&~e[2] | e[1]&~e[0]&~e[2] | ~a&e[1]; //11 operadores
//total = 22 operadores
ff  e0(p[0],clk,res,e[0]);
ff  e1(p[1],clk,res,e[1]);
ff  e2(p[2],clk,res,e[2]);

ff e3(out[0],clk,res,s[0]);
ff e4(out[1],clk,res,s[1]);
ff e5(out[2],clk,res,s[2]);

endmodule 




module stateMem(input clk,input res, input a, output [2:0] saida);
reg [5:0] StateMachine [0:15]; // 16 linhas e 6 bits de largura
initial
begin  // programar ainda....

StateMachine[0] = 6'h14;  StateMachine[1] = 6'h24;
StateMachine[2] = 6'h35;  StateMachine[3] = 6'h35;
StateMachine[4] = 6'h20;  StateMachine[5] = 6'h20;
StateMachine[8] = 6'h33;  StateMachine[9] = 6'h0b;
StateMachine[12] = 6'h02;  StateMachine[13] = 6'h02;
end
wire [3:0] address;  // 16 linhas = 4 bits de endereco
wire [5:0] dout; // 6 bits de largura 3+3 = proximo estado + saida
wire [5:0] dout2;
assign address[0] = a;
assign dout2 = StateMachine[address];
assign saida = dout[2:0];

ff out1(dout2[0], clk,res,dout[0]);
ff out2(dout2[1], clk,res,dout[1]);
ff out3(dout2[2], clk,res,dout[2]);
ff out4(dout2[3], clk,res,dout[3]);
ff out5(dout2[4], clk,res,dout[4]); 

ff st0(dout2[3],clk,res,address[1]);
ff st1(dout2[4],clk,res,address[2]);
ff st2(dout2[5],clk,res,address[3]);
endmodule

module main;
reg c,res,a;
wire [2:0] saida;
wire [2:0] saida1;
wire [2:0] saida2;

stateCase estadocase(c,res,a,saida);
statePorta estadoporta(c,res,a,saida2);
stateMem estadoMem(c,res,a,saida1);


initial
    c = 1'b0;
  always
    c= #(1) ~c;

// visualizar formas de onda usar gtkwave out.vcd
initial  begin
     $dumpfile ("out.vcd"); 
     $dumpvars; 
   end 

  initial 
    begin
     $monitor($time," c %b res %b a %b s %d smem %d sporta %d",c,res,a,saida,saida1,saida2);
      #1 res=0; a=0;
      #1 res=1;
      #8 a=1;
      #16 a=0;
      #12 a=1;
      #4;
      $finish ;
    end
endmodule

