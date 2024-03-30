const nodemailer = require('nodemailer');
const Secrets = require('./secrets.js');

// Create a SMTP transporter
let transporter = nodemailer.createTransport({
    host: 'wtc.andreidoroftei.ro', // Your SMTP server host
    port: 465, // SMTP port
    secure: true, // true for 465, false for other ports
    auth: {
        user: 'no-reply@wtc.andreidoroftei.ro', // Your email address
        pass: Secrets.email_password // Your password
    }
});

// Email content
/*let mailOptions = {
    from: 'no-reply@wtc.andreidoroftei.ro', // Sender address
    to: 'andrei.doroftei121@gmail.com', // List of recipients
    subject: 'Test Email', // Subject line
    text: 'This is a test email sent from Node.js.' // Plain text body
    // You can also use html instead of text for HTML content
};

// Send email
transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
        return console.log(error);
    }
    console.log('Message sent: %s', info.messageId);
});*/

let mailUser =  async function (userEmail, emailSubject, emailContent) {

    let mailOptions = {
        from: 'no-reply@wtc.andreidoroftei.ro', // Sender address
        to: userEmail, // List of recipients
        subject: emailSubject, // Subject line
        text: emailContent // Plain text body
        // You can also use html instead of text for HTML content
    };

    transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
            return console.log(error);
        }
        console.log('Message sent: %s', info.messageId);
    });
}
module.exports.mailUser = mailUser;