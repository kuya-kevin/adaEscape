-- Kevin E, Adam H, Tim W, Ada creative
-- *** NEW: new Week.adb written 

with Ada.Text_IO;              use Ada.Text_IO;
Package body Week is

   function stringToDays (S : String) return Days is
   begin
      return Days'Value (S);
   end stringToDays;

   function DaystoString (D : Days) return String is
   begin
      return D'Image;
   end DaystoString;

   function nextDay (D : Days) return Days is
      today : Days;
   begin
      begin
         today := days'succ(D);
      exception 
         when Constraint_Error => --Sunday to Monday
            today := Monday;
      end;
      return today;
   end nextDay;

end Week;
