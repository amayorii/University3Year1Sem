with Ada.Text_IO; use Ada.Text_IO;

package body Dining_Philosophers is

   protected body Screen is
      procedure Print_Thinking (Id : Integer; Iteration : Integer) is
      begin
         Put_Line ("Philosopher" & Integer'Image(Id) & " is thinking " & Integer'Image(Iteration) & " times");
      end Print_Thinking;

      procedure Print_Eating (Id : Integer; Iteration : Integer) is
      begin
         Put_Line ("Philosopher" & Integer'Image(Id) & " is eating " & Integer'Image(Iteration) & " times");
      end Print_Eating;
   end Screen;

   task body Philosopher is
   begin
      for I in 1 .. 10 loop
         Screen.Print_Thinking (Id, I);
         Strat.Take_Forks (Id, T.all);
         
         Screen.Print_Eating (Id, I);
         Strat.Put_Forks (Id, T.all);
      end loop;
   end Philosopher;

end Dining_Philosophers;