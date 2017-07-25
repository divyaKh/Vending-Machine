module vending_machine(clock, reset, coffee, cold_drink, candy, snack, return, product, change, ten_bucks, twenty_bucks, 
cancel);

input clock,reset;                                  
input coffee, cold_drink, candy, snack;
input ten_bucks, twenty_bucks, cancel;    //enter money or cancel product request
output return, change, product;           // return money, return change, give product
reg return, change, product;

//The intermediate signals 
reg [5:0] money_count,snack_count,remaining_amount;
reg bill_paid;
reg [1:0] pres_state;

//states' values
parameter s00=2'b00,
          s10=2'b01,
          s20=2'b10,
          s30=2'b11;

//reg item[3:0];

initial
  begin
  bill_paid=1'b0;
  money_count=6'd0;                  //No. of bits the number takes in binary 
  snack_count=6'd30;
  remaining_amount=6'd0;
end

//@(cancel or twenty_bucks or ten_bucks)

always
   begin   
if(!cancel)
  begin
    case({twenty_bucks,ten_bucks})
	     2'b00:pres_state=s00;
	     2'b01:pres_state=s10;
	     2'b10:pres_state=s20;
	     2'b11:pres_state=s30;
       default:$display("Invalid amount of money entered");
     endcase 
     $display("So the present state is %b",pres_state);
   end
   while(!bill_paid || !snack_count || !cancel )
   begin
   case(pres_state)
	 s00: begin
	      product=1'b0;
        change=6'd0;
	      return=6'd0;                    //7 bits wide: money value to be returned on cancellation of order
        bill_paid=1'b1;
	      snack_count=snack_count-1;
        money_count=6'd0;
        remaining_amount=6'd0;
        $finish;
        end
    
             	
	s10: begin
	     money_count= money_count+ 6'd10;
	     pres_state=nextState(coffee, cold_drink, candy, snack,money_count);
	     end
		

	s20: begin
	     money_count= money_count+ 6'd20;
	     pres_state=nextState(coffee, cold_drink, candy, snack,money_count);
	     end
	     
	s30: begin
	     money_count= money_count+ 6'd30;
	     pres_state=nextState(coffee, cold_drink, candy, snack,money_count);
	     end
	           
  default: $display("My msg: Invalid amount entered! the pres_state is %b",pres_state);
  endcase
 end
 end
  
  
function nextState(coffee, cold_drink, candy, snack, money_count);                                      //the function returns only the next state
reg remaining_amount;
  
begin
 if((candy || snack) && money_count<=30)
	remaining_amount=30-money_count;
	
 else if((coffee || cold_drink) && money_count<=40)
	remaining_amount=40-money_count;

 case(remaining_amount)
    00: nextState= s00;
		10: nextState= s10;
    20: nextState= s20;
		30: nextState= s30;
		default: $display("Invalid amount remaining!!!");
 endcase
		  
end
endfunction

endmodule