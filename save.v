module save(output reg [2:0] save,output reg[2:0]harm,output reg beat, input in,RST,CLK);
    wire clk_1Hz;
    reg [1:0] sec = 2'b00;
    clock #(25000000) clk_divider_1Hz (
        .CLK(CLK),
        .RST(RST),
        .CLK_div(clk_1Hz)
    );
	 initial begin
		save  = 3'b000;
		harm = 3'b000;
		beat = 1'b0;
	 end
    always @(posedge clk_1Hz or posedge RST) begin
		  if(RST)begin
				save <= 3'b000;
		  end
        else if (save == 3'b111) begin
            sec <= sec + 1'b1;
				if(~in)begin
					harm <= save;
					beat <= 1'b1;
					save  <= 3'b000;
				end
		  end 
		  else if (sec == 2'b10) begin
					save <= 3'b000;
					sec <= 2'b00;
		  end 
		  else if(in) begin
            save <= {save[1:0], in};
				beat <= 1'b0;
        end 
		  else if(~in)begin
				harm <= save;
				beat <= 1'b1;
				save  <= 3'b000;
		  end
    end
endmodule

//完成