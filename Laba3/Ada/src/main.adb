with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Semaphores; use GNAT.Semaphores;
with System;
with Ada.Unchecked_Deallocation;

procedure Main is
   Cons_Amount : constant Integer := 3;
   Prod_Amount : constant Integer := 2;
   Storage_Size     : constant Integer := 3;
   Items_Needed     : constant Integer := 20;

   type Storage_Array is array (1 .. Storage_Size) of Integer;

   --------------------------------------------------------
   -- Глобальні змінні для буфера та лічильника
   --------------------------------------------------------
   Storage      : Storage_Array;
   Head         : Integer := 1;
   Tail         : Integer := 1;
   Current_Item : Integer := 0;

   --------------------------------------------------------
   -- Семафори
   --------------------------------------------------------
   -- Семафор для перевірки наявності вільного місця
   Empty_Storage : Counting_Semaphore (Storage_Size, System.Default_Priority);
   
   -- Семафор для перевірки наявності готових товарів
   Full_Storage  : Counting_Semaphore (0, System.Default_Priority);
   
   -- М'ютекси (лічильні семафори з ініціалізацією 1) для критичних секцій
   Access_Mutex  : Counting_Semaphore (1, System.Default_Priority);
   Counter_Mutex : Counting_Semaphore (1, System.Default_Priority);

   --------------------------------------------------------
   -- Оголошення типів потоків
   --------------------------------------------------------
   task type Producer (Index : Integer; Quota : Integer);
   task type Consumer (Index : Integer; Quota : Integer);

   task body Producer is
      Item_To_Put : Integer;
   begin
      for I in 1 .. Quota loop
         Counter_Mutex.Seize;
         Item_To_Put := Current_Item;
         Current_Item := Current_Item + 1;
         Counter_Mutex.Release;

         Empty_Storage.Seize;
         Access_Mutex.Seize; 

         Storage (Tail) := Item_To_Put;
         Tail := (Tail mod Storage_Size) + 1;
         
         Put_Line ("Producer" & Integer'Image (Index) & " added item" & Integer'Image (Item_To_Put));

         Access_Mutex.Release; 
         Full_Storage.Release; 
      end loop;
   end Producer;

   task body Consumer is
      Item_To_Get : Integer;
   begin
      for I in 1 .. Quota loop
         delay 1.0;
         
         Full_Storage.Seize;
         Access_Mutex.Seize;

         Item_To_Get := Storage (Head);
         Head := (Head mod Storage_Size) + 1;
         
         Put_Line ("Consumer" & Integer'Image (Index) & " took item" & Integer'Image (Item_To_Get));

         Access_Mutex.Release;
         Empty_Storage.Release;
      end loop;
   end Consumer;

   --------------------------------------------------------
   -- Головний блок ініціалізації
   --------------------------------------------------------
   type Producer_Access is access Producer;
   type Consumer_Access is access Consumer;

   -- Створюємо процедуру для звільнення пам'яті Producer
   procedure Free_Producer is new Ada.Unchecked_Deallocation
     (Object => Producer,
      Name   => Producer_Access);

   -- Створюємо процедуру для звільнення пам'яті Consumer
   procedure Free_Consumer is new Ada.Unchecked_Deallocation
     (Object => Consumer,
      Name   => Consumer_Access);

   Producers : array (0 .. Prod_Amount - 1) of Producer_Access;
   Consumers : array (0 .. Cons_Amount - 1) of Consumer_Access;

   Temp_Chunk_Prod : Integer;
   Temp_Chunk_Con  : Integer;
   Remainder_Prod  : Integer;
   Remainder_Con   : Integer;
   Chunk           : Integer;

begin
   Temp_Chunk_Prod := Items_Needed / Prod_Amount;
   Temp_Chunk_Con  := Items_Needed / Cons_Amount;
   Remainder_Prod  := Items_Needed mod Prod_Amount;
   Remainder_Con   := Items_Needed mod Cons_Amount;

   for I in 0 .. Prod_Amount - 1 loop
      if I = Prod_Amount - 1 then
         Chunk := Temp_Chunk_Prod + Remainder_Prod;
      else
         Chunk := Temp_Chunk_Prod;
      end if;

      Producers (I) := new Producer (Index => I, Quota => Chunk);
   end loop;

   for I in 0 .. Cons_Amount - 1 loop
      if I = Cons_Amount - 1 then
         Chunk := Temp_Chunk_Con + Remainder_Con;
      else
         Chunk := Temp_Chunk_Con;
      end if;

      Consumers (I) := new Consumer (Index => I, Quota => Chunk);
   end loop;

   -- Чекаємо завершення та звільняємо Продюсерів
   for I in Producers'Range loop
      -- Цикл очікування: поки потік НЕ завершений, чекаємо 0.1 секунди
      while not Producers (I)'Terminated loop
         delay 0.1;
      end loop;
      
      -- Тепер безпечно звільняємо пам'ять
      Free_Producer (Producers (I));
   end loop;

   -- Чекаємо завершення та звільняємо Консюмерів
   for I in Consumers'Range loop
      -- Цикл очікування
      while not Consumers (I)'Terminated loop
         delay 0.1;
      end loop;
      
      -- Тепер безпечно звільняємо пам'ять
      Free_Consumer (Consumers (I));
   end loop;

end Main;