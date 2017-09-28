import controller, sys
import model   #strange, but we need a reference to this module to pass this module to update

from ball      import Ball
from floater   import Floater
from blackhole import Black_Hole
from pulsator  import Pulsator
from hunter    import Hunter
from special   import Special 

# Global variables: declare them global in functions that assign to them: e.g., ... = or +=
running = False
cycle_count = 0
balls = set()
select_kind = 'Ball'


#return a 2-tuple of the width and height of the canvas (defined in the controller)
def world():
    return (controller.the_canvas.winfo_width(),controller.the_canvas.winfo_height())

#reset all module variables to represent an empty/stopped simulation
def reset ():
    global running, cycle_count, balls 
    running = False
    cycle_count = 0
    balls = set()


#start running the simulation
def start ():
    global running 
    running  = True


#stop running the simulation (freezing it)
def stop ():
    global running 
    running = False


#step just one update in the simulation
def step ():
    start()
    update_all()
    display_all()
    stop()


#remember the kind of object to add to the simulation when an (x,y) coordinate in the canvas
#  is clicked next (or remember to remove an object by such a click)   
def select_object(kind):
    global select_kind
    select_kind = kind


#add the kind of remembered object to the simulation (or remove any objects that contain the
#  clicked (x,y) coordinate
def mouse_click(x,y):
    global balls
    if select_kind == 'Remove':
        for b in balls:
            coor = b.get_location()
            if coor[0] - 5 < x and x < coor[0] + 5 and coor[1] - 5 < y and y < coor[1] + 5:
                remove(b) 
                break
    elif select_kind == 'Ball':
        add(Ball(x,y))
    elif select_kind == 'Floater':
        add(Floater(x,y))
    elif select_kind == 'Black_Hole':
        add(Black_Hole(x,y))
    elif select_kind == 'Pulsator':
        add(Pulsator(x,y))
    elif select_kind == 'Hunter':
        add(Hunter(x,y))
    elif select_kind == 'Special':
        add(Special(x,y))

#add simulton s to the simulation
def add(s):
    global balls
    balls.add(s)

# remove simulton s from the simulation    
def remove(s):
    global balls
    print(balls)
    balls.remove(s)
    print(balls)
    

#find/return a set of simultons that each satisfy predicate p    
def find(p):
    prey_list = []
    for b in balls:
        if(p(b)):
            prey_list.append(b)
    return prey_list

#call update for every simulton in the simulation
def update_all():
    global cycle_count
    global balls
    
    count = len(balls)
    alist = list(balls)
    
    if running:
        cycle_count += 1
        
        while(count != 0):
            alist[count-1].update(model)
            count = count - 1
            

#delete from the canvas every simulton in the simulation, and then call display for every
#  simulton in the simulation to add it back to the canvas possibly in a new location: to
#  animate it; also, update the progress label defined in the controller
def display_all():
    for o in controller.the_canvas.find_all():
       controller.the_canvas.delete(o)
    
    for b in balls:
       b.display(controller.the_canvas)
    
    controller.the_progress.config(text=str(len(balls))+" balls/"+str(cycle_count)+" cycles")
