#!/usr/bin/env python3
import sys, random
from PIL import Image, ImageDraw
random.seed(63)
w,h=2304,1260
im=Image.new("RGB",(w,h))
pix=im.load()
for y in range(h):
 for x in range(w):
  pix[x,y]=(255,int(238-15*y/h+6*x/w),int(247-6*y/h+7*x/w))
d=ImageDraw.Draw(im,"RGBA")
for cx,cy,r,col in [(1800,220,420,(255,205,233,120)),(380,1110,510,(226,200,255,90)),(990,650,350,(255,255,255,72))]:
 d.ellipse((cx-r,cy-r,cx+r,cy+r),fill=col)
for i in range(75):
 x=random.randrange(30,w-30);y=random.randrange(45,h-45);r=random.randint(4,12)
 color=(255,255,255,175) if i%3 else (236,157,195,150)
 d.line((x-r,y,x+r,y),fill=color,width=2)
 d.line((x,y-r,x,y+r),fill=color,width=2)
im.save(sys.argv[1],optimize=True)
