module muxaluB (
    input logic [31:0] immgen,
    input logic [31:0] ru_rs2,
    input logic aluBSrc,
    output logic [31:0] aluB
);

    always_comb begin
        case (aluBSrc)
            1'b0: aluB = ru_rs2; // Selecciona RU[rs2]
            1'b1: aluB = immgen; // Selecciona immgen
            default: aluB = 32'b0; // Valor por defecto (no debería ocurrir)
        endcase
    end
endmodule