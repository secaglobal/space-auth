md5 = require 'MD5'
_ = require 'underscore'
validate = require('validator').check
User = require '../model/user'
UserSession = require '../model/user/session'
Project = require '../model/project'
WebAPI = require('space-core').WebAPI
Collection = require('norman').Collection

class UserWebAPI extends WebAPI
    @map:
        register: {access: WebAPI.ACCESS__GUEST},
        login: {access: WebAPI.ACCESS__GUEST}

    register: (params, res, req) ->
        if req.isLoggedIn
            return res.error('User already logged in', 'USER_REG__ALREADY_LOGGED_IN').render()

        if not params.projectGroupId
            return res.error('Undefined project group', 'USER_REG__PROJECT_GROUP_UNDEFINED').render()

        if not Project.isPublicRegistrationAllowed params.projectGroupId
            return res.error('Regisration not allowed', 'USER_REG__PUBLIC_REG_NOT_ALLOWED').render()

        user = new User
            email: params.email,
            password: params.password,
            projectGroupId: params.projectGroupId,
            added: parseInt(new Date().getTime() / 1000)

        if user.validate(errors = [])
            user.password = md5(user.password)
            user.save()
                .then () ->
                    UserSession.open(user, req.ip)
                .then (session) ->
                    res.render sid: session.hash
                .fail (err) ->
                    if err.code is 'ER_DUP_ENTRY'
                        res.error('User already `ists', 'USER_REG__ALREADY_EXISTS')
                    else
                        res.error(err.toString(), err.code)
                    res.render()
        else
            res.error(errors).render()

    login: (params, res, req) ->
        validate(params.email, 'EMAIL__INVALID').isEmail()
        validate(params.password, 'PASSWORD__SHORT').len(6, 64)
        validate(params.projectGroupId, 'AUTH__ILLEGAL_PROJECT_GROUP_ID').isInt()

        User.login(params.email, params.password, params.projectGroupId)
            .then (user) ->
                UserSession.open(user)

            .then (session) ->
                res.render sid: session.hash

            .fail (err) ->
                res.error(err.code).render()

module.exports = UserWebAPI
