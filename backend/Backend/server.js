const bcrypt = require("bcryptjs");
const bodyParser = require('body-parser');
const jwt = require("jsonwebtoken");
const cors = require('cors');
const express = require('express');
const { async } = require('q');
const https = require('https');
const fs = require('fs');
const options = {
    key: fs.readFileSync('key.pem', 'utf8'),
    cert: fs.readFileSync('cert.pem', 'utf8')
  };
var Promise = require('bluebird');

let Secrets = require('./secrets.js');
let Database = require('./database.js');
let SendMail = require('./send_mail.js');
const port = 5052;
const app = express();

app.use(cors());

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

easyStatusText = (res, statusCode, text) => {
    res.status(statusCode);
    res.send(text);
}

ApiRegister = async (req, res) => {
    let userJsonData = req.body;
    let username = userJsonData.username;
    let password = userJsonData.password;
    let email = userJsonData.email;
    if (username == null || password == null || email == null)
        easyStatusText(res, 400, 'Some data are missing! (username/password/email).');
    else {
        let usernameExists = await Database.checkIfUserExistsByUsername(username);
        if (usernameExists == true)
            easyStatusText(res, 409, 'A user with this username already exists.');
        else {
            let emailExists = await Database.checkIfUserExistsByEmail(email);
            if (emailExists == true)
                easyStatusText(res, 409, 'A user with this email already exists.');
            else {
                let encryptedPassword = bcrypt.hashSync(password, 10);
                let addUserStatus = await Database.addUser(username, email, encryptedPassword);
                if (addUserStatus == true)
                    
                    easyStatusText(res, 200, "Account created succesfully.");
                else
                    easyStatusText(res, 409, "Error while inserting new user into database.");
            }
        }
    }
}
ApiLogin = async (req, res) => {
    let userJsonData = req.body;
    let username = userJsonData.username;
    let password = userJsonData.password;
    if (username == null || password == null)
        easyStatusText(res, 400, 'Some data are missing! (username/password).');
    else {
        let usernameExists = await Database.checkIfUserExistsByUsername(username);
        if (usernameExists == false)
            easyStatusText(res, 409, 'A user with this username doesn\'t exist.');
        else {
            let isPasswordCorrect = await Database.checkIfPasswordIsCorrectForUser(username, password);
            if (isPasswordCorrect == -1)
                easyStatusText(res, 409, 'Database error.');
            else {
                if (isPasswordCorrect == -2)
                    easyStatusText(res, 409, 'Password is not correct for this username.');
                else {
                    const user_token = jwt.sign({ userid: isPasswordCorrect }, Secrets.jwt_secret);
                    let userEmail = await Database.getEmailForUserId(isPasswordCorrect);
                    let userName = await Database.getUserNameForUserId(isPasswordCorrect);
                    var rawJson = {
                        token: user_token,
                        email: userEmail,
                        username: userName
                    }
                    res.status(200);
                    res.send(JSON.stringify(rawJson));
                    //aici trebuie sa intorc jwt pentru ca are parola corecta si usernameul
                }
            }

        }
    }
}
ApiChangePassword = async (req, res) => {
    let userJsonData = req.body;
    let token = userJsonData.token;
    let newPassword = userJsonData.new_password;
    let password = userJsonData.password;
    if (password == null || newPassword == null || token == null)
        easyStatusText(res, 400, 'Some data are missing! (token/password/new password).');
    else {
        jwt.verify(token, Secrets.jwt_secret, async function (err, decoded) {
            if (err)
                easyStatusText(res, 400, 'Session lost. Please reconnect');
            else {
                let userId = decoded.userid;
                let userIdExists = await Database.checkIfUserExistsById(userId);
                if (userIdExists == false)
                    easyStatusText(res, 409, 'A user with this userid doesn\' exist.');
                else {
                    let isPasswordCorrect = await Database.checkIfPasswordIsCorrectForUserId(userId, password);
                    if (isPasswordCorrect == -1)
                        easyStatusText(res, 400, 'Database error');
                    else {
                        if (isPasswordCorrect == 0)
                            easyStatusText(res, 409, 'Password is not correct.');
                        else {
                            let encryptedNewPassword = bcrypt.hashSync(newPassword, 10);
                            let changePasswordStatus = await Database.changePasswordForUserId(userId, encryptedNewPassword);
                            if (changePasswordStatus == 1)
                                easyStatusText(res, 200, 'User password changed successfully.');
                            else
                                easyStatusText(res, 400, 'Database error.');
                        }
                    }
                }
            }
        });
    }
}
ApiChangeEmail = async (req, res) => {
    let userJsonData = req.body;
    let token = userJsonData.token;
    let newEmail = userJsonData.new_email;
    let password = userJsonData.password;
    if (password == null || newEmail == null || token == null)
        easyStatusText(res, 400, 'Some data are missing! (token/password/new email).');
    else {
        jwt.verify(token, Secrets.jwt_secret, async function (err, decoded) {
            if (err)
                easyStatusText(res, 400, 'Session lost. Please reconnect');
            else {
                let userId = decoded.userid;
                let userIdExists = await Database.checkIfUserExistsById(userId);
                if (userIdExists == false)
                    easyStatusText(res, 409, 'A user with this userid doesn\'t exist.');
                else {
                    let isPasswordCorrect = await Database.checkIfPasswordIsCorrectForUserId(userId, password);
                    if (isPasswordCorrect == -1)
                        easyStatusText(res, 400, 'Database error');
                    else {
                        if (isPasswordCorrect == 0)
                            easyStatusText(res, 409, 'Password is not correct.');
                        else {
                            let changeEmailStatus = await Database.changeEmailForUserId(userId, newEmail);
                            if (changeEmailStatus == 1)
                                easyStatusText(res, 200, 'User email changed successfully.');
                            else
                                easyStatusText(res, 400, 'Database error.');
                        }
                    }
                }
            }
        });
    }
}
ApiGetAllCoins = async (req, res) => {
    let coinsObj = await Database.getAllCoins();
    if (coinsObj == null)
        easyStatusText(res, 400, 'Database error.');
    else
        easyStatusText(res, 200, coinsObj);
}
ApiGetCoinInfo = async (req, res) => {
    let userJsonData = req.body;
    let coinId = userJsonData.coin_id;
    if (coinId == null)
        easyStatusText(res, 400, 'Some data are missing! (coin_id).');
    else {
        let coinExists = await Database.checkIfCoinExistsById(coinId);
        if (coinExists == false)
            easyStatusText(res, 409, 'A coin with this id doesn\'t exist.');
        else {
            let coinInfo = await Database.getInfoForCoinId(coinId);
            easyStatusText(res, 200, coinInfo);
        }
    }
}
ApiGetCoinsForUser = async (req, res) => {
    let userJsonData = req.body;
    let token = userJsonData.token;
    if (token == null)
        easyStatusText(res, 400, 'Some data are missing! (token).');
    else {
        jwt.verify(token, Secrets.jwt_secret, async function (err, decoded) {
            if (err)
                easyStatusText(res, 400, 'Session lost. Please reconnect');
            else {
                let userId = decoded.userid;
                let userIdExists = await Database.checkIfUserExistsById(userId);
                if (userIdExists == false)
                    easyStatusText(res, 409, 'A user with this userid doesn\'t exist.');
                else {
                    let getCoinsForUserStatus = await Database.getCoinsForUserId(userId);
                    easyStatusText(res, 200, getCoinsForUserStatus);
                }
            }
        });
    }
}
ApiRemoveUser = async (req, res) => {
    let userJsonData = req.body;
    let token = userJsonData.token;
    let password = userJsonData.password
    if (token == null || password == null)
        easyStatusText(res, 400, 'Some data are missing! (token/password).');
    else {
        jwt.verify(token, Secrets.jwt_secret, async function (err, decoded) {
            if (err)
                easyStatusText(res, 400, 'Session lost. Please reconnect');
            else {
                let userId = decoded.userid;
                let userIdExists = await Database.checkIfUserExistsById(userId);
                if (userIdExists == false)
                    easyStatusText(res, 409, 'A user with this userid doesn\'t exist.');
                else {
                    let isPasswordCorrect = await Database.checkIfPasswordIsCorrectForUserId(userId, password);
                    if (isPasswordCorrect == -1)
                        easyStatusText(res, 400, 'Database error');
                    else {
                        if (isPasswordCorrect == 0)
                            easyStatusText(res, 409, 'Password is not correct.');
                        else {
                            let removeUserStatus = await Database.removeUser(userId);
                            if (removeUserStatus == true)
                                easyStatusText(res, 200, 'User deteled succesfully.');
                            else
                                easyStatusText(res, 409, 'User deteled succesfully.');
                        }
                    }
                }
            }
        });
    }
}
ApiUpdateCoinForUser = async (req, res) => {
    let userJsonData = req.body;
    let token = userJsonData.token;
    let coins_string = userJsonData.coins_string;
    if (token == null || coins_string == null)
        easyStatusText(res, 400, 'Some data are missing! (token/coins_string).');
    else {
        jwt.verify(token, Secrets.jwt_secret, async function (err, decoded) {
            if (err)
                easyStatusText(res, 400, 'Session lost. Please reconnect');
            else {
                let userId = decoded.userid;
                let userIdExists = await Database.checkIfUserExistsById(userId);
                if (userIdExists == false)
                    easyStatusText(res, 409, 'A user with this userid doesn\'t exist.');
                else {
                    let updateStatus = await Database.updateCoinsForUser(userId, coins_string);
                    if (updateStatus == true)
                        easyStatusText(res, 200, "Updated");
                    else
                        easyStatusText(res, 409, "Database error");
                }
            }
        });
    }
}
//routes
app.post('/api/register', (req, res) => {
    ApiRegister(req, res);
});
app.post('/api/change-password', (req, res) => {
    ApiChangePassword(req, res);
});
app.post('/api/change-email', (req, res) => {
    ApiChangeEmail(req, res);
});
app.post('/api/login', (req, res) => {
    ApiLogin(req, res);
});
app.get('/api/get-all-coins', (req, res) => {
    ApiGetAllCoins(req, res);
});
app.get('/api/get-coin-info', (req, res) => {
    ApiGetCoinInfo(req, res);
});

app.post('/api/get-coins-for-user', (req, res) => {
    ApiGetCoinsForUser(req, res);
});
app.post('/api/remove-user', (req, res) => {
    ApiRemoveUser(req, res);
});
app.post('/api/update-coins-for-user', (req, res) => {
    ApiUpdateCoinForUser(req, res);
});
var server = https.createServer(options, app);
server.listen(port, () => {
    console.log("[Info] WTC server starting on port : " + port)
  });
  