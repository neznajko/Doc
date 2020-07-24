#!/usr/bin/env python3
import sys
########################################
#######   #   #####   ##################
####### D # o ##### c ##################
#######   #   #####   ##################
########################################
class Doc:
  def __init__(#########################
      self,    # What is this?
      name,    # Doc's name
      t1me,    # starting time
      t2me,    # ending time
      inst     # Institute
  ):###########/########################
    self.name = name
    self.t1me = t1me
    self.t2me = t2me
    self.inst = inst
    self.flag = False # visited flag
  ####################&#################
  @classmethod
  def unpack(################## 2nd cons
      c,     # rpyna k7ac
      s      # "Bob 08.30-10.00 Cross"
  ):#########/##########################
    name, time, inst = s.split()
    t1me, t2me = map(s2m, time.split('-'))
    return c(name, t1me, t2me, inst)
  
  def __str__(##########################
      self    # thatz
  ):##########/#########################
    n, i = self.name, self.inst
    ls = [self.t1me, self.t2me]
    t = '-'.join(map(m2s, ls))
    return f"{n} {t} {i} {self.flag}"

  def dur(##################### duration
      self,    #                      ..
      t = None # defaults to t1me
  ):#######/############################
    if t is None: t = self.t1me
    return self.t2me - t

  def __lt__(self, othr):
    self_time = (self.t1me, self.t2me)
    othr_time = (othr.t1me, othr.t2me)
    return self_time < othr_time

########################################
####   ####   ####   ###################
#### U #### s #### r ###################
####   ####   ####   ###################
########################################
class Usr:
  def __init__(#########################
      self,    # thatz
      name,    # User's name 
      j        # appt list index
  ):###########/########################
    self.name = name
    self.ls   = [Doc("", 0, 0, "")]
    self.j    = j
    
  def total(######## total visiting time
      self  #
  ):########v###########################
    ls = [rec.dur() for rec in self.ls]
    return sum(ls)

  def __str__(self):
    """ Dump name and visited records """
    ls = []
    for rec in self.ls[1:]:
      s = rec.__str__()
      # discard visited flag
      ls.append(' '.join(s.split()[:-1]))
    ls.insert(0, self.name)
    return '\n'.join(ls)

  def next_appt(self):
    while True:
      self.j += 1
      if not appt[self.j].flag: break

################################################
#######   ######################################
####### t ##   ##   ##   ##   ##################
############ a ## s ## k ## s ##################
################################################
class Xception(Exception): pass

def Exit(#######################################
    t    # time 
): raise Xception("Done") ######################

def WAit(#######################################
    u,   # uza                            
    t    # tme
):##############################################
  i = u.j       # backup current record index
  u.next_appt() # update u.j
  w = 0
  if appt[u.j].name != "Sent":
    if t + travel < appt[u.j].t1me:
      # arrive exactly at t1me:
      w1 = appt[u.j].t1me - travel - t
      w2 = appt[  i].t2me - t # full visit
      w = min(w1, w2)
    stk.push(Tsk(dOthEViSit, [u, t + w + travel]))
  u.ls.append(Doc(########### Take it easy Doc:)
    appt[i].name,
    t - mindur,
    t + w,
    appt[i].inst))

def dOthEViSit(#################################
    u,         # user
    t          # time
):##############################################
  if ck(u, t): # Ok! raise visited flag
    appt[u.j].flag = True
    stk.push(Tsk(WAit, [u, t + mindur]))
  else:
    u.next_appt() # moo 2 next available appt
    if appt[u.j].name != "Sent":
      t = max(t, appt[u.j].t1me)
      stk.push(Tsk(dOthEViSit, [u, t]))

################################################
# T ### s ### k ################################
#   ###   ###   ################################
################################################
################################################
class Tsk:
  def __init__(#################################
      self,    # boom
      func,    # function call
      args     # argument list
  ):###########,################################
    self.func = func
    self.args = args
    
  def run(self): self.func(*self.args) #########
    
  def __lt__(###################################
      self,  # Who me?
      othr   # Yea yu!
  ):#########v##################################
    """ If users have same appointment, order by
    total visiting time (TVT). """
    f,t = [],[]
    for ve in self, othr:
      f.append(ve.func) #          function call
      t.append(ve.args[-1]) #               time
    if (f[0] is dOthEViSit and #       dothEMAth
        f[1] is dOthEViSit):
      u,j,dur = [],[],[]
      for ve in self, othr:
        u.append(ve.args[0]) #              user
        j.append(u[-1].j) #                 appt
        dur.append(appt[j[-1]].dur()) # duration
      if j[0] == j[1]:
        if dur[0] == dur[1]:
          return u[0].name < u[1].name
        else:
          return dur[0] < dur[1]
    return t[0] < t[1]
  
  def __str__(self):
    """ dOthEMAth, Aänton, 08.30
        WAit, Bobby, 10.40
        Exit, 21.35
    """ 
    ls = [self.func.__name__,
          m2s(self.args[-1])]

    if self.func is not Exit:
      ls.insert(1, self.args[0].name)

    return ", ".join(ls)

################################################
##   #   #   ################# 6ek Ty 6ek geMek?
## S # T # K ###################################
##   #   #   ###################################
################################################
class Stk:
  def __init__(self):
    # -1 is Sentinel Güard
    self.ls = [Tsk(Exit, [appt[-2].t2me])]
    
  def push(self, tsk): # (insert sort)
    j = len(self.ls) - 1
    while j > -1 and self.ls[j] > tsk:
      j -= 1
    self.ls.insert(j + 1, tsk)

  def pop(self): return self.ls.pop(0)

################################################
################################################
######   #   #   #   ###########################
###### f # u # n # c ###########################
################################################
def ck(################################# tscheck
    u, # user
    t  # time
):##############################################
  """ Ck user's appointment """
  rec = appt[u.j]
  # ck visited flag ############################
  if rec.flag: return False
  # ck if same Inst. ###########################
  inst = u.ls[-1].inst # last visited ##########
  if inst == rec.inst: return False
  # ck duration ################################
  if rec.dur(t) < mindur: return False
  return True

def s2m(############## string to minutes
    s   # time string e.g.: 11.45
):#####################################_
  h,m = map(int,s.split('.'))
  return h*mph + m

def m2s(############## minutes to string
    m   # minutes e.g.: 570 (09.30)
):#####################################*
  n,r = m//mph,m%mph
  return "{:02d}.{:02d}".format(n,r)

def cycle():####################################
  tsk = stk.pop()
  tsk.run()

def vroo():#####################################
  try:
    while True:
      cycle()
  except Xception as x:
    print(x)

################################################
def load():
  """ load appt from stdin """
  buf  = sys.stdin.read() # redirect input file
  appt = buf.split('\n') # make a list
  appt = list(filter(None, appt)) # discard empty lmnts
  appt = list(map(Doc.unpack, appt))
  appt.sort()
  # add dummy record and sentinel guard
  appt = [[]] + appt
  appt.append(Doc.unpack("Sent 00.00-24.00 Clink"))
  return appt

########################################################
########################################################
#########   ##############   ###########################
####   ## l ############## b ##   ############   #######
#### g ########   ############# a ############ l #######
############### o ######################################
mph    = 60    # minutes per hour
mindur = 70    # minimum duration
travel = 30    # time between 2 consec appts
debug  = False # yeah!
########################################################
if debug: import pdb
############################################## Test Zone
appt = load()
usr  = [Usr("Aänton", 1), Usr("Bobby", 2)]
stk  = Stk()
stk.push(Tsk(dOthEViSit, [usr[0], appt[1].t1me]))
stk.push(Tsk(dOthEViSit, [usr[1], appt[2].t1me]))
print("[  appt ]", *appt[1:-1], sep='\n')
print("[  stk  ]", *stk.ls, sep='\n')
if debug: pdb.set_trace()
vroo()
print("[  usr  ]", *usr, sep='\n')
########################################################
# cure:
# next:
