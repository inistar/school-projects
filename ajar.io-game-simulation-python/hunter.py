# A Hunter is both a  Mobile_Simulton and Pulsator; it updates
#   like a Pulsator, but it also moves (either in a straight line
#   or in pursuit of Prey), and displays as a Pulsator.


from pulsator import Pulsator
from mobilesimulton import Mobile_Simulton
from prey import Prey
from math import atan2
import random 
import math

class Hunter(Pulsator,Mobile_Simulton):
    distance = 200
    def __init__(self, x, y):
        Pulsator.__init__(self,x,y)
        Mobile_Simulton.__init__(self, x, y, 20, 20, random.random()*math.pi*2, 5)
    
    def update(self, model):
        self.move()
        self.wall_bounce()
        
        lock_in = None
        
        if self.pulsator_counter == 0:
            self.pulsator_counter = 30
            puls_coor = self.get_dimension()
            if puls_coor[0] == 0 and puls_coor[1] == 0:
                model.remove(self)
            
            self.set_dimension(puls_coor[0] -1, puls_coor[1] -1)
            
        prey_eaten = []
        BH_func = lambda x: str(type(x)) in ["<class 'ball.Ball'>", "<class 'floater.Floater'>", "<class 'special.Special'>"]
        prey_list = model.find(BH_func)
        
        if lock_in == None:
            for i in prey_list:
                coor = i.get_location()
                hunter_coor = self.get_location()
                
                if abs(coor[0] - hunter_coor[0]) < 200 and abs(coor[1] - hunter_coor[1]) < 200:
                    lock_in  = i
                    break
        
        if lock_in != None:
            lock_in_coor = lock_in.get_location()
            self.set_angle(math.atan2(lock_in_coor[1] - hunter_coor[1], lock_in_coor[0] - hunter_coor[0])) 
            
#             if self.contains(lock_in_coor[0], lock_in_coor[1]):
#                 prey_eaten.append(i)
#                 model.remove(i)
#                 puls_coor = self.get_dimension()
#                 self.set_dimension(puls_coor[0] +1, puls_coor[1] +1)
#                 self.pulsator_counter = 30
        
        for i in prey_list:                    
            coor = i.get_location()
            hunter_coor = self.get_location()
            if self.contains(coor[0], coor[1]):
                prey_eaten.append(i)
                model.remove(i)
                puls_coor = self.get_dimension()
                self.set_dimension(puls_coor[0] +1, puls_coor[1] +1)
                self.pulsator_counter = 30
                
        if prey_eaten == []:
            self.pulsator_counter = self.pulsator_counter - 1
            
                
        return prey_eaten