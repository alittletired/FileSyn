nodemailer = require("nodemailer");
smtpTransport = nodemailer.createTransport("SMTP",{
  host:"smtp.yftech.com",
  auth:{
    user:"map_service@yftech.com",
    pass:"www.yfbar.com"
  }
})
mailOptions = {
  from:"map_service✔ <map_service@yftech.com>",
  to:"zhulin@yftech.com",
  subject:"同步失败文件 ✔",
  text:"服务器监听同步失败 ✔",
  html:"<b>Hello world ✔</b>"
}

exports.sendMail=(opt)->
  opt.from=   opt.from or mailOptions.from
  opt.to=   opt.from or mailOptions.to
  opt.subject=   opt.from or mailOptions.subject
  opt.text=   opt.from or mailOptions.text
  opt.html=   opt.from or mailOptions.html
  smtpTransport.sendMail (opt)
mailOptions = {
from: "map_service✔ <map_service@yftech.com>", # sender address
to: "bar@blurdybloop.com, baz@blurdybloop.com", # list of receivers
subject: "Hello ✔", # Subject line
text: "Hello world ✔", # plaintext body
html: "<b>Hello world ✔</b>" # html body
}