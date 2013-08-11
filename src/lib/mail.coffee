nodemailer = require("nodemailer");
smtpTransport = nodemailer.createTransport("SMTP",{
service: "smtpcom.263xmail.com",
auth: {
user: "map_service@yftech.com",
pass: "www.yfbar.com"
}
})
exports.sendMail=smtpTransport.sendMail
mailOptions = {
from: "map_service✔ <map_service@yftech.com>", # sender address
to: "bar@blurdybloop.com, baz@blurdybloop.com", # list of receivers
subject: "Hello ✔", # Subject line
text: "Hello world ✔", # plaintext body
html: "<b>Hello world ✔</b>" # html body
}