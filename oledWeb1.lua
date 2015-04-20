wifi_ip_str1=""

wifi.setmode(wifi.STATION)
wifi.sta.config("king","")
print(wifi.sta.getip())
wifi_ip_str1=wifi.sta.getip()


dispStr1="hello"

dofile("oled.lua") 

function startServer()
    srv=net.createServer(net.TCP) 
    srv:listen(80,function(conn) 
    conn:on("receive",function(conn,request) 
    
local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."<h1> Smart OLed</h1>";
        buf = buf.."<p>GPIO0 <a href=\"?pin=ON1\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF1\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO0 <a href=\"?pin=ONA\"><button>LEFT</button></a>&nbsp;<a href=\"?pin=OFFA\"><button>RIGHT</button></a></p>";
        
        buf = buf.."<p>GPIO2 <a href=\"?pin=ON2\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF2\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO2 <a href=\"?pin=ONB\"><button>LEFT</button></a>&nbsp;<a href=\"?pin=OFFB\"><button>RIGHT</button></a></p>";
                
        local _on,_off = "",""
        if(_GET.pin == "ON1")then
              dispStr1="BEGIN"
        elseif(_GET.pin == "OFF1")then
              dispStr1="STOP"
        end

        if(_GET.s ~= nil)then
              dispStr1=_GET["s"]         
        end

   
    conn:send(buf)
       
        conn:close();

disp:firstPage()
repeat  
    disp:drawStr(0, 0, dispStr1)
until disp:nextPage() == false

        
        collectgarbage();
    end)
end)

--if (wifi_ip_str1 ~= nil) then
--    showIPMsg()
--end

end

function drawWatch()
  disp:drawStr(0, 0, "Health")
end

function showIPMsg()
  disp:firstPage()
  repeat
    disp:setFont(u8g.font_6x10)
    disp:drawStr(0, 54, wifi_ip_str1)
  until disp:nextPage() == false
end


disp:firstPage()
repeat
  drawWatch()
until disp:nextPage() == false

--startServer()

tmr.alarm(1, 1000,1,function()
    if wifi.sta.getip=="0.0.0.0" then
        print("connect AP, waiting...")
    else
        startServer()
        
        tmr.stop(1)       
    end
end)


-----oled.lua
sda = 3
scl = 4
sla = 0x3c

i2c.setup(0, sda, scl, i2c.SLOW)
disp = u8g.ssd1306_128x64_i2c(sla)

disp:setFont(u8g.font_6x10)
disp:setFontRefHeightExtendedText()
disp:setDefaultForegroundColor()
disp:setFontPosTop()
