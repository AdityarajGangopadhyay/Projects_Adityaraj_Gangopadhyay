from __future__ import annotations
import random
class Node:
    def __init__(self, pos:tuple, g_val:int, h_val:int, parrent:Node, favor_larger_g=True) -> None:
        self.pos = pos
        self.g_val = g_val
        self.h_val = h_val
        self.f_val = g_val + h_val
        self.parrent = parrent
        self.active = True
        self.favor_larger_g = favor_larger_g

    def __repr__(self) -> str:
        s = ""
        if not self: 
            return
        if self.parrent:
            s = "%s P: %s %s" % (self.pos, self.parrent.pos, self.active)
        else:
            s = "%s P: None %s" % (self.pos, self.active)
        return s
    def __lt__(self, other:Node) -> bool:
        # if self.favor_larger_g == False:
        #     print("HEHHEH", self.favor_larger_g)
        if self.f_val != other.f_val:
            return self.f_val < other.f_val
        # (>) favors larger g_vals. so explores more towards the goal state
        # (<) favors smaller g_vals. so explores more towards the start state
        if self.favor_larger_g:
            return self.g_val > other.g_val
        else:
            return self.g_val < other.g_val

    def __eq__(self, other:Node) -> bool:
        if isinstance(other, Node):
            return self.pos == other.pos
        return NotImplemented
    def __hash__(self) -> int:
        return hash(self.pos)