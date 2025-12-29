class apb_agt_top extends uvm_env;
`uvm_component_utils(apb_agt_top)

apb_agent agnth[];
env_config m_cfg;
extern function new(string name = "apb_agt_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

//constructor method
function apb_agt_top::new(string name = "apb_agt_top",uvm_component parent);
super.new(name,parent);
endfunction

//build method
function void apb_agt_top::build_phase(uvm_phase phase);
super.build_phase(phase);
 if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

agnth = new[m_cfg.no_of_apb_agent];

 foreach(agnth[i])
         begin
                                        // set router_wr_agent_config into the database using the
                                        // router_env_config's router_wr_agent_config object
             agnth[i]=apb_agent::type_id::create($sformatf("agnth[%0d]",i) ,this);

           uvm_config_db #(apb_agt_config)::set(this,$sformatf("agnth[%0d]*",i),  "apb_agt_config", m_cfg.apb_agt_cfg[i]);
end
endfunction


