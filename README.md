# 112321030 FinalProject
Authors: 112321030

**Input/Output unit:**
- 8x8 LED 矩陣，用來顯示對戰畫面
  ![image](https://github.com/user-attachments/assets/9eededd5-deb7-4062-a3f0-c128c1a07524)

- 七段顯示器，用來顯示剩餘時間和計分
  ![image](https://github.com/user-attachments/assets/465e8f28-0972-40ff-afeb-388166ee39c2)

- LED 陣列，用來顯示子彈續力和目前關卡
  ![image](https://github.com/user-attachments/assets/2959eb61-ec30-4f7c-8bc9-43cbe86cb1cc)


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

