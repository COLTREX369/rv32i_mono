module bru (
    input logic [31:0] ru_rs1,
    input logic [31:0] ru_rs2,
    input logic [4:0] brOp,
    output logic nextPCSrc
);

  always_comb begin
    case (brOp)
      5'b00000: nextPCSrc = 1'b0; // No branch
      5'b10000: nextPCSrc = 1'b1; // JAL/JALR - Salto incondicional
      5'b01000: nextPCSrc = (ru_rs1 == ru_rs2) ? 1'b1 : 1'b0; // BEQ
      5'b01001: nextPCSrc = (ru_rs1 != ru_rs2) ? 1'b1 : 1'b0; // BNE
      5'b01100: nextPCSrc = ($signed(ru_rs1) < $signed(ru_rs2)) ? 1'b1 : 1'b0; // BLT
      5'b01101: nextPCSrc = ($signed(ru_rs1) >= $signed(ru_rs2)) ? 1'b1 : 1'b0; // BGE
      5'b01110: nextPCSrc = (ru_rs1 < ru_rs2) ? 1'b1 : 1'b0; // BLTU
      5'b01111: nextPCSrc = (ru_rs1 >= ru_rs2) ? 1'b1 : 1'b0; // BGEU
      default: nextPCSrc = 1'b0; // Valor por defecto (no debería ocurrir)
    endcase
  end
endmodule