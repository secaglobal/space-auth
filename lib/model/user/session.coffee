ORM = require 'norman'
User = require '../user'
Exception = require '../../exception'
md5 = require 'MD5'

class UserSession extends ORM.Model
    @schema: new ORM.Schema 'UserSession',
        userId: {type: Number, require: true},
        hash: {type: String, len: 32},
        added: Number,
        expire: Number,
        user: User

    @open: (user, ip) ->
        if not (user instanceof User)
            throw new Exception 'SESSION__ILLEGAL_USER_INSTANCE'

        if not user.id
            throw new Exception 'SESSION__ILLEGAL_USER_INSTANCE'

        time = parseInt(new Date().getTime() / 1000)
        str = new Date().getTime() + '_' + user.id + '_' + user.added + '_' + ip
        session = new @(userId: user.id, hash: md5(str), added: time,  expire: time + 86400)
        session.save().then () -> session

    @clear: () ->
        throw 'TODO spec'

module.exports = UserSession