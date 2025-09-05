class apb_agent extends uvm_agent;
`uvm_component_utils(apb_agent)

apb_agt_config m_cfg;

apb_driver drvh;
apb_monitor monh;
//apb_sequencer seqrh;

extern function new(string name = "apb_agent",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
// extern function void connect_phase(uvm_phase phase);

endclass

//constructor method

function apb_agent::new(string name = "apb_agent",uvm_component parent=null);
super.new(name,parent);
endfunction

//build phase

function void apb_agent::build_phase(uvm_phase phase);

        super.build_phase(phase);
   // get the config object using uvm_config_db
        if(!uvm_config_db #(apb_agt_config)::get(this,"","apb_agt_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
        monh=apb_monitor::type_id::create("monh",this);
        if(m_cfg.is_active==UVM_ACTIVE)
                begin
                        drvh=apb_driver::type_id::create("drvh",this);
                        //seqrh=apb_sequencer::type_id::create("seqrh",this);
                end

endfunction
/*
//  connect  method

function void apb_agent::connect_phase(uvm_phase phase);
        if(m_cfg.is_active==UVM_ACTIVE)
                begin
                        drvh.seq_item_port.connect(seqrh.seq_item_export);
                end
endfunction
*/
