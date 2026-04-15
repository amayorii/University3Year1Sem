with Dining_Table; use Dining_Table;

package Dining_Strategies is
   type Strategy is interface;
   procedure Take_Forks (S : in out Strategy; Id : Integer; T : in out Table_Type) is abstract;
   procedure Put_Forks  (S : in out Strategy; Id : Integer; T : in out Table_Type) is abstract;

   type Hierarchy_Strategy is new Strategy with null record;
   procedure Take_Forks (S : in out Hierarchy_Strategy; Id : Integer; T : in out Table_Type);
   procedure Put_Forks  (S : in out Hierarchy_Strategy; Id : Integer; T : in out Table_Type);

   type Arbitrator_Strategy is new Strategy with record
      Bouncer : Semaphore(4);
   end record;
   procedure Take_Forks (S : in out Arbitrator_Strategy; Id : Integer; T : in out Table_Type);
   procedure Put_Forks  (S : in out Arbitrator_Strategy; Id : Integer; T : in out Table_Type);
end Dining_Strategies;