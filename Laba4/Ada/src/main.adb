with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with GNAT.Semaphores; use GNAT.Semaphores;

procedure Main is
   Philosophers_Count : constant Integer := 5;
   Screen_Lock : Counting_Semaphore (1, Default_Ceiling);

   -- THE TABLE PACKAGE
   package Table is
      -- Create an Enum for our choices
      type Strategy_Choice is (Arbitrator_Rule, Hierarchy_Rule);
      
      -- Add a setup procedure so Main can choose
      procedure Initialize (Choice : Strategy_Choice);
      
      procedure Take_Forks (Id : Integer);
      procedure Put_Forks (Id : Integer);
   end Table;

   package body Table is
      Forks   : array (0 .. Philosophers_Count - 1) of Counting_Semaphore (1, Default_Ceiling);
      Bouncer : Counting_Semaphore (4, Default_Ceiling);
      
      -- A private variable to remember what Main chose
      Current_Strategy : Strategy_Choice := Arbitrator_Rule;

      procedure Initialize (Choice : Strategy_Choice) is
      begin
         Current_Strategy := Choice;
      end Initialize;

      procedure Take_Forks (Id : Integer) is
         Left_Fork  : constant Integer := (Id + 1) mod Philosophers_Count;
         Right_Fork : constant Integer := Id;
      begin
         case Current_Strategy is
            when Arbitrator_Rule =>
               Bouncer.Seize;
               Forks(Right_Fork).Seize;
               Forks(Left_Fork).Seize;
               
            when Hierarchy_Rule =>
               if Id = Philosophers_Count - 1 then
                  Forks(Left_Fork).Seize;  -- Reverse order for the last guy
                  Forks(Right_Fork).Seize;
               else
                  Forks(Right_Fork).Seize;
                  Forks(Left_Fork).Seize;
               end if;
         end case;
      end Take_Forks;

      procedure Put_Forks (Id : Integer) is
         Left_Fork  : constant Integer := (Id + 1) mod Philosophers_Count;
         Right_Fork : constant Integer := Id;
      begin
         case Current_Strategy is
            when Arbitrator_Rule =>
               Forks(Left_Fork).Release;
               Forks(Right_Fork).Release;
               Bouncer.Release;
               
            when Hierarchy_Rule =>
               if Id = Philosophers_Count - 1 then
                  Forks(Right_Fork).Release;
                  Forks(Left_Fork).Release;
               else
                  Forks(Left_Fork).Release;
                  Forks(Right_Fork).Release;
               end if;
         end case;
      end Put_Forks;
   end Table;

   -- THE PHILOSOPHER TASK
   task type Philosopher is
      entry Start (Id : Integer); 
   end Philosopher;

   task body Philosopher is
      My_Id : Integer;
      Gen   : Generator; 
   begin
      Reset (Gen); 
      
      accept Start (Id : Integer) do
         My_Id := Id;
      end Start;

      for I in 1 .. 10 loop
         -- Thinking
         Screen_Lock.Seize;
         Put_Line ("Philosopher" & Integer'Image(My_Id) & " is thinking " & Integer'Image(I) & " times");
         Screen_Lock.Release;
         delay Duration (Random (Gen) * 0.1); 

         Table.Take_Forks(My_Id);

         -- Eating
         Screen_Lock.Seize;
         Put_Line ("Philosopher" & Integer'Image(My_Id) & " is eating " & Integer'Image(I) & " times");
         Screen_Lock.Release;
         delay Duration (Random (Gen) * 0.1);

         Table.Put_Forks(My_Id);
      end loop;
   end Philosopher;

   Phils : array (0 .. Philosophers_Count - 1) of Philosopher;
begin
   --  Table.Initialize (Table.Hierarchy_Rule);
   Table.Initialize (Table.Arbitrator_Rule);
   
   for I in 0 .. Philosophers_Count - 1 loop
      Phils(I).Start (I);
   end loop;
end Main;