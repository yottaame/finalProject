module final(    
    output wire [7:0] DATA_R,
    output wire [7:0] DATA_G,
    output wire [7:0] DATA_B,
    output wire [2:0] cnt,
    output wire [2:0] gun,  // 对应 level_1 的 save
    output wire [6:0] seg,  // 七段顯示器輸出
    output wire [3:0] an,   // 4 個顯示器的掃描控制
	 output reg en,
    input walk,
    input AD,
    input WS,
    input [2:0] level,
    input in,
    input start,
    input CLK,
    input RST
);
	 assign in_r=in;
	 wire next_out;
	 initial begin
		en=1'b1;
	 end
    parameter load_1_0 = 8'b11111111;
    parameter load_1_1 = 8'b11111111;
    parameter load_1_2 = 8'b11111111;
    parameter load_1_3 = 8'b11111110;
    parameter load_1_4 = 8'b11111111;
    parameter load_1_5 = 8'b11111111;
    parameter load_1_6 = 8'b11111111;
    parameter load_1_7 = 8'b11111111;

    parameter load_2_0 = 8'b11111111;
    parameter load_2_1 = 8'b11111111;
    parameter load_2_2 = 8'b11111110;
    parameter load_2_3 = 8'b11111100;
    parameter load_2_4 = 8'b11111110;
    parameter load_2_5 = 8'b11111111;
    parameter load_2_6 = 8'b11111111;
    parameter load_2_7 = 8'b11111111;

    parameter load_3_0 = 8'b11111111;
    parameter load_3_1 = 8'b11111110;
    parameter load_3_2 = 8'b11111100;
    parameter load_3_3 = 8'b11111000;
    parameter load_3_4 = 8'b11111100;
    parameter load_3_5 = 8'b11111110;
    parameter load_3_6 = 8'b11111111;
    parameter load_3_7 = 8'b11111111;

    parameter load_4_0 = 8'b11111111;
    parameter load_4_1 = 8'b11111101;
    parameter load_4_2 = 8'b11111001;
    parameter load_4_3 = 8'b11110000;
    parameter load_4_4 = 8'b11111001;
    parameter load_4_5 = 8'b11111101;
    parameter load_4_6 = 8'b11111111;
    parameter load_4_7 = 8'b11111111;

    parameter load_5_0 = 8'b11111111;
    parameter load_5_1 = 8'b11111011;
    parameter load_5_2 = 8'b11110011;
    parameter load_5_3 = 8'b11100000;
    parameter load_5_4 = 8'b11110011;
    parameter load_5_5 = 8'b11111011;
    parameter load_5_6 = 8'b11111111;
    parameter load_5_7 = 8'b11111111;

    parameter load_6_0 = 8'b11111111;
    parameter load_6_1 = 8'b11110111;
    parameter load_6_2 = 8'b11101111;
    parameter load_6_3 = 8'b11000000;
    parameter load_6_4 = 8'b11101111;
    parameter load_6_5 = 8'b11110111;
    parameter load_6_6 = 8'b11111111;
    parameter load_6_7 = 8'b11111111;

    parameter load_7_0 = 8'b11111111;
    parameter load_7_1 = 8'b11101111;
    parameter load_7_2 = 8'b11011111;
    parameter load_7_3 = 8'b10000001;
    parameter load_7_4 = 8'b11011111;
    parameter load_7_5 = 8'b11101111;
    parameter load_7_6 = 8'b11111111;
    parameter load_7_7 = 8'b11111111;

    parameter off_0 = 8'b11101111;
    parameter off_1 = 8'b11010111;
    parameter off_2 = 8'b11101111;
    parameter off_3 = 8'b11110111;
    parameter off_4 = 8'b11000011;
    parameter off_5 = 8'b11110101;
    parameter off_6 = 8'b11000011;
    parameter off_7 = 8'b11110101;

    parameter on_0 = 8'b11101111;
    parameter on_1 = 8'b11010111;
    parameter on_2 = 8'b11101111;
    parameter on_3 = 8'b11111111;
    parameter on_4 = 8'b11000111;
    parameter on_5 = 8'b11110111;
    parameter on_6 = 8'b11001111;
    parameter on_7 = 8'b11111111;
	 
	 parameter lv2_0 = 8'b11000001;
    parameter lv2_1 = 8'b11011111;
    parameter lv2_2 = 8'b11101111;
    parameter lv2_3 = 8'b11011111;
    parameter lv2_4 = 8'b11101111;
    parameter lv2_5 = 8'b11000101;
    parameter lv2_6 = 8'b11010101;
    parameter lv2_7 = 8'b11010001;
	 
	 clock #(12500000) clk_divider_2Hz (
        .CLK(CLK),
        .RST(RST),
        .CLK_div(clk_2Hz)
    );
	 tim A1 (
      .clk(CLK),
      .rst(RST),
      .an(an),
      .seg(seg)
    );
	 save A0 (
      .in(in_r),
      .RST(RST),
		.CLK(CLK),
		.save(gun),  // 中间连接信号
		.harm(harm),
		.beat(beat_r)
	);
	 level_1 A2 (
		.next_out(next_out),
		.DATA_R(DATA_R),
		.DATA_G(DATA_G),
		.DATA_B(DATA_B),
		.cnt(cnt),
		.walk(walk),
		.AD(AD),
		.WS(WS),
		.in(in),
		.start(start),
		.CLK(CLK),
		.RST(RST)
	 );

endmodule


