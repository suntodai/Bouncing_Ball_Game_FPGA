// File_Name  :  Ball.v
// Data       :  2010/4/7
// Auhor      : SuperSun 
// Function   : generate the Ball position
module Ball(
rst_n,
clk_in,
Ball_S_in,
X_Step,
Y_Step,
Ball_X,
Ball_Y,
Ball_S,
flag);

input rst_n;
input clk_in;
input [3:0] Ball_S_in;// input ball size
input [3:0] X_Step;// input x step
input [3:0] Y_Step;// input y step
output [9:0] Ball_X;// ball x cordinate
output [9:0] Ball_Y;// ball y cordinate
output [9:0] Ball_S;// ball size
output [3:0] flag;

//begin at the rising edge of VSyn, so parameters have to be offsetted
parameter Ball_X_Center = 463, Ball_Y_Center = 273;
parameter Ball_X_Min = 143, Ball_Y_Min = 33;
parameter Ball_X_Max = 782, Ball_Y_Max = 513;

//wires and registers
(*keep*) wire[9:0] Ball_S;
reg [9:0] X, Y;
reg [9:0] Ball_X, Ball_Y;
reg [3:0] flag;
 
assign Ball_S = {6'b0,Ball_S_in};

//always@(posedge clk_in or negedge rst_n)
//begin
//   if(!rst_n)
//   begin
//      Ball_X <= Ball_X_Center;
//      Ball_Y <= Ball_Y_Center;
//   end
//   else
//      begin
//      Ball_X <= Ball_X_Center;
//      Ball_Y <= Ball_Y_Center;
//      end
//end
always@(posedge clk_in or negedge rst_n)
begin 
   if(!rst_n)
   begin
      Ball_X <= Ball_X_Center;
      X <= {6'b000000,X_Step};
      flag[1:0] <= 2'b00;
   end 
   else
   begin
      if(Ball_X+Ball_S >= Ball_X_Max)//over right
      begin
        X <=  ~{6'b000000,X_Step}+10'b1;
        flag[1:0] <= 2'b01;
      end
      else 
      begin 
         if(Ball_X-Ball_S <= Ball_X_Min)// over left wrongly written +!!!!!!!!!!!!!!!
         begin
             X <= {6'b000000,X_Step};
             flag[1:0] <= 2'b10;
         end
         else
         begin
             X <= ((Ball_X == Ball_X_Center)&&(X==10'b0))?{6'b000000,X_Step}:X;//bug---------------------------------
             flag[1:0] <= 2'b11;
         end
      end
      Ball_X <= Ball_X + X;
   end   
end 

always@(posedge clk_in or negedge rst_n)
begin 
   if(!rst_n)
   begin
      Ball_Y <= Ball_Y_Center;
      Y <= {6'b000000,Y_Step};
      flag[3:2] <= 2'b00;
   end 
   else
   begin
      if(Ball_Y+Ball_S >= Ball_Y_Max)// over bottom
      begin
        Y <=  ~{6'b000000,Y_Step}+10'b1;
        flag[3:2] <= 2'b01;
      end
      else 
      begin 
         if(Ball_Y-Ball_S <= Ball_Y_Min)//over top
         begin
             Y <= {6'b000000,Y_Step};
             flag[3:2] <= 2'b10;
         end
         else
         begin
             Y <= ((Ball_Y == Ball_Y_Center)&&(Y==10'b0))?{6'b000000,Y_Step}:Y;//bug 
             flag[3:2] <= 2'b11;
         end
      end
      Ball_Y <= Ball_Y + Y;  
   end   
end 
endmodule 