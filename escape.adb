----------------------------------
--Name: Adam H. Kevin E. Tim W.
--Class: Csci 324
--Project: Escape (Ada Creative)
----------------------------------

--*********************************************--
-- Lots of alterations were made since we submitted on Tuesday, 4/27. 
-- Essentially implemented the whole program
-- We removed some scaffolding that we did not use
-- Implemented all procedures
-- Wrote up the rest of the storyboard
-- our previous saveState.txt is now renamed "state1.txt/state2.txt/etc.."
-- also added "out.txt" as a txt file to write to
--*********************************************--

with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;
with week;
with bag;
with ada.numerics.discrete_random;
with misc;

procedure escape is -- *** renamed "Main" to "escape" 
   -- *** declared types in their respective package files (.ads)
   --*** start of declaration changes
   use week;
   --use items;
   use bag;
   use misc;

   Head :  Node_Ptr;
   today : Days;

   try_again : exception;
   chances : Integer := 9;

   type files is array(1..4) of String(1..10);
   f_name : files := ("state2.txt", "state3.txt", "state4.txt", "state5.txt");

   type randRange is range 1..4; --random number
   --***end of declaration changes

   State : Integer;
   Mood : Psyche;
   Anger : stat;
   Hunger : stat;
   Sleep : stat;
   Perception: stat;
   Sanity : stat;
   Count : Integer;
   Dead : Boolean := false;
   Won : Boolean := false;
   input : Character; --change to unbounded string;

   procedure write is --updates new stats to the output textfile
   -- *** NEW: wrote entire write procedure
      F : File_Type;
   begin
      Open (File => F,
            Name => "out.txt",
            Mode => Ada.Text_IO.Out_File);
      Put_Line(F, "State:" & state'Image);
      Put_Line(F, "Count:" & count'Image);
      Put_Line(F, "Psyche: " & Mood'Image);
      Put_Line(F, "Bag: " & getBag(head));
      Put_Line(F, "Day: " & today'Image);
      Put_Line(F, "Anger:" & Anger'Image);
      Put_Line(F, "Hunger:" & Hunger'Image);
      Put_Line(F, "Sleep:" & Sleep'Image);
      Put_Line(F, "Perception:" & Perception'Image);
      Put_Line(F, "Sanity:" & Sanity'Image);
      Close(F);
   end write;

   procedure read (File_Name: String) is --reads from textfile, assigns variables from stats given
      --- *** NEW: wrote the entire read procedure
    
      lastcommaindex : Integer := 0;
      temp_item: Unbounded_String;
      temporary : Unbounded_String;
      temp_item_count: Unbounded_String;
      temp_close_paren : Integer;
      temp_open_paren : Integer;

      item_count : Integer;
      item_add : Item;
        
      line : Unbounded_String;
      first : Unbounded_String;
      last : Unbounded_String;
      
      F : File_Type;
        
   begin

      Open (F, In_File, File_Name);
      while not End_Of_File (F) loop --move thru file
         line := To_Unbounded_String(Get_Line(F));
         for i in 1..length(line) loop --move thru chars of first line
            if To_String(line)(i) = ':' then --check for ":" parse first and last parts of string
               first := To_Unbounded_String(To_String(line)(1..(i-1)));
               last := To_Unbounded_String(To_String(line)((i+2)..length(line))); --i+2 to skip ": 
               
               if first = "State" then 
                  State := Integer'Value(To_String(last));
                        
               end if;

               if first = "Count" then --check for ints
                  Count := Integer'Value(To_String(last));

               elsif first = "Anger" then
                  Anger := Integer'Value(To_String(last));

               elsif first = "Hunger" then
                  Hunger := Integer'Value(To_String(last));

               elsif first = "Sleep" then
                  Sleep := Integer'Value(To_String(last));

                        
               elsif first = "Perception" then
                  Perception := Integer'Value(To_String(last));

               elsif first = "Sanity" then
                  Sanity := Integer'Value(To_String(last));

               end if; --end checking for ints

               if first = "Psyche" then
                  Mood := stringToPsyche(To_String(last));

               end if;

               if first = "Day" then
                  today := stringToDays(To_String(last)); --return last

               end if;

               if first = "Bag" then
                    
                  --modifiy last "Pill, Knife" --also assume proper read syntax => "Pill" "Knife"
                  for i in 1..length(last) loop
                
                     if To_String(last)(i) = ',' then --check for "," substring before + after

                        temp_item := To_Unbounded_String(To_String(last)(lastcommaindex+1..(i-1))); 
                               
                                
                        for j in 1 .. length(temp_item)  loop
                           if To_String(temp_item)(j) = '(' then -- (34) j - temp_item(i-1)
                                    
                              temp_open_paren := j;
                           end if;
                           if To_String(temp_item)(j) = ')' then -- (34) j - temp_item(i-1)
                              temp_close_paren := j;
                              temp_item_count := To_Unbounded_String(To_String(temp_item)(temp_open_paren+1 .. temp_close_paren-1)); --unbounded string

                              temporary := To_Unbounded_String(To_String(temp_item)(1..temp_open_paren-1));
                                                        
                              temp_item := temporary;
                                        
                           end if;
                        end loop; --end for
                                
                                
                        item_add := stringToItem(To_String(temp_item)); --convert to item --looks like Pill(3)
                        item_count := Integer'Value(To_String(temp_item_count));

                        addItem(item_add, item_count, head); --add


                        lastcommaindex := i+1;
                            
                     end if;

                     if i = length(last) then --last element
                                
                        temp_item := To_Unbounded_String(To_String(last)((lastcommaindex+1)..length(last))); --i+1 to skip ": "

                        for j in 1 .. length(temp_item)  loop
                                
                           if To_String(temp_item)(j) = '(' then -- (34) j - temp_item(i-1)
                                        
                              temp_open_paren := j;

                           end if;

                           if To_String(temp_item)(j) = ')' then -- (34) j - temp_item(i-1)
                              temp_close_paren := j;
                              temp_item_count := To_Unbounded_String(To_String(temp_item)(temp_open_paren+1 .. temp_close_paren-1)); --unbounded string

                           end if;
                        end loop; --end for

                        --add bag 

                        temp_item := To_Unbounded_String(To_String(temp_item)(1..temp_open_paren-1));
                                
                        item_add := stringToItem(To_String(temp_item)); --convert to item --looks like Pill(3)
                        item_count := Integer'Value(To_String(temp_item_count));
                        addItem(item_add, item_count, head); --add

                     end if; --last element

                  end loop; --end iterate through "Bag"

               end if; --end "Bag"

            end if;  --end parsing line 
         end loop; --end for

      end loop; --end while
      Close (F);

   end read;

   --- *** NOTE: removed procedures addBag/removeBag, wrote addItem/deductItem in bag.ads

   

   procedure generaterandomfile is --randomly decides new textfile to read from
      --- *** NEW: new generaterandomfile procedure

      subtype randRange is Integer range 1..4;
      package Rand_Int is new ada.numerics.discrete_random(randRange);
      use Rand_Int;
      gen : Generator;
      num : randRange;
   begin
      reset(gen);
      num := random(gen);
      put_line("* Loading State" & randRange'Image(num + 1));
      read(f_name(num));
      write;
   end generaterandomfile;
    

   procedure Start is
   -- *** NEW: deleted type declarations (doctor/weather/time) in Start, didn't end up using them

      procedure takePill is --increment stats
      -- *** NEW: new takepill procedure written
      begin
         begin
            anger := anger - 2;
         exception 
            when Constraint_Error =>
               anger := 0;
         end;
         begin
            sleep := sleep + 1;
         exception 
            when Constraint_Error => --if sleep equals 10
                
               Put_Line("* Eyes are getting heavy... good night...");
               sleep := 0;
               today := nextDay(today);
               write;
               start;
         end;
         begin
            sanity := sanity + 1;
         exception 
            when Constraint_Error =>
               sanity := 10;
         end;

         DeductItem(Pill, 1, head);
      end takePill;
        
       

      procedure path4 is --beat up doctor, have keycard
      -- *** NEW: new path4 procedure written
      begin
         Put_Line("* What should we do now?");

         Put_Line("Try to escape (1)");
         Put_Line("Go back to sleep (2)");
         Put_Line("Take pills (3)");

         get(input); --error check for strings/carraige return
         Put_Line("");
         case input is 

            when '1' =>  --win ending
               Put_Line("* You swipe the keycard on the door. Freedom!");   
               Won := True;
               raise try_again; --go to path2, call start
            
            when '2' =>  --lose ending
               Put_Line("* Really? With an unconcious body right next to your bed? ... ok then. ");
               Put_Line("* Security comes in, sees the mess you've made, and promptly sedates you.");
               Dead := True;

               raise try_again; --go to path2, call start

            when '3' =>  --take pills
               if inBag(Pill, head) then
                  Put_Line("* Check your stats :)");
                  Put_Line("");
                  takePill;
               else 
                  Put_Line("No more pills" );
               end if;

                
               write;
               path4;   
                
            when others =>
               Put_Line("Not a valid input");
               path4;

         end case;
        
      end path4;

      procedure path3 is 
      -- *** NEW: new path3 procedure written
      begin
         Put_Line("* What should we do now?");
         Put_Line("Look around (1)");
         Put_Line("Take pills (2)" );
         get(input); --error check for strings/carraige return
         Put_Line("");
         case input is 

            when '1' => --obtain shoes, go back to start (reset)
               if not inBag(Shoes, head) then
                  Put_Line("* You see your Black Air Force Ones in the corner of the room. You pick them up.");
                  Put_Line("* OBTAINED SHOES *");
                  new_line;
                  addItem(Shoes, 1, head);
               else 
                  Put_Line("* Nothing new here...");
               end if;
                
               Put_Line("* Nothing else to do today, let's go to sleep.");
                
               today := nextDay(today);
               write;
               Start;
                
            when '2' =>  --take pills
               if inBag(Pill, head) then
                  Put_Line("* Check your stats :)");
                  Put_Line("");
                  takePill;
               else 
                  Put_Line("No more pills" );
               end if;

               write;
               path3;
                
            when others =>
               Put_Line("* Not a valid input");
               path3; --reset

         end case;
        
      end path3;

      procedure path2 is
      -- *** NEW: new path2 procedure written
      begin

         Put_Line("* What should we do now?");
         Put_Line("'I'm doing just fine, how are you?' (1)");
         Put_Line("'...' (2)");
         Put_Line("'How much longer do I have to stay here?' (3)");
         Put_Line("Use item (4)");

         get(input); --error check for strings/carraige return
         Put_Line("");

         case input is 
            when '1' =>  --add more pills to bag, decrements hunger, go path3
               Put_Line("'I'm doing great, just here to drop off your daily pills and breakfast'");
               Put_Line("* RECEIVED 3 PILLS *");
               Put_Line("'Have a great day!'");	
               new_line;
               addItem(Pill, 3, Head);

               begin
                  Hunger := hunger - 3;
               exception 
                  when Constraint_Error =>
                     hunger := 0;
               end;
               write;

               path3;
            
            when '2' => --add more pills to bag, decrements hunger, go path3
               Put_Line("'Not very talkative today, huh? Anyways, here are your daily pills and breakfast'"); 
               Put_Line("* RECEIVED 3 PILLS *");
               Put_Line("* Doctor leaves in silence *");
               addItem(Pill, 3, Head);
               begin
                  Hunger := hunger - 3;
               exception 
                  when Constraint_Error =>
                     hunger := 0;
               end;
               write;
               path3;
                
            when '3' =>  --add more pills to bag, but does not decremenmt hunger, go path3
               Put_Line("'Won't be much longer...'");
               Put_Line("* RECEIVED 3 PILLS *");
               Put_Line("'Just take these and you'll be out soon!'");
               addItem(Pill, 3, Head);
               write;
               path3;
                 

            when '4' =>  --if weapon is in bag, go path4

               if not inBag(shoes, head) and not inBag(Egg, head) then
                  Put_Line("* Nothing to use, for now...");
                  path2;
               else 
            
                  if inBag(Egg, head) then
                     Put_Line("* You grab your hard boiled egg out of your pocket and shove it down Doctor Hall's throat.");
                     DeductItem(Egg, 1, head);
                  elsif inBag(shoes, head) then
                     Put_Line("* You beat Doctor Hall over the head with your Black Air Force Ones.");
                     DeductItem(Shoes, 1, head);
                  end if;
                  write;
                
                  Put_Line("* He drops his Keycard on the floor during the scuffle.");
                  if not inbag(keycard, head) then
                     Put_Line("* OBTAINED KEYCARD *");
                     new_line;
                     addItem(Keycard, 1, head);
                  end if;
            
                  begin
                     anger := anger + 2;
                  exception 
                     when Constraint_Error =>
                        anger := 10;
                  end;
                
                  write;
                  path4;

               end if; --end of first if
                
            when others =>
               Put_Line("* That input wasn't valid, choose again.");
               path2;
         end case;

         write;

      exception  --raised in path4, handled here in path2
            --after winning or losing, give option to restart game with new stats
         when try_again =>
            new_line;

            if won = true then
               Put_Line("...nice job escaping, Neo... Red or blue pill? (r/b)");
               get(input);
               if input = 'r' then
                  Put_Line("* Good choice...");
                  won := false;
                  --read different 
                  generaterandomfile; --read and write in procedure
                  start; --go to path3, can go wherever
               else 
                  Put_Line("* QUITTING *");
                  return;
               end if;

            elsif dead = true then

               Put_Line("* Looks like you messed up, soldier...");
               Put_Line("* Play again? (y/n)");
               get(input);
               if input = 'y' then
                  Put_Line("* Good choice...");
                  dead := false;
                  --read different 
                  generaterandomfile; --read and write in procedureD
                  start; --restart
               else 
                  Put_Line("* QUITTING *");
                  return;
               end if;
            end if;

      end path2;

      procedure path1 is
      -- *** NEW: path1 procedure further written
            
      begin
         Put_Line("The doctor will be here any minute!");
         new_line;
         Put_Line("* What should we do? ");
         Put_Line("Go back to sleep (1)");
         Put_Line("Call for help (2)");
         Put_Line("Try to escape (3)");
         Put_Line("Wait for the doctor (4)");

         get(input); --error check for strings/carraige return
         new_line;
            
         --loop this until proper answer is given
         case input is 

            when '1' =>  --increments day, decreases sleep, only available if sleep > 0
                    
               if sleep /= 0 then
                  begin
                     Sleep := sleep - 4;
                  exception 
                     when Constraint_Error =>
                        sleep := 0;    
                  end;
                  --if sleep is 0, can't sleep anymore
                    
                        
                  Put_Line("* Ok, then.. good night... ");
                  today := nextDay(today);
                  write;
                  Start;
               else
                  Put_Line("Can't sleep right now! You're not tired enough!");
                  path1;
               end if;
                    
                    
            when '2' =>  --dead path, nothing happens
               --check range errors
               begin
                  sanity := sanity + 2;
               exception 
                  when Constraint_Error =>
                     sanity := 10;
               end;
                    
               begin
                  anger := anger + 2;
               exception 
                  when Constraint_Error =>
                     anger := 10;
               end;
                    
               Put_Line( "* You shout for someone --no one answers, or cares. Yet you can hear others shouting.");    
               write;  
               path1;
               
            when '3' =>  --cannot escape unless keycard is in bag
               --if keys in bag, leave room, new call;
               --else
               Put_Line("* You run to a large steel door. It is locked. You'll need a swipe...");  

               if inbag(keycard,head) then
                  won := True;
                  raise try_again;
               end if;

               path1;
               
            when '4' =>  --only option that leads to path2
               Put_Line("* The Doctor knocks and enters the room. The door locks behind him.");
               Put_Line("'Hello, my name is Doctor Hall. How are you feeling today?' "); --custom for doctors
               Put_Line("");

                
               path2;
               --new call;

            when others =>
               Put_Line("* That input wasn't valid, choose again");
               Path1;
               --Error, send message and loop to top.
         end case;

      end path1;

   begin --begin start

      -- *** NEW: added dialogue in Start, rather than Main
      new_line;
      Put_Line("Today is " & DaystoString(today));
      Put_Line("It's a beautiful day to leave the hospital...");
      path1;
           
      --end loop
   end Start;

begin --begin main

   read("state1.txt");
   write; --test
   Start;

end escape;
