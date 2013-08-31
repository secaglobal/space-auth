ORM = require 'norman'

class User extends ORM.Model
    @schema: new ORM.Schema 'User',
        email: {type: String, require: true},
        password: {type: String, minLen: 6, maxLen: 255},
        added: Number,
        projectGroupId: {type: Number, require: true}

    @login: (email, password) ->
        throw 'TODO spec'

    @checkEmail: (email) ->
        throw 'TODO spec'

module.exports = User