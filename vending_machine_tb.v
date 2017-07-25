module vending_machine_tb;
reg Clock, Reset, Coffee, Cold_drink, Candy, Snack, Ten_bucks, Twenty_bucks, Cancel;
wire  Return, Product, Change;
parameter delay=7'd50;

vending_machine vm(Clock, Reset, Coffee, Cold_drink, Candy, Snack, Return, Product, Change, Ten_bucks, Twenty_bucks, 
Cancel);

/*We will force the inputs of money while compling (Ten_bucks, Twenty_bucks, Cancel) */

initial 
begin
Reset=1'b0;  
Clock=1'b0;
forever #10 Clock=~Clock;
$display("Here's our clock");
$monitor(Clock);
end

always@(posedge Clock)
begin
  Coffee=1'b1; 
 #delay resetAllInputs;
 Cold_drink=1'b1; 
 #delay resetAllInputs;
 Candy=1'b1; 
 #delay resetAllInputs;
 Snack=1'b1; 
 #delay resetAllInputs;
end  

task resetAllInputs;                     //the task can directly operate on the reg varibles defined in the module
  begin
    Coffee=1'b0;
    Cold_drink=1'b0;
    Candy=1'b0;
    Snack=1'b0;
  end  
endtask
  
endmodule
