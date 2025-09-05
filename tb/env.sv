class env extends uvm_env;
 `uvm_component_utils(env)

ahb_agt_top ahb_top;
apb_agt_top apb_top;
//virtual_sequencer v_sequencer;
scoreboard sb;
env_config m_cfg;
  extern function new(string name = "env",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

 endclass 
//constructor method
function env::new(string name = "env",uvm_component parent);
 super.new(name,parent);
endfunction

//build method
function void env::build_phase(uvm_phase phase);
super.build_phase(phase);
 if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
`uvm_fatal("CONFIG","cannot get() the m_cfg from uvm_config_db.have you set() it")

if(m_cfg.has_wagent)
     begin
      ahb_top=ahb_agt_top::type_id::create("ahb_top",this);
    end

if(m_cfg.has_ragent)
   begin
     apb_top=apb_agt_top::type_id::create("apb_top",this);
  end

/*if(m_cfg.has_virtual_sequencer)
   begin
     v_sequencer=virtual_sequencer::type_id::create("v_sequencer",this);
    end
*/
if(m_cfg.has_scoreboard)
   begin
     sb=scoreboard::type_id::create("sb",this);
   end

endfunction 

function void env::connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 ahb_top.agnth[0].monh.monitor_port.connect(sb.fifo_ahb.analysis_export);
 apb_top.agnth[0].monh.ap_s.connect(sb.fifo_apb.analysis_export);
endfunction


