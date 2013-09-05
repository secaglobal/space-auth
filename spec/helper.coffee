global.LIBS_PATH = "#{__dirname}/../lib"

ORM = require 'norman'

chai = require 'chai'
chai.should()
global.expect = chai.expect
global.sinon = require 'sinon'

ORM.DataProvider.registerProxy 'default', new ORM.MysqlProxy
