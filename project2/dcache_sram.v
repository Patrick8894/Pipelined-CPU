module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   reg    [24:0]    tag_o;
output   reg    [255:0]   data_o;
output   reg              hit_o;



// Memory
reg      [24:0]    tag [0:15][0:1];  // [22:0]tag [23]dirty [24]valid
reg      [255:0]   data[0:15][0:1];
reg      [1:0]     lru [0:15];       // 0 if empty, 1 if first entry is lru, 2 if second entry is lru
integer            i, j;


// Write Data
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
                lru[i] <= 2'b0;
            end
        end
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here

        // hit : 直接寫 更新lru
        if (tag_i[22:0] == tag[addr_i][0][22:0] && tag[addr_i][0][24] == 1) begin
            data[addr_i][0] <= data_i;
            tag[addr_i][0] <= { 2'b11, tag_i[22:0] };
            lru[addr_i] <= 2;
        end
        else if (tag_i[22:0] == tag[addr_i][1][22:0] && tag[addr_i][1][24] == 1) begin
            data[addr_i][1] <= data_i;
            tag[addr_i][1] <= { 2'b11, tag_i[22:0] };
            lru[addr_i] <= 1;
        end

        // miss : 依據lru 來決定哪一個entry 要被覆寫
        else begin
            case(lru[addr_i])
                0: begin                       //empty
                    data[addr_i][0] <= data_i;
                    tag[addr_i][0] <= { 2'b11, tag_i[22:0] };
                    lru[addr_i] <= 2;           // write over second set next time
                end
                1: begin
                    data[addr_i][0] <= data_i;
                    tag[addr_i][0] <=  { 2'b11, tag_i[22:0] };
                    lru[addr_i] <= 2;
                end
                2: begin
                    data[addr_i][1] <= data_i;
                    tag[addr_i][1] <=  { 2'b11, tag_i[22:0] };
                    lru[addr_i] <= 1;
                end
            endcase
        end


    end
end


// Read Data
// TODO: tag_o=? data_o=? hit_o=?
always@* begin
        if (tag_i[22:0] == tag[addr_i][0][22:0] && tag[addr_i][0][24] == 1) begin
            hit_o <= 1;
            data_o <= data[addr_i][0];
            tag_o <= {2'b10 , tag[addr_i][0][22:0]};
            lru[addr_i] <= 2;
        end
        else if (tag_i[22:0] == tag[addr_i][1][22:0] && tag[addr_i][1][24] == 1) begin
            hit_o <= 1;
            data_o <= data[addr_i][1];
            tag_o <= {2'b10 ,tag[addr_i][1][22:0]};
            lru[addr_i] <= 1;
        end

        //miss : 根據lru 決定allocate哪一個entry並回傳(給controller write back)
        else begin
            hit_o <= 0;
            data_o <= data[addr_i][lru[addr_i] - 1];
            tag_o <= tag[addr_i][lru[addr_i] - 1];
        end
end

endmodule