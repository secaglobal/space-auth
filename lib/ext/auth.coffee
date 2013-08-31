Collection = require('norman').Collection
UserSession = require '../model/user/session'
Q = require 'q'

setAuthProperties = (req, user) ->
    req.authUser = user
    req.authType = if user then 'USER' else 'GUEST'
    req.isLoggedIn = !!user

module.exports = (req, res, next) ->
    if req.cookies.sid
        new Collection(
            model:UserSession,
            fields: ['user']
            filters: {hash: req.cookies.sid, expire: {$lt: new Date().getTime() / 1000}},
            limit: 1
        ).load()
            .then (sessions) ->
                session = sessions.first()
                if session
                    setAuthProperties(req, session.user)

                setAuthProperties(req)
                next()
    else
        setAuthProperties(req)
        next()