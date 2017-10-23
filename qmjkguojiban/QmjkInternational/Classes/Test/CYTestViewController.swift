//
//  CYTestViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/20.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYTestViewController: UIViewController, QmjkLogDelegate, QmjkDataSource {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var waveView: UIView!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var waveViewHeight: NSLayoutConstraint!
    var botView: CYTestBotView!
    var cireView: CYCycleProgressView!
    let imageWidth = screenW - 160
    
    var userId: String?
    var subUser: CYUser?
    
    var rate: Int!
    var oxygen: Int!
    var breath: Int!
    var lowBP: Int!
    var highBP: Int!
    var PI: Int!
    var dataIndex = 0
    
    var manager = QmjkLib.manager
    var codeTimer: DispatchSourceTimer?
    var totalTime = 0
    
//    var HRView: HeartRateWaveView?
    var HRView: CYWaveView?
    var waveTimer: DispatchSourceTimer?
    var timingTimer: DispatchSourceTimer?  // 计时轮询,1s走一次
    var waveValues: [Int]?
    var indexValuesTemp: [Int]?
    var waveIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        beginTest()
        progress()
        waveValues = [Int](repeating: 0, count: 8000)
        indexValuesTemp = [Int]()
    }
    
    private func addSubviews() {
        botView = CYTestBotView(frame: dataView.bounds)
        dataView.addSubview(botView)
        
        waveViewHeight.constant = screenH - 150 - imageWidth - 168 - 20 - 20 + 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavbarHidden(vc: self, hidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setNavbarHidden(vc: self, hidden: false)
        endTest()
        codeTimer?.suspend()
        waveTimer?.suspend()
        timingTimer?.suspend()
    }
    
    /// 进度
    private func progress() {
        cireView = CYCycleProgressView()
        let x: CGFloat = -2
        let y: CGFloat = x
        let w: CGFloat = screenW-80*2 + 8
        let h: CGFloat = w
        /*
        switch IPHONEMODEL() {
        case .FIVE:
            y = x
        case .SIX:
            y += 1
            h -= 0.5
        case .PLUS:
            y -= 1
            h += 3
        default:
            y = 150-49.5
        }
         */
        cireView.frame = CGRect(x: x, y: y, width: w, height: h)
        cireView.value = 0
        cireView.maximumValue = 60
        imgView.layer.addSublayer(cireView)
    }
    
    /// 开始测量
    private func beginTest() {
        CYAlertView.showActivity(on: view, position: .center)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.0) {
            // 画波形之前先设置波形最大最小值
            self.startTimingTimer()
        }
        // 开始
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
            CYAlertView.hideToastActivity(on: self.view)
            /// 初始化波形图
            self.HRView = CYWaveView()
            self.HRView?.frame = CGRect(x: 0, y: 0, width: screenW, height: self.waveViewHeight.constant)
            self.waveView.layer.addSublayer(self.HRView!)
            self.startTimer()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 8.0) {
            self.startDrawWaveTimer()
        }
        
        codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        waveTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timingTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        manager.logDelegate = self
        manager.dataSource = self
        if QmjkRegisterHttpHandler.isRegistedApp() {
            manager.startTest()
        } else {
            manager.registApp(withAppID: qmjkAppId, appKey: qmjkAppKey)
        }
        modifyUserInfo()
    }
    
    /// 停止测量
    private func endTest() {
        manager.stopTest()
        manager.logDelegate = nil
        manager.dataSource = nil
        codeTimer?.suspend()
    }
    
    /// 开启计时
    private func startTimingTimer() {
        timingTimer?.schedule(deadline: .now(), repeating: 1.0)
        timingTimer?.setEventHandler(handler: {
            self.setMaxAndMin()
        })
        timingTimer?.resume()
    }
    
    /// 开启画波形的定时器
    private func startDrawWaveTimer() {
        let repeating = 1 / 120.0
        waveTimer?.schedule(deadline: .now(), repeating: repeating)
        waveTimer?.setEventHandler(handler: {
//            if self.waveIndex % 119 == 0 {
//                self.checkDataIndex()
//            }
            self.HRView?.value = (self.waveValues?[self.waveIndex])!
            self.waveIndex += 1
        })
        waveTimer?.resume()
    }
    
//    private func checkDataIndex() {
//        // 有时候每秒获取的点不足120个,通过这个判断来发现并忽略不足120点的波形
//        // 并且从新的波形开始
////        debugPrint("数组index: \(dataIndex)---波形index: \(waveIndex)")
//        if self.dataIndex < self.waveIndex {
//            self.dataIndex = self.waveIndex
//        }
//    }
    
    /// 开启获取数据的定时器
    private func startTimer() {
        // 在global线程里创建一个时间源
        
        // 设定这个时间源是每1秒循环一次，立即开始
        codeTimer?.schedule(deadline: .now(), repeating: 1.0)
        // 设定时间源的触发事件
        codeTimer?.setEventHandler(handler: {
            
            self.rate = Int(self.manager.getMonitorRate())
            self.oxygen = Int(self.manager.getMonitorOxygen())
            self.breath = Int(self.manager.getMonitorBreath())
            self.lowBP = Int(self.manager.getMonitorLow())
            self.highBP = Int(self.manager.getMonitorHigh())
            self.PI = Int(self.manager.getMonitorPI())
            
            self.totalTime += 1
            
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                self.cireView.value = CGFloat(self.totalTime)
//                self.HRView?.rate = Int32(self.rate)
                self.botView.reloadData(with: self.rate, oxygen: self.oxygen, breath: self.breath, low: self.lowBP, high: self.highBP, PI: self.PI)
                if self.totalTime >= 60 {
                    // 跳转到历史记录界面
                    self.transformToHistory()
                    self.codeTimer?.suspend()
                }
            }
        })
        //启动定时器
        codeTimer?.resume()
        
    }
    
    /// 修改用户资料
    private func modifyUserInfo() {
        var params = [String: Any]()
        params["userId"] = QmjkRegisterHttpHandler.getUserId()
        params["sex"] = subUser?.sex!
        params["birth"] = subUser?.birth!
        params["height"] = subUser?.height!
        params["weight"] = subUser?.weight!
        params["infoLow"] = subUser?.infoLow!
        params["infoHigh"] = subUser?.infoHigh!
        params["infoBPSituation"] = "2"
        QmjkRegisterHttpHandler.updateUserInfo(params, success: { (response) in
            let data = response as! [String : Any]
            let errorMsg = data["errorMsg"] as! String
            if errorMsg.isEmpty {
                /// 修改全民健康资料成功
                debugPrint("修改全民健康账号成功")
            } else {
                /// 修改全民健康账号失败
                debugPrint("修改全民健康账号失败--\(errorMsg)")
            }
        }) { (error) in
            /// 修改全民健康账号失败
            debugPrint("修改全民健康账号失败")
        }
    }
    
    /// 上传体检记录
    private func reloadDataToDatabase() {
        var history = CYHistory()
        history.monitorRate = self.rate
        history.monitorBreath = self.breath
        history.monitorHigh = self.highBP
        history.monitorLow = self.lowBP
        history.monitorPI = self.PI
        history.monitorOxygen = self.oxygen
        history.userId = userId
        let dfm = DateFormatter()
        dfm.dateFormat = "dd/MM/yyyy HH:mm"
        history.createTime = dfm.string(from: Date())

        CYUploadTestDataHandler.uploadTest(history) { (isSuccess, errMsg) in
            if isSuccess {
                debugPrint("添加历史记录成功:\n" + "\(history)")
            } else {
                debugPrint("添加历史记录失败:\n" + errMsg + "\n" + "\(history)")
            }
        }
    }
    
    /// 跳转页面
    private func transformToHistory() {
        if isZeroValue() {
            /// 测量失败
            testFailed("Test failed")
            return
        }
        /// 上传体检记录
        self.reloadDataToDatabase()
        self.performSegue(withIdentifier: "testToHistory", sender: self)
    }
    
    /// 测量数值是否都为0
    func isZeroValue() -> Bool {
        if self.rate == 0 && self.breath == 0 && self.highBP == 0 && self.lowBP == 0 && self.PI == 0 && oxygen == 0 {
            return true
        }
        return false
    }
    
    // MARK: qmjk datasource
    
    /// 红外红光数据
    func manager(_ manager: QmjkDeviceManager!, receiveData dataArray: [Any]!, error errMsg: String!) {
        if errMsg.isEmpty {
            let ired = dataArray[0] as! Int
            debugPrint(ired)
//            ired = self.handleIred(ired)
//            print(ired)
            if ired > 1000 && ired < 37000 {
                self.waveValues?[self.dataIndex] = ired
                self.indexValuesTemp?.append(ired)
            }
//            if self.indexValuesTemp?.count == 120 {
//                self.setMaxAndMin()
//            }
            self.dataIndex += 1
        } else {
            debugPrint(errMsg)
        }
    }
    
    /// 设置波形的最大最小值
    private func setMaxAndMin() {
        if (indexValuesTemp?.count)! <= 0 {
            return
        }
        let max = CGFloat((self.indexValuesTemp?.max())!+1000)
//        let max = CGFloat((self.indexValuesTemp?.max())!)
        let min = CGFloat((self.indexValuesTemp?.min())!-1000)
//        let min = CGFloat((self.indexValuesTemp?.min())!)
        self.HRView?.maxValue = max
        self.HRView?.minValue = min
    }
    
    /// 处理红外数据  优化波形
    private func handleIred(_ ired: Int) -> Int {
        var result: Int = ired
        
        let max: Int = 37000
        let min: Int = 5000
        
        if dataIndex == 0 {
            if result > max || result < min {
                return 14000
            }
            return result
        }
        if dataIndex == 1 {
            if result > max || result < min {
                return 15000
            }
            return result
        }
        
//        let last = waveValues![dataIndex - 1]
        let lastlast = waveValues![dataIndex - 2]
        if result > max || result < min {
            result = lastlast
        }
        
        return result
    }
    
    // MARK: qmjk log delegate
    func manager(_ manager: QmjkDeviceManager!, logInfo info: [AnyHashable : Any]!) {
        debugPrint(info)
        let code = info["code"] as! Int
        switch code {
        case 1:
            testFailed("Please insert device")
        case 9:
            testFailed("The finger is not insert")
        case 21:
            CYAlertView.showText("Please keep your body steady", on: view, duration: 1.5, position: .center)
        case 404:
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
            vc.userId = userId
        }
    }
    
}

class QmjkLib {
    static let manager = QmjkDeviceManager()
    private init() { }
}
