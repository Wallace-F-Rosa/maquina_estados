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
           |  +>+ 0 +----->| 1 +----->| 2 |<-----+ 3 |<------+ 4 +--+     |  |    | 3*|  111   |
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

parameter zero = 3'b000, um = 3'b001, dois = 3'b010, tres = 3'b011, quatro = 3'b100, cinco = 3'b001, seis = 3'b110, tres' = 3'b111 ;

assign saida =  (estado == tres') ? tres : estado;

    always @(posedge clk or  negedge reset) 
    begin
        if(reset == 0) estado = zero;
        else 
            case (estado)
                zero : estado = (a == 2'd0 || a == 2'd2) ? um : 
                                (a == 2'd1) ? dois : cinco;
                um : estado = (a == 2'd1 || a == 2'd0) ? dois : tres;
                dois : estado = (a == 2'd0) ? zero : (a == 2'd1) ? quatro : (a == 2'd2) ? tres' : tres;
                tres : estado = (a == 2'd3) ? cinco : dois;
                quatro : estado = (a == 2'd0) ? zero : tres;
                cinco : estado = (a == 2'd0) ? zero : (a == 2'd3) ? seis : tres;
                seis : estado = (a == 2'd0) ? zero : tres;
            endcase
    end
endmodule


module stateMem(input clk,input res, input[1:0] a, output [2:0] saida);
reg [5:0] StateMachine [0:31]; // 32 linhas e 6 bits de largura
initial
begin  // programar ainda....

StateMachine[0] = 6'h09;   StateMachine[1] = 6'h22;
StateMachine[2] = 6'h09;   StateMachine[3] = 6'h2d;
StateMachine[4] = 6'h22;   StateMachine[5] = 6'h22;
StateMachine[6] = 6'h1b;   StateMachine[7] = 6'h1b;
StateMachine[8] = 6'h00;   StateMachine[9] = 6'h24;
StateMachine[10] = 6'h1f;  StateMachine[11] = 6'h1b;
StateMachine[12] = 6'h12;  StateMachine[13] = 6'h12;
StateMachine[14] = 6'h12;  StateMachine[15] = 6'h2d;
StateMachine[16] = 6'h00;  StateMachine[17] = 6'h1b;
StateMachine[18] = 6'h1b;  StateMachine[19] = 6'h1b;
StateMachine[20] = 6'h00;  StateMachine[21] = 6'h1b;
StateMachine[22] = 6'h1b;  StateMachine[23] = 6'h36;
StateMachine[24] = 6'h00;  StateMachine[25] = 6'h1b;
StateMachine[26] = 6'h1b;  StateMachine[27] = 6'h1b;
StateMachine[28] = 6'h22;  StateMachine[29] = 6'h22;
StateMachine[30] = 6'h09;  StateMachine[31] = 6'h1b;
end
wire [4:0] address;  // 32 linhas = 5 bits de endereco
wire [5:0] dout; // 6 bits de largura 3+3 = proximo estado + saida
assign address[0] = a[0];
assign address[1] = a[1];
assign dout = StateMachine[address];
assign saida = dout[2:0];
ff st0(dout[3],clk,res,address[2]);
ff st1(dout[4],clk,res,address[3]);
ff st2(dout[5],clk,res,address[4]);
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
