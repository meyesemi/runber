`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Nill
// 
// Create Date: 2019-09-12 16:03
// Design Name: 
// Module Name: btn_deb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: ��������
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define	UD #1
module btn_deb #(
    parameter     BT_WIDTH = 4'd8
)
(
    input                          clk,
    input      [BT_WIDTH-1:0]      btn_in,
                               
    output reg [BT_WIDTH-1:0]      btn_out
);
    
    reg [19:0] time_cnt=20'd0;//21ms��ʱ�����Ĵ�����
    
    always @(posedge clk)
    begin
        time_cnt <= `UD time_cnt + 20'd1;  //��������20'hf_ffffʱ����ԼΪ21ms
    end
    
    always @(posedge clk)
    begin
        if(time_cnt == 0)   //ÿ��21msȡһ�ΰ���״ֵ̬��
            btn_out <= `UD btn_in;
    end

endmodule
