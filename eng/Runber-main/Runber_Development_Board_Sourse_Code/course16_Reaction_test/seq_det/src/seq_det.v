`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Nill
// 
// Create Date:   
// Design Name:  
// Module Name:  
// Project Name: 
// Target Devices: Gowin
// Tool Versions: 
// Description: 
//      
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define UD #1
module lock_top(
    input          clk, //输入时钟50MHz
    input  [7:0]   key,//8个按键输入
    
    output [7:0]   led,//8个led输出
    output [7:0]   smg,//8位数码管段选
    output [3:0]   dig  //4位数码管位选
);
    
    //===========================================================================
    wire  [7:0] btn_deb;
    wire        restart;
    wire        det_start;
    wire        det_end;
    
    wire [15:0] ctrl;
    //===========================================================================
    btn_deb#(       // 按键消抖             
        .BTN_WIDTH      (  4'd8      ) //parameter                  BTN_WIDTH = 4'd8 //按键位宽                         
    ) U_btn_deb                                                                                            
    (                                                                                                    
        .clk            (  clk       ),//input                      clk,//输入处理时钟50MHz                             
        .btn_in         (  key       ),//input      [BTN_WIDTH-1:0] btn_in,//输入按键信号                               
                                                                                                         
        .btn_deb        (  btn_deb  ) //output reg [BTN_WIDTH-1:0] btn_deb //输出按键消抖信号                          
    );

    assign restart = (~btn_deb[0])&(~btn_deb[7]);
    
    led_ctl led_ctl(
        .clk            (  clk        ),//input                 clk,      //输入处理时钟50MHz                            
        .restart        (  restart    ),//input                 restart,  //输入重新开始信号，高点平有效             
                                                                                                                  
        .det_start      (  det_start  ),//output reg            det_start,//输出检测开始信号                       
        .led            (  led        ) //output reg   [7:0]    led      //输出检测条件，以LED视觉触发                   
    );
    
    compare compare(
        .clk            (  clk        ),//input                clk,      //输入处理时钟50MHz                                    
        .det_start      (  det_start  ),//input                det_start,//输入计时开始信号，1个时钟周期，高电平有?      ?                            
        .restart        (  restart    ),//input                restart,  //输入重新开始信号，高点平有效    
        .btn_deb        (  btn_deb    ),//input      [ 7:0]    btn_deb,  //输入按键信号                                   
        .bit_sel        (  led        ),//input      [ 7:0]    bit_sel,  //输入检测条件                                  
                                                                                                               
        .det_end        (  det_end    ),//output               det_end,  //输出计时结束信号                                  
        .ctrl           (  ctrl       ) //output reg [15:0]    ctrl      //输出计时统计结果                                 
    );

    seq_display seq_display(
        .clk            (  clk        ),//input               clk,     //输入处理时钟50MHz                      
        .restart        (  restart    ),//input               restart, //输入重新开始信号，高点平有效      
        .det_end        (  det_end    ),//input               det_end, //输入计时结束信号                   
        .ctrl           (  ctrl       ),//input      [15:0]   ctrl,    //输入计时统计结果                    
                                                                                           
        .smg            (  smg        ),//output reg  [7:0]   smg,     //输出8位数码管段选                     
        .dig            (  dig        ) //output reg  [3:0]   dig      //输出4位数码管位选                     
    );



endmodule
