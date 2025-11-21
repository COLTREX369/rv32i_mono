module muxaluA (
    input logic [31:0] pc,
    input logic [31:0] ru_rs1,
    input logic aluASrc,
    output logic [31:0] aluA
);

    always_comb begin
        case (aluASrc)
            1'b0: aluA = ru_rs1; // Selecciona RU[rs1]
            1'b1: aluA = pc;     // Selecciona PC
            default: aluA = 32'b0; // Valor por defecto (no debería ocurrir)
        endcase
    end
endmodule