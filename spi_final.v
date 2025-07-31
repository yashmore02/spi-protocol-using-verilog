module SPI_Master (
    input wire CLK,
    input wire START,
    input wire [2:0] SS_IN,
    input wire [7:0] DATA_M,
    output reg [7:0] OUT_STATE_MASTER,
    output reg [7:0] OUT_MAIN_MASTER,
    output reg isValid_Selection
);
    reg [3:0] state;
    reg [7:0] data_buffer;

    // State Definitions
    parameter IDLE = 4'b0000,
              SEND = 4'b0001,
              RECEIVE = 4'b0010;

    always @(posedge CLK) begin
        if (START) begin
            state <= SEND; 
            data_buffer <= DATA_M;
            isValid_Selection <= 1; 
            OUT_MAIN_MASTER <= DATA_M; 
        end

        case (state)
            SEND: begin
                if (SS_IN != 3'b111) begin 
                    OUT_STATE_MASTER <= data_buffer; 
                    state <= RECEIVE; 
                end else begin
                    isValid_Selection <= 0; 
                end
            end

            RECEIVE: begin
                
                OUT_STATE_MASTER <= OUT_MAIN_MASTER; 
                state <= IDLE; 
            end

            IDLE: begin
               
                if (START) begin
                    state <= SEND;
                end
            end

            default: state <= IDLE;
        endcase
    end
endmodule
module SPI_Slave (
    input wire CLK,
    input wire [2:0] SS_IN,
    input wire [7:0] DATA_S,
    output reg [7:0] OUT_STATE_SLAVE,
    output reg [7:0] OUT_MAIN_SLAVE
);
    always @(posedge CLK) begin
        if (SS_IN != 3'b111) begin 
            OUT_MAIN_SLAVE <= DATA_S; 
            OUT_STATE_SLAVE <= OUT_MAIN_SLAVE; 
        end else begin
            OUT_STATE_SLAVE <= 8'b00000000; 
            OUT_MAIN_SLAVE <= 8'b00000000; 
        end
    end
endmodule

module Integration (
    input wire CLK,
    input wire START,
    input wire [2:0] SS_IN,
    input wire [7:0] DATA_M,
    input wire [7:0] DATA_S,
    output wire [7:0] OUT_STATE_MASTER,
    output wire [7:0] OUT_MAIN_MASTER,
    output wire [7:0] OUT_STATE_SLAVE1,
    output wire [7:0] OUT_STATE_SLAVE2,
    output wire [7:0] OUT_STATE_SLAVE3,
    output wire isValid_Selection
);

    wire [7:0] OUT_MAIN_SLAVE1;
    wire [7:0] OUT_MAIN_SLAVE2;
    wire [7:0] OUT_MAIN_SLAVE3;
    wire slave1_selected, slave2_selected, slave3_selected;


    assign slave1_selected = (SS_IN == 3'b000); 
    assign slave2_selected = (SS_IN == 3'b001); 
    assign slave3_selected = (SS_IN == 3'b010); 


    SPI_Master master (
        .CLK(CLK),
        .START(START),
        .SS_IN(SS_IN),
        .DATA_M(DATA_M),
        .OUT_STATE_MASTER(OUT_STATE_MASTER),
        .OUT_MAIN_MASTER(OUT_MAIN_MASTER),
        .isValid_Selection(isValid_Selection)
    );


    SPI_Slave slave1 (
        .CLK(CLK),
        .SS_IN(slave1_selected ? 3'b000 : 3'b111), 
        .DATA_S(DATA_S),
        .OUT_STATE_SLAVE(OUT_STATE_SLAVE1),
        .OUT_MAIN_SLAVE(OUT_MAIN_SLAVE1)
    );

    SPI_Slave slave2 (
        .CLK(CLK),
        .SS_IN(slave2_selected ? 3'b001 : 3'b111), 
        .DATA_S(DATA_S),
        .OUT_STATE_SLAVE(OUT_STATE_SLAVE2),
        .OUT_MAIN_SLAVE(OUT_MAIN_SLAVE2)
    );

    SPI_Slave slave3 (
        .CLK(CLK),
        .SS_IN(slave3_selected ? 3'b010 : 3'b111), 
        .DATA_S(DATA_S),
        .OUT_STATE_SLAVE(OUT_STATE_SLAVE3),
        .OUT_MAIN_SLAVE(OUT_MAIN_SLAVE3)
    );

endmodule
