module muxnextpc_tb;
    // Señales internas
    logic [31:0] pc_plus4;
    logic [31:0] alu_result;
    logic nextPCSrc;
    logic [31:0] next_pc;

    // Instancia del módulo muxnextpc
    muxnextpc uut (
        .pc_plus4(pc_plus4),
        .alu_result(alu_result),
        .nextPCSrc(nextPCSrc),
        .next_pc(next_pc)
    );

    initial begin
        $dumpfile("vcd/muxnextpc_tb.vcd");
        $dumpvars(0, muxnextpc_tb);
        $display("=================================================================");
        $display("            TESTBENCH PARA MUX NEXT PC");
        $display("=================================================================\n");

        // -----------------------------------------------------------
        // Prueba 1: Selección de PC + 4
        // -----------------------------------------------------------
        pc_plus4 = 32'h00000004;
        alu_result = 32'h00000010; // Valor arbitrario
        nextPCSrc = 1'b0; // Seleccionar PC + 4
        #10;
        $display("Prueba 1 - nextPCSrc=0: next_pc = 0x%h (debe ser 0x00000004)", next_pc);

        // -----------------------------------------------------------
        // Prueba 2: Selección de resultado de la ALU
        // -----------------------------------------------------------
        pc_plus4 = 32'h00000008; // Valor arbitrario
        alu_result = 32'h00000020;
        nextPCSrc = 1'b1; // Seleccionar resultado de la ALU
        #10;
        $display("Prueba 2 - nextPCSrc=1: next_pc = 0x%h (debe ser 0x00000020)", next_pc);

        $display("\n=================================================================");
        $display("                    FIN DEL TESTBENCH");
        $display("=================================================================\n");
        $finish;
    end
endmodule