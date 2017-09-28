# A Black_Hole is a Simulton; it updates by removing
#   any Prey whose center is contained within its radius
#  (returning a set of all eaten simultons), and
#   displays as a black circle with a radius of 10
#   (width/height 20).
# Calling get_dimension for the width/height (for
#   containment and displaying) will facilitate
#   inheritance in Pulsator and Hunter

from simulton import Simulton
from prey import Prey
import ball as Ball
import floater as Floater

class Black_Hole(Simulton):
    radius = 10

    def __init__(self,x,y):
        Simulton.__init__(self,x,y,20,20)
        self._color   = "black"
    
    def contains(self, x, y):
        BH_coor = self.get_location()
        BH_dime = self.get_dimension()
        
        return BH_coor[0] - (BH_dime[0]/2) < x and x < BH_coor[0] + (BH_dime[0]/2) and BH_coor[1] - (BH_dime[1]/2) < y and y < BH_coor[1] + (BH_dime[1]/2)
    
    def update(self, model):
        prey_list = []
        prey_eaten = []
        BH_func = lambda x: str(type(x)) in ["<class 'ball.Ball'>", "<class 'floater.Floater'>", "<class 'special.Special'>"]
        prey_list = model.find(BH_func)
        
        for i in prey_list:
            coor = i.get_location()
            if self.contains(coor[0], coor[1]):
                prey_eaten.append(i)
                model.remove(i)

        return prey_eaten
    
    def display(self,canvas):
        coor = self.get_dimension()
        canvas.create_oval(self._x-(coor[0]/2)      , self._y-coor[1]/2,
                                self._x+(coor[0]/2), self._y+(coor[1]/2),
                                fill=self._color)