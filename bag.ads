-- Kevin E, Adam H, Tim W, Ada creative
-- *** NEW: new bad.ads written 
with misc; use misc;

package bag is

   type Node;
   type Node_Ptr is access Node;
   type Node is record
      I: item;
      Count: Integer;
      Next: Node_Ptr;

   end record;

   function getBag(Node: in Node_Ptr) return string;
   procedure printBag(Node: in Node_Ptr);--will be modified to be used in write
   procedure DeductItem(I: item; Count: Integer; Curr: in out Node_Ptr);
   procedure addItem(I: item; Count: Integer; New_Node: in out Node_Ptr);--eventually helper function will happen.
   function inBag(I: item; Node: in Node_Ptr) return Boolean;--return count?

end bag;
