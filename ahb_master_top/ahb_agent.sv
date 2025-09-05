class ahb_agent extends uvm_agent;

`uvm_component_utils(ahb_agent)

ahb_agt_config m_cfg;

ahb_driver drvh;
ahb_sequencer seqrh;
ahb_monitor monh;

extern function new(string name = "ahb_agent",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

//constructor method

function void ahb_agent::connect_phase(uvm_phase phase);
        if(m_cfg.is_active==UVM_ACTIVE)
                begin
                        drvh.seq_item_port.connect(seqrh.seq_item_export);
                end
endfunction


function ahb_agent::new(string name = "ahb_agent",uvm_component parent=null);
super.new(name,parent);
endfunction

//build phase

function void ahb_agent::build_phase(uvm_phase phase);

        super.build_phase(phase);
   // get the config object using uvm_config_db
        if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
        monh=ahb_monitor::type_id::create("monh",this);
        if(m_cfg.is_active==UVM_ACTIVE)
                begin
                        drvh=ahb_driver::type_id::create("drvh",this);
                        seqrh=ahb_sequencer::type_id::create("seqrh",this);
                end

endfunction
