#!/usr/bin/env python3
# coding = utf-8
mph    = 60   # minutes per hour
mindur = 70   # minimum duration
debug  = True # yeah!
########################################
if debug: import pdb
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
  ######################################
  @classmethod
  def unpack(################## 2nd cons
      c,     # rpyna k7ac
      s      # "Bob 08.30-10.00 Cross"
  ):#########/##########################
    name,time,inst = s.split()
    t1me,t2me = map(s2m,time.split('-'))
    return c(name,t1me,t2me,inst)
  
  def __str__(##########################
      self    # thatz
  ):##########/#########################
    n, i = self.name,self.inst
    ls = [self.t1me,self.t2me]
    t = '-'.join(map(m2s,ls))
    return f"{n} {t} {i} {self.flag}"

  def dur(##################### duration
      self,  #                        ..
      t=None # defaults to t1me
  ):#######/############################
    if t is None: t = self.t1me
    return self.t2me - t
########################################
# This class should be named Vsitr or
# something, but let's keep as it is.
class Usr:
  def __init__(#########################
      self,    # thatz
      name,    # User's name 
      j        # appt list index
  ):###########/########################
    self.name = name
    self.ls   = [Doc("",0,0,"")]
    self.j    = j
    
  def total(######## total visiting time
      self  #
  ):####################################
    ls = [rec.dur() for rec in self.ls]
    return sum(ls)

  def __str__(self): return self.name
########################################  
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

def ck(################################# tscheck
    u, # usr index
    t  # time
):#############################################%
  """ Ck user's appointment """
  global appt, usr
  u = usr[u]
  rec = appt[u.j]
  # ck visited flag ###########################-
  if rec.flag: return False
  # ck if same Inst. ##########################/
  inst = u.ls[-1].inst # last visited #########*
  if inst == rec.inst: return False
  # ck duration ###############################`
  if u.dur(t) < mindur: return False
  return True

def Exit(######################################=
    t    # time 
): raise Exception("Done") ####################_

def dOthEViSit(
    u,
    t
):
  pass
########################################### Task
class Tsk:
  def __init__(################################*
      self,    # boom
      func,    # function call
      args     # last argument should be time
  ):###########,###############################>
    self.func = func
    self.args = args
    
  def run(self): self.func(*self.args) ########=
    
  def __lt__(##################################!
      self,  # Who me?
      othr   # Yea yu!
  ):#########v#################################+
    """ If users have same appointment, order by
    total visiting time (TVT). """
    if debug: pdb.set_trace()
    global usr, appt
    f,t = [],[]
    for ve in self, othr:
      f.append(ve.func) #          function call
      t.append(ve.args[-1]) #               time
    if (f[0] is dOthEViSit and #       dothEMAth
        f[1] is dOthEViSit):
      u,j,dur = [],[],[]
      for ve in self, othr:
        u.append(ve.args[0]) #         usr index
        j.append(usr[u[-1]].j) #      appt index
        dur.append(appt[j[-1]].dur()) # duration
      if j[0] == j[1]:
        if dur[0] == dur[1]:
          return u[0] < u[1] #      Aänton first
        else:
          return dur[0] < dur[1]
    return t[0] < t[1]
  
  def __str__(self):
    pass
################################################
class Stk:
  def __init__(self):
    global appt
    last = appt[-2] # -1 is Sentinel Guard
    self.ls = [Tsk(Exit, [last.t2me])]
    
  def push(self, tsk):
    j = len(self.ls) - 1
    while j > -1 and self.ls[j] > tsk: j -= 1
    self.ls.insert(j + 1, tsk)
################################################
def cycle():####################################
  global stk
  tsk = stk.pop(0)
  tsk.run()
################################################
def vroo():
  try:
    cycle()
  except Exception as e:
    print(e)
################################################
if __name__ == "__main__":
  appt = [
    "Bob    08.00-10.30 Med",
    "Bill   08.15-09.15 Cure",
    "John   08.20-09.45 Cure",
    "Becky  09.00-11.00 Cross",
    "Aänton 10.00-11.45 Heal",
    "Sent   00.00-24.00 Clink"
  ]
  appt = [""] + list(map(Doc.unpack, appt))
  usr  = [Usr("Aänton", 1), Usr("Bobby", 2)]
  stk  = Stk()
#  vroo()
################################################
# cure: test Stk
# next: dOthEViSit
