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
    input          clk, //����ʱ��50MHz
    input  [7:0]   key,//8����������
    
    output [7:0]   led,//8��led���
    output [7:0]   smg,//8λ����ܶ�ѡ
    output [3:0]   dig  //4λ�����λѡ
);
    
    //===========================================================================
    wire  [7:0] btn_deb;
    wire        restart;
    wire        det_start;
    wire        det_end;
    
    wire [15:0] ctrl;
    //===========================================================================
    btn_deb#(       // ��������             
        .BTN_WIDTH      (  4'd8      ) //parameter                  BTN_WIDTH = 4'd8 //����λ��                         
    ) U_btn_deb                                                                                            
    (                                                                                                    
        .clk            (  clk       ),//input                      clk,//���봦��ʱ��50MHz                             
        .btn_in         (  key       ),//input      [BTN_WIDTH-1:0] btn_in,//���밴���ź�                               
                                                                                                         
        .btn_deb        (  btn_deb  ) //output reg [BTN_WIDTH-1:0] btn_deb //������������ź�                          
    );

    assign restart = (~btn_deb[0])&(~btn_deb[7]);
    
    led_ctl led_ctl(
        .clk            (  clk        ),//input                 clk,      //���봦��ʱ��50MHz                            
        .restart        (  restart    ),//input                 restart,  //�������¿�ʼ�źţ��ߵ�ƽ��Ч             
                                                                                                                  
        .det_start      (  det_start  ),//output reg            det_start,//�����⿪ʼ�ź�                       
        .led            (  led        ) //output reg   [7:0]    led      //��������������LED�Ӿ�����                   
    );
    
    compare compare(
        .clk            (  clk        ),//input                clk,      //���봦��ʱ��50MHz                                    
        .det_start      (  det_start  ),//input                det_start,//�����ʱ��ʼ�źţ�1��ʱ�����ڣ��ߵ�ƽ���      �                            
        .restart        (  restart    ),//input                restart,  //�������¿�ʼ�źţ��ߵ�ƽ��Ч    
        .btn_deb        (  btn_deb    ),//input      [ 7:0]    btn_deb,  //���밴���ź�                                   
        .bit_sel        (  led        ),//input      [ 7:0]    bit_sel,  //����������                                  
                                                                                                               
        .det_end        (  det_end    ),//output               det_end,  //�����ʱ�����ź�                                  
        .ctrl           (  ctrl       ) //output reg [15:0]    ctrl      //�����ʱͳ�ƽ��                                 
    );

    seq_display seq_display(
        .clk            (  clk        ),//input               clk,     //���봦��ʱ��50MHz                      
        .restart        (  restart    ),//input               restart, //�������¿�ʼ�źţ��ߵ�ƽ��Ч      
        .det_end        (  det_end    ),//input               det_end, //�����ʱ�����ź�                   
        .ctrl           (  ctrl       ),//input      [15:0]   ctrl,    //�����ʱͳ�ƽ��                    
                                                                                           
        .smg            (  smg        ),//output reg  [7:0]   smg,     //���8λ����ܶ�ѡ                     
        .dig            (  dig        ) //output reg  [3:0]   dig      //���4λ�����λѡ                     
    );



endmodule
