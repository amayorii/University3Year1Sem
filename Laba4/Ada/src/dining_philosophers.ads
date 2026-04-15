with Dining_Table; use Dining_Table;
with Dining_Strategies; use Dining_Strategies;

package Dining_Philosophers is
   protected Screen is
      procedure Print_Thinking (Id : Integer; Iteration : Integer);
      procedure Print_Eating (Id : Integer; Iteration : Integer);
   end Screen;

   task type Philosopher (Id : Integer; T : not null access Table_Type; Strat : not null access Strategy'Class);
end Dining_Philosophers;