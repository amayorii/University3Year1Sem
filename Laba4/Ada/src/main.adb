with Dining_Table; use Dining_Table;
with Dining_Strategies; use Dining_Strategies;
with Dining_Philosophers; use Dining_Philosophers;

procedure Main is
   My_Table    : aliased Table_Type;
   My_Strategy : aliased Arbitrator_Strategy;

   type Phil_Ptr is access Philosopher;
   Phils : array (0 .. Philosophers_Count - 1) of Phil_Ptr;
begin
   for I in 0 .. Philosophers_Count - 1 loop
      Phils(I) := new Philosopher(I, My_Table'Access, My_Strategy'Access);
   end loop;
end Main;