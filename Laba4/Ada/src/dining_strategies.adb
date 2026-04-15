package body Dining_Strategies is

   -- Hierarchy Strategy
   procedure Take_Forks (S : in out Hierarchy_Strategy; Id : Integer; T : in out Table_Type) is
   begin
      if Id = Philosophers_Count - 1 then
         T.Get_Fork ((Id + 1) mod Philosophers_Count);
         T.Get_Fork (Id);
      else
         T.Get_Fork (Id);
         T.Get_Fork ((Id + 1) mod Philosophers_Count);
      end if;
   end Take_Forks;

   procedure Put_Forks (S : in out Hierarchy_Strategy; Id : Integer; T : in out Table_Type) is
   begin
      if Id = Philosophers_Count - 1 then
         T.Put_Fork (Id);
         T.Put_Fork ((Id + 1) mod Philosophers_Count);
      else
         T.Put_Fork ((Id + 1) mod Philosophers_Count);
         T.Put_Fork (Id);
      end if;
   end Put_Forks;

   -- Arbitrator Strategy
   procedure Take_Forks (S : in out Arbitrator_Strategy; Id : Integer; T : in out Table_Type) is
   begin
      S.Bouncer.Wait;
      T.Get_Fork (Id);
      T.Get_Fork ((Id + 1) mod Philosophers_Count);
   end Take_Forks;

   procedure Put_Forks (S : in out Arbitrator_Strategy; Id : Integer; T : in out Table_Type) is
   begin
      T.Put_Fork ((Id + 1) mod Philosophers_Count);
      T.Put_Fork (Id);
      S.Bouncer.Signal;
   end Put_Forks;

end Dining_Strategies;