// Code your testbench here
// or browse Examples


module spi_master_tb;

  reg clk;
  reg reset;
  reg [2:0] ss;
  reg [5:0] miso;
  wire [5:0] mosi;

  // Instantiate the SPI Master
  spi_master uut (
    .reset(reset),
    .ss(ss),
    .sclk(clk),
    .miso(miso),
    .mosi(mosi)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns clock period
  end

  // Test Procedure
  initial begin
    // Initialize inputs
    reset = 1;
    ss = 3'b111;
    miso = 6'b110011;

    // Apply reset
    #15;
    reset = 0;

    // Test Case 1: Select SLAVE_1 and check data transfer
    #20;
//     ss = 3'b000;  // Selecting SLAVE_1
//     #100;         // Wait to observe mosi shifts

//     // Test Case 2: Select SLAVE_2 and check data transfer
//     #20;
//     ss = 3'b001;  // Selecting SLAVE_2
//     #100;         // Wait to observe mosi shifts

    // Test Case 3: Select SLAVE_3 and check data transfer
    #20;
    ss = 3'b010;  // Selecting SLAVE_3
    #100;         // Wait to observe mosi shifts

//     // Test Case 4: Idle state check
//     #20;
//     ss = 3'b111;  // Deselect all slaves
    #50;

    // End simulation
    #20;
    $finish;
  end

  // Monitor signals for debugging
  initial begin
    $monitor("Time = %0t | clk = %b | reset = %b | ss = %b | miso = %b | mosi = %b",
             $time, clk, reset, ss, miso, mosi);
  end

endmodule
