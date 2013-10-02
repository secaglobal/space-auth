md5 = require 'md5'
Q = require 'q'
Core = require 'space-core'
ORM = require 'norman'
User = require "#{LIBS_PATH}/model/user"
UserSession = require "#{LIBS_PATH}/model/user/session"
ext = require "#{LIBS_PATH}/ext/auth"


describe '@ExtAuth', () ->
    beforeEach () ->
        @_deferred = Q.defer()
        sinon.stub(ORM.Collection.prototype, 'load').returns @_deferred.promise

    afterEach () ->
        ORM.Collection.prototype.load.restore()

    it 'should search current session', () ->
        req = {cookies: {sid: 12345}, projectGroupId: 1}
        ext(req, {}, ()->)
        expect(ORM.Collection.prototype.load.called).be.ok

        col = ORM.Collection.prototype.load.firstCall.thisValue
        expect(col.config.filters.hash).be.deep.equal 12345
        expect(col.config.filters.expire['$gt']).be.most new Date().getTime() / 1000

    it 'should setup user if projectGroupId is ok', (done) ->
        req = {cookies: {sid: 12345}, projectGroupId: 1}
        user = new User {projectGroupId: 1, id: 4}
        ext(req, {}, ()->)

        @_deferred.promise
            .then () ->
                expect(req.authUser).be.equal user
                expect(req.authType).be.equal 'USER'
                expect(req.isLoggedIn).be.equal true
                done()
            .fail done

        @_deferred.resolve(new ORM.Collection([
            new UserSession({id: 2, user: user})
        ]))

    it 'should be logged out if projectGroupId mismatch', (done) ->
        req = {cookies: {sid: 12345}, projectGroupId: 1}
        user = new User {projectGroupId: 2, id: 4}
        ext(req, {}, ()->)

        @_deferred.promise
            .then () ->
                expect(req.authUser).be.equal false
                expect(req.authType).be.equal 'GUEST'
                expect(req.isLoggedIn).be.equal false
                done()
            .fail done

        @_deferred.resolve(new ORM.Collection([
            new UserSession({id: 2, user: user})
        ]))

    it 'should be logged out if session was not found', (done) ->
        req = {cookies: {sid: 12345}, projectGroupId: 1}
        ext(req, {}, ()->)

        @_deferred.promise
            .then () ->
                expect(req.authUser).be.equal false
                expect(req.authType).be.equal 'GUEST'
                expect(req.isLoggedIn).be.equal false
                done()
            .fail done

        @_deferred.resolve(new ORM.Collection([]))

    it 'should be logged out if sid was not received', () ->
        req = {cookies: {}, projectGroupId: 1}
        ext(req, {}, ()->)

        expect(ORM.Collection.prototype.load.called).be.not.ok
        expect(req.authUser).be.equal false
        expect(req.authType).be.equal 'GUEST'
        expect(req.isLoggedIn).be.equal false

    it 'should be logged out if projectGroupId was not set', () ->
        req = {cookies: {sid: 12345}}
        ext(req, {}, ()->)

        expect(ORM.Collection.prototype.load.called).be.not.ok
        expect(req.authUser).be.equal false
        expect(req.authType).be.equal 'GUEST'
        expect(req.isLoggedIn).be.equal false
