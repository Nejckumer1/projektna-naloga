%rebase('template.tpl')
%import sqlite3
<style>
.link{
  color:#ff5555;
  font-weight: bold;
}
.link:hover{
  color:#dd4949
}
.dot {
  height: 48px;
  width: 48px;
  border-radius: 50%;
  display: inline-block;
}
table,tr,td{
  border:solid black 1px;
  text-align: center;
}
</style>
<div class="row" style="width: 50%;">
  <h4>Loged in as {{username}}</h4>
  <div style="margin-left:400px; margin-top:-10px; position:absolute;">
    <form action='/logout/' method="post">
      <button type="submit" class="waves-effect waves-light btn" style="background-color: #ff5555; margin-bottom:10px;">Logout</button>
    </form>
    %conn = sqlite3.connect('baza/fourinarow.db')
    %c = conn.cursor()   
    %c.execute("SELECT username,number_of_wins FROM Users ORDER BY number_of_wins DESC LIMIT 5")
    %neki=c.fetchall();
    <p>Leaderboard</p>
    <table style="width:200px">
      <tr>
        <td>Username</td>
        <td>Number of wins</td>
      </tr>
      %for i in neki:
        %neki_username = i[0]
        %neki_wins = i[1]
        <tr>
          <td>{{neki_username}}</td>
          <td>{{neki_wins}}</td>
        </tr>
      %end
      %conn.close
    </table> 
  </div>
  %if winner==1:
    <h4 style="color:green">you win</h4>
  %elif winner==2:
    <h4 style="color:red">you lose</h4>
  %elif winner==4:
    <h3 style="color:orange">draw</h3>
  %end   
  <br><br>
  <form action='/restart/' method="post">
      <button type="submit" class="waves-effect waves-light btn" style="background-color: #ff5555; margin-bottom:10px;">restart</button>
  </form>
  %if winner == 0:
    %for i in range(7):
      %marginLeft=i*50
      <form action='/insert/' method="post" style="position: absolute;margin-left:{{marginLeft}}px;">
        %if T[0][i] == 0:
          <button value="{{i}}" type="submit" id = "{{i}}" name="button" style="width:50px;height: 50px;"></button>
        %else:
          <button disabled value="{{i}}" type="submit" id = "{{i}}" name="button" style="width:50px;height: 50px;"></button>   
        %end
      </form>
    %end
  %end

<br>
<br>
<br>
  %for i in range(len(T)):
    %for j in range(len(T[i])):
      %color = "white"
      %if T[i][j] == 1:
        %color = "blue"
      %end
      %if T[i][j] == 2:
        %color = "red"
      %end
      %marginLeft = 50*j
      %marginTop = 50*i
      <div 
        style = "border:solid black 1px;
        height:50px;width:50px;
        position:absolute;
        margin-left:{{marginLeft}}px;
        margin-top:{{marginTop}}px;"
      > 
        <span class="dot" style="background-color: {{color}};"></span>
      </div>
    %end
  %end
  <br>

</div>
