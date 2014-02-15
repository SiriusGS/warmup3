import unittest
import os
import testLib
import sys


# Test add users
class TestFixtureReset(testLib.RestTestCase):
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)
    
    def testAdd1(self):
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user', 'password' : 'password'} )
        self.makeRequest("/TESTAPI/resetFixture", method="POST")

        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user', 'password' : 'password'} )
        self.assertResponse(respData)

#
class TestAddSameUser(testLib.RestTestCase):
    def assertResponse(self, respData, count = None, errCode = testLib.RestTestCase.ERR_USER_EXISTS):
        expected = {'errCode' : errCode}
        if count is not None:
            expected['count'] = count
        self.assertDictEqual(expected, respData)

    def testAdd1(self):
        self.makeRequest("/users/add", method="POST", data = { 'user' : 'user', 'password' : 'password'} )
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user', 'password' : 'password'} )
        self.assertResponse(respData)

class TestAddNullUsername(testLib.RestTestCase):
    def assertResponse(self, respData, count=None, errCode = testLib.RestTestCase.ERR_BAD_USERNAME):
        expected = {'errCode':errCode}
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testAdd1(self):
       # self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : "", 'password' : 'password'} )
        self.assertResponse(respData)

class TestLongUsername(testLib.RestTestCase):
    def assertResponse(self, respData, count=None, errCode = testLib.RestTestCase.ERR_BAD_USERNAME):
        expected = {'errCode':errCode}
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testAdd1(self):
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'a' * 129, 'password' : 'password'} )
        self.assertResponse(respData)

class TestBadPassword(testLib.RestTestCase):
    def assertResponse(self, respData, count=None, errCode = testLib.RestTestCase.ERR_BAD_PASSWORD):
        expected = {'errCode':errCode}
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)
    def testAdd1(self):
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'a'*129} )
        self.assertResponse(respData)

#Test login
class TestBadCredential(testLib.RestTestCase):
    def assertResponse(self, respData, count= None, errCode = testLib.RestTestCase.ERR_BAD_CREDENTIALS):
        expected = {'errCode':errCode}
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testLogin1(self):
        respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user', 'password' : 'password'} )
        self.assertResponse(respData)


class TestRegisteredLogin(testLib.RestTestCase):
   
    def assertResponse(self, respData, count = 2, errCode = testLib.RestTestCase.SUCCESS):
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)
    
    def testLogin1(self):
        self.makeRequest("/users/add", method="POST", data = { 'user' : 'user', 'password' : 'password'} )
        respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user', 'password' : 'password'} )
        self.assertResponse(respData)



















