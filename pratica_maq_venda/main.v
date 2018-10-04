
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

module moeda(input clk, input res, input next);


endmodule

module maq_pedido(input clk,input res,input vendeu, input next, input [1:0] moeda ,output m5, output m10, output m20);
reg [1:0] estado;

assign m5 = (estado == cinco);
assign m10 = (estado == dez);
assign m20 = (estado == vinte);

parameter zero = 2'b00, cinco = 2'b01, dez = 2'b10, vinte = 2'b11;

always @(posedge clk or  negedge res) 
    begin
        if(res == 0 || ~next) estado = zero;
        else
            case(estado)
                zero : estado = moeda;
                cinco : estado = moeda;
                dez : estado = moeda;
                vinte : estado = moeda;
            endcase
    end
endmodule


module maq_venda(input clk, input res, input m5, input m10, input m20, output next, output vendeu);
reg [2:0] estado;
reg [6:0] saldo;

parameter init = 3'b000, pedido = 3'b001, soma= 3'b010, vende = 3'b011, proximo = 3'b100;

assign vendeu = (estado >= 2'd40);
assign next = ~vendeu;

always @(posedge clk or  negedge res) 
    begin
        if(res == 0) estado = init;
        else
            estado += m5*5 + m10*10 + m20*20;
    end
endmodule




module main;



endmodule

