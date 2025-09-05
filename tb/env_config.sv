class env_config extends uvm_object;
 `uvm_object_utils(env_config);
bit has_wagent = 1;
bit has_ragent = 1;
int no_of_ahb_agent = 1;
int no_of_apb_agent = 1;
bit has_virtual_sequencer =1;
bit has_scoreboard = 1;
ahb_agt_config ahb_agt_cfg[];
apb_agt_config apb_agt_cfg[];

extern function new(string name = "env_config");
endclass
function env_config::new(string name = "env_config");
 super.new(name);
endfunction

