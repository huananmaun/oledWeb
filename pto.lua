function pto(istr1)
if istr1 == nil then
     istr1= "OK"
end

  disp:firstPage()
  repeat
    disp:setFont(u8g.font_6x10)
    disp:drawStr(0, 54, istr1)
  until disp:nextPage() == false
end
