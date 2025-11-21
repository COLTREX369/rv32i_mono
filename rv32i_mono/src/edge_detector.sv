module edge_detector (
    input  logic clk,
    input  logic rst,
    input  logic signal_in,
    output logic edge_detected
);

    logic signal_d;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            signal_d <= 1'b1;  // Botones activos en bajo
        end else begin
            signal_d <= signal_in;
        end
    end

    // Detectar flanco descendente (presión de botón)
    assign edge_detected = signal_d & ~signal_in;

endmodule