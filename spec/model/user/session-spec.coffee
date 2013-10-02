md5 = require 'md5'
Q = require 'q'
Core = require 'space-core'
ORM = require 'norman'
User = require "#{LIBS_PATH}/model/user"
UserSession = require "#{LIBS_PATH}/model/user/session"


describe '@UserSession', () ->
    beforeEach () ->
        @_deferred = Q.defer()
        sinon.stub(UserSession.prototype, 'save').returns @_deferred.promise

    afterEach () ->
        UserSession.prototype.save.restore()

    describe '#open', () ->
        it 'should throw Exception if user is illegal', () ->
            expect(() -> UserSession.open({})).throw Core.Exception
            expect(() -> UserSession.open({id: 2})).throw Core.Exception
            expect(() -> UserSession.open(new User)).throw Core.Exception

        it 'should be used for regitered users', (done) ->
            UserSession.open(new User({id: 4}))
                .then (session) ->
                    expect(session.hash.length).be.equal 32
                    done()
                .fail done

            @_deferred.resolve()

