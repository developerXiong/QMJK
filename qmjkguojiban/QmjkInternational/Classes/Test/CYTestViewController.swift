//
//  CYTestViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/20.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYTestViewController: UIViewController, QmjkLogDelegate, QmjkDataSource {
    
    @IBOutlet weak var waveView: UIView!
    @IBOutlet weak var dataView: UIView!
    var botView: CYTestBotView!
    
    var sid: Int64?
    
    var rate: Int!
    var oxygen: Int!
    var breath: Int!
    var lowBP: Int!
    var highBP: Int!
    var PI: Int!
    
    var manager = QmjkLib.manager
    var codeTimer: DispatchSourceTimer?
    var totalTime = 0
    
    var HRView: HeartRateWaveView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        beginTest()
    }
    
    private func addSubviews() {
        botView = CYTestBotView(frame: dataView.bounds)
        dataView.addSubview(botView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavbarHidden(vc: self, hidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setNavbarHidden(vc: self, hidden: false)
        endTest()
    }
    
    /// 开始测量
    private func beginTest() {
//        CYAlertView.showText("Loading...", on: view, duration: 5.0, position: .center)
        CYAlertView.showActivity(on: view, position: .center)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            CYAlertView.hideToastActivity(on: self.view)
            /// 初始化波形图
            self.HRView = HeartRateWaveView(frame: CGRect(x: 0, y: 0, width: screenW, height: 50))
            self.waveView.addSubview(self.HRView!)
        }
        
        codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        manager.logDelegate = self
        manager.dataSource = self
        if QmjkRegisterHttpHandler.isRegistedApp() {
            manager.startTest()
        } else {
            manager.registApp(withAppID: qmjkAppId, appKey: qmjkAppKey)
        }
        startTimer()
    }
    
    /// 停止测量
    private func endTest() {
        manager.stopTest()
        manager.logDelegate = nil
        manager.dataSource = nil
        codeTimer?.suspend()
    }
    
    /// 开启获取数据的定时器
    func startTimer() {
        // 在global线程里创建一个时间源
        
        // 设定这个时间源是每1秒循环一次，立即开始
        codeTimer?.scheduleRepeating(deadline: .now(), interval: 1.0)
        // 设定时间源的触发事件
        codeTimer?.setEventHandler(handler: {
            
            self.rate = Int(self.manager.getMonitorRate())
            self.oxygen = Int(self.manager.getMonitorOxygen())
            self.breath = Int(self.manager.getMonitorBreath())
            self.lowBP = Int(self.manager.getMonitorLow())
            self.highBP = Int(self.manager.getMonitorHigh())
            self.PI = Int(self.manager.getMonitorPI())
            
            self.totalTime += 1
            // 跳转到历史记录界面
//            if self.totalTime >= 60 {
//                self.reloadDataToDatabase()
//            }
            
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                self.HRView?.rate = Int32(self.rate)
                self.botView.reloadData(with: self.rate, oxygen: self.oxygen, breath: self.breath, low: self.lowBP, high: self.highBP, PI: self.PI)
                if self.totalTime >= 60 {
                    // 跳转到历史记录界面
                    self.reloadDataToDatabase()
                    self.transformToHistory()
                    self.codeTimer?.suspend()
                }
            }
        })
        //启动定时器
        codeTimer?.resume()
        
    }
    
    /// 更新数据库数据
    private func reloadDataToDatabase() {
        /// 添加数据到数据库
        let db = CYDatabaseManager.shared
        var history = CYHistory()
        history.rate = self.rate
        history.breath = self.breath
        history.high = self.highBP
        history.low = self.lowBP
        history.PI = self.PI
        history.oxygen = self.oxygen
        history.sid_id = sid
        history.createTime = Date()
        if history.rate == 0 && history.breath == 0 && history.high == 0 && history.low == 0 && history.PI == 0 && oxygen == 0 {
            /// 测量失败
            testFailed("Test failed")
            return
        }
        let isSuccess = db.insert(_history: history)
        if !isSuccess {
            print_debug("添加历史记录失败")
        }
    }
    
    /// 跳转页面
    private func transformToHistory() {
        self.performSegue(withIdentifier: "testToHistory", sender: self)
    }
    
    // MARK: qmjk datasource
    
    /// 红外红光数据
    func manager(_ manager: QmjkDeviceManager!, receiveData dataArray: [Any]!, error errMsg: String!) {
        if errMsg.isEmpty {
//            let ired = dataArray[0] as! Int
//            let red = dataArray[1] as! Int
//            print_debug("\(ired)-\(red)")
        } else {
            print_debug(errMsg)
        }
    }
    
    // MARK: qmjk log delegate
    func manager(_ manager: QmjkDeviceManager!, logInfo info: [AnyHashable : Any]!) {
        print_debug(info)
        let code = info["code"] as! Int
        switch code {
        case 1:
            testFailed("Please insert the device")
        case 9:
            testFailed("The finger is not insert")
        case 21:
            CYAlertView.showText("Please keep your body steady", on: view, duration: 1.5, position: .center)
        case 1000:
            // 注册qmjkapp成功
            manager.startTest()
        case 1001:
            // 注册amjkapp失败
            testFailed("Test failure: regist app fail")
        default: break
            
        }
    }
    
    /// 测量失败,返回主页面
    private func testFailed(_ text: String?) {
        if text != nil {
            CYAlertView.hideToastActivity(on: view)
            CYAlertView.showText(text!, on: view, duration: 1.5, position: .center)
        }
        codeTimer?.suspend()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    /// 返回
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 传数据到下个页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "testToHistory" {
            let vc = segue.destination as! CYHistoryListViewController
            vc.sid = sid
        }
    }
    
}

class QmjkLib {
    static let manager = QmjkDeviceManager()
    private init() { }
}
