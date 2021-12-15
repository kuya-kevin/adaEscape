-- Kevin E, Adam H, Tim W, Ada creative
-- *** NEW: new misc.ads written 
package misc is

   type item is (Pill, Keycard, Egg, Shoes);
   type Psyche is (peachy, homocidal, angry, confused, inLove, Weeaboo, Downbad);
   subtype stat is Integer range 0 .. 10;


   function stringToItem(S : String) return item;

   function stringToPsyche(S: String) return Psyche;

end misc;
