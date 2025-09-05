class ahb_monitor extends uvm_monitor;
`uvm_component_utils(ahb_monitor)
virtual ahb_if.AHB_MON_MP vif;

ahb_agt_config m_cfg;
 uvm_analysis_port #(write_xtn) monitor_port;
 
extern function new(string name = "ahb_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
extern function void report_phase(uvm_phase phase);
endclass

//constructor method
function ahb_monitor::new(string name = "ahb_monitor",uvm_component parent);
super.new(name,parent);
monitor_port = new("monitor_port",this);
endfunction

//build method
function void ahb_monitor::build_phase(uvm_phase phase);
super.build_phase(phase);
 if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

endfunction

//connect phase
 function void ahb_monitor::connect_phase(uvm_phase phase);
          vif = m_cfg.vif;
        endfunction
//run phase
task ahb_monitor::run_phase(uvm_phase phase);
        forever
                begin
                        collect_data();
                end

endtask

//collect data
task ahb_monitor::collect_data();
  write_xtn xtn;
        xtn = write_xtn::type_id::create("xtn");

        wait(vif.ahb_mon_cb.Htrans == 2'b10 || vif.ahb_mon_cb.Htrans == 2'b11)
         xtn.Htrans = vif.ahb_mon_cb.Htrans;
         xtn.Hwrite = vif.ahb_mon_cb.Hwrite;
         xtn.Hsize  = vif.ahb_mon_cb.Hsize;
         xtn.Haddr  = vif.ahb_mon_cb.Haddr;
         xtn.Hburst = vif.ahb_mon_cb.Hburst;

     @(vif.ahb_mon_cb);
    wait(vif.ahb_mon_cb.Hreadyout)
     if(vif.ahb_mon_cb.Hwrite)
      xtn.Hwdata = vif.ahb_mon_cb.Hwdata;
	else
       xtn.Hrdata = vif.ahb_mon_cb.Hrdata;
      monitor_port.write(xtn);
	  `uvm_info(get_type_name(),$sformatf("Printing from source monitor \n %s",xtn.sprint()),UVM_LOW)
    m_cfg.mon_data_count++;//count should match with driver count to avoid data loss 
/*repeat(2)
@(vif.ahb_mon_cb);
*/
endtask
function void ahb_monitor::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: ahb monitor collect %0d transactions", m_cfg.mon_data_count),UVM_LOW)
endfunction




