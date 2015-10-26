/**********************************************
______________________________________________
_______  ___   ___          ___   __   _    _
_______ |     |   | |\  /| |___  |  \  |   /_\
_______ |___  |___| | \/ | |___  |__/  |  /   \
_______________________________________________
descript:
author : Young
Version: VERA.0.0
creaded: 2015/6/9
madified:
***********************************************/
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

