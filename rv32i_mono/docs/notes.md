🔷 Informe de Observaciones, Retos, Soluciones y Conclusiones

Laboratorio 1 – Diseño del Procesador Monociclo RISC-V (RV32I)
Arquitectura de Computadores – Universidad Tecnológica de Pereira

🗂️ Introducción

El presente informe recopila de manera sistemática todas las observaciones, dificultades, correcciones aplicadas y conclusiones obtenidas durante la creación del procesador monociclo basado en la arquitectura RISC-V (RV32I).
El objetivo principal es conservar un registro ordenado del proceso de construcción, verificación y análisis de cada uno de los módulos siguiendo la metodología propuesta en el laboratorio.

🎯 Objetivos

Implementar los componentes esenciales del procesador (ALU, Banco de Registros, Unidad de Control, Memorias, etc.).

Validar su comportamiento mediante testbench utilizando Icarus Verilog.

Inspeccionar señales de simulación a través de WaveTrace (VSCode).

Registrar progresivamente los problemas encontrados y las soluciones aplicadas.

📑 Desarrollo y Registro Técnico
⚙️ 1️⃣ ALU (Arithmetic Logic Unit)

Se diseñó la ALU como un módulo puramente combinacional con dos entradas de 32 bits (A y B) y una línea de selección ALUOp de 4 bits. Implementa 11 operaciones: aritméticas, lógicas, desplazamientos y comparaciones.
El testbench validó casos positivos, negativos y pruebas de bits.

Resultado del testbench:
![PC Diagram](../img/alu_tb.png)

🧭 2️⃣ Program Counter (PC)

Módulo secuencial que mantiene la dirección de instrucción activa. Reset asíncrono y actualización en cada ciclo mediante next_pc.

Resultado del testbench:
![PC Diagram](../img/pc_tb.png)

➕ 3️⃣ Sumador (Sum)

Incrementa la dirección del PC en 4.

Resultado del testbench:
![PC Diagram](../img/sum_tb.png)

🧩 4️⃣ Unidad de Control (Control Unit)

Decodifica instrucciones y genera señales internas del procesador (RUWr, ImmSrc, AluOp, BrOp, etc.).
Probada con instrucciones R, I, S, B, U y J.

Resultado del testbench:
![PC Diagram](../img/cu_tb.png)

🗄️ 5️⃣ Banco de Registros (Register Unit)

32 registros de 32 bits con lectura asíncrona y escritura sincronizada. Protección del registro x0.

Problema detectado: escritura inestable antes del posedge.
Solución: estabilizar señales en el testbench.

Resultado del testbench:
![PC Diagram](../img/ru_tb.png)

🧮 6️⃣ Immediate Generator (immgen)

Generación de inmediatos para todos los formatos RISC-V.

Dificultad: S-type mal formado.
Solución: ajustar bits [31:25] y [11:7].

Resultado del testbench:
![PC Diagram](../img/immgen_tb.png)

🔀 7️⃣ Multiplexores ALU (muxaluA y muxaluB)

Seleccionan entradas provenientes del PC, RU o inmmediatos.

Resultados:
![PC Diagram](../img/muxaluA_tb.png)
![PC Diagram](../img/muxaluB_tb.png)

🛰️ 8️⃣ Branch Unit (BRU)

Evalúa condiciones BEQ, BNE, BLT, BGE, BLTU y BGEU para decidir saltos.

Resultado del testbench:
![PC Diagram](../img/bru_tb.png)

🔁 9️⃣ Multiplexor del Next PC (muxnextpc)

Escoge entre PC+4 o dirección de salto.

Resultado:
![PC Diagram](../img/muxnextpc_tb.png)

💾 🔟 Data Memory (DM)

Memoria de datos de 1 KiB con soporte para byte, half y word.

Problemas:

Lectura inmediata tras escritura → requería 1 ciclo.

Valores iniciales indeterminados → memoria inicializada en 0.

Resultado del testbench:
![PC Diagram](../img/dm_tb.png)

🧰 1️⃣1️⃣ Multiplexor de Escritura en RU (muxrudata)

Escoge entre ALURes, DataRd o PC+4 según RUDataWrSrc.

Resultado:
![PC Diagram](../img/muxrudata.png)

📘 1️⃣2️⃣ Instruction Memory (IM)

Memoria de 256 instrucciones con lectura combinacional.

Resultado:
![PC Diagram](../img/im_tb.png)

1️⃣3️⃣ Integración del Procesador Monociclo

Tras validar de forma independiente cada módulo, se realizó el ensamble del procesador completo dentro del archivo monociclo.sv.
En esta etapa se interconectaron todos los bloques desarrollados durante el laboratorio:

Program Counter (PC): mantiene la dirección de la instrucción activa.

Instruction Memory (IM): entrega la instrucción correspondiente al PC.

Control Unit (CU): interpreta la instrucción y produce las señales de control.

Register Unit (RU): almacena datos y provee los operandos.

Immediate Generator (immgen): obtiene y extiende el inmediato acorde al formato.

Multiplexores (muxaluA, muxaluB): seleccionan las entradas para la ALU.

ALU: ejecuta operaciones aritméticas y lógicas.

Branch Unit (BRU): determina si debe realizarse un salto.

Data Memory (DM): gestiona lectura y escritura de datos.

Multiplexor (muxrudata): escoge el valor que se guardará en el registro destino.

Sumador (sum): calcula PC + 4.

Multiplexor (muxnextpc): define la siguiente dirección del PC.

🔷 Arquitectura y flujo de ejecución

El comportamiento del procesador en cada ciclo sigue la siguiente secuencia:

El PC envía la dirección a la IM.

La IM devuelve la instrucción de 32 bits.

La CU decodifica opcode, funct3 y funct7, y genera las señales de control.

El RU proporciona los valores de rs1 y rs2.

El immgen calcula el inmediato correspondiente.

Los multiplexores definen qué valores entran a la ALU.

La ALU realiza la operación indicada por la instrucción.

La BRU evalúa si debe tomarse un salto condicional.

La DM realiza lectura/escritura si la instrucción así lo requiere.

El muxrudata selecciona el valor que se escribirá en rd.

El RU almacena el resultado (si la instrucción lo permite).

El muxnextpc decide entre PC+4 o una dirección alternativa.

El PC actualiza su valor en el siguiente flanco de reloj.

Todo este flujo asegura la ejecución correcta de cualquier instrucción del subconjunto RV32I.

🔍 Señales expuestas para depuración

Para facilitar la verificación en la FPGA, se habilitaron varias señales internas como salidas del módulo principal:

pc_out: dirección actual del PC

inst_out: instrucción procesada

alu_res_out: resultado de la ALU

ru_rs1_out, ru_rs2_out: valores leídos del banco de registros

DataRd_out: dato recibido desde memoria

DataWr_out: dato a almacenar en memoria

RUWr_out, DMWr_out: señales de escritura

Estas señales se conectan posteriormente al módulo fpga_top, que permite mostrarlas en los displays hexadecimales y LEDs de la DE1-SoC.

🧪 Testbench del procesador completo

El archivo monociclo_tb.sv instancia el procesador, genera las señales de reloj y reset, y ejecuta el programa almacenado en la memoria de instrucciones.
Durante la simulación se monitorearon tanto los registros como la memoria para validar el comportamiento esperado:

x3 debe terminar con el valor 15, resultado del bucle de sumas.

mem[0] debe almacenar 15 al concluir el programa.

mem[2] y mem[3] deben contener 0x2A y 0x55 respectivamente, como prueba de LOAD/STORE.

La simulación se ejecuta durante ~100 ciclos, suficientes para completar todas las instrucciones. Además, se genera un archivo VCD para inspección detallada en WaveTrace.

✔️ Validación final

Los resultados confirmaron que:

✔️ El bucle de suma se ejecuta correctamente (x1 avanza de 1 a 5).

✔️ La acumulación produce el valor esperado (x3 = 15).

✔️ La memoria almacena el resultado adecuadamente (mem[0] = 15).

✔️ Las instrucciones LOAD y STORE funcionan como se espera.

✔️ El salto JAL opera correctamente y omite la instrucción 0xDEADBEEF.

✔️ Todas las operaciones aritméticas, lógicas y de desplazamiento se comportan de forma correcta.

