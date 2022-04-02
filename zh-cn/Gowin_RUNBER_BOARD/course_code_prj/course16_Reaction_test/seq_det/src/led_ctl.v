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
module led_ctl(
    input                 clk,      //���봦��ʱ��50MHz               
    input                 restart,  //�������¿�ʼ�źţ��ߵ�ƽ��Ч    
                                                                      
    output reg            det_start,//�����⿪ʼ�ź�                
    output reg   [7:0]    led      //��������������LED�Ӿ�����      
);
    
    //============================================================================
    reg [25:0] time_1s_cnt = 26'd0;  //0~49_999_999 1s ����
    always @(posedge clk)
    begin
        if(time_1s_cnt == 26'd1199_9999)
            time_1s_cnt <= `UD 26'd0;
        else
            time_1s_cnt <= `UD time_1s_cnt + 26'd1;
    end
    
    reg [1:0] second_cnt = 2'd0;
    always @(posedge clk)
    begin
        if(restart)
            second_cnt <= `UD 2'd0;
        else if(time_1s_cnt == 26'd1199_9999)
        begin
            if(second_cnt == 2'd3)
                second_cnt <= `UD second_cnt;
            else
                second_cnt <= `UD second_cnt + 2'd1;
        end
    end
    
    //============================================================================
    // ѭ����λ�Ĵ���
    reg [7:0]  led_temp = 8'b0000_0001;
    reg [9:0]  time_led_cnt=10'd0;
    always @(posedge clk)
    begin
        if(time_led_cnt == 10'd579)
            time_led_cnt <= `UD 10'd0;
        else
            time_led_cnt <= `UD time_led_cnt + 10'd1;
    end
    
    always @(posedge clk)
    begin
        if(time_led_cnt == 10'd579)
            led_temp <= `UD {led_temp[0],led_temp[7:1]};
    end
    
    //===========================================================================
    reg [8:0] time_cnt=9'd0;   //ȡ�����led״̬
    always @(posedge clk)
    begin
        time_cnt <= `UD time_cnt + 10'd1;
    end
    
    //==========================================================================
    reg   start_cnt=1'b0;  //start����
    always @ (posedge clk)
    begin
        if(second_cnt == 2'd3 && start_cnt == 1'b0 && time_cnt == 10'd375)
            det_start <= `UD 1'b1;
        else
            det_start <= `UD 1'b0;
    end
    
    always @(posedge clk)
    begin
        if(restart)
            start_cnt <= `UD 1'b0;
        else if(second_cnt == 2'd3 && start_cnt == 1'b0 && time_cnt == 10'd375)
            start_cnt <= `UD 1'b1;
    end
    
    always @(posedge clk)
    begin
        if(restart)
            led <= `UD 8'b0000_0000;
        else if(second_cnt == 2'd3 && start_cnt == 1'b0 && time_cnt == 10'd375)
            led <= `UD led_temp;
    end

endmodule