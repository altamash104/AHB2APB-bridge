class test extends uvm_test;

`uvm_component_utils(test)

//parameters
ahb_sequencer seqrh;
ahb_agt_top ahb_top;
base_sequence_ahb seqh;

env envh;
env_config e_cfg;
ahb_agt_config ahb_cfg[];
apb_agt_config apb_cfg[];
bit has_ragent=1;
bit has_wagent=1;
int no_of_apb_agent=1;
int no_of_ahb_agent=1;

extern function new (string name="test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void config_bridge();
extern function void end_of_elaboration_phase(uvm_phase phase);
//extern task run_phase(uvm_phase phase);
endclass

function test::new(string name="test",uvm_component parent);
        super.new(name,parent);
endfunction

function void test::build_phase(uvm_phase phase);
        super.build_phase(phase);
e_cfg = env_config::type_id::create("e_cfg");
//create env_config object
if(has_wagent)
        e_cfg.ahb_agt_cfg=new[no_of_ahb_agent];
if(has_ragent)
        e_cfg.apb_agt_cfg=new[no_of_apb_agent];
config_bridge();

        uvm_config_db #(env_config)::set(this,"*","env_config",e_cfg);
 envh=env::type_id::create("envh",this);
 //      `uvm_info("TEST", "i am in the build phase of driver",UVM_LOW);
endfunction

function void test::config_bridge();
//creating write & rd agent
if(has_wagent)
        begin
        ahb_cfg=new[no_of_ahb_agent];
        foreach(ahb_cfg[i])
                begin
                        ahb_cfg[i]=ahb_agt_config::type_id::create($sformatf("ahb_cfg[%0d]",i));

                       if(!uvm_config_db #(virtual ahb_if)::get(this,"","vif",ahb_cfg[i].vif))
                        `uvm_fatal("VIF CONFIG- WRITE","cannot get() interface from uvm_config_db.have you set() it?")
                         ahb_cfg[i].is_active=UVM_ACTIVE;
                        e_cfg.ahb_agt_cfg[i]=ahb_cfg[i];
end
end


 if(has_ragent)
          begin
          apb_cfg=new[no_of_apb_agent];
          foreach(apb_cfg[i])
                 begin
                          apb_cfg[i]=apb_agt_config::type_id::create($sformatf("apb_cfg[%0d]",i));

                          if(!uvm_config_db #(virtual apb_if)::get(this,"","vif",apb_cfg[i].vif))
                          `uvm_fatal("VIF CONFIG- READ","cannot get() interface from uvm_config_db.have you set() it?")
                           apb_cfg[i].is_active=UVM_ACTIVE;
                          e_cfg.apb_agt_cfg[i]=apb_cfg[i];
 end
 end
e_cfg.has_ragent=has_ragent;
e_cfg.has_wagent=has_wagent;
e_cfg.no_of_apb_agent=no_of_apb_agent;
e_cfg.no_of_ahb_agent=no_of_ahb_agent;

endfunction

function void test::end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
endfunction

/*
//-----------------  run() phase method  -------------------//
task test::run_phase(uvm_phase phase);
	//raise objection
    phase.raise_objection(this);
	//create instance for sequence
//    seqrh=write_xtn::type_id::create("seqrh");
	//start the sequence 
  seqh = ahb_sequence::type_id::create("seqh");
        seqh.start(envh.ahb_top.agnth[0].seqrh);
   // seqh.start(envh.ahb_top.seqrh);
	//drop objection
    phase.drop_objection(this);
	endtask
*/



class test_1 extends test;

  `uvm_component_utils(test_1)

  single_transfer s_seq;

  extern function new (string name="test_1",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass


function test_1::new(string name="test_1",uvm_component parent);
        super.new(name,parent);
endfunction

function void test_1::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task test_1::run_phase(uvm_phase phase);
        phase.raise_objection(this);
        s_seq=single_transfer::type_id::create("s_seq");


          begin
             //envh.ahb_top.agnth[0].seqrh
            foreach(envh.ahb_top.agnth[i])
            s_seq.start(envh.ahb_top.agnth[i].seqrh);
                #100;
          end


        phase.drop_objection(this);
endtask


class test_2 extends test;

  `uvm_component_utils(test_2)

  undef_transfer un_seq;

  extern function new (string name="test_2",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass


function test_2::new(string name="test_2",uvm_component parent);
        super.new(name,parent);
endfunction

function void test_2::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task test_2::run_phase(uvm_phase phase);
        phase.raise_objection(this);



        un_seq=undef_transfer::type_id::create("un_seq");


          begin
            foreach(envh.ahb_top.agnth[i])
            un_seq.start(envh.ahb_top.agnth[i].seqrh);
            #100;
          end


        phase.drop_objection(this);
endtask

class test_3 extends test;

 `uvm_component_utils(test_3)

  inc_ahb_seq i_seq;

  extern function new (string name="test_3",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass

function test_3::new(string name="test_3",uvm_component parent);
        super.new(name,parent);
endfunction

function void test_3::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task test_3::run_phase(uvm_phase phase);
        phase.raise_objection(this);



        i_seq=inc_ahb_seq::type_id::create("i_seq");


          begin
            foreach(envh.ahb_top.agnth[i])
            i_seq.start(envh.ahb_top.agnth[i].seqrh);
            #100;
          end

        phase.drop_objection(this);
endtask


class test_4 extends test;

 `uvm_component_utils(test_4)

  wrap_ahb_seq w_seq;

  extern function new (string name="test_4",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass


function test_4::new(string name="test_4",uvm_component parent);
        super.new(name,parent);
endfunction

function void test_4::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task test_4::run_phase(uvm_phase phase);
        phase.raise_objection(this);



        w_seq=wrap_ahb_seq::type_id::create("w_seq");


          begin
            foreach(envh.ahb_top.agnth[i])
            w_seq.start(envh.ahb_top.agnth[i].seqrh);
            #100;
          end


        phase.drop_objection(this);
endtask



