package body Dining_Table is

   protected body Semaphore is
      entry Wait when Count > 0 is
      begin
         Count := Count - 1;
      end Wait;

      procedure Signal is
      begin
         Count := Count + 1;
      end Signal;
   end Semaphore;

   procedure Get_Fork (T : in out Table_Type; Id : Integer) is
   begin
      T.Forks(Id).Wait;
   end Get_Fork;

   procedure Put_Fork (T : in out Table_Type; Id : Integer) is
   begin
      T.Forks(Id).Signal;
   end Put_Fork;

end Dining_Table;