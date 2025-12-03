module rv32i_fpga_top (

    // ======== Pines físicos de la DE1-SoC ========
    input  logic        CLOCK_50,      // Reloj de 50 MHz
    input  logic [3:0]  KEY,           // KEY[0] = reset
    input  logic [9:0]  SW,            // Switches
    output logic [9:0]  LEDR,          // LEDs rojos

    // Displays de 7 segmentos
    output logic [6:0]  HEX0,
    output logic [6:0]  HEX1,
    output logic [6:0]  HEX2,
    output logic [6:0]  HEX3
);

    // ================================
    // Reloj y Reset
    // ================================
    logic clk;
    logic reset;

    assign clk   = CLOCK_50;
    assign reset = ~KEY[0];     // reset activo en bajo

    // ================================
    // Señales de debug desde el CPU
    // ================================
    logic [31:0] pc;
    logic [31:0] inst;
    logic [31:0] alu_res;
    logic [31:0] alu_a;
    logic [31:0] alu_b;
    logic [31:0] next_pc;

    logic [31:0] x1, x2, x3, x4, x5, x6, x7;
    logic [31:0] dm_dbg [0:7];

    // ================================
    // Instancia del procesador
    // ================================
    monociclo cpu (
        .clk             (clk),
        .reset           (reset),
        .pc_out          (pc),
        .inst_out        (inst),
        .alu_result_out  (alu_res),
        .alu_a_out       (alu_a),
        .alu_b_out       (alu_b),
        .next_pc_out     (next_pc),
        .debug_x1        (x1),
        .debug_x2        (x2),
        .debug_x3        (x3),
        .debug_x4        (x4),
        .debug_x5        (x5),
        .debug_x6        (x6),
        .debug_x7        (x7),
        .debug_dm_word   (dm_dbg)
    );

    // ================================
    // Mostrar PC en HEX usando tu hex_decoder
    // ================================
    hex_decoder h0 (.hex_value(pc[3:0]   ), .seg(HEX0));
    hex_decoder h1 (.hex_value(pc[7:4]   ), .seg(HEX1));
    hex_decoder h2 (.hex_value(pc[11:8]  ), .seg(HEX2));
    hex_decoder h3 (.hex_value(pc[15:12] ), .seg(HEX3));

    // ================================
    // Mostrar debug extra en LEDs
    // ================================
    assign LEDR = pc[9:0];

endmodule
