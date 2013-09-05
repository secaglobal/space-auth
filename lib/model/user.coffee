Core = require 'space-core'
ORM = require 'norman'
md5 = require 'MD5'

class User extends ORM.Model
    @schema: new ORM.Schema 'User',
        email: {type: String, require: true},
        password: {type: String, minLen: 6, maxLen: 255},
        added: Number,
        projectGroupId: {type: Number, require: true}

    @login: (email, password, projectGroupId) ->
        new ORM.Collection(
            model: User,
            filters:
                email: email,
                password: md5(password),
                projectGroupId: projectGroupId
        ).load().then (col) ->
            col.first() or throw new Core.Exception('USER_LOGIN__WRONG_CREDENTIALS')

    @checkEmail: (email) ->
        throw 'TODO spec'

module.exports = User