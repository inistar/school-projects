# A Floater is Prey; it updates by moving mostly in
#   a straight line, but with random changes to its
#   angle and speed, and displays as ufo.gif (whose
#   dimensions (width and height) are computed by
#   calling .width()/.height() on the PhotoImage


from PIL.ImageTk import PhotoImage
from prey import Prey
import random
import math
from ball import Ball

class Floater(Prey):
    def __init__(self, x,y):
        Ball.__init__(self, x, y)
        self._speed   = 5
        self._angle   = random.random()*math.pi*2
        self._image   = PhotoImage(file="ufo.gif")
    
    def update(self,model):
        temp = random.randint(1, 1000)
        if temp <= 300:
            int_rand = 0
            while(True):
                temp = random.random()
                int_rand = self.get_speed() + (temp-.5)
                if(3 < int_rand and int_rand < 7):
                    break
                    
            self.set_speed(int_rand)
            self.set_angle(self.get_angle()+temp)
            
        self.move()
        self.wall_bounce()
    
    
    def display(self, canvas):
        canvas.create_image(*self.get_location(),image=self._image) 
    