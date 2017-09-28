# The special balls have a less chance of getting eaten by a black hole, hunter, and pulsator.

from prey import Prey
import math 
import random

class Special(Prey):
    radius = 5

    def __init__(self,x,y):
        Prey.__init__(self,x,y,10,10,random.random()*math.pi*2,5)
        self._color   = "#"+str(hex(random.randint(20,255)))[2:]+str(hex(random.randint(20,255)))[2:]+str(hex(random.randint(20,255)))[2:]
    
    def update(self,model):   
        BH_func = lambda x: str(type(x)) in ["<class 'blackhole.Black_Hole'>", "<class 'pulsator.Pulsator'>"]
        prey_list = model.find(BH_func)
       
        for i in prey_list:
            coor = i.get_location()
            special_coor = self.get_location()
            
            if abs(coor[0] - special_coor[0]) < 30 and abs(coor[1] - special_coor[1]) < 30:
                self.set_angle((self.get_angle())*-1)
        '''  
        temp = random.randint(1, 1000)
        if temp <= 300:
            coor = self.get_location()
            if coor[0] > 30:
                self.set_location(coor[0] + 30, coor[1])
            if coor[0] < 470:
                self.set_location(coor[0] - 30, coor[1])
            #self.set_angle((self.get_angle())*-1)
            '''
        
        self.move()
        self.wall_bounce()
        
    def display(self,canvas):
       canvas.create_oval(self._x-Special.radius      , self._y-Special.radius,
                                self._x+Special.radius, self._y+Special.radius,
                                fill=self._color)