class write_xtn extends uvm_sequence_item;

        `uvm_object_utils(write_xtn)

      //properties
        rand bit Hwrite;
	rand bit [2:0] Hsize;
        rand bit [1:0] Htrans;
        rand bit [31:0] Haddr;
        rand bit [2:0] Hburst;
    
        rand bit [31:0] Hwdata;
       logic [31:0] Hrdata; //unspecified length
        rand bit [9:0] length;

        constraint valid_hsize {Hsize inside {[0:2]};} 
	constraint valid_haddr {Hsize == 1 -> Haddr % 2 == 0;
                               Hsize == 2 -> Haddr % 4 == 0;}
	constraint valid_length {(2**Hsize) * length <= 1024;}

	
       	constraint haddr_range {Haddr inside {[0:1000]};} 
       
	constraint hwdata_range{Hwdata inside {[0:100]};}

    /*    constraint haddr_range {Haddr inside {[32'h8000_0000 : 32'h8000_03ff],
                                               [32'h8400_0000 : 32'h8400_03ff],
                                               [32'h8800_0000 : 32'h8800_03ff],
                                               [32'h8c00_0000 : 32'h8c00_03ff]};} */
        extern function void do_print(uvm_printer printer);
//	extern function bit do_compare(uvm_object rhs,uvm_comparer comparer);

endclass

function void write_xtn::do_print(uvm_printer printer);
        super.do_print(printer);

        printer.print_field("Haddr", this.Haddr, 32, UVM_HEX);
        printer.print_field("Hwdata", this.Hwdata, 32, UVM_HEX);
        printer.print_field("Hwrite", this.Hwrite, 1, UVM_DEC);
        printer.print_field("Htrans", this.Htrans, 2, UVM_DEC);
        printer.print_field("Hsize", this.Hsize, 2, UVM_DEC);
        printer.print_field("Hburst", this.Hburst, 3, UVM_HEX);


endfunction

/*function bit write_xtn::do_compare(uvm_object rhs,uvm_comparer comparer);
counter_trans rhs_;
if(!cast(rhs_,rhs))begin
`uvm_fatal("do_compare","cast of the rhs object failed")
return 0;
end

return.super.do_compare(rhs,comparer)&&(data_out == rhs_.data_out);
endfunction*/
