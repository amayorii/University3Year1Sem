package Dining_Table is
   Philosophers_Count : constant Integer := 5;

   protected type Semaphore (Initial_Count : Natural) is
      entry Wait;
      procedure Signal;
   private
      Count : Natural := Initial_Count;
   end Semaphore;

   type Fork_Array is array (0 .. Philosophers_Count - 1) of Semaphore(1);
   
   type Table_Type is tagged record
      Forks : Fork_Array;
   end record;

   procedure Get_Fork (T : in out Table_Type; Id : Integer);
   procedure Put_Fork (T : in out Table_Type; Id : Integer);
end Dining_Table;