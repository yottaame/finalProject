# 112321030 FinalProject
Authors: 112321030

**功能說明:**

- [x] 子彈發射顯示
- [x] 怪物顯示
- [ ] 玩家顯示
- [x] 時間倒數
- [x] 子彈續力
- [ ] 切換關卡
- [ ] 切換模式
- [ ] 子彈續力攻擊傷害不同
- [ ] 玩家會被攻擊
- [ ] ......

**程式模組說明：**

module final(    
    output wire [7:0] DATA_R,//紅色燈
    output wire [7:0] DATA_G,//綠色燈
    output wire [7:0] DATA_B,//藍色燈
    output wire [2:0] cnt,   //控制亮燈排數,
    output wire [2:0] gun,   //子彈續力顯示
    output wire [6:0] seg,   //倒計時
    output wire [3:0] an,    // 4 個顯示器的掃描控制
	  output reg en,           //LED開關
    input walk,              //移動開關
    input AD,                //左右移動
    input WS,                //上下移動
    input [2:0] level,       //模式
    input in,                //子彈續力
    input start,             //開始
    input CLK,               //時間
    input RST                //重置
);

**部分功能尚未完善**

