////////-Base sequence-----////
class base_sequence_ahb extends uvm_sequence #(write_xtn);

        `uvm_object_utils(base_sequence_ahb)
             
                bit [31:0] haddr;
                bit hwrite;
                bit [2:0] hsize;
                bit [2:0] hburst;
 
        extern function new(string name = "base_sequence_ahb");
endclass

function base_sequence_ahb::new(string name = "base_sequence_ahb");
        super.new(name);
endfunction
////////single transfer////////
class single_transfer extends base_sequence_ahb;

 `uvm_object_utils(single_transfer)


 extern function new(string name = "single_transfer");
        extern task body();
 endclass

function single_transfer::new(string name = "single_transfer");
        super.new(name);
endfunction


task single_transfer::body();
        req = write_xtn::type_id::create("req");
        begin
        start_item(req);
        assert(req.randomize() with {Htrans == 2'b10; Hwrite == 1'b1; Hburst == 3'b000;}); //first xtn is NS
        finish_item(req);

        end

 //store in local variables
        haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
endtask
 

//////////////
  
class undef_transfer extends base_sequence_ahb;


   `uvm_object_utils(undef_transfer)


    extern function new(string name="undef_transfer");
    extern task body();

endclass

function undef_transfer::new(string name="undef_transfer");
   super.new(name);
endfunction

task undef_transfer::body();


   req = write_xtn::type_id::create("req");

   begin
     start_item(req);

     assert(req.randomize() with {Htrans == 2'b10; Hwrite == 1'b1; Hburst == 3'b001;});  //for first beat of the burst which is non-seq

     finish_item(req);


   end



   //storeing xtn varuables to local variables

       haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;

   /***************unspecified length ***********/
if(hburst == 3'b001)

            begin

              for(int i=0; i<req.length-1;i++)

                begin
                 start_item(req);

                  if(hsize == 2'b00)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+1'b1;}); //remaining seq transfers; haddr is increament of previous addr(2^hsize)

                    end


                  if(hsize == 2'b01)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+2'b10;});

                    end

                    if(hsize == 2'b10)
                  begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+3'b100;});

                    end

                    finish_item(req);

                      haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;


                  end
              end
endtask



/************************increment*********************/

class inc_ahb_seq extends base_sequence_ahb;


   `uvm_object_utils(inc_ahb_seq)


    extern function new(string name="inc_ahb_seq");
    extern task body();

endclass

function inc_ahb_seq::new(string name="inc_ahb_seq");
   super.new(name);
endfunction

task inc_ahb_seq::body();

   req = write_xtn::type_id::create("req");

   begin
     start_item(req);

     assert(req.randomize() with {Htrans == 2'b10; Hwrite == 1'b1; Hburst inside {3,5,7};}); //NS

     finish_item(req);


   end


   //storeing xtn varuables to local variables


        haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;

/***************inc-4***********/

        if(hburst == 3'b011)

            begin

              for(int i=0; i<3;i++)

                begin

                  start_item(req);

                  if(hsize == 2'b00)  //8bit=1byte

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);}); //Seq

                    end


                  if(hsize == 2'b01) //16bit=2byte

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});

                    end

                    if(hsize == 2'b10)  //32bit=4byte

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite;Haddr == haddr+(2**hsize);});

                    end

                    finish_item(req);


                            haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;

                  end
              end

 /***************inc-8***********/

        if(hburst == 3'b101)

            begin

              for(int i=0; i<7;i++)

                begin

                  start_item(req);

                  if(hsize == 2'b00)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});

                    end



                  if(hsize == 2'b01)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});

                    end

                    if(hsize == 2'b10)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});

                    end

                    finish_item(req);

                            haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;

                  end
              end

/***************inc-16***********/

        if(hburst == 3'b111)

            begin

              for(int i=0; i<15;i++)

                begin

                  start_item(req);

                  if(hsize == 2'b00)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});

                    end


                  if(hsize == 2'b01)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});

                    end

                    if(hsize == 2'b10)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});

                    end

                    finish_item(req);

                            haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;

                  end
              end

endtask

/************************wrap*********************/

class wrap_ahb_seq extends base_sequence_ahb;


   `uvm_object_utils(wrap_ahb_seq)


    extern function new(string name="wrap_ahb_seq");
    extern task body();

endclass

function wrap_ahb_seq::new(string name="wrap_ahb_seq");
   super.new(name);
endfunction

task wrap_ahb_seq::body();

   req = write_xtn::type_id::create("req");

   begin
     start_item(req);

     assert(req.randomize() with {Htrans == 2'b10; Hwrite == 1'b1; Hburst inside {2,4,6};}); //NS

     finish_item(req);


   end

//storeing xtn varuables to local variables


        haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;

       /***************wrap-4***********/

        if(hburst == 3'b010)

            begin

              for(int i=0; i<3;i++)

                begin

                  start_item(req);

                  if(hsize == 2'b00)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr =={haddr[31:2], {haddr[1:0] + 1'b1}};});

                    end


                  if(hsize == 2'b01)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == {haddr[31:3], {haddr[2:0] + 2'b10}};});

                    end

                    if(hsize == 2'b10)  //32bit =4byte

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == {haddr[31:4], {haddr[3:0] + 3'b100}};});

                    end

                    finish_item(req);

                      haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;

end
              end

       /***************wrap-8***********/

        if(hburst == 3'b100)

            begin

              for(int i=0; i<7;i++)

                begin

                  start_item(req);

                  if(hsize == 2'b00)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr =={haddr[31:2], haddr[1:0] + 1'b1};});

                    end


                  if(hsize == 2'b01)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == {haddr[31:3], haddr[2:0] + 2'b10};});

                    end

                    if(hsize == 2'b10)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == {haddr[31:4], haddr[3:0] + 3'b100};});

                    end

                    finish_item(req);

                      haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;


                  end
              end

/***************wrap-16***********/

        if(hburst == 3'b110)

            begin

              for(int i=0; i<15;i++)

                begin

                  start_item(req);

                  if(hsize == 2'b00)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr =={haddr[31:2], haddr[1:0] + 1'b1};});

                    end


                  if(hsize == 2'b01)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == {haddr[31:3], haddr[2:0] + 2'b10};});

                    end

                    if(hsize == 2'b10)

                    begin

                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == {haddr[31:4], haddr[3:0] + 3'b100};});

                    end

                    finish_item(req);

                      haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;


                  end
              end

endtask

  
