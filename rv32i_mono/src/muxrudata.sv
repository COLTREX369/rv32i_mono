module muxrudata (
    input  logic [31:0] PCInc,       // PC + 4
    input  logic [31:0] ALURes,      // Resultado de la ALU
    input  logic [31:0] DataRd,      // Dato leído de la memoria
    input  logic [1:0]  RUDataWrSrc, // Control del mux
    output logic [31:0] DataWr       // Dato a escribir en el registro
);

    // Mux para seleccionar el dato a escribir en el registro
    always_comb begin
        case (RUDataWrSrc)
            2'b00: DataWr = ALURes;   // Desde la ALU
            2'b01: DataWr = DataRd;   // Desde la memoria de datos
            2'b10: DataWr = PCInc;    // Desde PC + 4
            default: DataWr = 32'b0;   // Valor por defecto (seguridad)
        endcase
    end
endmodule