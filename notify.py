#!/usr/bin/python3
#coding=utf-8

import time
import redis
from Db import Db
import Log

class NotifyTask():
	
	#redis instance
	_r = ""
	#queue name
	_key = "queue"
	#mysql instance
	_db = ""

	def __init__(self):
		self._r = redis.Redis(host='127.0.0.1',port=6379)
		self._db = Db.getinstance()
	
	def loop(self):
		while True:
			try:
				l = self._r.llen(self._key)
				if l > 0:
					self._db.startTrans()
					self.pop()
					self._db.commit()
			except Exception as e:
				Log.error(e)
				continue
			
			time.sleep(1)

	#insert notify
	def ins(self, sql=""):
		if sql != "":
			print(sql.decode())
			sql = sql.decode()
			self._db.execute(sql)
	
	#pop notify
	def pop(self):
		while True:
			sql = self._r.rpop(self._key)
			#print(sql)
			if sql != None:
				self.ins(sql)
			else:
				return

if __name__ == "__main__":
	t = NotifyTask()
	t.loop()
