const axios = require('axios');
const FormData = require('form-data');
const Secrets = require('./secrets.js');
let mailUser =  async function (userEmail, emailSubject, emailContent) {

    let payload = new FormData();
    payload.append("mail_from", Secrets.mail_from);
    payload.append("password", Secrets.mail_password);
    payload.append("mail_to", userEmail);
    payload.append("subject", emailSubject);
    payload.append("content", emailContent);
    payload.append("subtype", "");

    let res = await axios.post(Secrets.mail_api, payload, {
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Connection": "close"
        }
    }).then(
        response => {
            console.log(response.data);
        }
    ).catch(error => {
        console.error('[Error]：', error);
    });
}
module.exports.mailUser = mailUser;