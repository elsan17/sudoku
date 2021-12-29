import random
from random import randint, shuffle
import pygame
from pygame.locals import *

puzzle = []
for i in range(9):
  puzzle.append([0,0,0,0,0,0,0,0,0])

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]

#checks puzzle for empty spaces
def check(puzzle):
  for row in puzzle:
    for col in row:
      if col == 0:
        return False
  return True



#creates fully solved puzzle
def create(puzzle):
  global counter
  global numbers

  for n in range(81):
    row = n//9
    col = n%9

    if puzzle[row][col] == 0:
      numbers = random.sample(numbers, len(numbers))
      for num in numbers:
        if not num in puzzle[row]:
          if not num in [puzzle[r][col] for r in range(9)]:
            square = []
            for i in range(3,10,3):
              if (row < i) and (row > (i-4)):
                for j in range(3,10,3):
                  if (col < j) and (col > (j-4)):
                    for k in range(1,4):
                      for l in range(1,4):
                        square.append(puzzle[i-k][j-l])



            if not num in square:
              puzzle[row][col] = num
              if check(puzzle):
                return True
              elif create(puzzle):
                return True
      break
  puzzle[row][col] = 0



#checks to see if puzzle can be solved
def canBeSolved(puzzle):
  global counter
  global numbers

  for n in range(81):
    row = n//9
    col = n%9

    if puzzle[row][col]==0:
      numbers = random.sample(numbers, len(numbers))
      for num in numbers:
        if not num in puzzle[row]:
          if not num in [puzzle[r][col] for r in range(9)]:
            square = []
            for i in range(3,10,3):
              if (row < i) and (row > (i-4)):
                for j in range(3,10,3):
                  if (col < j) and (col > (j-4)):
                    for k in range(1,4):
                      for l in range(1,4):
                        square.append(puzzle[i-k][j-l])

            if not num in square:
              puzzle[row][col] = num
              if check(puzzle):
                counter += 1
                break
              elif canBeSolved(puzzle):
                return True
      break
  puzzle[row][col]=0



counter = 1
create(puzzle)


copy = []
for i in range(9):
  copy.append([])
  for j in range(9):
    copy[i].append(puzzle[i][j])


attempts = 5 #?????
while attempts > 0:
  row = randint(0,8)
  col = randint(0,8)
  while copy[row][col]==0:
    row = randint(0,8)
    col = randint(0,8)

  backup = copy[row][col]
  copy[row][col] = 0

  counter = 0
  canBeSolved(copy)

  if counter!=1:
    copy[row][col] = backup
    attempts -= 1




new = []
for row in range(9):
    new.append([])
    for col in range(9):
        new[row].append(copy[row][col])




checked_x=-50
checked_y=-50
x=0
y=0
x_val = 50
y_val = 100
pygame.init()
screen = pygame.display.set_mode((800, 600))
running = True
while running:
    screen.fill((255, 255, 255))
    surf = pygame.Surface((400, 400))
    surf.fill((0, 0, 0))
    rect = surf.get_rect()
    screen.blit(surf, (x_val, y_val))
    #pygame.draw.circle(screen, (100, 230, 150), (400, 300), 50)
    surf = pygame.Surface((40, 40))
    surf.fill((255,255,255))
    rect = surf.get_rect()

    r_val = 50
    c_val = 100
    space = 6
    r_val = 56
    grid = []
    for i in range(9):
        grid.append([])
    x_count = 0
    y_count = 0
    #goes by row :)
    for j in range(3):
        for r in range(3):
            for i in range(3):
                for c in range(3):
                    c_val += space
                    screen.blit(surf, (c_val-50, r_val+50))
                    space = 40 + 16/6
                    grid[x_count].append((c_val-30, r_val+70))
                    for event in pygame.event.get():
                        if event.type == pygame.MOUSEBUTTONUP:
                            pos = pygame.mouse.get_pos()
                            x = pos[0]
                            y = pos[1]
                    if (x > c_val-50) and (x < c_val-10):
                        if (y > r_val+50) and (y < r_val+90):
                            surf.fill((200,200,230))
                            screen.blit(surf, (c_val-50, r_val+50))
                            checked_x = x_count
                            checked_y = y_count
                    y_count += 1

                    surf.fill((255, 255, 255))

                space = 46
            r_val += 40 + 16/6
            c_val = 100
            space = 6
            x_count += 1
            y_count= 0
        r_val += 6 - 16/6


    for row in range(9):
        for col in range(9):
            font = pygame.font.Font('freesansbold.ttf', 32)
            if (new[row][col]==0) and (new[row][col]==copy[row][col]):
                text = font.render(' ', True, (0,0,0))
            elif new[row][col]==puzzle[row][col]:
                text = font.render(str(new[row][col]), True, (0,0,0))
                if new[row][col]!=copy[row][col]:
                    text = font.render(str(new[row][col]), True, (100,100,100))
            elif (copy[row][col]==puzzle[row][col]) and (new[row][col]!=puzzle[row][col]):
                new[row][col] = puzzle[row][col]
                text = font.render(str(new[row][col]), True, (0,0,0))
            else:
                text = font.render(str(new[row][col]), True, (100,100,100))
            textRect = text.get_rect()
            textRect.center = grid[row][col]
            screen.blit(text, textRect)
    count = 0
    surf = pygame.Surface((75, 75))
    surf.fill((180,180,180))
    rect = surf.get_rect()
    for j in range(3):
        for i in range(3):
            screen.blit(surf, (500+85*i, 177.5+85*j))
            if (x>500+85*i) and (x<500+85*(i+1)-10):
                if (y>177.5+85*j) and (y<177.5+85*(j+1)-10):
                    surf.fill((100, 100, 100))
                    new[checked_x][checked_y] = count+1
                    #text = font.render(str(count), True, (0,0,0))
                    #textRect = text.get_rect()
                    #extRect.center = (checked_x+20, checked_y+20)
                    #screen.blit(text, textRect)
                    screen.blit(surf, (500+85*i, 177.5+85*j))
            surf.fill((180,180,180))
            font = pygame.font.Font('freesansbold.ttf', 40)
            count+=1
            text = font.render(str(count), True, (0,0,0))
            textRect = text.get_rect()
            textRect.center = (500+85*i+75/2, 177.5+85*j+75/2)
            screen.blit(text, textRect)

    surf = pygame.Surface((200,50))
    surf.fill((220,220,220))
    rect = surf.get_rect()
    screen.blit(surf, (500+85/4, 177.5+85*3))
    if (x>500+85/4) and (x<500+85/4+200):
        if (y>177.5+85*3) and (y<177.5+85*3+50):
            surf.fill((140, 140, 140))
            screen.blit(surf, (500+85/4, 177.5+85*3))
            new[checked_x][checked_y] = 0
    font = pygame.font.Font('freesansbold.ttf', 20)
    text = font.render('clear', True, (0,0,0))
    textRect = text.get_rect()
    textRect.center = (600+85/4, 177.5+85*3+25)
    screen.blit(text, textRect)


    pygame.display.update()
    for event in pygame.event.get():
        if event.type == KEYDOWN:
            num_keys = [K_1,K_2,K_3,K_4,K_5,K_6,K_7,K_8,K_9]
            for n in range(9):
                if event.key == num_keys[n]:
                    new[checked_x][checked_y] = n+1
            if event.key == K_ESCAPE:
                running = False
            elif event.key == K_BACKSPACE or event.key == K_DELETE:
                new[checked_x][checked_y] = 0
            elif event.key == K_UP:
                if checked_x==0:
                    checked_x=9
                    y = 510
                checked_y -= 1
                y -= 40 + 16/6
            elif event.key == K_DOWN:
                if checked_x==8:
                    checked_x=-1
                    y = 90
                checked_x += 1
                y += 40 + 16/6
            elif event.key == K_LEFT:
                if checked_y==0:
                    checked_y=9
                    x = 460
                checked_y -= 1
                x -= 40 + 16/6
            elif event.key == K_RIGHT:
                if checked_y==8:
                    checked_y=-1
                    x = 40
                checked_y += 1
                x += 40 + 16/6

        elif event.type == pygame.MOUSEBUTTONUP:
            pos = pygame.mouse.get_pos()
            x= pos[0]
            y= pos[1]

            #get a list of all sprites that are under the mouse cursor
            #clicked_sprites = [s for s in sprites if s.rect.collidepoint(pos)]
        elif event.type == QUIT:
            running = False
    pygame.display.flip()
pygame.quit()
