module muxnextpc (
    input logic [31:0] pc_plus4,
    input logic [31:0] alu_result,
    input logic nextPCSrc,
    output logic [31:0] next_pc
);

    always_comb begin
        case (nextPCSrc)
            1'b0: next_pc = pc_plus4;    // Selecciona PC + 4
            1'b1: next_pc = alu_result;   // Selecciona resultado de la ALU
            default: next_pc = 32'b0;     // Valor por defecto (no debería ocurrir)
        endcase
    end
endmodule