#!/usr/bin/env python3
"""Source-universal Boolean integer-form rows in the physical p/S/T layout."""
from collections import Counter

def coordinate(a,b):
 assert type(a)is int and type(b)is int and 0<=a<1440 and 0<=b<1440
 sa,va=divmod(a,720);sb,vb=divmod(b,720);i,t=divmod(va,16);j,u=divmod(vb,16);h=(u-t)%16
 if h>8:h,i,j=16-h,j,i
 if h in (0,8) and i>j:i,j=j,i
 if sa==sb and h==0 and i==j:return i
 return 45+(0 if sa==sb else 18225)+h*2025+45*i+j

def compile_row(cut):
 e=cut['events'];w=cut['weights'];c=cut['constant'];assert type(c)is int and len(e)==len(w) and 0<len(e)<=12 and len(set(e))==len(e)
 assert all(type(v)is int and 0<=v<1440 for v in e) and all(type(b)is int for b in w)
 row=Counter()
 for k,(event,b) in enumerate(zip(e,w)):
  row[(event%720)//16]-=c*b+b*(b-1)//2
  for event2,d in zip(e[:k],w[:k]):row[coordinate(event2,event)]-=b*d
 return dict(sorted((i,v) for i,v in row.items() if v)),c*(c-1)//2
