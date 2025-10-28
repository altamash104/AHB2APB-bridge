class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard);

uvm_tlm_analysis_fifo #(read_xtn) fifo_apb;
uvm_tlm_analysis_fifo #(write_xtn) fifo_ahb;
write_xtn Hxtn1,Hxtn2,q[$];
read_xtn Pxtn,Pxtn1,pq[$];

//cov
//ahb_xtn hcov;
//apb_xtn pcov;

extern function new(string name="scoreboard",uvm_component parent);
extern task run_phase(uvm_phase phase);
//extern function void check_data(write_xtn w,read_xtn r);
//extern fucntion void compare(int HDATA,PDATA,Haddr,Paddr);
extern function void compare(write_xtn hxtn,read_xtn pxtn);
extern function void verify(int haddr,int paddr,int hdata,int pdata);

endclass

function scoreboard::new(string name="scoreboard",uvm_component parent);
  super.new(name,parent);
  fifo_ahb=new("fifo_ahb",this);
  fifo_apb=new("fifo_apb",this);

  //cg=new;
// cg_ahb=new();
// cg_apb=new();

endfunction

/*
task scoreboard::run_phase(uvm_phase phase);
 super.run_phase(phase);

 Hxtn2=write_xtn::type_id::create("Hxtn2");

 Pxtn=read_xtn::type_id::create("Pxtn");

 fork
  forever
    begin
         fifo_ahb.get(Hxtn1);
         q.push_back(Hxtn1);
           check_data(Hxtn2,Pxtn);
	 
       `uvm_info(get_type_name(),$sformatf("printing from scoreboard \n %s",Hxtn1.sprint),UVM_MEDIUM);
    // if(Hxtn1.Hwrite==0)
     
	   
        end

  forever
    begin
         fifo_apb.get(Pxtn);
         check_data(Hxtn2,Pxtn);
	 
      `uvm_info(get_type_name(),$sformatf("printing from scoreboard \n %s",Pxtn.sprint),UVM_MEDIUM);

        //if(Pxtn.Pwrite)

        end
 join

endtask




function void scoreboard::check_data(write_xtn w,read_xtn r);

 begin
 Hxtn2=q.pop_front;
// cov 
// hcov=Hxtn2;
// pcov=Pxtn;

 if(Hxtn2.Hwrite==0)
    begin
      case(Hxtn2.Hsize)
           3'b 000 :begin
                         if(Hxtn2.Haddr[1:0]==2'b00)
			 
                                   compare(Hxtn2.Hrdata[7:0],Pxtn.Prdata[7:0],Hxtn2.Haddr,Pxtn.Paddr);
                         if(Hxtn2.Haddr[1:0]==2'b01)
                                   compare(Hxtn2.Hrdata[7:0],Pxtn.Prdata[15:8],Hxtn2.Haddr,Pxtn.Paddr);
                         if(Hxtn2.Haddr[1:0]==2'b10)
                                   compare(Hxtn2.Hrdata[7:0],Pxtn.Prdata[23:16],Hxtn2.Haddr,Pxtn.Paddr);
                         if(Hxtn2.Haddr[1:0]==2'b11)
                                   compare(Hxtn2.Hrdata[7:0],Pxtn.Prdata[31:24],Hxtn2.Haddr,Pxtn.Paddr);
                        end

           3'b 001 :begin
 	   
                         if(Hxtn2.Haddr[1:0]==2'b00)
                                   compare(Hxtn2.Hrdata[15:0],Pxtn.Prdata[15:0],Hxtn2.Haddr,Pxtn.Paddr);
                                 if(Hxtn2.Haddr[1:0]==2'b10)
                                   compare(Hxtn2.Hrdata[15:0],Pxtn.Prdata[31:16],Hxtn2.Haddr,Pxtn.Paddr);
                        end

           3'b 010 :begin
                         if(Hxtn2.Haddr[1:0]==2'b00)
                                   compare(Hxtn2.Hrdata[31:0],Pxtn.Prdata[31:0],Hxtn2.Haddr,Pxtn.Paddr);
                        end
       endcase

    end
else if(Hxtn2.Hwrite==1'b1)
    begin
      case(Hxtn2.Hsize)
            3'b 000 :begin
                         if(Hxtn2.Haddr[1:0]==2'b00)
                                   compare(Hxtn2.Hwdata[7:0],Pxtn.Pwdata[7:0],Hxtn2.Haddr,Pxtn.Paddr);
                         if(Hxtn2.Haddr[1:0]==2'b01)
                                   compare(Hxtn2.Hwdata[15:8],Pxtn.Pwdata[7:0],Hxtn2.Haddr,Pxtn.Paddr);
                         if(Hxtn2.Haddr[1:0]==2'b10)
                                   compare(Hxtn2.Hwdata[23:16],Pxtn.Pwdata[7:0],Hxtn2.Haddr,Pxtn.Paddr);
                         if(Hxtn2.Haddr[1:0]==2'b11)
                                   compare(Hxtn2.Hwdata[31:24],Pxtn.Pwdata[7:0],Hxtn2.Haddr,Pxtn.Paddr);
                        end

            3'b 001 :begin
                         if(Hxtn2.Haddr[1:0]==2'b00)
                                   compare(Hxtn2.Hwdata[15:0],Pxtn.Pwdata[15:0],Hxtn2.Haddr,Pxtn.Paddr);
                                 if(Hxtn2.Haddr[1:0]==2'b10)
                                   compare(Hxtn2.Hwdata[31:16],Pxtn.Pwdata[15:0],Hxtn2.Haddr,Pxtn.Paddr);
                        end
			3'b 010 :begin
                         if(Hxtn2.Haddr[1:0]==2'b00)
                                   compare(Hxtn2.Hwdata[31:0],Pxtn.Pwdata[31:0],Hxtn2.Haddr,Pxtn.Paddr);
                        end

       endcase
    end
end
endfunction

function void scoreboard::compare(int HDATA,PDATA,Haddr,Paddr);


if((HDATA!=0)&&(PDATA!=0))
 begin
  if(HDATA==PDATA)
   begin
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
   
    $display("data compare successfull");
   `uvm_info(get_type_name(),$sformatf("Data compare successful HDATA=%0h and PDATA=%0h \n",HDATA,PDATA),UVM_LOW)
  //  cg.sample();
  //       cg_ahb.sample();
    //    cg_apb.sample();
   end
  else
     begin
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
     
     `uvm_info(get_type_name(),$sformatf("Data compare failed HDATA=%0h and PDATA=%0h \n",HDATA,PDATA),UVM_LOW)
     $finish;
    end
  if(Haddr==Paddr)
    `uvm_info(get_type_name(),$sformatf("Addr compare successful Haddr=%0h and Paddr=%0h \n",Haddr,Paddr),UVM_LOW)
  else
     begin
     `uvm_info(get_type_name(),$sformatf("Addr compare failed Haddr=%0h and Paddr=%0h \n",Haddr,Paddr),UVM_LOW)
     $finish;
    end
 end
endfunction*/


task scoreboard:: run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
		fifo_ahb.get(Hxtn1);
		fifo_apb.get(Pxtn);
		compare(Hxtn1,Pxtn);
	end
endtask

function void scoreboard:: compare(write_xtn hxtn,read_xtn pxtn); //hxtn=Hxtn1; pxtn=Pxtn
	if(hxtn.Hwrite==1) begin
		if(hxtn.Hsize==0) begin
			if(hxtn.Haddr[1:0]==2'b00)
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hwdata[7:0],pxtn.Pwdata[7:0]);
			else if(hxtn.Haddr[1:0]==2'b01)
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hwdata[15:8],pxtn.Pwdata[7:0]);
			else if(hxtn.Haddr[1:0]==2'b10)
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hwdata[23:16],pxtn.Pwdata[7:0]);
			else
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hwdata[31:24],pxtn.Pwdata[7:0]);
				
		end
		if(hxtn.Hsize==1) begin
			if(hxtn.Haddr[1:0]==2'b00)
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hwdata[15:0],pxtn.Pwdata[15:0]);
			else if(hxtn.Haddr[1:0]==2'b10)
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hwdata[31:16],pxtn.Pwdata[15:0]);

		end
		if(hxtn.Hsize==2) begin
			if(hxtn.Haddr[1:0]==2'b00)
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hwdata[31:0],pxtn.Pwdata[31:0]);
		end
			
	end

	else begin
	
		if(hxtn.Hsize==0) begin
			if(hxtn.Haddr[1:0]==2'b00)
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hrdata[7:0],pxtn.Prdata[7:0]);
			else if(hxtn.Haddr[1:0]==2'b01) 
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hrdata[7:0],pxtn.Prdata[15:8]);
			else if(hxtn.Haddr[1:0]==2'b10)
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hrdata[7:0],pxtn.Prdata[23:16]);
			else
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hrdata[7:0],pxtn.Prdata[31:24]);
				
		end
		if(hxtn.Hsize==1) begin
			if(hxtn.Haddr[1:0]==2'b00)
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hrdata[15:0],pxtn.Prdata[15:0]);
			else if(hxtn.Haddr[1:0]==2'b10)
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hrdata[15:0],pxtn.Prdata[31:16]);

		end
		if(hxtn.Hsize==2) begin
			if(hxtn.Haddr[1:0]==2'b00)
				verify(hxtn.Haddr,pxtn.Paddr,hxtn.Hrdata[31:0],pxtn.Prdata[31:0]);
		end

	end
endfunction

function void scoreboard:: verify(int haddr,int paddr,int hdata,int pdata);
	if(haddr==paddr) begin
	$display("$$$$$$$$$$$$$ Haddr%0h  time=%0t",haddr,$time);
		if(hdata==pdata) begin
			`uvm_info(get_type_name,"item matched",UVM_LOW)
			//	cov1.sample();
			//	cov2.sample();
			end
		else
			`uvm_error(get_type_name,"data mismatched!!!!!")

	end
	else
		`uvm_error(get_type_name,"address mismatched!!!!!")

endfunction
