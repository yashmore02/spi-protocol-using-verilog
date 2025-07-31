module spi_master (
  input wire [5:0] miso,    
  input wire [2:0] ss,
  input wire sclk,
  output reg [5:0] mosi,
  input reset
  //output reg ss1, ss2, ss3    
  );

  reg [5:0] m_temp;          
  reg [5:0] m_data;
  reg [3:0] count;
  reg [2:0] next_state;
  wire [2:0] ss_in;
 
  //state encoding
  parameter IDLE = 3'b000;
  parameter SLAVE_1 = 3'b001;
  parameter SLAVE_2 = 3'b010;
  parameter SLAVE_3 = 3'b011;
  parameter LEFT_SHIFT = 3'b100;
 
  assign ss_in = ss;
 
  always @(posedge sclk or posedge reset) begin
   
    if (reset) begin
      //ss1 <= 1;
      //ss2 <= 1;
      //ss3 <= 1;
      m_data <= 6'b001101;    
      mosi <= 6'b0;
      m_temp <= 6'b0;
      next_state <= IDLE;
      count <= 4'd0;
    end else begin
      case(next_state)
           
            IDLE: begin
              case(ss_in)
                3'b000: next_state <= SLAVE_1;
                3'b001: next_state <= SLAVE_2;
                3'b010: next_state <= SLAVE_3;
                default: next_state <= IDLE;
              endcase
            end
         
            SLAVE_1: begin
              mosi[5:0] <= {mosi[5:1], m_data[5]};
              if(count <= 4'd6) begin
                next_state <= LEFT_SHIFT;
              end else begin
                next_state <= IDLE;
              end
            end
         
            SLAVE_2: begin
              mosi[5:0] <= {mosi[5:1], m_data[5]};
              if(count <= 4'd6) begin
                next_state <= LEFT_SHIFT;
              end else begin
                next_state <= IDLE;
              end
            end
         
            SLAVE_3: begin
              mosi[5:0] <= {mosi[5:1], m_data[5]};
              if(count <= 4'd6) begin
                next_state <= LEFT_SHIFT;
              end else begin
                next_state <= IDLE;
              end
            end
         
            LEFT_SHIFT: begin
              mosi <= mosi << 1;
              m_data <= m_data << 1;
              count <= count + 4'd1;
      //         m_data <= {m_data[4:0],1'b0};
              if(count <= 4'd5) begin
                case(ss_in)
                  000: next_state <= SLAVE_1;
                  001: next_state <= SLAVE_2;
                  010: next_state <= SLAVE_3;
                  default: next_state <= IDLE;
                endcase
              end
              else begin
                next_state <= IDLE;
              end
            end
         
          endcase
    end
   
   
    
  end
     
endmodule