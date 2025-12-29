class apb_sequence extends uvm_sequence;

 `uvm_object_utils(apb_sequence)

extern function new(string name="apb_sequence");

endclass

function apb_seq::new(string name="apb_sequence");
   super.new(name);
endfunction

