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

module video_save_to_file #(
	parameter	DSIZE	= 8,
	parameter	NUM_D	= 3,
	parameter	FRAME_MAX	= 20,
	parameter	FILE_COVER = "DISABLE"
)(
	input string			OUT_FILE,		//only fold path,no file path 
	input					opclk,
	input					in_vsync,
	input					in_hsync,
	input					in_de,
	input [NUM_D*DSIZE-1:0]	in_data,
	event					sim_finish
);

reg			vsync;
reg			hsync;
reg			de;
reg [NUM_D*DSIZE-1:0]	data;
always@(negedge opclk)begin
	vsync	<= in_vsync;
	hsync	<= in_hsync;
	de	<= in_de;
	data	<= in_data;
end

int	image_file;
logic	start_write	= 0;
logic	sync_flag	= 1'bx;	//
string	file_name;
int	frame_cnt	= 0;

initial begin:init_write_block
	start_write	= 0;
	$sformat(file_name,{OUT_FILE,"%0d.txt"},frame_cnt);	
	image_file	= $fopen(file_name,"w");
	if($feof(image_file) || image_file == 0)begin
		$display("---%s file connot be open",OUT_FILE);
		disable init_write_block;
	end
	repeat(3) @(posedge de);
	sync_flag	= !vsync;
	start_write	= 1;
	@ sim_finish;
end

always@(vsync)begin:file_write_block
	if(start_write == 0)begin
	end else if(vsync ===  sync_flag)begin
		$fclose(image_file);
	end else begin
		image_file	= $fopen(file_name,"w");
		if($feof(image_file) || image_file == 0)begin
			$display("---%s file connot be open",OUT_FILE);
			disable file_write_block;
		end
		while(vsync !=  sync_flag)begin
			wait(de || vsync ==  sync_flag);
			if(vsync ==  sync_flag) break;
			while(de)begin
				@(negedge opclk);
				if(de) $fwrite(image_file," %0d",data);
			end
			$fwrite(image_file,"\n");
		end
		$fclose(image_file);
		frame_cnt = frame_cnt + 1;
		if(frame_cnt == FRAME_MAX   || frame_cnt == FRAME_MAX*2 || 
		   frame_cnt == FRAME_MAX*3 || frame_cnt >= FRAME_MAX*4)begin
//			$fclose(file_name);
			$stop;
		end
		if(FILE_COVER == "DISABLE")begin
			$sformat(file_name,{OUT_FILE,"%0d.txt"},frame_cnt);
		end else begin
			$sformat(file_name,{OUT_FILE,"0.txt"});
		end
//		$stop;
end	end
		
			
final begin
	$fclose(file_name);
	$display("there are %d frames processed",frame_cnt);
	$display("please check the file in the path of %s",OUT_FILE); 
end

endmodule
		



