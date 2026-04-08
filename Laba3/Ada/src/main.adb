with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   Cons_Prod_Amount : constant Integer := 3;
   Storage_Size     : constant Integer := 3;
   Items_Needed     : constant Integer := 20;

   --------------------------------------------------------
   -- ВИПРАВЛЕННЯ ПОМИЛКИ: Оголошуємо іменований тип масиву
   --------------------------------------------------------
   type Storage_Array is array (1 .. Storage_Size) of Integer;

   --------------------------------------------------------
   -- 1. Захищений об'єкт "Склад"
   --------------------------------------------------------
   protected Buffer is
      -- ВИПРАВЛЕННЯ СТИЛЮ: прибрано слово 'in'
      entry Put (Item : Integer);
      entry Get (Item : out Integer);
   private
      -- Використовуємо іменований тип замість анонімного
      Storage : Storage_Array;
      Head    : Integer := 1;
      Tail    : Integer := 1;
      Count   : Integer := 0;
   end Buffer;

   protected body Buffer is
      entry Put (Item : Integer) when Count < Storage_Size is
      begin
         Storage (Tail) := Item;
         Tail := (Tail mod Storage_Size) + 1;
         Count := Count + 1;
      end Put;

      entry Get (Item : out Integer) when Count > 0 is
      begin
         Item := Storage (Head);
         Head := (Head mod Storage_Size) + 1;
         Count := Count - 1;
      end Get;
   end Buffer;

   --------------------------------------------------------
   -- 2. Захищений лічильник
   --------------------------------------------------------
   protected Item_Counter is
      procedure Get_Next (Item : out Integer);
   private
      Current_Item : Integer := 0;
   end Item_Counter;

   protected body Item_Counter is
      procedure Get_Next (Item : out Integer) is
      begin
         Item := Current_Item;
         Current_Item := Current_Item + 1;
      end Get_Next;
   end Item_Counter;

   --------------------------------------------------------
   -- 3. Оголошення типів потоків
   --------------------------------------------------------
   task type Producer (Index : Integer; Quota : Integer);
   task type Consumer (Index : Integer; Quota : Integer);

   task body Producer is
      Item_To_Put : Integer;
   begin
      for I in 1 .. Quota loop
         Item_Counter.Get_Next (Item_To_Put);
         Buffer.Put (Item_To_Put);
         
         -- ВИПРАВЛЕННЯ СТИЛЮ: пробіли перед дужками після Image
         Put_Line ("Producer" & Integer'Image (Index) & " added item" & Integer'Image (Item_To_Put));
      end loop;
   end Producer;

   task body Consumer is
      Item_To_Get : Integer;
   begin
      for I in 1 .. Quota loop
         delay 1.0;
         
         Buffer.Get (Item_To_Get);
         Put_Line ("Consumer" & Integer'Image (Index) & " took item" & Integer'Image (Item_To_Get));
      end loop;
   end Consumer;

   --------------------------------------------------------
   -- 4. Головний блок ініціалізації
   --------------------------------------------------------
   type Producer_Access is access Producer;
   type Consumer_Access is access Consumer;

   Producers : array (0 .. Cons_Prod_Amount - 1) of Producer_Access;
   Consumers : array (0 .. Cons_Prod_Amount - 1) of Consumer_Access;

   Temp_Chunk : Integer;
   Remainder  : Integer;
   Chunk      : Integer;

begin
   Temp_Chunk := Items_Needed / Cons_Prod_Amount;
   Remainder  := Items_Needed mod Cons_Prod_Amount;

   for I in 0 .. Cons_Prod_Amount - 1 loop
      if I = Cons_Prod_Amount - 1 then
         Chunk := Temp_Chunk + Remainder;
      else
         Chunk := Temp_Chunk;
      end if;

      Producers (I) := new Producer (Index => I, Quota => Chunk);
      Consumers (I) := new Consumer (Index => I, Quota => Chunk);
   end loop;

end Main;