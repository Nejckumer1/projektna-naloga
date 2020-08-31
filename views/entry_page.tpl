%rebase('template.tpl')
<style>
.link{
  color:#ff5555;
  font-weight: bold;
}
.link:hover{
  color:#dd4949
}
</style>
<div class="row" style="width: 50%; ">
  <h3>Welcome to the simple four in a row game</h3>
  <form class="col s12" action='/check_login/' method="post">
    <div class="row">
      <div class="input-field col s12">
        <input id="username" name='username' type="text" class="validate">
        <label for="username">Username</label>
      </div>
    </div>
    <div class="row">
      <div class="input-field col s12">
        <input id="password" name='password' type="password" class="validate">
        <label for="password">Password</label>
      </div>
    </div>
    <button class="btn waves-effect waves-light" style="background-color: #ff5555; margin-right:20px;" type="submit" name="action">Login</button>
    Don't have an account? Register <a href="http://127.0.0.1:8080/register" class="link">here</a>.
  </form>
  %try:
    %if error == True:
       <p style="color: #ff5555;">Wrong username or password!</p> <br>
    %end
  %except NameError:
    %print("Prvič prijavil")
</div>
