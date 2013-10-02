md5 = require 'md5'
Q = require 'q'
Core = require 'space-core'
ORM = require 'norman'
User = require "#{LIBS_PATH}/model/user"

describe '@User', () ->
    beforeEach () ->
        @_deferred = Q.defer()
        sinon.stub(ORM.Collection.prototype, 'load').returns @_deferred.promise
        @_collectionLoad = ORM.Collection.prototype.load

    afterEach () ->
        ORM.Collection.prototype.load.restore()

    describe '#login', () ->
        it 'should search user', () ->
            User.login 'email', 'password', 12

            expect(@_collectionLoad.called).be.ok
            expect(@_collectionLoad.firstCall.thisValue.config.filters).be.deep.equal
                email: 'email',
                password: md5('password'),
                projectGroupId: 12

        it 'should return user if credentials are correct', (done) ->
            User.login('email', 'password', 12)
                .then (user) ->
                    expect(user.id).be.equal 4
                    done()
                .fail done

            @_deferred.resolve(new ORM.Collection([{id: 4}], {model: User}))

        it 'should fail if credentials are incorrect', (done) ->
            User.login('email', 'password', 12)
                .then (user) ->
                    done(new Error 'Should throw error')
                .fail (err) ->
                    expect(err.code).be.equal 'USER_LOGIN__WRONG_CREDENTIALS'
                    done()

            @_deferred.resolve(new ORM.Collection({model: User}))


