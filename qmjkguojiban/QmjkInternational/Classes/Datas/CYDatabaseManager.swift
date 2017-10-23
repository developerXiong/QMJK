//
//  CYDatabaseManager.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/21.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

import SQLite

//class CYDatabaseManager {
//    private var db: Connection!
//    
//    /// 主表 user
//    private let users = Table("user")                      //表名
//    private let id = Expression<Int64>("id")               //主键
//    private let password = Expression<String>("password")  //列表1
//    private let email = Expression<String>("email")        //列表2
//    private let isUpload_user = Expression<Bool>("isUpload_user")    //是否上传到服务器
//    
//    /// 从表 subUser
//    private let subUsers = Table("subUser")                         //表名
//    private let sid = Expression<Int64>("sid")                      //主键
//    private let name = Expression<String>("name")                   //列表1
//    private let createTime = Expression<Date>("createTime")         //列表2
//    private let sex = Expression<Bool>("sex")                       //列表2
//    private let birth = Expression<String>("birth")                     //列表2
//    private let height = Expression<String>("height")               //列表2
//    private let weight = Expression<String>("weight")               //列表2
//    private let highBP = Expression<String>("highBP")               //列表2
//    private let lowBP = Expression<String>("lowBP")                 //列表2
//    private let user_id = Expression<Int64>("user_id")              //外键--关联user.id
//    private let isUpload_sub = Expression<Bool>("isUpload_sub")    //是否上传到服务器
//    
//    /// 历史记录 history
//    private let history = Table("history")                          //表名
//    private let hid = Expression<Int64>("hid")                      //主键
//    private let rate = Expression<Int>("rate")                      //主键
//    private let oxygen = Expression<Int>("oxygen")                  //列表1
//    private let breath = Expression<Int>("breath")                  //列表2
//    private let high = Expression<Int>("high")                      //列表2
//    private let low = Expression<Int>("low")                        //列表2
//    private let PI = Expression<Int>("PI")                          //列表2
//    private let createTime_h = Expression<Date>("createTime_h")     //列表2
//    private let sid_id = Expression<Int64>("sid_id")                //外键--关联subUser.sid
//    private let isUpload_history = Expression<Bool>("isUpload_history")    //是否上传到服务器
//    
//    
//    static let shared = CYDatabaseManager()
//    
//    private init() {
//        let sqlFilePath = NSHomeDirectory() + "/Documents" + "/db.sqlite3"
//        do {
//            db = try Connection(sqlFilePath)
//        } catch {
//            debugPrint("connect db error: \(error)")
//        }
//        createdTableUser()
//        createdTableSubUser()
//        createdTableHistory()
//    }
//    
//    /// 创建User表
//    func createdTableUser()  {
//        do {
//            try db.run(users.create(ifNotExists: true) { t in
//                t.column(id, primaryKey: true)
//                t.column(password)
//                t.column(email, unique: true)
//                t.column(isUpload_user, defaultValue: false)
//            })
//            debugPrint("建表users成功!")
//        } catch { debugPrint("create user table error: \(error)") }
//    }
//    
//    /// 创建subUser 表
//    func createdTableSubUser()  {
//        do {
//            try db.run(subUsers.create(ifNotExists: true) { t in
//                t.column(sid, primaryKey: true)
//                t.column(name)
//                t.column(createTime)
//                t.column(sex)
//                t.column(birth)
//                t.column(height)
//                t.column(weight)
//                t.column(highBP)
//                t.column(lowBP)
//                t.column(isUpload_sub, defaultValue: false)
//                t.column(user_id)
//                t.foreignKey(user_id, references: users, id, delete: .setNull)
//            })
//            debugPrint("建表subUsers成功!")
//        } catch { debugPrint("create subUser table error: \(error) \nEnd") }
//        db.trace({ (statement) in
//            debugPrint("---\(statement)")
//        })
//    }
//    
//    /// 创建历史记录表
//    func createdTableHistory() {
//        do {
//            try db.run(history.create(ifNotExists: true) { t in
//                t.column(hid, primaryKey: true)
//                t.column(rate)
//                t.column(oxygen)
//                t.column(breath)
//                t.column(low)
//                t.column(high)
//                t.column(PI)
//                t.column(createTime_h)
//                t.column(isUpload_history, defaultValue: false)
//                t.column(sid_id)
//                t.foreignKey(sid_id, references: subUsers, sid, delete: .setNull)
//            })
//            debugPrint("建表history成功!")
//        } catch { debugPrint("create history table error: \(error) \nEnd") }
//        db.trace({ (statement) in
//            debugPrint("---\(statement)")
//        })
//    }
//    
//    // MARK: 操作主用户表
//    
//    /// 插入数据 用户
//    func insertData(_password: String, _email: String, _isUpload: Bool) -> Bool{
//        do {
//            let insert = users.insert(password <- _password, email <- _email, isUpload_user <- _isUpload)
//            let rowid = try db.run(insert)
//            debugPrint("插入用户成功\(rowid)");
//            return true
//        } catch {
//            debugPrint(error)
//            return false
//        }
//    }
//    
//    /// 读取所有数据 用户
//    func readData() -> [CYUserInfo] {
//        var userData = CYUserInfo()
//        var userDataArr = [CYUserInfo]()
//        for user in try! db.prepare(users) {
//            userData.id = Int64(user[id])
//            userData.password = user[password]
//            userData.email = user[email]
//            userData.isUpload = user[isUpload_user]
//            userDataArr.append(userData)
//        }
//        return userDataArr
//    }
//    
//    /// 读取某一条数据 用户
//    func readAData(_email: String, _password: String) -> CYUserInfo? {
//        var user: CYUserInfo? = nil
//        let filter = users.filter(email == _email).filter(password == _password)
//        do {
//            for u in try db.prepare(filter) {
//                user = CYUserInfo()
//                user?.id = Int64(u[id])
//                user?.email = u[email]
//                user?.password = u[password]
//                user?.isUpload = u[isUpload_user]
//            }
//        } catch {
//            debugPrint("\(error)")
//        }
//        return user
//    }
//    
//    /// 更新数据 用户
//    func updateData(userId: Int64, _email: String, _password: String, isUpload: Bool) {
//        let currUser = users.filter(id == userId)
//        do {
//            try db.run(currUser.update(password <- _password, email <- _email, isUpload_user <- isUpload))
//        } catch {
//            debugPrint(error)
//        }
//    }
//    
//    /// 删除数据 nil=删除所有 用户
//    func delData(userId: Int64?) {
//        var currUser = users
//        if userId != nil {
//            currUser = users.filter(id == userId!)
//        }
//        do {
//            try db.run(currUser.delete())
//        } catch {
//            debugPrint(error)
//        }
//    }
//
//    
//    
//    // MARK: 操作子用户表
//    
//    /// 插入数据  子表
//    func insertData(subUser user: CYSubUserInfo) -> Bool{
//        do {
//            let insert = subUsers.insert(name <- user.name!, createTime <- user.creatTime!, sex <- user.sex!, birth <- user.birth!, height <- user.height!, weight <- user.weight!, highBP <- user.highBP!, lowBP <- user.lowBP!, isUpload_sub <- user.isUpload, user_id <- user.user_id!)
//            let rowid = try db.run(insert)
//            debugPrint("插入成功\(rowid)");
//            return true
//        } catch {
//            debugPrint(error)
//            return false
//        }
//    }
//    
//    /// 读取所有子用户
//    func readAllData(userId: Int64) -> [CYSubUserInfo] {
//        let userData = CYSubUserInfo()
//        var userDataArr = [CYSubUserInfo]()
////        let statement = subUsers.join(users, on: user_id == id && userId == 1)
//        let statement = subUsers.filter(user_id == userId)
//
//        do {
//            for user in try db.prepare(statement) {
//                userData.sid = Int64(user[sid])
//                userData.birth = user[birth]
//                userData.sex = user[sex]
//                userData.creatTime = user[createTime]
//                userData.height = user[height]
//                userData.weight = user[weight]
//                userData.highBP = user[highBP]
//                userData.lowBP = user[lowBP]
//                userData.name = user[name]
//                userData.isUpload = user[isUpload_sub]
//                userDataArr.append(userData)
//            }
//        } catch {
//            debugPrint("read sub user error:\(error)")
//        }
//        return userDataArr
//    }
//    
//    /// 读取一个数据 子用户
//    func readAData(_sid: Int64) -> CYSubUserInfo? {
//        var userData : CYSubUserInfo? = nil
//        let statement = subUsers.filter(sid == _sid)
//        do {
//            for user in try db.prepare(statement) {
//                userData = CYSubUserInfo()
//                userData?.sid = Int64(user[sid])
//                userData?.birth = user[birth]
//                userData?.sex = user[sex]
//                userData?.creatTime = user[createTime]
//                userData?.height = user[height]
//                userData?.weight = user[weight]
//                userData?.highBP = user[highBP]
//                userData?.lowBP = user[lowBP]
//                userData?.name = user[name]
//                userData?.user_id = user[user_id]
//            }
//        } catch {
//            debugPrint("read sub user error:\(error)")
//        }
//        return userData
//    }
//    
//    /// 更新数据 子用户
//    func updateData(user: CYSubUserInfo) -> Bool {
//        let currUser = subUsers.filter(sid == user.sid!)
//        do {
//            try db.run(currUser.update(name <- user.name!, createTime <- user.creatTime!, sex <- user.sex!, birth <- user.birth!, height <- user.height!, weight <- user.weight!, highBP <- user.highBP!, lowBP <- user.lowBP!, isUpload_sub <- user.isUpload))
//            return true
//        } catch {
//            debugPrint(error)
//            return false
//        }
//    }
//    
//    /// 删除数据 nil=删除所有 子用户
//    func delData(id: Int64?) {
//        var currUser = subUsers
//        if id != nil {
//            currUser = subUsers.filter(sid == id!)
//        }
//        
//        do {
//            try db.run(currUser.delete())
//        } catch {
//            debugPrint(error)
//        }
//    }
//    
//    // MARK: 操作历史记录表
//    
//    /// 插入数据  history
//    func insert(_history: CYHistory) -> Bool{
//        do {
//            let insert = history.insert(rate <- _history.rate!, oxygen <- _history.oxygen!, breath <- _history.breath!, high <- _history.high!, low <- _history.low!, PI <- _history.PI!, createTime_h <- _history.createTime!, isUpload_history <- _history.isUpload, sid_id <- _history.sid_id!)
//            let rowid = try db.run(insert)
//            debugPrint("插入成功\(rowid)");
//            return true
//        } catch {
//            debugPrint(error)
//            return false
//        }
//    }
//    
//    /// 读取所有数据 历史记录
//    func readAllData(sid: Int64) -> [CYHistory] {
//        var userData = CYHistory()
//        var userDataArr = [CYHistory]()
//        let statement = history.filter(sid_id == sid)
////        let statement = history.join(subUsers, on: sid == sid_id && sid == sid)
//        do {
//            for history in try db.prepare(statement) {
//                userData.sid_id = history[sid_id]
//                userData.rate = history[rate]
//                userData.oxygen = history[oxygen]
//                userData.breath = history[breath]
//                userData.low = history[low]
//                userData.high = history[high]
//                userData.PI = history[PI]
//                userData.createTime = history[createTime_h]
//                userDataArr.insert(userData, at: 0)
//            }
//        } catch {
//            debugPrint("read history error:\(error)")
//        }
//        return userDataArr
//    }
//    
//    /// 更新数据 历史记录
//    func updateData(_history: CYHistory) {
//        let currUser = history.filter(sid_id == _history.sid_id!)
//        do {
//            try db.run(currUser.update(rate <- _history.rate!, oxygen <- _history.oxygen!, breath <- _history.breath!, high <- _history.high!, low <- _history.low!, PI <- _history.PI!,createTime_h <- _history.createTime!, isUpload_history <- _history.isUpload))
//        } catch {
//            debugPrint(error)
//        }
//    }
//    
//    /// 删除数据 nil=删除所有 历史记录
//    func delData(_sid: Int64?) {
//        var currUser = history
//        if _sid != nil {
//            currUser = currUser.filter(sid == _sid!)
//        }
//        
//        do {
//            try db.run(currUser.delete())
//        } catch {
//            debugPrint(error)
//        }
//    }
//}



