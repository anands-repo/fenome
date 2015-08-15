`timescale 1ns / 1ps
module hash_function #(
    parameter DATA_WIDTH = 128,
    parameter MAIN_HASH_WIDTH = 30,
    parameter SUBSIDIARY_HASH_WIDTH = 9,
    parameter NUM_SUBSIDIARY_HASH = 6,
    parameter NUM_STAGES = 8,
    parameter LAST_STAGE_SIZE = 16
) (
    input clk,
    input rstb,
    input [DATA_WIDTH-1:0] data,
    input data_valid,
    input ready4_hash,
    output hash_valid,
    output empty,
    output ready4_data,
    output [MAIN_HASH_WIDTH-1:0] main_hash,
    output [NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH-1:0] subsidiary_hash_values
);

parameter [(NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH)*DATA_WIDTH-1:0] SEED = 10752'b100010010001111100100110010100100111010001110010010001010111111011001101100111000001110001100011111000101110011110100011010110110010010111101111010011000110001011011110010000010101011100110100100010101110010011101101100111110011001100101101010011101111000000110101111101011000011101000001101101111100111011111010010110110101101011101000101010001111010111001100011000010101100001100001000001101110001110010110011001110100100000001101000111001110100110101100110110101111010011000110111001111000001001111011010011011011000110100001011100011101101110010010000101101010011111011111011110010111110100110100110100101001011100100010100110100011111111111000011000111101011111100110001111010110010001001001001101000010011011010110001011001101111100110000110111001101010111111100110000110001001011010100100011001011001110101101110100001001010010111000111000000110011010100100111011000110011111111011011110110101111111101101100101111000010011111000010111011001110101000011111011010111111001011101011111111100110111001010011100101100010110101001000000011001000111101011010101100000010011100100101101000001101001111100100100001101011011101000000110001000001101001001101101101111101010000000011101001001000001110010000100001000011011011100011000100110110011001100111001101101101101101000111101110100101100000100111011001001000111011100111101111001110011001111100111101000011001110011100001111011110100110011011011100000100010001100100100001101111000010011100011111000110100001110111111111111101001010100011010010111011000101010000001001100001100000001110010110010011101111010011101000000111010010010011000000100000011010101100011001001101010001111110100100110001000010111111110101010010001010000010111100111000010001110011110101000111000001001111011100111011011000000110001101011100010001010011111111101111110001100000100111010010011000000000011110100000111011111011000101000110100111001110010001110001110100001000111010011010000011100110110000010011100001011011101000110111111111100010111000011000100100100110000110101001110001000000100110110000100111010110001011100100000000111111101101110111111101001000000100010110101000111110001101111100000101010000001001110001110001100001001100101110011111100010111001111110101110111101110000010100100110111000000000110110011100010010000001001110100010001010110101111000100110011110110110010100100101101101000000010110011100111100111100101100110001010000110001011111001100011000011110011101100111111100100111100010100100001110001010100111010000101001110101011110100000101111001010000000111110100101000000010010000110001111110110110110001111100000001101000101010010010010001010101111110010100000110000111110000110100010101000001111100111001111100000011110101101010001110111100110101010000110011011000001010011001100111001011011111110111100001000101000011100100001110110111001001001001000001010101110101100000100100111110111101110011010100000101100100100110010101001100100011000111001011001010011100011100001100101001101110110000010001110010000111000110101011101010111011001110111000000111000011010101001001111010000100010010101010001101001110110001001001111110111001000100110111000110010101111100111011100011000101001010101111101000100000010100011000101010101101010000011111001001000100011100001101010001100110111000101110001001111001000010111000000011110011101011101001001000001001010000111111110101101100011001111010000100010111011010011011110101010110001110100111111000110000111000001110101001100110100000010011110001101010010011101000011010000000110000001011010101000101000100000101000111110000100000111011001101111011000001010010110011110110000000010100101010001011111010101011001010000111111000010101011111000100101010110011000111001100001101010111110100000000000111001000000011001101111101100101101111001000101001010001001000110100000100001100011111010100001111011010000110001110101010101010111000111001111000011111000010000011001010011111001100110110101100010110101110001101010001101011001111001101001100110011110101010111101011011110011101110111100110111000101011111010111101001000010101000101110010110110111001110101010010110000001001101101011100011011001110010100000010010111111111111110000111101101000111010000010010101011100001010011010110010001101110100001100101011001101110001010000111000110110001001110100011010010000100100100010000111011111110111000001010101000100000001010011010011111000101111101011110101111111011110100110010110100111000111110100110001100011100010110011101000011001100011011001100111101110010000010011100100111101010111000000101100000100111111110000010011101001111001000100011101101001100101011100000000001110111100001100100000100001010100000111111010011011011011010000001011010000001101100000011110001101001100010111111111000010110110000101101010000001001010111001111011111001000001001111101110110001001110000010000111111010000011101001011010011111011000010110001010111101011010011100101010000101110001110011110101011001101000010101010010000000011101111000101111010000111101111011001000110001010000101110100111101010010000000011010010101111000000001111010011101000110001111001100111100101111000000100111010111011001000111101110000100010011000001101000000000111101000110011010110101001001110111100111000111101111000001010110100001111111011010011011011010100100100110100000011100110001100010001100001111110111000000110010011000110010010101011011011010011110011101011011110110101010111111110111101001101001110110101101010100110011011010001110111111101011111101010111101100110001100011001111010011101011110010100001000001001100111001111111101101110101000000100010011001011011000011100011010000110100101010001000110100110101011010100101111000011100101110111011010001010010110010100000100011111011000010000000111010111001000010100001000100000001011011110010000010111011101010001100110110010111010001100111001100100111010111001010100011010000100000110011011001110010000111001001001010001111000100010111010000000100010110100011010000100111100011001011111010100111001010100110011010110111010110010101010101110011011000110110110011010011100001100110101110111100101001100100101101001101110100100000101110110100001010100011110001111101101010001001011100100010110000101010111001001000100101101101011001100011011001101010001000101110101001000101010111100011101111100100101100100100111001010110110100000000011000101100000100010110000010110110110000100110101000101111111011111110001000011000000111111001001000011111111101010101010111111111111011111000011110111010001010100010101111000000000001000100111000010111100101010110110011001100101111011001110101101110110001001101110001101001101000100000001001110011100111000001101100001001101110100000000011010100101101110100111000001010111001110110111011111100111111111111110101010011111110110000001010011111000110001110010110110101001101010000100100010110110101000101011111101110110010010101010001011111110100110100000110010001000011110101111110010011100010111001110001001100001000011100001001011110111010001001111110000111110010101101110101111101110111110101101100001111100001010010011101110111010100111100001000001110101010100001101000110110110011110111101100000100101000010001001100101000010010011101001100001100010010010111100110100111110101000111110011001000011100000001001101010000100101100111110000100000101100010101001110110000000010101000101000001000100100100010011111001111110001000110001010011101111001010101100101100001011011110000100000101001011000000111100101000101001010000100101000000111111000100011111111101100101110001000100000001101010010110101001101000001011000100001011100000110101000011010010111111111000010101010111011010110100100100010010100010110101100100100101001010110101000001110000101001111000001110001010000001100001001110000111000101101101110111001010010101111011100000101011111110001110100111010010110001011000001100110010001011001011010001101100110110000100111011100101111111101110011110111000100001000100100011000000111101011010100011010110010110010110010100100100101001100111000111011010010100111010010100000001010110000111110010000000010001110001010100000000110000011111010100000110001011000111000110011000110001100001110110000101110101110010010001110101011010100101110100101011111011100101000100110011001101110001010101001111000111000010000110111101001110010111010110001011000001111101111110000110100001100110010101001101000100101100110100111100110001100000000001101101110001101101001001001000101001100000110110101110110011001000000100011100001000000011100100110011110100010111010111100110011011101001010101001111101001011010110000011100101110101000010101101010001110001000000100001100010010111001110110011001000101011100010010110100011001101010101110011110111000111101010010010101110111100110100100010110101100010110001000011001111010001111101010001011110111110100101010001011001010010110000011100010111100000011111001100000001001110001100110101001111011011001101001110000101100011011111100100011110000110000111101001000100010110101111010100011111111101111001001000100100000101000111000011100100110011101010011110010001011000000110110000111101000101111101011011010110111110101110101000001001111000011101000110011000111000010010110010011011000111110000000011010100101011101111000010100110100001000011010111001111010110101000100110100011011011110011101111110011010100101101000001001110000011111010011000100111011100001010010001111110010111011101001100011000001010111101001000010010000110111100111110011011000100111100100001111100011101111010001001011110111100100100001110100101011010111000011111001111101001000011001011101100110111001011101001011010101101101100000011010101011000001111000010101110001011001000110101110110101101110010101010000010000010100101011010111101110110101011110100111100001101001111110010001111111100010000000001100101111001110111000010110001000100101000111010001001001000111100010010000011111010111111011000010100010001001010100001111111110001111111110000110010111001110000111100110001110110101101111100001100110001100010011001000011011010101111111000000100000101010101001010111001000101100011001010001000011110011111011001100110000111111101000011110101111000011110001011010011011011110111110111110101101111111111001001111100010001010110010100011000111100111111011011000000010010001010111001110010010000010001010011101100011110110000111000010001100111010100110101101010111010001111101100101010111011010100011111101010111101000110101100111101010011011000010011111101100100010001100100010110000011000001101111010101000101111100110110101000000111111001010110111011010001011110100111110011010010000111101100001110010100000010011011110001110001011111101111010010110111011111111110111000111001110001010110111100000011110001101111101000010010101111001100100100010110111010001001110101101101110001001111001101111010111101001010111111100011011011101000100111001110110111111110010001000111011011110010000101010010;

localparam stage_depth = (DATA_WIDTH-LAST_STAGE_SIZE)/(NUM_STAGES-1);

wire [NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH-1:0] seeds[0:DATA_WIDTH-1];
reg [DATA_WIDTH-1:0] data_for_stages[0:NUM_STAGES-1];
reg [NUM_STAGES-1:0] valid;

genvar p;
generate
    for (p=0; p<DATA_WIDTH; p=p+1) begin:assign_seeds
        assign seeds[p] = SEED[(NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH)*(p+1)-1:(NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH)*p];
    end
endgenerate

genvar k, l;
generate
    for (k = 0; k < NUM_STAGES; k=k+1) begin:pipelines
        if (k == 0) begin
            always @* data_for_stages[k] <= data;
        end
        else begin
            always @(posedge clk or negedge rstb) begin
                if (~rstb) begin
                    data_for_stages[k] <= {DATA_WIDTH{1'b0}};
                end
                else begin
                    if (ready4_hash) data_for_stages[k] <= data_for_stages[k-1];
                end
            end
        end

        if (k < NUM_STAGES-1) begin:except_last_stage
            reg [NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH-1:0] hash[-1:stage_depth-1];

            if (k != 0) begin
                always @* hash[-1] <= pipelines[k-1].except_last_stage.hash[stage_depth-1];
            end
            else begin
                always @(posedge clk) hash[-1] <= {(NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH){1'b0}};
            end

            for (l=0; l<stage_depth; l=l+1) begin:some_name
                if (l < stage_depth-1) begin
                    always @* hash[l] <= ({(NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH){data_for_stages[k][k*stage_depth+l]}} & seeds[k*stage_depth+l]) ^ hash[l-1];
                end
                else begin
                    always @(posedge clk or negedge rstb) begin
                        if (~rstb) begin
                            hash[l] <= {(NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH){1'b0}};
                        end
                        else begin
                            if (ready4_hash) hash[l] <= ({(NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH){data_for_stages[k][k*stage_depth+l]}} & seeds[k*stage_depth+l]) ^ hash[l-1];
                        end
                    end
                end
            end
        end
        else begin:last_stage
            reg [NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH-1:0] hash[-1:LAST_STAGE_SIZE-1];

            always @* hash[-1] <= pipelines[k-1].except_last_stage.hash[stage_depth-1];

            for (l=0; l<LAST_STAGE_SIZE; l=l+1) begin:some_name
                if (l<LAST_STAGE_SIZE-1) begin
                    always @* hash[l] <=  ({(NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH){data_for_stages[k][k*stage_depth+l]}} & seeds[k*stage_depth+l]) ^ hash[l-1];
                end
                else begin
                    always @(posedge clk or negedge rstb) begin
                        if (~rstb) begin
                            hash[l] <= {(NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH){1'b0}};
                        end
                        else begin
                            if (ready4_hash) hash[l] <= ({(NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH){data_for_stages[k][k*stage_depth+l]}} & seeds[k*stage_depth+l]) ^ hash[l-1];
                        end
                    end
                end
            end
        end
    end
endgenerate

always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        valid <= 'b0;
    end
    else begin
        if (ready4_hash) valid <= {valid[NUM_STAGES-2:0], data_valid};
    end
end

assign empty = ~|(valid);

assign main_hash               = pipelines[NUM_STAGES-1].last_stage.hash[LAST_STAGE_SIZE-1][NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH+MAIN_HASH_WIDTH-1:NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH];
assign subsidiary_hash_values  = pipelines[NUM_STAGES-1].last_stage.hash[LAST_STAGE_SIZE-1][NUM_SUBSIDIARY_HASH*SUBSIDIARY_HASH_WIDTH-1:0];
assign hash_valid              = valid[NUM_STAGES-1] & ready4_hash;
assign ready4_data             = ready4_hash;

endmodule