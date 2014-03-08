// File_Name  : BouncingBall.v
// Data       : 2010/4/7
// Author     : Supersun 
// Function   : top module of the game
module BouncingBall(
CLOCK_50,
KEY,
SW,
VGA_CLK,        //  VGA Clock
VGA_HS,         //  VGA H_SYNC
VGA_VS,         //  VGA V_SYNC
VGA_BLANK,      //  VGA BLANK
VGA_SYNC,       //  VGA SYNC
VGA_R,          //  VGA Red[9:0]
VGA_G,          //  VGA Green[9:0]
VGA_B,          //  VGA Blue[9:0])
LEDG,
);

input CLOCK_50;
input [0:0] KEY;
input [17:0] SW;
output          VGA_CLK;        //  VGA Clock
output          VGA_HS;         //  VGA H_SYNC
output          VGA_VS;         //  VGA V_SYNC
output          VGA_BLANK;      //  VGA BLANK
output          VGA_SYNC;       //  VGA SYNC
output  [9:0]   VGA_R;          //  VGA Red[9:0]
output  [9:0]   VGA_G;          //  VGA Green[9:0]
output  [9:0]   VGA_B;          //  VGA Blue[9:0] 
output  [3:0]   LEDG;


//registers and wires 
wire [9:0] Red, Green, Blue;
wire [9:0] VGA_X, VGA_Y;
wire [9:0] Ball_X, Ball_Y,Ball_S;
reg clk_25;

always@(posedge CLOCK_50)
  clk_25 <= ~clk_25;


VGA_Controller U0(	//	Host Side
						.iRed(Red),
						.iGreen(Green),
						.iBlue(Blue),
						.oRequest(),
						//	VGA Side
						.H_Cont(VGA_X),
						.V_Cont(VGA_Y),
						.oVGA_R(VGA_R),
						.oVGA_G(VGA_G),
						.oVGA_B(VGA_B),
						.oVGA_H_SYNC(VGA_HS),
						.oVGA_V_SYNC(VGA_VS),
						.oVGA_SYNC(VGA_SYNC),
						.oVGA_BLANK(VGA_BLANK),
						.oVGA_CLOCK(VGA_CLK),
						//	Control Signal
						.iCLK(clk_25),
						.iRST_N(KEY[0])	);

Ball U1(
.rst_n(KEY[0]),
.clk_in(VGA_VS),// keep track of the vertical signal to updata
.Ball_S_in(SW[4:1]),// SW[4:1]  control the size of the ball
.X_Step(SW[8:5]),//SW[8:5] control the horizontal step of the ball
.Y_Step(SW[12:9]),//SW[12:9] control the vertical step of the ball
.Ball_X(Ball_X),
.Ball_Y(Ball_Y),
.Ball_S(Ball_S),
.flag(LEDG[3:0]));

color_gen U2
(
.Ball_X(Ball_X),
.Ball_Y(Ball_Y),
.VGA_X(VGA_X),
.VGA_Y(VGA_Y),
.Ball_S(Ball_S),
.VGA_R(Red),
.VGA_G(Green),
.VGA_B(Blue));

endmodule 
