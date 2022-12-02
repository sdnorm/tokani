class InterpreterController < ApplicationController
  def index
  
    @interpreter_accounts = AccountUser.where("roles->>'interpreter' = 'true'")
     @interpreters = InterpreterDetail.all
  end
end
