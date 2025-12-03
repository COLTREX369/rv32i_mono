🖥️ CPU RISC-V RV32I Monociclo para FPGA DE1-SoC
Procesador didáctico RISC-V de 32 bits implementado en SystemVerilog, diseñado para demostraciones en una FPGA Cyclone V.

🧭 Descripción del proyecto
Un procesador RISC-V monociclo totalmente funcional que:

🌟 Ejecuta programas RISC-V reales (incluye 43 instrucciones de ejemplo)  
🌟 Puede cargarse en la FPGA DE1-SoC para pruebas en vivo  
🌟 Emplea displays de 7 segmentos para monitorear la ejecución  
🌟 Ofrece modo manual (un ciclo por pulsador) y automático (1 instrucción/seg)  
🌟 Usa 10 LEDs para identificar la clase de instrucción en ejecución

El programa de demostración ejecuta un bucle que suma 1+2+3+4+5 = 15 y muestra operaciones aritméticas, lógicas, desplazamientos, load/store, saltos condicionales y JAL/JALR.

⚡ Inicio rápido

Simulación con Icarus Verilog

```powershell
cd p:\arquitectura de computadores\proyecto\rv32i_mono
iverilog -g2012 -o sim\monociclo_tb.vvp tb\monociclo_tb.sv src\*.sv
vvp sim\monociclo_tb.vvp

# Ver últimos resultados
vvp sim\monociclo_tb.vvp | Select-Object -Last 30
```

Carga en la FPGA DE1-SoC

Abrir en Quartus Prime:  
Archivo → Open Project → seleccionar quartus\rv32i_fpga.qpf  
Los pines ya están definidos en de1_soc_pins.tcl.

Compilar:
Processing → Start Compilation (Ctrl+L)  
Tiempo estimado: ~19 minutos  
Genera output_files/rv32i_fpga.sof

Programar la FPGA:
Tools → Programmer  
Hardware Setup → “DE-SoC [USB-0]” o “USB-Blaster”  
Agregar .sof si no aparece → marcar “Program/Configure” → Start

Alternativa en terminal:

```powershell
cd quartus
quartus_sh --flow compile rv32i_fpga
quartus_pgm -m jtag -o "p;output_files\rv32i_fpga.sof"
```

🎮 Controles en la FPGA

Botones  
KEY[0] = Avanzar un ciclo  
KEY[1] = Reset (PC = 0)

Switches  
SW[9] = Modo: 0 Manual / 1 Automático  
SW[8] = Selección de ventana en displays  
SW[7:4] = Registro a visualizar (si SW[3:0] = 0011)  
SW[3:0] = Señal a mostrar

Displays HEX  
HEX5-4: Bits superiores según ventana  
HEX3-0: Bits inferiores fijos de la señal seleccionada

LEDs rojos  
LEDR0 = Auto  
LEDR1 = Ventana  
LEDR2 = Pulso  
LEDR3 = Tipo R  
LEDR4 = Tipo I-ALU  
LEDR5 = LOAD  
LEDR6 = STORE  
LEDR7 = BRANCH  
LEDR8 = JAL  
LEDR9 = JALR

📡 Señales visualizables (SW[3:0])

0000 → PC  
0001 → Instrucción  
0010 → Resultado ALU  
0011 → Registro (x1-x7)  
0100 → Memoria[0]  
0101 → Memoria[1]  
0110 → Memoria[2]  
0111 → Memoria[3]  
1000 → ALU A  
1001 → ALU B  
1010 → Next PC

Ejemplo para ver x3: 0000110011

🏗️ Arquitectura
Componentes principales:

- pc.sv  
- sum.sv  
- im.sv  
- cu.sv  
- ru.sv  
- immgen.sv  
- muxaluA.sv  
- muxaluB.sv  
- bru.sv  
- alu.sv  
- muxnextpc.sv  
- dm.sv  
- muxrudata.sv

Top-level: monociclo.sv  
Adaptación a FPGA: fpga_top.sv

🔩 Módulos adicionales para FPGA

Incluye:

- clock_divider.sv — reduce 50 MHz a 1 Hz  
- debouncer.sv — elimina rebotes  
- edge_detector.sv — detecta flancos  
- hex_decoder.sv — decodifica nibble a segmentos  
- hex_display_6.sv — maneja los displays HEX5-0

Funciones esenciales para interacción y visualización en hardware real.

📝 Programa de demostración

- Bucle suma 1+2+3+4+5  
- Operaciones aritméticas (ADD/SUB)  
- Lógicas (AND/OR/XOR)  
- Shifts (SLLI/SRLI/SRAI)  
- Load/Store  
- Branch condicional  
- JAL incondicional

🧪 Pruebas

```powershell
iverilog -g2012 -o sim\alu_tb.vvp tb\alu_tb.sv src\alu.sv
vvp sim\alu_tb.vvp

gtkwave vcd\alu_tb.vcd
```

📂 Estructura del proyecto

rv32i_mono/  
├── src/  
├── tb/  
├── sim/  
├── vcd/  
├── quartus/  
│   ├── output_files/  
│   ├── db  
│   └── incremental_db  
├── docs/  
└── readme.md

📘 Documentación adicional

- Tabla de configuraciones  
- Notas técnicas

🛠️ Corrección de errores

- rs1 errado en ADDI  
- opcode incorrecto en BLT  
- ImmSrc corregido en saltos  
- Muxes de ALU ajustados para branches  
- Corrección en JAL  
- Límite del bucle corregido

👨‍💻 Autor

Juan David Colorado Obando  
Arquitectura de Computadores — UTP 2025

🧰 Herramientas utilizadas

- Icarus Verilog 12.0  
- Quartus Prime 23.1 Lite  
- VS Code + SystemVerilog
```// filepath: p:\arquitectura de computadores\proyecto\rv32i_mono\readme.md
// ...existing code...

🖥️ CPU RISC-V RV32I Monociclo para FPGA DE1-SoC
Procesador didáctico RISC-V de 32 bits implementado en SystemVerilog, diseñado para demostraciones en una FPGA Cyclone V.

🧭 Descripción del proyecto
Un procesador RISC-V monociclo totalmente funcional que:

🌟 Ejecuta programas RISC-V reales (incluye 43 instrucciones de ejemplo)  
🌟 Puede cargarse en la FPGA DE1-SoC para pruebas en vivo  
🌟 Emplea displays de 7 segmentos para monitorear la ejecución  
🌟 Ofrece modo manual (un ciclo por pulsador) y automático (1 instrucción/seg)  
🌟 Usa 10 LEDs para identificar la clase de instrucción en ejecución

El programa de demostración ejecuta un bucle que suma 1+2+3+4+5 = 15 y muestra operaciones aritméticas, lógicas, desplazamientos, load/store, saltos condicionales y JAL/JALR.

⚡ Inicio rápido

Simulación con Icarus Verilog

```powershell
cd p:\arquitectura de computadores\proyecto\rv32i_mono
iverilog -g2012 -o sim\monociclo_tb.vvp tb\monociclo_tb.sv src\*.sv
vvp sim\monociclo_tb.vvp

# Ver últimos resultados
vvp sim\monociclo_tb.vvp | Select-Object -Last 30
```

Carga en la FPGA DE1-SoC

Abrir en Quartus Prime:  
Archivo → Open Project → seleccionar quartus\rv32i_fpga.qpf  
Los pines ya están definidos en de1_soc_pins.tcl.

Compilar:
Processing → Start Compilation (Ctrl+L)  
Tiempo estimado: ~19 minutos  
Genera output_files/rv32i_fpga.sof

Programar la FPGA:
Tools → Programmer  
Hardware Setup → “DE-SoC [USB-0]” o “USB-Blaster”  
Agregar .sof si no aparece → marcar “Program/Configure” → Start

Alternativa en terminal:

```powershell
cd quartus
quartus_sh --flow compile rv32i_fpga
quartus_pgm -m jtag -o "p;output_files\rv32i_fpga.sof"
```

🎮 Controles en la FPGA

Botones  
KEY[0] = Avanzar un ciclo  
KEY[1] = Reset (PC = 0)

Switches  
SW[9] = Modo: 0 Manual / 1 Automático  
SW[8] = Selección de ventana en displays  
SW[7:4] = Registro a visualizar (si SW[3:0] = 0011)  
SW[3:0] = Señal a mostrar

Displays HEX  
HEX5-4: Bits superiores según ventana  
HEX3-0: Bits inferiores fijos de la señal seleccionada

LEDs rojos  
LEDR0 = Auto  
LEDR1 = Ventana  
LEDR2 = Pulso  
LEDR3 = Tipo R  
LEDR4 = Tipo I-ALU  
LEDR5 = LOAD  
LEDR6 = STORE  
LEDR7 = BRANCH  
LEDR8 = JAL  
LEDR9 = JALR

📡 Señales visualizables (SW[3:0])

0000 → PC  
0001 → Instrucción  
0010 → Resultado ALU  
0011 → Registro (x1-x7)  
0100 → Memoria[0]  
0101 → Memoria[1]  
0110 → Memoria[2]  
0111 → Memoria[3]  
1000 → ALU A  
1001 → ALU B  
1010 → Next PC

Ejemplo para ver x3: 0000110011

🏗️ Arquitectura
Componentes principales:

- pc.sv  
- sum.sv  
- im.sv  
- cu.sv  
- ru.sv  
- immgen.sv  
- muxaluA.sv  
- muxaluB.sv  
- bru.sv  
- alu.sv  
- muxnextpc.sv  
- dm.sv  
- muxrudata.sv

Top-level: monociclo.sv  
Adaptación a FPGA: fpga_top.sv

🔩 Módulos adicionales para FPGA

Incluye:

- clock_divider.sv — reduce 50 MHz a 1 Hz  
- debouncer.sv — elimina rebotes  
- edge_detector.sv — detecta flancos  
- hex_decoder.sv — decodifica nibble a segmentos  
- hex_display_6.sv — maneja los displays HEX5-0

Funciones esenciales para interacción y visualización en hardware real.

📝 Programa de demostración

- Bucle suma 1+2+3+4+5  
- Operaciones aritméticas (ADD/SUB)  
- Lógicas (AND/OR/XOR)  
- Shifts (SLLI/SRLI/SRAI)  
- Load/Store  
- Branch condicional  
- JAL incondicional

🧪 Pruebas

```powershell
iverilog -g2012 -o sim\alu_tb.vvp tb\alu_tb.sv src\alu.sv
vvp sim\alu_tb.vvp

gtkwave vcd\alu_tb.vcd
```

📂 Estructura del proyecto

rv32i_mono/  
├── src/  
├── tb/  
├── sim/  
├── vcd/  
├── quartus/  
│   ├── output_files/  
│   ├── db  
│   └── incremental_db  
├── docs/  
└── readme.md

📘 Documentación adicional

- Tabla de configuraciones  
- Notas técnicas

🛠️ Corrección de errores

- rs1 errado en ADDI  
- opcode incorrecto en BLT  
- ImmSrc corregido en saltos  
- Muxes de ALU ajustados para branches  
- Corrección en JAL  
- Límite del bucle corregido

👨‍💻 Autor

Juan David Colorado Obando  
Arquitectura de Computadores — UTP 2025

🧰 Herramientas utilizadas

- Icarus Verilog 12.0
- Quartus Prime 23.1 Lite
- VS Code + SystemVerilog