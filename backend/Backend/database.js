var mariadb = require('mariadb');
const bcrypt = require("bcryptjs");
let Secrets = require('./secrets.js');
var Promise = require('bluebird');
const { async } = require('q');
const { query } = require('express');

const pool = mariadb.createPool({
    host: Secrets.host,
    user: Secrets.username,
    password: Secrets.password,
    database: Secrets.database,
    charset: 'utf8mb4',
    collate: 'utf8mb4_general_ci',
    connectionLimit: 10
})

let getPool = function () {
    return pool;
}
//MODEL
async function query_checkIfUserExistsByUsername(username) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT COUNT(*) as accountNumber FROM `users` WHERE `username` =' + pool.escape(username);
            const rows = await conn.query(mysql_query);
            conn.end();
            var results = Object.assign({}, rows[0]);
            if (results["accountNumber"] == 1) return resolve(true);
            return resolve(false);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_checkIfUserExistsByEmail(email) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT COUNT(*) as accountNumber FROM `users` WHERE `email` =' + pool.escape(email);
            const rows = await conn.query(mysql_query);
            conn.end();
            var results = Object.assign({}, rows[0]);
            if (results["accountNumber"] == 1) return resolve(true);
            return resolve(false);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_checkIfUserExistsById(userId) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT COUNT(*) as accountNumber FROM `users` WHERE `id` =' + pool.escape(userId);
            const rows = await conn.query(mysql_query);
            conn.end();
            let results = Object.assign({}, rows[0]);
            if (results["accountNumber"] == 1) return resolve(true);
            return resolve(false);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_addUser(username, email, token) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT `password`  FROM `register` WHERE `token` =' + pool.escape(token);
            let rows = await conn.query(mysql_query);
            let results = Object.assign({}, rows[0]);
            let password = results["accountNumber"];

            mysql_query = 'DELETE * FROM `register` WHERE `token` = ' + pool.escape(token);
            await conn.query(mysql_query);

            mysql_query = 'INSERT INTO `users`(`username`, `email`, `password`) VALUES (' + pool.escape(username) + ',' + pool.escape(email) + ',' + pool.escape(password) + ')';
            rows = await conn.query(mysql_query);
            mysql_query = 'SELECT `id` FROM `users` WHERE username = ' + pool.escape(username);
            rows = await conn.query(mysql_query);
            results = Object.assign({}, rows[0]);
            var sqlId = results["id"];
            mysql_query = 'INSERT INTO `watch_list`(`user_id`) VALUES (' + pool.escape(sqlId) + ')';
            rows = await conn.query(mysql_query);
            conn.end();
            return resolve(true);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_addRegister(username, email, password, token, timestamp) {
    await query_removeExpiredRegisterTokens();
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'INSERT INTO `register`(`username`, `email`, `password`, `token`, `timestamp`) VALUES (' + pool.escape(username) + ',' + pool.escape(email) + ',' + pool.escape(password) + ',' + pool.escape(token) + ',' + pool.escape(timestamp) + ')';
            await conn.query(mysql_query);
            conn.end();
            return resolve(true);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
/*
return -1 => problems with db
return -2 => password is not correct
return id => password is correct for user
*/
async function query_checkIfPasswordIsCorrectForUser(username, password) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT `password`, `id` FROM `users` WHERE `username` =' + pool.escape(username);
            const rows = await conn.query(mysql_query);
            conn.end();
            let results = Object.assign({}, rows[0]);
            let encryptedPassword = results["password"];
            let userId = results["id"];
            if (encryptedPassword == null || userId == null) return resolve(-1);
            if (bcrypt.compareSync(password, encryptedPassword))
                return resolve(userId);
            return resolve(-2);

        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
/*
return -1 => problems with db
return  0 => password is not correct
return  1 => password is correct for user
*/
async function query_checkIfPasswordIsCorrectForUserId(userId, password) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT `password` FROM `users` WHERE `id` =' + pool.escape(userId);
            const rows = await conn.query(mysql_query);
            conn.end();
            let results = Object.assign({}, rows[0]);
            let encryptedPassword = results["password"];
            if (encryptedPassword == null) return resolve(-1);
            if (bcrypt.compareSync(password, encryptedPassword))
                return resolve(1);
            return resolve(0);

        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
/*
return 1  -> ok
return -1 -> db problem*/
async function query_changePasswordForUserId(userId, newPassword) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'UPDATE `users` SET `password`=' + pool.escape(newPassword) + ' WHERE `id` = ' + pool.escape(userId);
            const rows = await conn.query(mysql_query);
            conn.end();
            if (rows == null) return resolve(-1);
            return resolve(1);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
/*
return 1  -> ok
return -1 -> db problem*/
async function query_changeEmailForUserId(userId, newEmail) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'UPDATE `users` SET `email`=' + pool.escape(newEmail) + ' WHERE `id` = ' + pool.escape(userId);
            const rows = await conn.query(mysql_query);
            conn.end();
            if (rows == null) return resolve(-1);
            return resolve(1);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}


async function query_getAllCoins() {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT * FROM `coins` WHERE 1';
            const rows = await conn.query(mysql_query);
            conn.end();
            var normalObj = Object.assign({}, rows);
            var coins_list = [];
            for (var i = 0; i < Object.keys(normalObj).length - 1; i++) {
                coins_list.push(normalObj[i]);
            }
            return resolve(coins_list);

        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_checkIfCoinExistsById(coinId) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT COUNT(*) as coinsNumber FROM `coins` WHERE `id` =' + pool.escape(coinId);
            const rows = await conn.query(mysql_query);
            conn.end();
            var results = Object.assign({}, rows[0]);
            if (results["coinsNumber"] == 1) return resolve(true);
            return resolve(false);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_getInfoForCoinId(coinId) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT * FROM `coins` WHERE `id` = ' + pool.escape(coinId);
            const rows = await conn.query(mysql_query);
            conn.end();
            var normalObj = Object.assign({}, rows[0]);
            var coin_info = {};

            coin_info["id"] = normalObj["id"];
            coin_info["name"] = normalObj["name"];

            return resolve(coin_info);

        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_getEmailForUserId(userId) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT `email` FROM `users` WHERE `id` = ' + pool.escape(userId);
            const rows = await conn.query(mysql_query);
            conn.end();
            var normalObj = Object.assign({}, rows[0]);
            return resolve(normalObj["email"]);

        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_getUserNameForUserId(userId) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT `username` FROM `users` WHERE `id` = ' + pool.escape(userId);
            const rows = await conn.query(mysql_query);
            conn.end();
            var normalObj = Object.assign({}, rows[0]);
            return resolve(normalObj["username"]);

        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_updateCoinsForUser(userId, coins_string) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'UPDATE `watch_list` SET `coin_names` = ' + pool.escape(coins_string) + ' WHERE `user_id` = ' + pool.escape(userId);
            const rows = await conn.query(mysql_query);
            conn.end();
            return resolve(true);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}

async function query_getCoinsForUserId(userId) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT `coin_names` FROM `watch_list` WHERE `user_id` = ' + pool.escape(userId);
            const rows = await conn.query(mysql_query);
            conn.end();
            var result = Object.assign({}, rows[0]);
            //console.log(result);
            return resolve(result["coin_names"]);

        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_removeUser(userId) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'DELETE FROM `watch_list` WHERE `user_id` = ' + pool.escape(userId);
            conn.query(mysql_query);
            mysql_query = 'DELETE FROM `users` WHERE `id` = ' + pool.escape(userId);
            conn.query(mysql_query);
            conn.end();
            return resolve(true);

        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}

async function query_removeExpiredForgotPasswordTokens() {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            let maxTimeStamp = Math.floor(Date.now() / 1000) - 10 * 60;
            conn = await pool.getConnection();
            let mysql_query = 'DELETE FROM `forgot_password` WHERE `emited_time` <= ' + pool.escape(maxTimeStamp);
            const rows = await conn.query(mysql_query);
            conn.end();
            return resolve(true);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_checkIfForgotPasswordTokenExists(forgotPasswordToken) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            let maxTimeStamp = Math.floor(Date.now() / 1000) - 10 * 60;
            conn = await pool.getConnection();
            let mysql_query = 'SELECT COUNT(*) as tokenCount FROM `forgot_password` WHERE `token` =' + pool.escape(forgotPasswordToken);
            const rows = await conn.query(mysql_query);
            conn.end();
            var result = Object.assign({}, rows[0]);
            if (result["tokenCount"] >= 1) return resolve(true);
            return resolve(false);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_addForgotPasswordToken(userId, currentTimeStamp, forgotPasswordToken) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'INSERT INTO `forgot_password`(`user_id`, `emited_time`, `token`) VALUES (' + pool.escape(userId) + ', ' + pool.escape(currentTimeStamp) + ', ' + pool.escape(forgotPasswordToken) + ')';
            const rows = await conn.query(mysql_query);
            conn.end();
            return resolve(true);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}

async function query_getUserIdFromEmail(email) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT `id` FROM `users` WHERE `email` =' + pool.escape(email);
            const rows = await conn.query(mysql_query);
            conn.end();
            var result = Object.assign({}, rows[0]);
            return resolve(result["id"] );
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_checkIfEmailAlreadyEmited(userId) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT COUNT(*) as countEmited FROM `forgot_password` WHERE `user_id` =' + pool.escape(userId);
            const rows = await conn.query(mysql_query);
            conn.end();
            var result = Object.assign({}, rows[0]);
            if (result["countEmited"] >= 1) return resolve(true);
            return resolve(false);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_checkIfFPTokenIsValid(userId, forgotPasswordToken) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT COUNT(*) as countEmited FROM `forgot_password` WHERE `user_id` =' + pool.escape(userId) + ' AND `token` = ' + pool.escape(forgotPasswordToken);
            const rows = await conn.query(mysql_query);
            conn.end();
            let result = Object.assign({}, rows[0]);
            if (result["countEmited"] >= 1) return resolve(true);
            return resolve(false);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_removeFPToken(userId) {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'DELETE FROM `forgot_password` WHERE `user_id` =' + pool.escape(userId);
            const rows = await conn.query(mysql_query);
            conn.end();
            return resolve(true);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_removeExpiredRegisterTokens() {
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            let maxTimeStamp = Math.floor(Date.now() / 1000) - 10 * 60;
            conn = await pool.getConnection();
            let mysql_query = 'DELETE FROM `register` WHERE `timestamp` <= ' + pool.escape(maxTimeStamp);
            const rows = await conn.query(mysql_query);
            conn.end();
            return resolve(true);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_checkIfRegisterTokenExists(token) {
    await query_removeExpiredRegisterTokens();
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT COUNT(*) as countTokens FROM `register` WHERE `token` =' + pool.escape(token);
            const rows = await conn.query(mysql_query);
            conn.end();
            let result = Object.assign({}, rows[0]);
            if (result["countTokens"] >= 1) return resolve(true);
            return resolve(false);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_checkIfRegisterEmailExists(email) {
    await query_removeExpiredRegisterTokens();
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT COUNT(*) as countRows FROM `register` WHERE `email` =' + pool.escape(email);
            const rows = await conn.query(mysql_query);
            conn.end();
            let result = Object.assign({}, rows[0]);
            if (result["countRows"] >= 1) return resolve(true);
            return resolve(false);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_checkIfRegisterUsernameExists(username) {
    await query_removeExpiredRegisterTokens();
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT COUNT(*) as countRows FROM `register` WHERE `username` =' + pool.escape(username);
            const rows = await conn.query(mysql_query);
            conn.end();
            let result = Object.assign({}, rows[0]);
            if (result["countRows"] >= 1) return resolve(true);
            return resolve(false);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
async function query_checkIfRegisterDataMatch(username, email, token) {
    await query_removeExpiredRegisterTokens();
    let conn;
    try {
        return new Promise(async (resolve, reject) => {
            conn = await pool.getConnection();
            let mysql_query = 'SELECT `username`, `email` FROM `register` WHERE `token` =' + pool.escape(token);
            const rows = await conn.query(mysql_query);
            conn.end();
            let result = Object.assign({}, rows[0]);
            if (result["username"] == username && result["email"] == email) return resolve(true);
            return resolve(false);
        });
    } catch (err) {
        throw err;
    } finally {
        if (conn) return conn.end();
    }
}
module.exports.checkIfUserExistsByUsername = query_checkIfUserExistsByUsername;
module.exports.checkIfUserExistsByEmail = query_checkIfUserExistsByEmail;
module.exports.checkIfUserExistsById = query_checkIfUserExistsById;
module.exports.checkIfPasswordIsCorrectForUser = query_checkIfPasswordIsCorrectForUser;
module.exports.checkIfPasswordIsCorrectForUserId = query_checkIfPasswordIsCorrectForUserId;
module.exports.changePasswordForUserId = query_changePasswordForUserId;
module.exports.changeEmailForUserId = query_changeEmailForUserId;
module.exports.getAllCoins = query_getAllCoins;
module.exports.checkIfCoinExistsById = query_checkIfCoinExistsById;
module.exports.getInfoForCoinId = query_getInfoForCoinId;
module.exports.getCoinsForUserId = query_getCoinsForUserId;
module.exports.removeUser = query_removeUser;
module.exports.getUserNameForUserId = query_getUserNameForUserId;
module.exports.getEmailForUserId = query_getEmailForUserId;
module.exports.updateCoinsForUser = query_updateCoinsForUser;
module.exports.addUser = query_addUser;
module.exports.removeExpiredForgotPasswordTokens = query_removeExpiredForgotPasswordTokens;
module.exports.checkIfForgotPasswordTokenExists = query_checkIfForgotPasswordTokenExists;
module.exports.addForgotPasswordToken = query_addForgotPasswordToken;
module.exports.getUserIdFromEmail = query_getUserIdFromEmail;
module.exports.checkIfEmailAlreadyEmited = query_checkIfEmailAlreadyEmited;
module.exports.checkIfFPTokenIsValid = query_checkIfFPTokenIsValid;
module.exports.removeFPToken = query_removeFPToken;
module.exports.removeExpiredRegisterTokens = query_removeExpiredRegisterTokens;
module.exports.checkIfRegisterTokenExists = query_checkIfRegisterTokenExists;
module.exports.checkIfRegisterEmailExists = query_checkIfRegisterEmailExists;
module.exports.checkIfRegisterUsernameExists = query_checkIfRegisterUsernameExists;
module.exports.addRegister = query_addRegister;
module.exports.checkIfRegisterDataMatch = query_checkIfRegisterDataMatch;