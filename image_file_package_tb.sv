/*******************************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________

--Module Name:
--Project Name:
--Chinese Description:
	
--English Description:
	
--Version:VERA.1.0.0
--Data modified:
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
--Data created:
________________________________________________________
********************************************************/
`timescale 1ns/1ps
module image_file_package_tb;

import ImageFilePkg::*;

ImageFileClass afile	= new("tmp.txt");

int line [$];

initial begin
    $display("%s",afile.path);
    afile.read_file_curr_line(line);
    afile.close_image_file;
    $display("-------->> %d",line.size());
end

endmodule

