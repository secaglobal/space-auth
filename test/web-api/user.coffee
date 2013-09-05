md5 = require 'md5'
request = require 'request'
User = require "#{LIBS_PATH}/model/user"

describe '@User', () ->
    beforeEach (done) ->
        loadFixtures({
            User: [
                {id: 1, email: 'mike@foodquest.com.ua', password: md5('testpass1'), projectGroupId: 1},
                {id: 2, email: 'lev@foodquest.com.ua', password: md5('testpass2'), projectGroupId: 2},
                {id: 3, email: 'zorro@foodquest.com.ua', password: md5('testpass3'), projectGroupId: 2},
            ]
        })
        .then(() -> done()).fail(done)

    describe '#login', () ->
        it 'should return session id if credential is ok', (done) ->
            request {
                url: 'http://localhost:4101/user/login',
                qs: {projectGroupId: 1, email: 'mike@foodquest.com.ua', password: 'testpass1'}
            }, (err, response, body) ->
                return done err if err

                try
                    res = JSON.parse body
                catch e
                    done new Error "Invalid json: #{body}"


                expect(res.status).be.ok
                expect(res.response.sid.length).be.equal 32
                done()

        it 'should return error if password is not ok', () ->
            request {
                url: 'http://localhost:4101/user/login',
                qs: {projectGroupId: 1, email: 'mike@foodquest.com.ua', password: 'wrong password'}
            }, (err, response, body) ->
                return done err if err

                try
                    res = JSON.parse body
                catch e
                    done new Error "Invalid json: #{body}"


                expect(res.status).be.equal false
                expect(res.response).be.not.ok
                done()



