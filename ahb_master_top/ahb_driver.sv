class ahb_driver extends uvm_driver #(write_xtn);
`uvm_component_utils(ahb_driver);
ahb_agt_config m_cfg;
semaphore sem;
virtual ahb_if.AHB_DR_MP vif;
write_xtn xtn;
extern function new(string name = "ahb_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase (uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut (write_xtn xtn);
extern function void report_phase(uvm_phase phase);
endclass

//constuctor method
function ahb_driver::new(string name = "ahb_driver",uvm_component parent);
super.new(name,parent);
endfunction

//build phase
function void ahb_driver::build_phase(uvm_phase phase);
super.build_phase(phase);
xtn=write_xtn::type_id::create("xtn");
if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
sem=new(1);
endfunction

//connect phase

function void ahb_driver::connect_phase (uvm_phase phase);
  
  //interface connection
  vif=m_cfg.vif;
endfunction


//run phase

task ahb_driver::run_phase(uvm_phase phase);
   @(vif.ahb_drv_cb);
        vif.ahb_drv_cb.Hresetn <= 1'b0;
        @(vif.ahb_drv_cb);
        vif.ahb_drv_cb.Hresetn <= 1'b1;
        forever
                begin
		
                        seq_item_port.get_next_item(req); 
                        send_to_dut(req);
                        seq_item_port.item_done();
                end
endtask


// send to dut
task ahb_driver::send_to_dut(write_xtn xtn);

       // @(vif.ahb_drv_cb);

  	while(!vif.ahb_drv_cb.Hreadyout)
        @(vif.ahb_drv_cb);

        vif.ahb_drv_cb.Hwrite  <= xtn.Hwrite;
        vif.ahb_drv_cb.Htrans <= xtn.Htrans;
        vif.ahb_drv_cb.Hsize   <= xtn.Hsize;
        vif.ahb_drv_cb.Haddr   <= xtn.Haddr;
        vif.ahb_drv_cb.Hburst<=xtn.Hburst;
        vif.ahb_drv_cb.Hreadyin<= 1'b1;
    
        @(vif.ahb_drv_cb);
	
        while(!vif.ahb_drv_cb.Hreadyout)
        @(vif.ahb_drv_cb);

        if(xtn.Hwrite)
             vif.ahb_drv_cb.Hwdata<=xtn.Hwdata;
        else
             vif.ahb_drv_cb.Hwdata<=32'd0;
         @(vif.ahb_drv_cb);
         m_cfg.drv_data_count++;// to check data loss so that what no of data we are sending
	
	/*repeat(2)
	@(vif.ahb_drv_cb);
*/
       `uvm_info("AHB_DRIVER", "Displaying ahb_driver data", UVM_LOW)
       
endtask
//------------------------- UVM report_phase
function void ahb_driver::report_phase(uvm_phase phase);
    	`uvm_info(get_type_name(), $sformatf("Report: ROUTER write driver sent %0d transactions", m_cfg.drv_data_count),UVM_LOW)
endfunction

/*
///////////////////////////////////////////adding pipeline

class ahb_driver extends uvm_driver #(write_xtn);
`uvm_component_utils(ahb_driver);
ahb_agt_config m_cfg;
semaphore sem;
virtual ahb_if.AHB_DR_MP vif;
write_xtn xtn;
extern function new(string name = "ahb_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase (uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut (write_xtn xtn);
extern function void report_phase(uvm_phase phase);
endclass

//constuctor method
function ahb_driver::new(string name = "ahb_driver",uvm_component parent);
super.new(name,parent);
endfunction

//build phase
function void ahb_driver::build_phase(uvm_phase phase);
super.build_phase(phase);
xtn=write_xtn::type_id::create("xtn");
if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
sem=new(1);
endfunction

//connect phase

function void ahb_driver::connect_phase (uvm_phase phase);
  
  //interface connection
  vif=m_cfg.vif;
endfunction


//run phase

task ahb_driver::run_phase(uvm_phase phase);
super.run_phase(phase);
   @(vif.ahb_drv_cb);
        vif.ahb_drv_cb.Hresetn <= 1'b0;
        @(vif.ahb_drv_cb);
        vif.ahb_drv_cb.Hresetn <= 1'b1;
	
        forever
                begin
		
                        seq_item_port.get_next_item(req); 
                        send_to_dut(req);
                        seq_item_port.item_done();
                end
endtask


// send to dut
task ahb_driver::send_to_dut(write_xtn xtn);
fork
        sem.get(1);  
	begin
	vif.ahb_drv_cb.Hwrite  <= xtn.Hwrite;
        vif.ahb_drv_cb.Htrans <= xtn.Htrans;
        vif.ahb_drv_cb.Hsize   <= xtn.Hsize;
 	vif.ahb_drv_cb.Hburst<=xtn.Hburst;

        vif.ahb_drv_cb.Haddr   <= xtn.Haddr;
               vif.ahb_drv_cb.Hreadyin<= 1'b1;  
	end
	sem.put(1);  
    
        @(vif.ahb_drv_cb);

        sem.get(1);  
	begin
        if(xtn.Hwrite)
             vif.ahb_drv_cb.Hwdata<=xtn.Hwdata;
        else
             vif.ahb_drv_cb.Hwdata<=32'd0; 
	     end
	sem.put(1);


        while(!vif.ahb_drv_cb.Hreadyout)
        @(vif.ahb_drv_cb);

         //@(vif.ahb_drv_cb);
       //  m_cfg.drv_data_count++;// to check data loss so that what no of data we are sending

       `uvm_info("AHB_DRIVER", "Displaying ahb_driver data", UVM_LOW)
join_any
endtask
//------------------------- UVM report_phase
function void ahb_driver::report_phase(uvm_phase phase);
    	`uvm_info(get_type_name(), $sformatf("Report: ROUTER write driver sent %0d transactions", m_cfg.drv_data_count),UVM_LOW)
endfunction
*/

