class Project
    @GROUP__ADMIN: 1
    @GROUP__COMMON: 2

    @isPublicRegistrationAllowed: (pgid) ->
        pgid = parseInt(pgid) if typeof pgid == 'string'
        pgid and pgid is @GROUP__COMMON

module.exports = Project