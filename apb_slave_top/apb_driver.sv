class apb_driver extends uvm_driver #(read_xtn);
`uvm_component_utils(apb_driver);
virtual apb_if.APB_DR_MP vif;
apb_agt_config m_cfg;
read_xtn xtn;

extern function new(string name = "apb_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut (read_xtn xtn);
extern function void report_phase(uvm_phase phase);

endclass

//constuctor method
function apb_driver::new(string name = "apb_driver",uvm_component parent);
super.new(name,parent);
endfunction

//build phase
function void apb_driver::build_phase(uvm_phase phase);
super.build_phase(phase);
xtn=read_xtn::type_id::create("xtn");
if(!uvm_config_db #(apb_agt_config)::get(this,"","apb_agt_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

endfunction

//connect phase

function void apb_driver::connect_phase(uvm_phase phase);

  vif=m_cfg.vif;

endfunction
 //run phase

task apb_driver::run_phase(uvm_phase phase);
 req = read_xtn::type_id::create("req", this);

                begin
                       // seq_item_port.get_next_item(req); 
                        send_to_dut(req);
                       // seq_item_port.item_done();
                end
endtask
// send to dut
task apb_driver::send_to_dut(read_xtn xtn);

  wait(vif.apb_drv_cb.Pselx!=0)
    @(vif.apb_drv_cb); 
   $display("whle statement  woking properly in driver");
    if(vif.apb_drv_cb.Pwrite == 0) 
       vif.apb_drv_cb.Prdata <= {$random}; 
       repeat(2) @(vif.apb_drv_cb); 
       wait(vif.apb_drv_cb.Penable == 1);
        m_cfg.drv_data_count++;
       `uvm_info("APB_DRIVER", "Displaying apb_driver data", UVM_LOW)
       
endtask
//------------------------- UVM report_phase
function void apb_driver::report_phase(uvm_phase phase);
    	`uvm_info(get_type_name(), $sformatf("Report: ROUTER read driver sent %0d transactions", m_cfg.drv_data_count),UVM_LOW)
endfunction



