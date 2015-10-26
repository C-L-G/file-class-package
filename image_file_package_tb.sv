/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  image_file_package_tb.sv
--Project Name: GitHub
--Data modified: 2015-10-26 12:28:12 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module image_file_package_tb;

import ImageFilePkg::*;

ImageFileClass afile	= new("E:/work/video_process_module/image_file_class/tmp.txt");

int line [$];

initial begin
    $display("%s",afile.path);
    afile.read_file_curr_line(line);
    afile.close_image_file;
    $display("-------->> %d",line.size());
end

endmodule

