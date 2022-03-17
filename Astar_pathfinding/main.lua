io.stdout:setvbuf('no')
colonne = 25
ligne = 25
love.window.setMode(400,400)

w = 400 / colonne
h = 400 / ligne

function spot(tablee,i,j)
  tablee.x = i
  tablee.y = j
  tablee.f = 0
  tablee.g = 0
  tablee.h = 0
  tablee.voisin = {}
  tablee.CameFrom = {}
  
  function tablee.show(color)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line",(tablee.x-1)*w,(tablee.y-1)*h,w,h)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill",(tablee.x-1)*w,(tablee.y-1)*h,w,h)
--    for i = 1,#tablee.voisin do
--    love.graphics.setColor(0,0,0)
--    love.graphics.print(tablee.voisin[i].x ..",".. tablee.voisin[i].y,(tablee.x-1)*w,(tablee.y-1 )*h + 10*i)
--    end
  end
  
  function tablee.PlusDeVoisin(grid)
    local i2 = tablee.x
    local j2 = tablee.y
    if i2 > 1 then 
      tablee.voisin[#tablee.voisin+1] = grid[i-1][j]
    end
    if i2 < ligne then 
            tablee.voisin[#tablee.voisin+1] = grid[i+1][j]
    end
    if j2 > 1 then
            tablee.voisin[#tablee.voisin+1] = grid[i][j-1]
    end
    if j2 < colonne then
            tablee.voisin[#tablee.voisin+1] = grid[i][j+1]
    end
  end
end


function heuristic(a,b)
  local varHeu =((b.x - a.x)^2 + (b.y - a.y)^2)^0.5
--  local varHeu = math.abs(b.x - a.x) + math.abs(b.y - a.y)
  return varHeu
end

grille = {} 
for i = 1,colonne do
  grille[i] = {}
  for j = 1,ligne do 
    grille[i][j] = {}
    spot(grille[i][j],i,j)
  end 
end 

for i = 1,colonne do
  for j = 1,ligne do 
    grille[i][j].PlusDeVoisin(grille)
  end 
end 

theWay = {}
run = true
openset = {}
closeset = {}
------------------------------------------------------------------------------- configuration (to modify) 
start = grille[1][1]
fin = grille[25][25]

openset[#openset+1] = start
closeset[#closeset + 1] = grille[1][1]
--for i = 1,ligne-1 do
--  closeset[#closeset + 1] = grille[i][2]
--end
------------------------------------------------------------------------------
winner = 1


function love.draw()
  if run then
    print("run")
    if #openset > 0 then
      theWay = {}
      winner = 1
      for i = 1,#openset do
        if openset[i].f < openset[winner].f then
          winner = i
          
        end
      end 
      current = openset[winner]
      
      
      
      table.remove(openset,winner)
      table.insert(closeset,current)
      
      for i = 1,#current.voisin do
        levoisin = current.voisin[i]
        
        if VinO(closeset,levoisin) then
        tempG = current.g + 1
        
        levoisin.g = tempG
        levoisin.h = heuristic(levoisin,fin)
        levoisin.f = levoisin.g + levoisin.h
        levoisin.CameFrom = current
        if VinO(openset,levoisin) then
          table.insert(openset,#openset+1,levoisin)
          print("add")
        end
        end
      end
      
      if current == fin then
        print('ok')
        run = false
        test = true 
        while test do
          if type(current.CameFrom) == "nil" then
            test = false
          else
             print('lllllloooo')
            --table.insert(theWay,#theWay,current.CameFrom)
            theWay[#theWay+1] = current--.CameFrom
            current = current.CameFrom
          end
        end
      end
    else
      print('non')
    end


  end
  
  for i = 1,colonne do
    for j = 1,ligne do 
      grille[i][j].show({1,1,1})
    end 
  end 
  
  for i = 1,#openset do
    openset[i].show({0,1,0})
  end 
  
  for i = 1,#closeset do
    closeset[i].show({1,0,0})
  end 
  
  
--  table.insert(theWay,1,current)
--  theWay[#theWay+1] = current
  
  --print(type(nil) ~= 'nil')
  for i = 1,#theWay do
 -- table.foreach(theWay[i],print)
  theWay[i].show({0,0,1})
  end
end

function VinO(O,V)
  for i = 1,#O do
    if O[i].x == V.x and O[i].y == V.y then
    return false
    end
  end
  return true
end

function love.keypressed(key)
  if key == "z" then 
    run = true
  end
end

