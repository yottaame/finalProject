module tim (
    input clk,                // 系統時鐘
    input rst,                // 重置信號
    output reg [6:0] seg,     // 七段顯示器輸出 (7-bit)
    output reg [3:0] an       // 4個顯示器的掃描控制 (低電平有效)
);

    // 段碼資料表 (共陽極，1表示熄滅，0表示點亮)
    reg [6:0] digit_table [0:9];
    initial begin
        digit_table[0] = 7'b1000000; // 0
        digit_table[1] = 7'b1111001; // 1
        digit_table[2] = 7'b0100100; // 2
        digit_table[3] = 7'b0110000; // 3
        digit_table[4] = 7'b0011001; // 4
        digit_table[5] = 7'b0010010; // 5
        digit_table[6] = 7'b0000010; // 6
        digit_table[7] = 7'b1111000; // 7
        digit_table[8] = 7'b0000000; // 8
        digit_table[9] = 7'b0010000; // 9
    end

    // 分鐘與秒數
    reg [2:0] min = 3'd6;       // 初始分鐘設為6
    reg [5:0] sec = 6'd0;       // 初始秒設為0

    // 掃描顯示器計數器
    reg [1:0] scan_cnt = 2'b00;

    // 時鐘分頻信號
    wire clk_1Hz;               // 1Hz 時鐘，用於倒計時
    wire clk_1kHz;              // 1kHz 時鐘，用於掃描邏輯

    // 分頻模組實例化
    clock #(25000000) clk_divider_1Hz(clk, rst, clk_1Hz);  // 1Hz 時鐘分頻
    clock #(25000)    clk_divider_1kHz(clk, rst, clk_1kHz); // 1kHz 時鐘分頻

    // 掃描邏輯
    always @(posedge clk_1kHz or posedge rst) begin
        if (rst) begin
            scan_cnt <= 2'b00;     // 重置掃描計數器
            an <= 4'b1111;         // 關閉所有顯示器
            seg <= 7'b1111111;     // 熄滅所有段
        end else begin
            // 每次掃描切換至下一個顯示器
            scan_cnt <= scan_cnt + 1;

            // 動態掃描顯示器
            case (scan_cnt)
                2'd0: begin
                    an <= 4'b1110; // 第一個顯示器 (秒的個位)
                    seg <= digit_table[sec % 10];
                end
                2'd1: begin
                    an <= 4'b1101; // 第二個顯示器 (秒的十位)
                    seg <= digit_table[sec / 10];
                end
                2'd2: begin
                    an <= 4'b1011; // 第三個顯示器 (分的個位)
                    seg <= digit_table[min % 10];
                end
                2'd3: begin
                    an <= 4'b0111; // 第四個顯示器 (分的十位)
                    seg <= digit_table[min / 10];
                end
            endcase
        end
    end

    // 倒計時邏輯
    always @(posedge clk_1Hz or posedge rst) begin
        if (rst) begin
            min <= 3'd6;
            sec <= 6'd0;
        end else begin
            if (sec == 0) begin
                if (min > 0) begin
                    min <= min - 1;
                    sec <= 6'd58; // 秒數回到59
                end
            end else begin
                sec <= sec - 2;
            end
        end
    end
endmodule
