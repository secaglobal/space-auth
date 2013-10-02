Q = require 'q'
Core = require 'space-core'

UserWebAPI = require "#{LIBS_PATH}/web-api/user"
User = require "#{LIBS_PATH}/model/user"

describe '@UserWebAPI', () ->

    beforeEach () ->
        @_res = new Core.Response()

        sinon.stub(@_res, 'error').returns @_res
        sinon.stub(@_res, 'render')

    describe '#login', () ->

        beforeEach () ->
            @_deferred = Q.defer()
            sinon.stub(User, 'login').returns @_deferred.promise

        afterEach () ->
            User.login.restore()

        it 'should check credentials', () ->
            new UserWebAPI({
                email: 'levandovskiy.s@gmail.com', password: 'password', projectGroupId: 2
            }, @_res, {}).execute('login')

            expect(User.login.calledWith 'levandovskiy.s@gmail.com', 'password', 2).be.ok

        it 'should fail if user already logged in', () ->
            new UserWebAPI({}, @_res, {isLoggedIn: true}).execute('login')
            expect(@_res.error.calledWith 'ACCESS_DENIED').be.ok

        it 'should fail if received email is not valid', () ->
            new UserWebAPI({email: 'email'}, @_res, {}).execute('login')
            expect(@_res.error.calledWith 'EMAIL__INVALID').be.ok

        it 'should fail if received illegal password', () ->
            params =
                email: 'levandovskiy.s@gmail.com',
                password: 111

            new UserWebAPI(params, @_res, {}).execute('login')
            expect(@_res.error.calledWith 'PASSWORD__SHORT').be.ok

        it 'should fail if received illegal projectGroupId', () ->
            params =
                email: 'levandovskiy.s@gmail.com',
                password: 111111
                projectGroupId: 'a'

            new UserWebAPI(params, @_res, {}).execute('login')
            expect(@_res.error.calledWith 'AUTH__ILLEGAL_PROJECT_GROUP_ID').be.ok

