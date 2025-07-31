

module tb_Integration;

    // Inputs
    reg CLK;
    reg START;
    reg [2:0] SS_IN;
    reg [7:0] DATA_M;
    reg [7:0] DATA_S;

    // Outputs
    wire [7:0] OUT_STATE_MASTER;
    wire [7:0] OUT_MAIN_MASTER;
    wire [7:0] OUT_STATE_SLAVE1;
    wire [7:0] OUT_STATE_SLAVE2;
    wire [7:0] OUT_STATE_SLAVE3;
    wire isValid_Selection;

    // Instantiate the Integration module
    Integration uut (
        .CLK(CLK),
        .START(START),
        .SS_IN(SS_IN),
        .DATA_M(DATA_M),
        .DATA_S(DATA_S),
        .OUT_STATE_MASTER(OUT_STATE_MASTER),
        .OUT_MAIN_MASTER(OUT_MAIN_MASTER),
        .OUT_STATE_SLAVE1(OUT_STATE_SLAVE1),
        .OUT_STATE_SLAVE2(OUT_STATE_SLAVE2),
        .OUT_STATE_SLAVE3(OUT_STATE_SLAVE3),
        .isValid_Selection(isValid_Selection)
    );

    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        START = 0;
        SS_IN = 3'b111; // No slave selected
        DATA_M = 8'hA5; // Arbitrary data from master
        DATA_S = 8'h5A; // Arbitrary data from slave

        // Wait for the clock to stabilize
        #10;

        // Test Case 1: Select Slave 1 and send data
        START = 1;
        SS_IN = 3'b000; // Select Slave 1
        #10;
        START = 0;

        #20;
        $display("Slave 1 Selected:");
        $display("OUT_STATE_MASTER: %h", OUT_STATE_MASTER);
        $display("OUT_MAIN_MASTER: %h", OUT_MAIN_MASTER);
        $display("OUT_STATE_SLAVE1: %h", OUT_STATE_SLAVE1);
        $display("isValid_Selection: %b", isValid_Selection);

        // Test Case 2: Select Slave 2 and send data
        START = 1;
        SS_IN = 3'b001; // Select Slave 2
        DATA_M = 8'hC3;
        DATA_S = 8'h3C;
        #10;
        START = 0;

        #20;
        $display("Slave 2 Selected:");
        $display("OUT_STATE_MASTER: %h", OUT_STATE_MASTER);
        $display("OUT_MAIN_MASTER: %h", OUT_MAIN_MASTER);
        $display("OUT_STATE_SLAVE2: %h", OUT_STATE_SLAVE2);
        $display("isValid_Selection: %b", isValid_Selection);

        // Test Case 3: Select Slave 3 and send data
        START = 1;
        SS_IN = 3'b010; // Select Slave 3
        DATA_M = 8'hB4;
        DATA_S = 8'h4B;
        #10;
        START = 0;

        #20;
        $display("Slave 3 Selected:");
        $display("OUT_STATE_MASTER: %h", OUT_STATE_MASTER);
        $display("OUT_MAIN_MASTER: %h", OUT_MAIN_MASTER);
        $display("OUT_STATE_SLAVE3: %h", OUT_STATE_SLAVE3);
        $display("isValid_Selection: %b", isValid_Selection);

        // Test Case 4: No valid slave selected
        START = 1;
        SS_IN = 3'b111; // No slave selected
        DATA_M = 8'hFF;
        DATA_S = 8'h00;
        #10;
        START = 0;

        #20;
        $display("No Slave Selected:");
        $display("OUT_STATE_MASTER: %h", OUT_STATE_MASTER);
        $display("OUT_MAIN_MASTER: %h", OUT_MAIN_MASTER);
        $display("OUT_STATE_SLAVE1: %h", OUT_STATE_SLAVE1);
        $display("OUT_STATE_SLAVE2: %h", OUT_STATE_SLAVE2);
        $display("OUT_STATE_SLAVE3: %h", OUT_STATE_SLAVE3);
        $display("isValid_Selection: %b", isValid_Selection);

        // End simulation
        $finish;
    end

endmodule
