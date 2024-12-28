module level_1 (
    output reg  next_out,
	 output reg  [7:0] DATA_R,
    output reg  [7:0] DATA_G,
    output reg  [7:0] DATA_B,
    output reg  [2:0] cnt,//8X8LED S2~S0
	 input walk,
	 input WS,
    input AD,
	 input in,
	 input start,
    input CLK,
    input RST	// 重置信號
);
	
	 wire harm;
    wire clk_1Hz;
    wire clk_1kHz;
	 wire beat_r;
	 wire save;
	 reg  beat;
	 reg [1:0]mode;
	 reg [2:0]player;
	 reg [4:0]p_r;
	 reg [1:0]point;
	 reg [2:0]state;
	 reg image;
	 reg level;
    reg down;
	 

    // 初始化
    initial begin
		  beat=1'b0;
		  image=1'b0;
		  level=1'b0;
	     down = 1'b1;        //上下位置判定
        cnt = 3'b000;		 //掃描
		  player = 3'b000;    //左右位置判定
		  p_r = 5'b00000;     //分數暫存檔
		  mode = 2'b00;      //小關卡
		  point = 2'b00;      //總分
		  state = 3'b000;     //子彈
        DATA_R = 8'b11111111;
        DATA_G = 8'b11111111;
        DATA_B = 8'b11111111;
    end	 
	 
	 save A0 (
      .in(in),
      .RST(RST),
		.CLK(CLK),
		.save(save),  // 中间连接信号
		.harm(harm),
		.beat(beat_r)
	);

    tim A1 (
        .clk(CLK),
        .rst(RST),
        .an(an),
        .seg(seg)
    );

    // 時間參數輸入
    clock #(25000000) clk_divider_1Hz (
        .CLK(CLK),
        .RST(RST),
        .CLK_div(clk_1Hz)
    );
    clock #(25000) clk_divider_1kHz (
        .CLK(CLK),
        .RST(RST),
        .CLK_div(clk_1kHz)
    );

	 
    // LED顯示初始化
	 //*第一關設定皆為1滴血
	 
	 //game not start
	 reg [7:0] level_0_0 = 8'b00000000;
    reg [7:0] level_0_1 = 8'b00000000;
    reg [7:0] level_0_2 = 8'b00000000;
    reg [7:0] level_0_3 = 8'b00000000;
    reg [7:0] level_0_4 = 8'b00000000;
    reg [7:0] level_0_5 = 8'b00000000;
    reg [7:0] level_0_6 = 8'b00000000;
    reg [7:0] level_0_7 = 8'b00000000;
	 
	 reg [7:0] level_0rb_0 = 8'b11111111;
    reg [7:0] level_0rb_1 = 8'b11111111;
    reg [7:0] level_0rb_2 = 8'b11111111;
    reg [7:0] level_0rb_3 = 8'b11111111;
    reg [7:0] level_0rb_4 = 8'b11111111;
    reg [7:0] level_0rb_5 = 8'b11111111;
    reg [7:0] level_0rb_6 = 8'b11111111;
    reg [7:0] level_0rb_7 = 8'b11111111;
	 
	 //monster level 1 mode 1 color R point 10
    reg [7:0] level_11_0m = 8'b11110111;
    reg [7:0] level_11_1m = 8'b11101101;
    reg [7:0] level_11_2m = 8'b11011111;
    reg [7:0] level_11_3m = 8'b11110111;
    reg [7:0] level_11_4m = 8'b11111101;
    reg [7:0] level_11_5m = 8'b11101111;
    reg [7:0] level_11_6m = 8'b11111011;
    reg [7:0] level_11_7m = 8'b11110110;
	 
	 //monster level 1 mode 2 color R point 10
    reg [7:0] level_12_0m = 8'b11111101;
    reg [7:0] level_12_1m = 8'b11101111;
    reg [7:0] level_12_2m = 8'b11110111;
    reg [7:0] level_12_3m = 8'b11111101;
    reg [7:0] level_12_4m = 8'b11011011;
    reg [7:0] level_12_5m = 8'b11111110;
    reg [7:0] level_12_6m = 8'b11101111;
    reg [7:0] level_12_7m = 8'b11011110;
	 
	 //monster level 1 mode 3 color R point 10 
	 reg [7:0] level_13_0m = 8'b11011111;
    reg [7:0] level_13_1m = 8'b11111110;
    reg [7:0] level_13_2m = 8'b11011111;
    reg [7:0] level_13_3m = 8'b11111110;
    reg [7:0] level_13_4m = 8'b11111011;
    reg [7:0] level_13_5m = 8'b11110110;
    reg [7:0] level_13_6m = 8'b11111101;
    reg [7:0] level_13_7m = 8'b11101110;
	 
	 //player color B
	 reg [7:0] tmp_data   = 8'b11111111;
	 reg [7:0] level_1_0p = 8'b11111111;//3'b100
    reg [7:0] level_1_1p = 8'b11111111;//3'b101
    reg [7:0] level_1_2p = 8'b11111111;//3'b110
    reg [7:0] level_1_3p = 8'b11111111;//3'b111
    reg [7:0] level_1_4p = 8'b01111111;//3'b000
    reg [7:0] level_1_5p = 8'b11111111;//3'b001
    reg [7:0] level_1_6p = 8'b11111111;//3'b010
    reg [7:0] level_1_7p = 8'b11111111;//3'b011
	 
	 //shooting color G
	 reg [7:0] level_1_0s = 8'b11111111;
    reg [7:0] level_1_1s = 8'b11111111;
    reg [7:0] level_1_2s = 8'b11111111;
    reg [7:0] level_1_3s = 8'b11111111;
    reg [7:0] level_1_4s = 8'b11111111;
    reg [7:0] level_1_5s = 8'b11111111;
    reg [7:0] level_1_6s = 8'b11111111;
    reg [7:0] level_1_7s = 8'b11111111;
	 
    parameter lose_sad_0 = 8'b11111111;
    parameter lose_sad_1 = 8'b11110111;
    parameter lose_sad_2 = 8'b10110111;
    parameter lose_sad_3 = 8'b11011111;
    parameter lose_sad_4 = 8'b11011111;
    parameter lose_sad_5 = 8'b10110111;
    parameter lose_sad_6 = 8'b11110111;
    parameter lose_sad_7 = 8'b11111111;
	 
	 parameter lose_F_0 = 8'b11111111;
    parameter lose_F_1 = 8'b11111111;
    parameter lose_F_2 = 8'b11000001;
    parameter lose_F_3 = 8'b11110101;
    parameter lose_F_4 = 8'b11110101;
    parameter lose_F_5 = 8'b11111101;
    parameter lose_F_6 = 8'b11111111;
    parameter lose_F_7 = 8'b11111111;

    parameter win_smile_0 = 8'b11110111;
    parameter win_smile_1 = 8'b11111011;
    parameter win_smile_2 = 8'b11010111;
    parameter win_smile_3 = 8'b10111111;
    parameter win_smile_4 = 8'b10111111;
    parameter win_smile_5 = 8'b11010111;
    parameter win_smile_6 = 8'b11111011;
    parameter win_smile_7 = 8'b11110111;
	 
	 parameter win_b_0 = 8'b11111111;
    parameter win_b_1 = 8'b11111111;
    parameter win_b_2 = 8'b10000011;
    parameter win_b_3 = 8'b10000111;
    parameter win_b_4 = 8'b10000111;
    parameter win_b_5 = 8'b10000111;
    parameter win_b_6 = 8'b11111111;
    parameter win_b_7 = 8'b11111111;

    parameter lv1_0 = 8'b11000001;
    parameter lv1_1 = 8'b11011111;
    parameter lv1_2 = 8'b11101111;
    parameter lv1_3 = 8'b11011111;
    parameter lv1_4 = 8'b11101111;
    parameter lv1_5 = 8'b11000101;
    parameter lv1_6 = 8'b11000001;
    parameter lv1_7 = 8'b11011111;
	 
	 //分數
	 always @(posedge clk_1Hz) begin
		  if(p_r==5'b01010)begin
				mode<=mode+1'b1;
				point <= point+1'b1;
		  end
		  else if(p_r==5'b10100)begin
				mode<=mode+1'b1;
				point <= point+1'b1;
		  end
		  else if(p_r==5'b11110)begin
				point <= point+1'b1;
		  end
	 end
	 
	 //顯示切換
	 always @(posedge clk_1Hz or negedge level) begin
		  if(~level)begin
		      level<=~level;
		  end
	 	  else if(point==2'b11)begin
		      image<=~image;
		  end
	 end

	 //reg<=wire? beat
	 
	 // player LED顯示 移動邏輯
	 always @(posedge clk_1Hz or posedge walk) begin
        if (walk) begin 					
				if (WS) begin
				//上下移動
                    if(~down)begin //上轉下
                        case(player)
                            3'b000:level_1_4p <= 8'b01111111;
                            3'b001:level_1_5p <= 8'b01111111;
									 3'b010:level_1_6p <= 8'b01111111;
									 3'b011:level_1_7p <= 8'b01111111;
									 3'b100:level_1_0p <= 8'b01111111;
									 3'b101:level_1_1p <= 8'b01111111;
									 3'b110:level_1_2p <= 8'b01111111;
									 3'b111:level_1_3p <= 8'b01111111;
                        endcase
                        down<=1'b1;
                    end
				end
				else if (~WS) begin
						 if(down)begin//下轉上
                        case(player)
                            3'b000:level_1_4p <= 8'b10111111;
                            3'b001:level_1_5p <= 8'b10111111;
									 3'b010:level_1_6p <= 8'b10111111;
									 3'b011:level_1_7p <= 8'b10111111;
									 3'b100:level_1_0p <= 8'b10111111;
									 3'b101:level_1_1p <= 8'b10111111;
									 3'b110:level_1_2p <= 8'b10111111;
									 3'b111:level_1_3p <= 8'b10111111;
                        endcase
                        down<=1'b0;						 
						 end
            end 
				else if (AD) begin
            //左右移動
					case (player)
						3'b000:  begin
									tmp_data <= level_1_5p ; 
									level_1_5p <= level_1_4p ; 
									level_1_4p <= tmp_data ; 
									player<=player+1;          //4到5
									end
						3'b001:  begin
									tmp_data <= level_1_6p ;
					 	         level_1_6p <= level_1_5p ;
									level_1_5p <= tmp_data;
									player<=player+1;         //5到6
									end
						3'b010:  begin
									tmp_data <= level_1_7p ;
					 	         level_1_7p <= level_1_6p ;
									level_1_6p <= tmp_data;
									player<=3'b011;          //6到7
									end
						3'b011:  player<=3'b011;          //7
						3'b100:  begin
									tmp_data <= level_1_1p ;
					 	         level_1_1p <= level_1_0p ;
									level_1_0p <= tmp_data;
									player<=player+1;			//0到1
									end
						3'b101:  begin
									tmp_data <= level_1_2p ;
					 	         level_1_2p <= level_1_1p ;
									level_1_1p <= tmp_data;
									player<=player+1;			//1到2
									end
						3'b110:  begin
									tmp_data <= level_1_3p ;
					 	         level_1_3p <= level_1_2p ;
									level_1_2p <= tmp_data;
									player<=player+1;			//2到3
									end
						3'b111:  begin
									tmp_data <= level_1_4p ;
					 	         level_1_4p <= level_1_3p ;
									level_1_3p <= tmp_data;
									player<=3'b000;			//3到4
									end
					endcase
            end 
				else if (~AD) begin
					case (player)
						3'b000:  begin
									tmp_data <= level_1_3p ;
					 	         level_1_3p <= level_1_4p ;
									level_1_4p <= tmp_data;
									player<=3'b111;			//4到3
									end
						3'b001:  begin
									tmp_data <= level_1_4p ;
					 	         level_1_4p <= level_1_5p ;
									level_1_5p <= tmp_data;
									player<=3'b000;			//5到4
									end
						3'b010:  begin
									tmp_data <= level_1_5p ;
					 	         level_1_5p <= level_1_6p ;
									level_1_6p <= tmp_data;
									player<=3'b001;			//6到5
									end
						3'b011:  begin
									tmp_data <= level_1_0p ;
					 	         level_1_0p <= level_1_1p ;
									level_1_1p <= tmp_data;
									player<=3'b010;			//7到6
									end
						3'b100:  player<=3'b100;
						3'b101:  begin
									tmp_data <= level_1_1p ;
					 	         level_1_1p <= level_1_0p ;
									level_1_0p <= tmp_data;
									player<=3'b100;			//1到0
									end
						3'b110:  begin
									tmp_data <= level_1_2p ;
					 	         level_1_2p <= level_1_1p ;
									level_1_1p <= tmp_data;
									player<=3'b101;			//2到1
									end
						3'b111:  begin
									tmp_data <= level_1_2p ;
					 	         level_1_2p <= level_1_3p ;
									level_1_3p <= tmp_data;
									player<=3'b110;			//3到2
									end
					endcase
            end
        end
	 end
	 
	 //發射顯示
    always @(posedge clk_1Hz or negedge beat) begin
		if(beat==1'b0)begin
			beat<=beat_r;
		end
		else begin
			if(~down)begin
				case(mode)
					2'b00:
					begin
						case (player)
							3'b000:  
							begin
								case(state)
									3'b000:	begin
												level_1_4s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_4s <= 8'b11101111;
												state<=3'b010;
												end
								   3'b010:  begin
												level_1_4s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_4s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  if(level_11_4m==8'b11111101)begin
												level_1_4s  <= 8'b11111111;
												level_11_4m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_4s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_4s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_4s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b001:  
							begin
								case(state)
									3'b000:	begin
												level_1_5s  <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	if(level_11_5m==8'b11101111)begin
												level_1_5s  <= 8'b11111111;
												level_11_5m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_5s  <= 8'b11101111;
												state<=3'b010;
												end
								   3'b010:  begin
												level_1_5s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_5s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_5s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_5s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_5s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b010:  
							begin
								case(state)
									3'b000:	begin
												level_1_6s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_6s <= 8'b11101111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_6s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:	if(level_11_6m==8'b11111011)begin
												level_1_6s <= 8'b11111111;
												level_11_6m<= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_6s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_6s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_6s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_6s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b011:
							begin
								case(state)
									3'b000:	begin
													level_1_7s <= 8'b11011111;
													state<=3'b001;
												end													
									3'b001:	begin
													level_1_7s <=8'b11101111;
													state<=3'b010;
												end
									3'b010:	if(level_11_7m==8'b11110110)begin
													level_1_7s <=8'b11111111;
													level_11_7m<=8'b11111110;
													p_r <= p_r+1'b1;
													state<=3'b000;
													beat<=1'b0;
												end
												else begin
													level_1_7s <= 8'b11110111;
													state<=3'b011;
												end
									3'b011:  begin
												level_1_7s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_7s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  if(level_11_7m==8'b11111110)begin
												level_1_7s <= 8'b11111111;
												level_11_7m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_7s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_7s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b100:  
							begin
								case(state)
									3'b000:	begin
												level_1_0s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_0s <= 8'b11101111;
												state<=3'b010;
												end
									3'b010:	if(level_11_0m==8'b11110111)begin
												level_1_0s <=  8'b11111111;
												level_11_0m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_0s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:  begin
												level_1_0s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_0s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_0s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_0s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b101:
							begin
								case(state)
									3'b000:	begin
												level_1_1s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	if(level_11_1m==8'b11101101)begin
												level_1_1s <= 8'b11111111;
												level_11_1m <=8'b11111101;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_1s <= 8'b11101111;
												state<=3'b010;
												end
									3'b010:  begin
												level_1_1s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:  begin
												level_1_1s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  if(level_11_1m==8'b11111101)begin
												level_1_1s <= 8'b11111111;
												level_11_1m <=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_1s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_1s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:	begin
												level_1_1s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b110:
							begin
								case(state)
									3'b000:	if(level_11_2m==8'b11011111)begin
												level_11_2m <=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else if(level_11_2m==8'b11111111)begin
												level_1_2s <= 8'b11011111;
												state<=3'b001;												
												end
									3'b001:	begin
												level_1_2s <= 8'b11101111;
												state<=3'b010;												
												end
									3'b010:	begin
												level_1_2s <= 8'b11110111;
												state<=3'b011;												
												end
									3'b011:	begin
												level_1_2s <= 8'b11111011;
												state<=3'b100;												
												end
									3'b100:	begin
												level_1_2s <= 8'b11111101;
												state<=3'b101;												
												end
									3'b101:	begin
												level_1_2s <= 8'b11111110;
												state<=3'b110;												
												end
									3'b110:	begin
												level_1_2s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b111:
							begin
								case(state)
									3'b000:	begin
												level_1_3s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_3s <= 8'b11101111;
												state<=3'b010;
												end
									3'b010:	if(level_11_3m==8'b11110111)begin
												level_1_3s  <= 8'b11111111;
												level_11_3m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else if(level_11_3m==8'b11111111)begin
												level_1_3s <= 8'b11110111;
												state<=3'b011;												
												end
									3'b011:	begin
												level_1_3s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:	begin
												level_1_3s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:	begin
												level_1_3s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:	begin
												level_1_3s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
						endcase
					end
					2'b01:
					begin
						case (player)
							3'b000:  
							begin
								case(state)
									3'b000:	if(level_12_4m==8'b11011011)begin 
												level_1_4s  <= 8'b11111111;
												level_12_4m <= 8'b11111011;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_4s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_4s <= 8'b11101111;
												state<=3'b010;
												end
								   3'b010:  begin
												level_1_4s <=  8'b11110111;
												state<=3'b011;
												end
									3'b011:	if(level_12_4m==8'b11111011)begin 
												level_1_4s  <= 8'b11111111;
												level_12_4m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_4s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_4s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_4s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_4s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b001:  
							begin
								case(state) 
									3'b000:	begin
												level_1_5s  <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_5s <= 8'b11101111;
												state<=3'b010;
												end
								   3'b010:  begin
												level_1_5s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_5s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_5s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  if(level_12_5m ==8'b11111110)begin
												level_1_5s <= 8'b11111111;
												level_12_5m <=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_5s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_5s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b010:  
							begin
								case(state) 
									3'b000:	begin
												level_1_6s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	if(level_12_6m==8'b11101111)begin
												level_1_6s <=   8'b11111111;
												level_12_6m<=   8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_6s <=   8'b11101111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_6s <=   8'b11110111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_6s <=   8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_6s <=   8'b11111101;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_6s <=   8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_6s <=   8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b011:
							begin
								case(state) 
									3'b000:	if(level_12_7m==8'b11011110)begin
												level_1_7s <=   8'b11111111;
												level_12_7m<=   8'b11111110;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_7s <=   8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
													level_1_7s <=8'b11101111;
													state<=3'b010;
												end
									3'b010:	begin
													level_1_7s <=8'b11110111;
													state<=3'b011;
												end
									3'b011:  begin
												level_1_7s <=   8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_7s <=   8'b11111101;
												state<=3'b101;
												end
									3'b101:  if(level_12_7m==8'b11111110)begin
												level_1_7s <= 8'b11111111;
												level_12_7m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_7s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_7s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b100:  
							begin
								case(state) 
									3'b000:	begin
												level_1_0s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_0s <= 8'b11101111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_0s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:  begin
												level_1_0s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  if(level_12_0m==8'b11111101)begin
												level_1_0s  <= 8'b11111111;
												level_12_0m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_0s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_0s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_0s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b101:
							begin
								case(state) 
									3'b000:	begin
												level_1_1s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	if(level_12_1m==8'b11101111)begin
												level_1_1s <= 8'b11111111;
												level_12_1m <=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_1s <= 8'b11101111;
												state<=3'b010;
												end
									3'b010:  begin
												level_1_1s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:  begin
												level_1_1s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_1s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_1s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:	begin
												level_1_1s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b110:
							begin
								case(state) 
									3'b000:	begin
												level_1_2s <= 8'b11011111;
												state<=3'b001;												
												end
									3'b001:	begin
												level_1_2s <= 8'b11101111;
												state<=3'b010;												
												end
									3'b010:	if(level_12_2m==8'b11110111)begin
												level_1_2s  <= 8'b11111111;
												level_12_2m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_2s <= 8'b11110111;
												state<=3'b011;												
												end
									3'b011:	begin
												level_1_2s <= 8'b11111011;
												state<=3'b100;												
												end
									3'b100:	begin
												level_1_2s <= 8'b11111101;
												state<=3'b101;												
												end
									3'b101:	begin
												level_1_2s <= 8'b11111110;
												state<=3'b110;												
												end
									3'b110:	begin
												level_1_2s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b111:
							begin
								case(state) 
									3'b000:	begin
												level_1_3s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_3s <= 8'b11101111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_3s <= 8'b11110111;
												state<=3'b011;												
												end
									3'b011:	begin
												level_1_3s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:	if(level_12_3m==8'b11111101)begin
												level_1_3s <=8'b11111111;
												level_12_3m<=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_3s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:	begin
												level_1_3s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:	begin
												level_1_3s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
						 endcase
					end
	 
	 				2'b10:
					begin
						case (player)
							3'b000:  
							begin
								case(state) 
									3'b000:	begin
												level_1_4s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_4s <= 8'b11101111;
												state<=3'b010;
												end
								   3'b010:  begin
												level_1_4s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:	if(level_13_4m==8'b11111011)begin
												level_1_4s  <= 8'b11111111;
												level_13_4m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_4s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_4s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_4s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_4s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b001:  
							begin  
								case(state)
									3'b000:	begin
												level_1_5s  <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_5s  <= 8'b11101111;
												state<=3'b010;
												end
								   3'b010:  if(level_13_5m==8'b11110110)begin
												level_1_5s  <= 8'b11111111;
												level_13_5m <= 8'b11111110;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_5s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_5s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_5s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  if(level_13_5m==8'b11111110)begin
												level_1_5s  <= 8'b11111111;
												level_13_5m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_5s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_5s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b010:  
							begin 
								case(state)
									3'b000:	begin
												level_1_6s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_6s <= 8'b11101111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_6s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_6s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  if(level_13_6m==8'b11111101)begin
												level_1_6s <= 8'b11111111;
												level_13_6m<= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_6s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_6s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_6s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b011:
							begin
								case(state) 
									3'b000:	begin
													level_1_7s <= 8'b11011111;
													state<=3'b001;
												end													
									3'b001:	if(level_13_7m== 8'b11101110)begin
													level_1_7s <= 8'b11111111;
													level_13_7m<= 8'b11111110;
													p_r <= p_r+1'b1;
													state<=3'b000;
													beat<=1'b0;
												end
												else begin
													level_1_7s <=8'b11101111;
													state<=3'b010;
												end
									3'b010:	begin
													level_1_7s <= 8'b11110111;
													state<=3'b011;
												end
									3'b011:  begin
												level_1_7s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_7s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  if(level_13_7m==8'b11111110)begin
												level_1_7s <= 8'b11111111;
												level_13_7m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_7s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_7s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b100:  
							begin
								case(state) 
									3'b000:	if(level_13_0m==8'b11011111)begin
												level_1_0s <=  8'b11111111;
												level_13_0m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_0s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_0s <= 8'b11101111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_0s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:  begin
												level_1_0s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_0s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_0s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_0s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b101:
							begin
								case(state) 
									3'b000:	begin
												level_1_1s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_1s <= 8'b11101111;
												state<=3'b010;
												end
									3'b010:  begin
												level_1_1s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:  begin
												level_1_1s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_1s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  if(level_13_1m==8'b11111110)begin
												level_1_1s <= 8'b11111111;
												level_13_1m <=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_1s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:	begin
												level_1_1s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b110:
							begin
								case(state) 
									3'b000:	if(level_13_2m==8'b11011111)begin
												level_1_2s <=  8'b11111111;
												level_13_2m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_2s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_2s <= 8'b11101111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_2s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:  begin
												level_1_2s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_2s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_2s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_2s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b111:
							begin
								case(state) 
									3'b000:	begin
												level_1_3s <= 8'b11011111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_3s <= 8'b11101111;
												state<=3'b010;
												end
									3'b010:  begin
												level_1_3s <= 8'b11110111;
												state<=3'b011;
												end
									3'b011:  begin
												level_1_3s <= 8'b11111011;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_3s <= 8'b11111101;
												state<=3'b101;
												end
									3'b101:  if(level_13_3m==8'b11111110)begin
												level_1_3s <= 8'b11111111;
												level_13_3m <=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_3s <= 8'b11111110;
												state<=3'b110;
												end
									3'b110:	begin
												level_1_3s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
						endcase
					end
				endcase
			end
			else if(down)begin
				case(mode)
					2'b00:
					begin
						case (player)
							3'b000:  
							begin
								case(state)
									3'b000:	begin
												level_1_4s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_4s <= 8'b11011111;
												state<=3'b010;
												end
								   3'b010:  begin
												level_1_4s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_4s <= 8'b11110111;
												state<=3'b100;
												end
									3'b100:	begin
												level_1_4s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  if(level_11_4m==8'b11111101)begin
												level_1_4s  <= 8'b11111111;
												level_11_4m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_4s <= 8'b11111101;
												state<=3'b101;
												end
									3'b110:  begin
												level_1_4s <= 8'b11111110;
												state<=3'b110;
												end
									3'b111:  begin
												level_1_4s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b001:  
							begin
								case(state)
									3'b000:	begin
												level_1_5s  <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_5s  <= 8'b110111111;
												state<=3'b001;
												end
									3'b010:	if(level_11_5m==8'b11101111)begin
												level_1_5s  <= 8'b11111111;
												level_11_5m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_5s  <= 8'b11101111;
												state<=3'b011;
												end
								   3'b011:  begin
												level_1_5s <= 8'b11110111;
												state<=3'b100;
												end
									3'b100:	begin
												level_1_5s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_5s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_5s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_5s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b010:  
							begin
								case(state)
									3'b000:	begin
												level_1_6s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_6s <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_6s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_6s <= 8'b11110111;
												state<=3'b100;
												end
									3'b100:	if(level_11_6m==8'b11111011)begin
												level_1_6s <= 8'b11111111;
												level_11_6m<= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_6s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_6s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_6s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_6s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b011:
							begin
								case(state)
									3'b000:	begin
													level_1_7s <= 8'b10111111;
													state<=3'b001;
												end													
									3'b001:	begin
													level_1_7s <= 8'b11011111;
													state<=3'b010;
												end
									3'b010:	begin
													level_1_7s <= 8'b11101111;
													state<=3'b011;
												end
									3'b011:	if(level_11_7m== 8'b11110110)begin
													level_1_7s <=8'b11111111;
													level_11_7m<=8'b11111110;
													p_r <= p_r+1'b1;
													state<=3'b000;
													beat<=1'b0;
												end
												else begin
													level_1_7s <= 8'b11110111;
													state<=3'b100;
												end
									3'b100:  begin
												level_1_7s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_7s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  if(level_11_7m==8'b11111110)begin
												level_1_7s <= 8'b11111111;
												level_11_7m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_7s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_7s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b100:  
							begin
								case(state)
									3'b000:	begin
												level_1_0s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_0s <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_0s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:	if(level_11_0m==8'b11110111)begin
												level_1_0s <=  8'b11111111;
												level_11_0m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_0s <= 8'b11110111;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_0s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_0s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_0s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_0s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b101:
							begin
								case(state)
									3'b000:	begin
												level_1_1s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_1s <= 8'b110111111;
												state<=3'b010;
												end
									3'b010:	if(level_11_1m==8'b11101101)begin
												level_1_1s <= 8'b11111111;
												level_11_1m <=8'b11111101;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_1s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:  begin
												level_1_1s <= 8'b11110111;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_1s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  if(level_11_1m==8'b11111101)begin
												level_1_1s <= 8'b11111111;
												level_11_1m <=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_1s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_1s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:	begin
												level_1_1s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b110:
							begin
								case(state)
									3'b000:	begin
												level_1_2s <= 8'b10111111;
												state<=3'b001;												
												end
									3'b001:	if(level_11_2m==8'b11011111)begin
												level_11_2m <=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else if(level_11_2m==8'b11111111)begin
												level_1_2s <= 8'b11011111;
												state<=3'b010;												
												end
									3'b010:	begin
												level_1_2s <= 8'b11101111;
												state<=3'b011;												
												end
									3'b011:	begin
												level_1_2s <= 8'b11110111;
												state<=3'b100;												
												end
									3'b100:	begin
												level_1_2s <= 8'b11111011;
												state<=3'b101;												
												end
									3'b101:	begin
												level_1_2s <= 8'b11111101;
												state<=3'b110;												
												end
									3'b110:	begin
												level_1_2s <= 8'b11111110;
												state<=3'b111;												
												end
									3'b111:	begin
												level_1_2s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b111:
							begin
								case(state)
									3'b000:	begin
												level_1_3s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_3s <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_3s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:	if(level_11_3m==8'b11110111)begin
												level_1_3s  <= 8'b11111111;
												level_11_3m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else if(level_11_3m==8'b11111111)begin
												level_1_3s <= 8'b11110111;
												state<=3'b100;												
												end
									3'b100:	begin
												level_1_3s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:	begin
												level_1_3s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:	begin
												level_1_3s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:	begin
												level_1_3s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
						endcase
					end
					2'b01:
					begin
						case (player)
							3'b000:  
							begin
								case(state)
									3'b000:	begin
												level_1_4s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	if(level_12_4m==8'b11011011)begin 
												level_1_4s  <= 8'b11111111;
												level_12_4m <= 8'b11111011;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_4s <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_4s <= 8'b11101111;
												state<=3'b011;
												end
								   3'b011:  begin
												level_1_4s <=  8'b11110111;
												state<=3'b100;
												end
									3'b100:	if(level_12_4m==8'b11111011)begin 
												level_1_4s  <= 8'b11111111;
												level_12_4m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_4s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_4s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_4s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_4s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b001:  
							begin
								case(state) 
									3'b000:	begin
												level_1_5s  <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_5s <=  8'b11011111;
												state<=3'b010;
												end
								   3'b010:  begin
												level_1_5s <=  8'b11101111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_5s <=  8'b11110111;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_5s <=  8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_5s <=  8'b11111101;
												state<=3'b110;
												end
									3'b110:  if(level_12_5m ==8'b11111110)begin
												level_1_5s <= 8'b11111111;
												level_12_5m <=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_5s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_5s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b010:  
							begin
								case(state) 
									3'b000:	begin
												level_1_6s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_6s <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:	if(level_12_6m==8'b11101111)begin
												level_1_6s <=   8'b11111111;
												level_12_6m<=   8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_6s <=   8'b11101111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_6s <=   8'b11110111;
												state<=3'b100;
												end
									3'b100:	begin
												level_1_6s <=   8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_6s <=   8'b11111101;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_6s <=   8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_6s <=   8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b011:
							begin
								case(state)
									3'b000:	begin
													level_1_7s <=8'b10111111;
													state<=3'b001;
												end
									3'b001:	if(level_12_7m==8'b11011110)begin
												level_1_7s <=   8'b11111111;
												level_12_7m<=   8'b11111110;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_7s <=   8'b11011111;
												state<=3'b010;
												end
									3'b010:	begin
													level_1_7s <=8'b11101111;
													state<=3'b011;
												end
									3'b011:	begin
													level_1_7s <=8'b11110111;
													state<=3'b100;
												end
									3'b100:  begin
												level_1_7s <=   8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_7s <=   8'b11111101;
												state<=3'b110;
												end
									3'b110:  if(level_12_7m==8'b11111110)begin
												level_1_7s <= 8'b11111111;
												level_12_7m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_7s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_7s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b100:  
							begin
								case(state) 
									3'b000:	begin
												level_1_0s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_0s <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_0s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_0s <= 8'b11110111;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_0s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  if(level_12_0m==8'b11111101)begin
												level_1_0s  <= 8'b11111111;
												level_12_0m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_0s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_0s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_0s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b101:
							begin
								case(state) 
									3'b000:	begin
												level_1_1s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_1s <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:	if(level_12_1m==8'b11101111)begin
												level_1_1s <= 8'b11111111;
												level_12_1m <=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_1s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:  begin
												level_1_1s <= 8'b11110111;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_1s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_1s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_1s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:	begin
												level_1_1s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b110:
							begin
								case(state) 
									3'b000:	begin
												level_1_2s <= 8'b10111111;
												state<=3'b001;												
												end
									3'b001:	begin
												level_1_2s <= 8'b11011111;
												state<=3'b010;												
												end
									3'b010:	begin
												level_1_2s <= 8'b11101111;
												state<=3'b011;												
												end
									3'b011:	if(level_12_2m==8'b11110111)begin
												level_1_2s  <= 8'b11111111;
												level_12_2m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_2s <= 8'b11110111;
												state<=3'b100;												
												end
									3'b100:	begin
												level_1_2s <= 8'b11111011;
												state<=3'b101;												
												end
									3'b101:	begin
												level_1_2s <= 8'b11111101;
												state<=3'b110;												
												end
									3'b110:	begin
												level_1_2s <= 8'b11111110;
												state<=3'b111;												
												end
									3'b111:	begin
												level_1_2s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b111:
							begin
								case(state) 
									3'b000:	begin
												level_1_3s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_3s <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_3s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_3s <= 8'b11110111;
												state<=3'b100;												
												end
									3'b100:	begin
												level_1_3s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:	if(level_12_3m==8'b11111101)begin
												level_1_3s <=8'b11111111;
												level_12_3m<=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_3s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:	begin
												level_1_3s <= 8'b11111110;
												state<=3'b110;
												end
									3'b111:	begin
												level_1_3s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
						endcase
					end
					2'b10:
					begin
						case (player)
							3'b000:  
							begin
								case(state) 
									3'b000:	begin
												level_1_4s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_4s <= 8'b11011111;
												state<=3'b010;
												end
								   3'b010:  begin
												level_1_4s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:  begin
												level_1_4s <=  8'b11110111;
												state<=3'b100;
												end
									3'b100:	if(level_13_4m==8'b11111011)begin
												level_1_4s  <= 8'b11111111;
												level_13_4m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_4s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_4s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_4s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_4s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b001:  
							begin  
								case(state)
									3'b000:	begin
												level_1_5s  <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_5s  <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_5s  <= 8'b111011111;
												state<=3'b011;
												end
								   3'b011:  if(level_13_5m==8'b11110110)begin
												level_1_5s  <= 8'b11111111;
												level_13_5m <= 8'b11111110;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_5s <= 8'b11110111;
												state<=3'b100;
												end
									3'b100:	begin
												level_1_5s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_5s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  if(level_13_5m==8'b11111110)begin
												level_1_5s  <= 8'b11111111;
												level_13_5m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_5s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_5s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b010:  
							begin 
								case(state)
									3'b000:	begin
												level_1_6s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_6s <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_6s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_6s <= 8'b11110111;
												state<=3'b100;
												end
									3'b100:	begin
												level_1_6s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  if(level_13_6m==8'b11111101)begin
												level_1_6s <= 8'b11111111;
												level_13_6m<= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_6s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_6s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_6s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b011:
							begin
								case(state) 
									3'b000:	begin
													level_1_7s <= 8'b10111111;
													state<=3'b001;
												end
									3'b001:	begin
													level_1_7s <= 8'b110111111;
													state<=3'b010;
												end
									3'b010:	if(level_13_7m== 8'b11101110)begin
													level_1_7s <= 8'b11111111;
													level_13_7m<= 8'b11111110;
													p_r <= p_r+1'b1;
													state<=3'b000;
													beat<=1'b0;
												end
												else begin
													level_1_7s <=8'b11101111;
													state<=3'b011;
												end
									3'b011:	begin
													level_1_7s <= 8'b11110111;
													state<=3'b100;
												end
									3'b100:  begin
												level_1_7s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_7s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  if(level_13_7m==8'b11111110)begin
												level_1_7s <= 8'b11111111;
												level_13_7m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_7s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_7s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b100:  
							begin
								case(state)
									3'b000:	begin
												level_1_0s <=   8'b10111111;
												state<=3'b001;
												end
									3'b001:	if(level_13_0m==8'b11011111)begin
												level_1_0s <=  8'b11111111;
												level_13_0m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_0s <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_0s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_0s <= 8'b11110111;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_0s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_0s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_0s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_0s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b101:
							begin
								case(state) 
									3'b000:	begin
												level_1_1s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_1s <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:  begin
												level_1_1s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:  begin
												level_1_1s <= 8'b11110111;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_1s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_1s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  if(level_13_1m==8'b11111110)begin
												level_1_1s <= 8'b11111111;
												level_13_1m <=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_1s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:	begin
												level_1_1s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b110:
							begin
								case(state)
									3'b000:	begin
												level_1_2s <= 	 8'b10111111;
												state<=3'b001;
												end
									3'b001:	if(level_13_2m==8'b11011111)begin
												level_1_2s <=  8'b11111111;
												level_13_2m <= 8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_2s <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:	begin
												level_1_2s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:	begin
												level_1_2s <= 8'b11110111;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_2s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_2s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  begin
												level_1_2s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:  begin
												level_1_2s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
							3'b111:
							begin
								case(state) 
									3'b000:	begin
												level_1_3s <= 8'b10111111;
												state<=3'b001;
												end
									3'b001:	begin
												level_1_3s <= 8'b11011111;
												state<=3'b010;
												end
									3'b010:  begin
												level_1_3s <= 8'b11101111;
												state<=3'b011;
												end
									3'b011:  begin
												level_1_3s <= 8'b11110111;
												state<=3'b100;
												end
									3'b100:  begin
												level_1_3s <= 8'b11111011;
												state<=3'b101;
												end
									3'b101:  begin
												level_1_3s <= 8'b11111101;
												state<=3'b110;
												end
									3'b110:  if(level_13_3m==8'b11111110)begin
												level_1_3s <= 8'b11111111;
												level_13_3m <=8'b11111111;
												p_r <= p_r+1'b1;
												state<=3'b000;
												beat<=1'b0;
												end
												else begin
												level_1_3s <= 8'b11111110;
												state<=3'b111;
												end
									3'b111:	begin
												level_1_3s <= 8'b11111111;
												state<=3'b000;
												beat<=1'b0;
												end
								endcase
							end
						endcase
					end
				endcase
			end
		end
	 end 

	

   //LED掃描邏輯
    always @(posedge clk_1kHz or posedge RST) begin
        if (RST) begin
            cnt <= 4'b0000;
				level_11_0m <= 8'b11110111;
				level_11_1m <= 8'b11101101;
				level_11_2m <= 8'b11011111;
				level_11_3m <= 8'b11110111;
				level_11_4m <= 8'b11111101;
				level_11_5m <= 8'b11101111;
				level_11_6m <= 8'b11111011;
				level_11_7m <= 8'b11110110;
				
				tmp_data   <= 8'b11111111;
				level_1_0p <= 8'b11111111;
				level_1_1p <= 8'b11111111;
				level_1_2p <= 8'b11111111;
				level_1_3p <= 8'b11111111;
				level_1_4p <= 8'b01111111;
				level_1_5p <= 8'b11111111;
				level_1_6p <= 8'b11111111;
				level_1_7p <= 8'b11111111;
				
				level_1_0s <= 8'b11111111;
				level_1_1s <= 8'b11111111;
				level_1_2s <= 8'b11111111;
				level_1_3s <= 8'b11111111;
				level_1_4s <= 8'b11111111;
				level_1_5s <= 8'b11111111;
				level_1_6s <= 8'b11111111;
				level_1_7s <= 8'b11111111;

       end 
		  else begin
					if (cnt == 4'b0111) begin
						cnt <= 4'b0000;
					end 
					else begin
						cnt <= cnt + 1;
						if(~start)begin
						case (cnt)
                    4'b0000: begin
									  DATA_R <= level_0rb_1;
									  DATA_B<=level_0rb_1;
									  DATA_G<=level_0_1;
									  end
                    4'b0001: begin
									  DATA_R <=level_0rb_2;
									  DATA_B<=level_0rb_2;
									  DATA_G<=level_0_2;
									  end
                    4'b0010: begin
									  DATA_R <=level_0rb_3;
									  DATA_B<=level_0rb_3;
									  DATA_G<=level_0_3;
									  end
                    4'b0011: begin
									  DATA_R <=level_0rb_4;
									  DATA_B<=level_0rb_4;
									  DATA_G<=level_0_4;
									  end
                    4'b0100: begin
									  DATA_R <= level_0rb_5;
									  DATA_B<=level_0rb_5;
									  DATA_G<=level_0_5;
									  end
                    4'b0101: begin
									  DATA_R <=level_0rb_6;
									  DATA_B<=level_0rb_6;
									  DATA_G<=level_0_6;
									  end
                    4'b0110: begin
									  DATA_R <=level_0rb_7;
									  DATA_B<=level_0rb_7;
									  DATA_G<=level_0_7;
									  end
                    4'b0111: begin
									  DATA_R <=level_0rb_0;
									  DATA_B<=level_0rb_0;
									  DATA_G<=level_0_0;
									  end
                endcase
				end
						else if(start)begin
							if(p_r==5'b11110)begin
								if(~image)begin
								case (cnt)
								4'b0000: DATA_R <= win_b_0;
								4'b0001: DATA_R <= win_b_1;
								4'b0010: DATA_R <= win_b_2;
								4'b0011: DATA_R <= win_b_3;
								4'b0100: DATA_R <= win_b_4;
								4'b0101: DATA_R <= win_b_5;
								4'b0110: DATA_R <= win_b_6;
								4'b0111: DATA_R <= win_b_7;
								endcase
							end
						else if(image)begin
							case (cnt)
								4'b0000: DATA_R <= win_smile_0;
								4'b0001: DATA_R <= win_smile_1;
								4'b0010: DATA_R <= win_smile_2;
								4'b0011: DATA_R <= win_smile_3;
								4'b0100: DATA_R <= win_smile_4;
								4'b0101: DATA_R <= win_smile_5;
								4'b0110: DATA_R <= win_smile_6;
								4'b0111: DATA_R <= win_smile_7;
							endcase
						end
					end
					else if(~level)begin
							case (cnt)
								4'b0000: DATA_R <= lv1_0;
								4'b0001: DATA_R <= lv1_1;
								4'b0010: DATA_R <= lv1_2;
								4'b0011: DATA_R <= lv1_3;
								4'b0100: DATA_R <= lv1_4;
								4'b0101: DATA_R <= lv1_5;
								4'b0110: DATA_R <= lv1_6;
								4'b0111: DATA_R <= lv1_7;
							endcase						
					end
					else begin
						case (mode)
						  2'b00: begin
								case (cnt)
									 4'b0000: begin
												 DATA_R <= level_11_1m;
												 DATA_B<=level_1_1p;
												 DATA_G<=level_1_1s;
												 end
									 4'b0001: begin
												 DATA_R <= level_11_2m; 
												 DATA_B<=level_1_2p;
												 DATA_G<=level_1_2s;
												 end
									 4'b0010: begin
												 DATA_R <= level_11_3m; 
												 DATA_B<=level_1_3p;
												 DATA_G<=level_1_3s;
												 end
									 4'b0011: begin
												 DATA_R <= level_11_4m; 
												 DATA_B<=level_1_4p;
												 DATA_G<=level_1_4s;
												 end
									 4'b0100: begin
												 DATA_R <= level_11_5m; 
												 DATA_B<=level_1_5p;
												 DATA_G<=level_1_5s;
												 end
									 4'b0101: begin
												 DATA_R <= level_11_6m; 
												 DATA_B<=level_1_6p;
												 DATA_G<=level_1_6s;
												 end
									 4'b0110: begin
												 DATA_R <= level_11_7m; 
												 DATA_B<=level_1_7p;
												 DATA_G<=level_1_7s;
												 end
									 4'b0111: begin
												 DATA_R <= level_11_0m; 
												 DATA_B<=level_1_0p;
												 DATA_G<=level_1_0s;
												 end
								endcase
						  end
						  2'b01: begin
								case (cnt)
									 4'b0000: begin
												 DATA_R <= level_12_0m; 
												 DATA_B<=level_1_0p;
												 DATA_G<=level_1_0s;
												 end
									 4'b0001: begin
												 DATA_R <= level_12_1m; 
												 DATA_B<=level_1_1p;
												 DATA_G<=level_1_1s;
												 end
									 4'b0010: begin
												 DATA_R <= level_12_2m; 
												 DATA_B<=level_1_2p;
												 DATA_G<=level_1_2s;
												 end
									 4'b0011: begin
												 DATA_R <= level_12_3m; 
												 DATA_B<=level_1_3p;
												 DATA_G<=level_1_3s;
												 end
									 4'b0100: begin
												 DATA_R <= level_12_4m; 
												 DATA_B<=level_1_4p;
												 DATA_G<=level_1_4s;
												 end
									 4'b0101: begin
												 DATA_R <= level_12_5m; 
												 DATA_B<=level_1_5p;
												 DATA_G<=level_1_5s;
												 end
									 4'b0110: begin
												 DATA_R <= level_12_6m; 
												 DATA_B<=level_1_6p;
												 DATA_G<=level_1_6s;
												 end
									 4'b0111: begin
												 DATA_R <= level_12_7m; 
												 DATA_B<=level_1_7p;
												 DATA_G<=level_1_7s;
												 end
								endcase
						  end
						  2'b10: begin
								case (cnt)
									 4'b0000: begin
												 DATA_R <= level_13_0m; 
												 DATA_B<=level_1_0p;
												 DATA_G<=level_1_0s;
												 end
									 4'b0001: begin
												 DATA_R <= level_13_1m; 
												 DATA_B<=level_1_1p;
												 DATA_G<=level_1_1s;
												 end
									 4'b0010: begin
												 DATA_R <= level_13_2m; 
												 DATA_B<=level_1_2p;
												 DATA_G<=level_1_2s;
												 end
									 4'b0011: begin
												 DATA_R <= level_13_3m; 
												 DATA_B<=level_1_3p;
												 DATA_G<=level_1_3s;
												 end
									 4'b0100: begin
												 DATA_R <= level_13_4m; 
												 DATA_B<=level_1_4p;
												 DATA_G<=level_1_4s;
												 end
									 4'b0101: begin
												 DATA_R <= level_13_5m; 
												 DATA_B<=level_1_5p;
												 DATA_G<=level_1_5s;
												 end
									 4'b0110: begin
												 DATA_R <= level_13_6m; 
												 DATA_B<=level_1_6p;
												 DATA_G<=level_1_6s;
												 end
									 4'b0111: begin
												 DATA_R <= level_13_7m; 
												 DATA_B<=level_1_7p;
												 DATA_G<=level_1_7s;
												 end
								endcase
							end
						endcase
					end
				end
		  end
		end
	end

endmodule


