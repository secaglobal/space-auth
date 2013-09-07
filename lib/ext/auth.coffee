Core = require 'space-core'
Collection = require('norman').Collection
UserSession = require '../model/user/session'
Q = require 'q'

setAuthProperties = (req, user) ->
    req.authUser = user or false
    req.authType = if user then 'USER' else 'GUEST'
    req.isLoggedIn = !!user

module.exports = (req, res, next) ->
    rpgid = req.projectGroupId
    if req.cookies.sid and req.projectGroupId
        new Collection(
            model:UserSession,
            fields: ['user']
            filters: {hash: req.cookies.sid, expire: {$gt: Core.Util.getServerTime()}},
            limit: 1
        ).load()
            .then (sessions) ->
                session = sessions.first()
                pgid = 0
                pgid = session.user.projectGroupId if session and session.user

                setAuthProperties req, pgid is rpgid and session and session.user
                next()
    else
        setAuthProperties(req)
        next()