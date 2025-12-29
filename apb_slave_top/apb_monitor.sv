class apb_monitor extends uvm_monitor;

        `uvm_component_utils(apb_monitor)

        virtual apb_if.APB_MON_MP vif;
        apb_agt_config m_cfg;
 // uvm_analysis_port #(read_xtn) ap_s;
  read_xtn  xtn;

  //methods
        extern function new(string name ="apb_monitor",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task collect_data();
        extern function void report_phase(uvm_phase phase);
endclass

//constructor new method
function apb_monitor::new(string name ="apb_monitor",uvm_component parent);
        super.new(name,parent);
 // create object for handle ap_s using new
  //ap_s=new("ap_s",this);
endfunction

//build_phase
function void apb_monitor::build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(apb_agt_config)::get(this,"","apb_agt_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction


//connect_phase

function void apb_monitor::connect_phase(uvm_phase phase);

      vif=m_cfg.vif;
endfunction
//run phase
task apb_monitor::run_phase(uvm_phase phase);
        forever
                begin
                        collect_data();
                end

endtask

//collect data
task apb_monitor::collect_data();

  read_xtn xtn;
        xtn = read_xtn::type_id::create("xtn");
           wait(vif.apb_mon_cb.Penable)
           $display("apb monitor wait statement");
                xtn.Paddr = vif.apb_mon_cb.Paddr;
                xtn.Pwrite = vif.apb_mon_cb.Pwrite; 
                xtn.Pselx = vif.apb_mon_cb.Pselx;
        if(xtn.Pwrite == 0)
		xtn.Prdata = vif.apb_mon_cb.Prdata; //collect data
        else
                xtn.Pwdata = vif.apb_mon_cb.Pwdata;

        @(vif.apb_mon_cb); 
    //  monitor_port.write(xtn);
         m_cfg.mon_data_count++;
  `uvm_info(get_type_name(),$sformatf("Printing from source monitor \n %s",xtn.sprint()),UVM_LOW)
 
	
endtask
//report phasse
function void apb_monitor::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: ahb monitor collect %0d transactions", m_cfg.mon_data_count),UVM_LOW)
endfunction





