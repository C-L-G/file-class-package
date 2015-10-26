/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  image_file_package.sv
--Project Name: GitHub
--Data modified: 2015-10-26 12:28:12 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
package ImageFilePkg;

class ImageFileClass;
    string	path    = "";
    integer	handle;
    int		pesize	= 8;
    int		line_data[$];
	integer line_num=0;
    int		p1_data[$];
    int		p2_data[$];
    int		p3_data[$];
    string	curr_string;
    string	tmp_path;

    function new(string	file_path,string ftype = "r");
	path	= file_path;
	handle	= $fopen(path,ftype);
	if(handle == 0)begin
	    $display("--->>>Can't open file %s<<<---", path);
	    $stop;
	end else begin
	    tmp_path	= {"$TMP/","sim_image_file_",$psprintf("%0t%0h",$time,$random),".txt"};
	    read_file_curr_line;
    	end 
    endfunction:new

    function void read_file_curr_line(
	ref int line [$]    = line_data,
	ref int p1[$]	    = p1_data,
	ref int p2[$]	    = p2_data,
	ref int p3[$]	    = p3_data	
    				);
	int II	= 0;
	integer	tmp_handle;
	integer curr_str_handle;
	//-->> open temp file <<--
	tmp_handle= $fopen(tmp_path,"w");
	if(tmp_handle == -1)begin
		$display("--->>>read line: Can't read file %s <<---",tmp_path);
	end
	//--<< open temp file >>--
	//-->> REWIND FILE <<--
	curr_str_handle	= $fgets(curr_string,handle);
	if($feof(handle) || (curr_str_handle == 0))begin
	   	tmp_handle = $rewind(handle);
		line_num  = 0;
		curr_str_handle	= $fgets(curr_string,handle);		//restart 
	end
	//--<< REWIND FILE >>--
	if( curr_str_handle != 0)begin
	    //--->> <<---
	    $fwrite(tmp_handle,"%s",curr_string);
	    $fclose(tmp_handle);
	    //---<< >>---
		//$display("%s",curr_string);
	    tmp_handle= $fopen(tmp_path,"r");
	    while( ($fscanf(tmp_handle,"%d ",line[II])) != -1)begin
		//while( ($sscanf(curr_string,"%d ",line[II])) != -1)begin
			$display("NUM: %d -->> %d",II,line[II]);
			$stop;
			p1[II]	= line[II]>>(2*pesize);
			p2[II]	= (line[II]>>pesize)%(2**pesize);
			p3[II]	= line[II] % (2**pesize);
			II += 1;
	    end
	    $fclose(tmp_handle);
	    this.line_data  = line;
	    this.p1_data    = p1;
	    this.p2_data    = p2;
	    this.p3_data    = p3;
		line_num		= line_num + 1;
	end else begin
	    $display("--->>>read line: Can't read file %s <<---",path);  
		$display("%d <===> %d",curr_str_handle,tmp_handle);
		$stop;
	end
    endfunction:read_file_curr_line

    function integer cur_data;
	integer  tmp_p;
	tmp_p	    = $ftell(handle);
	if($fscanf(handle,"%d ",cur_data) == -1)begin
	    $display("--->>Can't read file %s<<<---",path);
	    cur_data	= -1;
	end else begin
	    tmp_p = $fseek(handle,tmp_p,0);
	    cur_data	= tmp_p;
	end
    endfunction:cur_data
    
    function integer fpoint;
	fpoint = $ftell(handle);
    endfunction:fpoint

    function integer new_frame;
		new_frame = $rewind(handle);
    endfunction:new_frame

    task close_image_file;
	if(handle != 0)
	    $fclose(handle);
    endtask:close_image_file  

endclass:ImageFileClass

endpackage: ImageFilePkg
	    

    

