import bottle
import sqlite3
import random
conn = sqlite3.connect('baza/fourinarow.db')
c = conn.cursor()
username = "prazen"
T = [
    [0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0]]

@bottle.get('/')
def index():
    global winner 
    winner=0
    for i in range(len(T)):
        for j in range(len(T[i])):
            T[i][j]=0
    return bottle.template('entry_page.tpl')

@bottle.post('/check_login/')
def check_login():
    conn = sqlite3.connect('baza/fourinarow.db')
    c = conn.cursor()  
    username = bottle.request.forms['username']
    password = bottle.request.forms['password']
    c.execute("SELECT * from Users where username='{}' and password='{}'".format(username,password))
   
    neki=c.fetchall()
    if neki == []:
        return bottle.template('entry_page.tpl', error = True) 
    else:
        global logedinUsername
        logedinUsername = username
        return bottle.redirect('/game')
    conn.commit()
    
@bottle.post('/check_register/')
def check_register():
    conn = sqlite3.connect('baza/fourinarow.db')
    c = conn.cursor()   
    username = bottle.request.forms['username']
    password = bottle.request.forms['password']
    c.execute("SELECT * from Users where username='{}'".format(username))
    neki=c.fetchall()
    if neki == []:
        print("bla")
        c.execute("INSERT into Users (username, password, number_of_wins) VALUES ('{}','{}',0);".format(username,password))
        conn.commit()
        return bottle.template('entry_page.tpl', error = False) 
    else:
        print("username already exists")
        return bottle.template('register.tpl', error = True)
    conn.commit()

@bottle.post('/insert/')
def insert():   
    row = int(bottle.request.forms['button'])
    global winner
    winner = check_if_finished()
    if winner == 0:
        insertPlayer(row,1)
        winner = check_if_finished()
        if winner == 0:
            bot_turn()
        winner = check_if_finished()
        if winner == 1:
            conn = sqlite3.connect('baza/fourinarow.db')
            c = conn.cursor()
            c.execute("UPDATE Users SET number_of_wins = number_of_wins + 1 WHERE username='{}'".format(logedinUsername))
            conn.commit()        
    return bottle.redirect('/game')

def insertPlayer(row,player):
    if T[0][row] != 0:
        return(1)
    for i in range(6):
        if T[i][row] != 0:
            T[i-1][row]=player
            return(0)
        elif i==5:
            T[i][row]=player
            return(0)

@bottle.get('/game')
def game():
    return bottle.template('game.tpl',username=logedinUsername, T = T,winner=winner)

@bottle.get('/register')
def register():
    return bottle.template('register.tpl')

def check_if_finished():
    allFilled = True
    for i in range(len(T)):
        for j in range(len(T[i])):
            if T[i][j]==0:
                allFilled=False
            else: 
                num=T[i][j]
                if i > 2:
                    if T[i-1][j]==num and T[i-2][j] == num and T[i-3][j] == num:
                        print("konec1")
                        return(num)
                if j < 4:
                    if T[i][j+1]==num and T[i][j+2] == num and T[i][j+3] == num:
                        print("konec2")
                        return(num)
                if i > 2 and j < 4:
                    if T[i-1][j+1]==num and T[i-2][j+2] == num and T[i-3][j+3] == num:
                        print("konec3")
                        return(num)
                if i < 3 and j < 4:
                    if T[i+1][j+1]==num and T[i+2][j+2] == num and T[i+3][j+3] == num:
                        print("konec4")
                        return(num)
    if allFilled == True:
        print("vse je polno")
        return(4)
    return(0)

def bot_turn():
    for i in range(7):
        if T[0][i] == 0:
            insertPlayer(i,2)
            res = check_if_finished()
            if res == 2:
                return()    
            else:
                deleTop(i)
    for i in range(7):
        if T[0][i] == 0:
            insertPlayer(i,1)
            res = check_if_finished()
            if check_if_finished() == 1:
                deleTop(i)
                insertPlayer(i,2)
                return(0)
            else:
                deleTop(i)     

    ran=random.randint(0,6)
    while(insertPlayer(ran,2)==1):
        ran=random.randint(0,6)

def deleTop(row):
    for i in range(6):
        if T[i][row] != 0:
            T[i][row]=0
            break

@bottle.post('/restart/')
def restart():
    global winner
    winner=0
    for i in range(len(T)):
        for j in range(len(T[i])):
            T[i][j]=0
    return bottle.redirect('/game')
    
@bottle.post('/logout/')
def logout():
    logedinUsername=""
    return bottle.redirect('/')