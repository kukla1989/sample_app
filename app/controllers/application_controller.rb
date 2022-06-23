class ApplicationController < ActionController::Base
  def hello
    render html: "hello path to enlightenment :)"
end
