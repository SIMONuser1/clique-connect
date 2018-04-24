# lib/email_interceptor.rb
class EmailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    message.to = [ 'blake.rowley@cliquelabs.com' ]
  end
end

