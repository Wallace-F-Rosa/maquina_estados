//Aluno : Wallace Ferancini Rosa Mátricula : 92545

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

/*
//Diagrama_Parte_I

                 +------------------0--------------------+
                 |+--------------------3-------------->+-+-+   3   +---+-----+
                 ||                                 +--+ 5 +------>| 6 +--+  |    +---+--------+
                 ||          +--------2/3-------+-+ |  +---+       +---+  |  |    | E | COD    |
                 ||          |        +---+       | |  ^                  |  |    |---|--------|
                 ||          | +------+ 3*+--3---+| 1  |                  |  |    | 0 |  000   |
                 ||          | |      +-+-+      || /  |                  |  |    | 1 |  001   |
                 ||          | 2      ^ |        || 2  3                  1  |    | 2 |  010   |
                 ||          | |     2| |        || |  |                  /  |    | 3 |  011   |
                 ||          | |      | |1/0     || |  |                  2  |    | 4 |  100   |
                 v|          | v      | |        vv v+-+                  /  0    | 5 |  101   |
           +--->+-+-+ 2/0  +-+-+  0/1 +-v-+ 0/1/2+---+ 1/2/3 +---+        3  |    | 6 |  110   |
           |  +>+ 0 +----->| 1 +----->| 2 |<-----+ 3 |<------+ 4 +--+     |  |    | 3*|  111   | (3* = tres2 no case)
           |  | |---+      +---+      +-+-++----->---+<---+  +---+  |     |  |    +---+--------+
           |  | | ^                     | ^|  3           |    ^    |     +  |
           |  | | +----------0----------+ ||              +----|----|-----+  |
           |  | +------------1------------++----------1--------+    |        |
           |  |                                                     +        |
           |  ++---------------------------0------------------------+        |
           |                                                                 |
           +-------------------------------0---------------------------------+
*/

module stateCase(input clk,input reset,input [1:0] a,output [2:0] saida);
reg [2:0] estado;

parameter zero = 3'b000 , um = 3'b001, dois = 3'b010, tres = 3'b011, quatro = 3'b100, cinco = 3'b101, seis = 3'b110, tres2 = 3'b111 ;

assign saida =  (estado == tres2) ? tres : estado;

    always @(posedge clk or  negedge reset) 
    begin
        if(reset == 0) estado = zero;
        else 
            case (estado)
                zero : estado = (a == 2'd0 || a == 2'd2) ? um : 
                                (a == 2'd1) ? dois : cinco;
                um : estado = (a == 2'd1 || a == 2'd0) ? dois : tres;
                dois : estado = (a == 2'd0) ? zero : (a == 2'd1) ? quatro : (a == 2'd2) ? tres2 : tres;
                tres : estado = (a == 2'd3) ? cinco : dois;
                quatro : estado = (a == 2'd0) ? zero : tres;
                cinco : estado = (a == 2'd0) ? zero : (a == 2'd3) ? seis : tres;
                seis : estado = (a == 2'd0) ? zero : tres;
                tres2 : estado = (a == 2'd2) ? um : (a == 2'd3) ? tres : dois;
            endcase
    end
endmodule


module stateMem(input clk,input res, input[1:0] a, output [2:0] saida);
reg [5:0] StateMachine [0:31]; // 32 linhas e 6 bits de largura
initial
begin  // programar ainda....

StateMachine[0] = 6'h01;   StateMachine[1] = 6'h02;
StateMachine[2] = 6'h01;   StateMachine[3] = 6'h05;
StateMachine[4] = 6'h0A;   StateMachine[5] = 6'h0A;
StateMachine[6] = 6'h0B;   StateMachine[7] = 6'h0B;
StateMachine[8] = 6'h10;   StateMachine[9] = 6'h14;
StateMachine[10] = 6'h17;  StateMachine[11] = 6'h13;
StateMachine[12] = 6'h1A;  StateMachine[13] = 6'h1A;
StateMachine[14] = 6'h1A;  StateMachine[15] = 6'h1D;
StateMachine[16] = 6'h20;  StateMachine[17] = 6'h23;
StateMachine[18] = 6'h23;  StateMachine[19] = 6'h23;
StateMachine[20] = 6'h28;  StateMachine[21] = 6'h2B;
StateMachine[22] = 6'h2B;  StateMachine[23] = 6'h2E;
StateMachine[24] = 6'h30;  StateMachine[25] = 6'h33;
StateMachine[26] = 6'h33;  StateMachine[27] = 6'h33;
StateMachine[28] = 6'h1A;  StateMachine[29] = 6'h1A;
StateMachine[30] = 6'h19;  StateMachine[31] = 6'h1B;
end
wire [4:0] address;  // 32 linhas = 5 bits de endereco
wire [5:0] dout; // 6 bits de largura 3+3 = saida + proximo
assign address[0] = a[0];
assign address[1] = a[1];
assign dout = StateMachine[address];
assign saida = dout[5:3];

ff st0(dout[0],clk,res,address[2]);
ff st1(dout[1],clk,res,address[3]);
ff st2(dout[2],clk,res,address[4]);

endmodule


module statePorta(input clk, input res, input [1:0] a, output [2:0] s);
wire [2:0] e;
wire [2:0] p;
assign s[0] = e[0] ; 
assign s[1] = e[1];
assign s[2] = e[2]&~e[1] | e[2]&~e[0]; // 5 operadores
assign p[0] = a[1]&~e[0] | a[0]&e[2]&~e[0] | a[1]&~a[0]&~e[1] | a[1]&e[2]&e[1] | a[1]&a[0]&~e[2] | ~a[0]&~e[2]&~e[1]&e[0] ; // 25 operadores
assign p[1] = a[0]&e[2] | ~a[0]&~e[2]&e[0] | ~e[2]&~e[1]&e[0] | ~a[1]&e[1]&e[0] | ~a[1]&a[0]&~e[1] | a[1]&e[1]&~e[0] | a[1]&e[2]&~e[0] ; //27 operadores
assign p[2] = ~a[1]&a[0]&~e[2]&e[1]&e[0] | a[1]&~a[0]&~e[2]&e[1]&~e[0] | a[1]&a[0]&~e[2]&~e[1]&~e[0] | a[1]&a[0]&~e[2]&e[1]&e[0] | a[1]&a[0]&e[2]&~e[1]&e[0]; //40 operadores

//total = 97 operadores

ff  e0(p[0],clk,res,e[0]);
ff  e1(p[1],clk,res,e[1]);
ff  e2(p[2],clk,res,e[2]);

endmodule 

module main;
reg c,res;
reg [1:0] a;
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
        //matricula : 92545 binario : 10110100110000001
     $monitor($time," c %b res %b a %b s %d smem %d sporta %d",c,res,a,saida,saida1,saida2);
      #1 res=0; a=2'b10;
      #1 res=1;
      #1 a=2'b10;
      #4 a=2'b11;
      #4 a=2'b01;
      #4 a=2'b00;
      #4 a=2'b11;
      #4 a=2'b00;
      #4 a=2'b00;
      #4 a=2'b01;
      #4
      $finish ;
    end
endmodule
