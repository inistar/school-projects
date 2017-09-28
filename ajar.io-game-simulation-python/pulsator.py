# A Pulsator is a Black_Hole; it updates as a Black_Hole
#   does, but also by growing/shrinking depending on
#   whether or not it eats Prey (and removing itself from
#   the simulation if its dimension becomes 0), and displays
#   as a Black_Hole but with varying dimensions


from blackhole import Black_Hole

counter = 30 

class Pulsator(Black_Hole):
    def __init__(self, x, y):
        global counter
        Black_Hole.__init__(self, x, y)
        self.pulsator_counter = counter 
        
    def update(self, model):
        if self.pulsator_counter == 0:
            self.pulsator_counter = counter
            puls_coor = self.get_dimension()
            if puls_coor[0] == 0 and puls_coor[1] == 0:
                model.remove(self)
            
            self.set_dimension(puls_coor[0] -1, puls_coor[1] -1)
            
        prey_eaten = []
        BH_func = lambda x: str(type(x)) in ["<class 'ball.Ball'>", "<class 'floater.Floater'>", "<class 'special.Special'>"]
        prey_list = model.find(BH_func)
        
        for i in prey_list:
            coor = i.get_location()
            if self.contains(coor[0], coor[1]):
                prey_eaten.append(i)
                model.remove(i)
                puls_coor = self.get_dimension()
                self.set_dimension(puls_coor[0] +1, puls_coor[1] +1)
                self.pulsator_counter = counter
                
        if prey_eaten == []:
            self.pulsator_counter = self.pulsator_counter - 1
            
                
        return prey_eaten