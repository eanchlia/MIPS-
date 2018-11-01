module test();
reg clk_40, reset_40;
Controller cpu (clk_40,reset_40);

initial
begin
    clk_40 <= 0;
    reset_40 <= 0;
    #20
    reset_40 <= 1;

end

always #5 clk_40 = ~clk_40;
 initial
 begin
 $shm_open ( "waves.shm" ) ;
 $shm_probe ( "AS" ) ;
 end

initial begin
#2000 $finish();
end
   
endmodule

