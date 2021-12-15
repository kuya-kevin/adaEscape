package Week is

   type Days is (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday);

   function stringToDays (S : String) return Days;
   function DaystoString (D : Days) return String;
   function nextDay (D : Days) return Days;

end Week;
