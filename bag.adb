-- Kevin E, Adam H, Tim W, Ada creative
-- *** NEW: new bad.adb written 

with misc; use misc;
with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings;              use Ada.Strings;
with Ada.Strings.Fixed;        use Ada.Strings.Fixed;
package body bag is

   procedure printBag(Node: in Node_Ptr) is
   begin
      if Node /= null then
         Put_Line(Node.I'Image);
         Put_Line(Node.Count'Image);
         printBag(Node.Next);
      end if;
   end printBag;

   function getBag(Node: in Node_Ptr) return string is
   begin 
      if Node = null then
         return "";
      else 
         if Node.next = null then
            return Node.I'Image & "(" & trim(Node.Count'Image, Left) & ")" & getBag(Node.next);
         else
            return Node.I'Image & "(" & trim(Node.Count'Image, Left) & "), " & getBag(Node.next);
         end if;
      end if;
   end getBag;
        


   procedure addItem(I: item; Count: Integer; New_Node: in out Node_Ptr) is 
   begin
      if New_Node = null then
         New_Node := new Node'(I,Count,null);
      else
         if New_Node.I = I then
            New_Node.Count := New_Node.Count + Count;
         else
            if New_Node.Next /= null then
               addItem(I, Count, New_Node.Next);
            else
               New_Node.Next := new Node'(I, Count, null);
            end if;
         end if; 
      end if;
   end addItem;

   procedure DeductItem(I: item; Count: Integer; Curr: in out Node_Ptr) is--Prev should be intialized to = head

      procedure DeductItemHelper (I: item; Count: Integer; Curr: in out Node_Ptr) is
      begin 
         if Curr /= null then
            if Curr.I = I then
               Curr.Count := Curr.Count - Count;
               if Curr.Count <= 0 then
                  Curr := Curr.next; 
                 
               end if;
            else 

               DeductItemHelper(I, Count, Curr.next);
            end if;
         else 
            Put_Line("Error, bag empty or item not in list");
         end if;
      end DeductItemHelper; 
   begin  

      DeductItemHelper (I, Count, Curr);
   end DeductItem;

   function inBag(I: item; Node: in Node_Ptr) return Boolean is
   begin
      if Node = null then
         return false;
      else 
         if Node.I = I then
            return true;
         else 
            return inBag(I, Node.next);
         end if;
      end if;
   end inBag;

                    

end bag;
