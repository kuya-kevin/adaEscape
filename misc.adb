-- Kevin E, Adam H, Tim W, Ada creative
-- *** NEW: new misc.adb written 
Package body misc is

   function stringToItem (S : String) return item is
   begin
      return item'Value (S);
   end stringToItem;

   function stringToPsyche (S : String) return Psyche is
   begin
      return Psyche'Value (S);
   end stringToPsyche;

end misc;
