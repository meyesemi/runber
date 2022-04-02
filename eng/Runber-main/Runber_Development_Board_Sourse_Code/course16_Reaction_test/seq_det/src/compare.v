`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Nill
// 
// Create Date:   
// Design Name:  
// Module Name:  compare
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
module compare(
    input                clk,      //���봦��ʱ��50MHz                                 
    input                det_start,//�����ʱ��ʼ�źţ�1��ʱ�����ڣ��ߵ�ƽ��Ч  
    input                restart,  //���¿�ʼ�ź�
    input      [ 7:0]    btn_deb,  //���밴���ź�                                      
    input      [ 7:0]    bit_sel,  //����������                                      
                                                                                       
    output               det_end,  //�����ʱ�����ź�                                  
    output reg [15:0]    ctrl      //�����ʱͳ�ƽ��                                  
);

//==============================================================================
    //���������
    reg [15:0] time_ms_cnt= 16'd0;//0~49999   1ms����
    always@(posedge clk)
    begin
        if(det_start)
            time_ms_cnt <= `UD 16'd0;
        else if(time_ms_cnt == 16'd11999)
            time_ms_cnt <= `UD 16'd0;
        else
            time_ms_cnt <= `UD time_ms_cnt + 16'd1;
    end

    //===========================================================================
    reg    counter_en = 1'b0;
    reg    flow = 1'b0;
    reg    counter_en_1d = 1'b0;
    always @(posedge clk)
    begin
        if(det_start)
            counter_en <= `UD 1'b1;
        else if((btn_deb == (~bit_sel)) || flow || restart)
            counter_en <= `UD 1'b0;
    end
    
    always @(posedge clk)
    begin
        counter_en_1d <= `UD counter_en;
    end
    
    assign det_end = (~counter_en & counter_en_1d) & (~restart);

//==============================================================================
    //ͳ�Ʒ�Ӧʱ��
    wire [3:0] dec_single,dec_ten,dec_hundred,dec_thousand;
    wire       dec_sigle_trg;
    wire       carry1,carry2,carry3,carry4;//4λ��λ
    
    assign dec_sigle_trg = counter_en & (time_ms_cnt == 16'd11999);
    
    always @(posedge clk)
    begin
        if(det_start)
            flow <= `UD 1'b0;
        else if(carry4)
            flow <= `UD 1'b1;
    end
    
    assign ctrl ={dec_thousand,dec_hundred,dec_ten,dec_single};
    
    dec_counter single(
        .clk              (  clk           ),//input            clk,
        .det_start        (  det_start     ),//input            det_start,
        .trig             (  dec_sigle_trg ),//input            trig,
        .flow             (  flow          ),//input            flow,
                 
        .carry            (  carry1        ),//output reg       carry,
        .dec              (  dec_single    ) //output reg [3:0] dec
    );
    
    dec_counter ten(
        .clk              (  clk           ),//input            clk,
        .det_start        (  det_start     ),//input            det_start,
        .trig             (  carry1        ),//input            trig,
        .flow             (  flow          ),//input            flow,
                 
        .carry            (  carry2        ),//output reg       carry,
        .dec              (  dec_ten       ) //output reg [3:0] dec
    );
    
    dec_counter hundred(
        .clk              (  clk           ),//input            clk,
        .det_start        (  det_start     ),//input            det_start,
        .trig             (  carry2        ),//input            trig,
        .flow             (  flow          ),//input            flow,
                 
        .carry            (  carry3        ),//output reg       carry,
        .dec              (  dec_hundred   ) //output reg [3:0] dec
    );
    
    dec_counter thousand(
        .clk              (  clk           ),//input            clk,
        .det_start        (  det_start     ),//input            det_start,
        .trig             (  carry3        ),//input            trig,
        .flow             (  flow          ),//input            flow,
                 
        .carry            (  carry4        ),//output reg       carry,
        .dec              (  dec_thousand  ) //output reg [3:0] dec
    );
    
endmodule
