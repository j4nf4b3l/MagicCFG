import Cocoa
import RNCryptor
import ZIPFoundation


// This is the section where purple mode gets booted. Pls note that no bootchain is included here.
// You may need to build and add it yourself...
// The exploiting stuff should work tho...

class PurpleViewController: NSViewController, NSAlertDelegate, USBWatcherDelegate {
    
    func deviceAdded(_ device: io_object_t) {
        if self.deviceDetectionHandler == true {
            DispatchQueue.global(qos: .background).async {
                getDeviceModel()
                self.deviceDetection()

            }
        }
    }
    
    var temp_block = false
    

    
    @IBOutlet weak var OutputLBL: NSTextField!
    @IBOutlet var OutPutLogField: NSTextView!
    
    @IBOutlet weak var OutputFieldGlobal: NSScrollView!
    func deviceRemoved(_ device: io_object_t) {
        if self.deviceDetectionHandler == true {
            DispatchQueue.global(qos: .background).async {
                self.deviceDetection()

            }
        }
    }
    
    @IBOutlet weak var UseAlternateDiagsAir1: NSButton!
    
    var connectedDeviceModel = String()
    var deviceDetectionHandler:Bool = true
    var supportedDevicesJson = [supportedDevicesStruct]()
    var runTask = true
    
    @IBOutlet weak var ProgressB: NSProgressIndicator!
    

    @IBAction func DismissVie(_ sender: Any) {
        deviceDetectionHandler = false
        runTask = false
        self.dismiss(sender)
        usbDelegate = false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        usbWatcher = USBWatcher(delegate: self)
        
        var windowFrame = self.view.frame
        windowFrame.size = NSMakeSize(450, 333)
        self.view.window?.setFrame(windowFrame,display: true, animate: true)
        
        ProgressB.doubleValue = 0
        ProgressB.minValue = 0
        ProgressB.maxValue = 100
        //self.CircProgress.progress = 1
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: Bundle.main.url(forResource: "supportedDevices", withExtension: "json")!)
                self.supportedDevicesJson = try JSONDecoder().decode([supportedDevicesStruct].self, from: data)
            } catch {
                print(error)
            }
        }
//        var timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in DispatchQueue.global(qos: .background).async {
//            if self.deviceDetectionHandler == true {
//                self.deviceDetection(timer: timer)
//            }
//            }}
//        DispatchQueue.global(qos: .background).async {
//            timer.fire()
//        }
        self.GoBTN.isEnabled = false
        
    }
        
    @IBAction func Go(_ sender: Any) {
        Go_now()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func Cancel(_ sender: Any) {
        runTask = false
    }
    
    @IBOutlet weak var USBSERIAL: NSButton!
    
    func getBootchainNANDDowngrade() {
        if !runTask {DispatchQueue.main.async {
            self.ConnectedString.stringValue = NSLocalizedString("Canceled", comment: "");
            sleep(3)}; deviceDetectionHandler = true; return }
        DispatchQueue.main.async {
            self.ConnectedString.stringValue = NSLocalizedString("Fetching bootchain...\nThis could take some minutes...", comment: "")
            sleep(3)
            self.ProgressB.doubleValue = 30
        }
        let file = Bundle.main.path(forResource: "libBigDick", ofType: "dylib")
        let archiveURL = URL(fileURLWithPath: file!)
        var archiveData = try! Data(contentsOf: archiveURL)


        do {
            

            
            
            var iBSS_data = Data()  /// Some data
            var iBEC_data = Data() /// Some data
            var dtre_data = Data() /// Some data
            var rdsk_data = Data() /// Some data
            var kernel_data = Data() /// Some data
                print(connectedDeviceModel)
            
            /// When data fetched, the data will be sent to the idevice
            
            if !runTask {DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Canceled", comment: "")}; deviceDetectionHandler = true; return }
            DispatchQueue.main.async {
                self.ConnectedString.stringValue = "Sending stage 1|5"
                self.ProgressB.doubleValue = 50
            }
            
                let ibss_size = iBSS_data.count
                            if ibss_size < 5 {
                                print("iBSS skipped")
                            } else {
                                iBSS_data.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> Void in
                                                 //Use `bytes` inside this closure
                                    printDeviceInfo()
                                    
                                    if connectedDeviceModel == "P101" || connectedDeviceModel == "P105" || connectedDeviceModel == "K93" || connectedDeviceModel == "K93A" || connectedDeviceModel == "N41" || connectedDeviceModel == "N94" {
                                        if uploadToDevice2(bytes, ibss_size) == 0 {
                                            print("Uploaded iBSS\n")
                                            sleep(3)
                                            printDeviceInfo()
                                        } else {
                                            print("Error while uploading iBSS", logLevel:.ERROR)
                                            return
                                        }
                                    } else {
                                        if uploadToDevice(bytes, UInt(ibss_size)) == 0 {
                                            print("Uploaded iBSS")
                                            if connectedDeviceModel == "J71" || connectedDeviceModel == "N53" || connectedDeviceModel == "J85" || connectedDeviceModel == "J85m" || connectedDeviceModel == "D22" || connectedDeviceModel == "D21" || connectedDeviceModel == "D20" {
                                                if uploadToDevice(bytes, UInt(ibss_size)) == 0 {
                                                    print("Uploaded iBSS\n")
                                                } else {
                                                    print("Error while uploading iBSS", logLevel:.ERROR)
                                                    deviceDetectionHandler = true
                                                    return
                                                }
                                            }

                                        } else {
                                            print("Error while uploading iBSS")
                                            return
                                        }
                                    }
                                    
                                    })
                            }
            
            
            DispatchQueue.main.async {
                self.ConnectedString.stringValue = "Sending stage 2|5"
                self.ProgressB.doubleValue = 60
            }
            if !runTask {DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Canceled", comment: "")}; deviceDetectionHandler = true; return }

let ibec_size = iBEC_data.count
            if ibec_size < 5 {
                print("iBEC skipped")
            } else {
                
                iBEC_data.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> Void in
                                 //Use `bytes` inside this closure
                    if uploadToDevice(bytes, UInt(ibec_size)) == 0 {
                
                        print("Uploaded iBEC\n")
                    } else {
                        print("Error while uploading iBEC", logLevel:.ERROR)
                        deviceDetectionHandler = true
                        return
                    }

                    })
            }
            if !runTask {DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Canceled", comment: "")}; deviceDetectionHandler = true; return }
            DispatchQueue.main.async {
                self.ConnectedString.stringValue = "Sending stage 3|5"
                self.ProgressB.doubleValue = 60
            }
            let dtre_size = dtre_data.count
                        if dtre_size < 5 {
                            print("dtre skipped")
                        } else {
                            dtre_data.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> Void in
                                             //Use `bytes` inside this closure
                                if uploadToDevice(bytes, UInt(dtre_size)) == 0 {
                                    print("Uploaded dtre")
                                    sendCommand(convert_to_mutable_pointer(value: "devicetree"))
                                } else {
                                    print("Error while uploading dtre", logLevel:.ERROR)
                                    return
                                }

                                })
                        }
            
            if !runTask {DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Canceled", comment: "")}; deviceDetectionHandler = true; return }
            DispatchQueue.main.async {
                self.ConnectedString.stringValue = "Sending stage 4|5"
                self.ProgressB.doubleValue = 78
            }
            let rdsk_size = rdsk_data.count
                        if rdsk_size < 5 {
                            print("rdsk skipped")
                        } else {
                            rdsk_data.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> Void in
                                             //Use `bytes` inside this closure
                                if uploadToDevice(bytes, UInt(rdsk_size)) == 0 {
                                    print("Uploaded rdsk")
                                    sendCommand(convert_to_mutable_pointer(value: "ramdisk"))

                                } else {
                                    print("Error while uploading rdsk", logLevel:.ERROR)
                                    return
                                }

                                })
                        }
            if !runTask {DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Canceled", comment: "")}; deviceDetectionHandler = true; return }
            DispatchQueue.main.async {
                self.ConnectedString.stringValue = "Sending stage 5|5"
                self.ProgressB.doubleValue = 91
            }
            let kernel_size = kernel_data.count
                        if kernel_size < 5 {
                            print("kernel skipped")
                        } else {
                            kernel_data.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> Void in
                                             //Use `bytes` inside this closure
                                if uploadToDevice(bytes, UInt(kernel_size)) == 0 {
                                    print("Uploaded kernel")
                                    sendCommand(convert_to_mutable_pointer(value: "setenv auto-boot false"))
                                    sendCommand(convert_to_mutable_pointer(value: "saveenv"))
                                    sendCommand(convert_to_mutable_pointer(value: "bootx"))
                                } else {
                                    print("Error while uploading kernel", logLevel:.ERROR)
                                    return
                                }

                                })
                        }
            DispatchQueue.main.async { [self] in
                self.ConnectedString.stringValue = "Done"
                self.ProgressB.doubleValue = 100
                deviceDetectionHandler = true
            }
            deviceDetectionHandler = true

   
        
        } catch {
            print(error)
        }
    }
    
    func getBootchain() {
        if !runTask {DispatchQueue.main.async {
            self.ConnectedString.stringValue = NSLocalizedString("Canceled", comment: "");
            sleep(3)}; deviceDetectionHandler = true; return }
        DispatchQueue.main.async {
            self.ConnectedString.stringValue = NSLocalizedString("Fetching bootchain...\nThis could take some minutes...", comment: "")
            sleep(3)
            self.ProgressB.doubleValue = 30
        }
        let file = Bundle.main.path(forResource: "file", ofType: "some_type")
        let archiveURL = URL(fileURLWithPath: file!)
        var filedata = try! Data(contentsOf: archiveURL)


        do {

            
            var iBSS_data = Data()  /// Some data
            var iBEC_data = Data() /// Some data
            var Diags_data = Data() /// Some data

                print(connectedDeviceModel)
            
            /// When data fetched, the data will be sent to the idevice

            if !runTask {DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Canceled", comment: "")}; deviceDetectionHandler = true; return }
            DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Sending iBSS...", comment: "")
                self.ProgressB.doubleValue = 50
            }
            
                let ibss_size = iBSS_data.count
                            if ibss_size < 5 {
                                print("iBSS skipped")
                            } else {
                                iBSS_data.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> Void in
                                    printDeviceInfo()
                                    
                                    if connectedDeviceModel == "P101" || connectedDeviceModel == "P105" || connectedDeviceModel == "K93" || connectedDeviceModel == "K93A" || connectedDeviceModel == "N41" || connectedDeviceModel == "N94" || connectedDeviceModel == "J1"  {
                                        if uploadToDevice2(bytes, ibss_size) == 0 {
                                            print("Uploaded iBSS\n")
                                            sleep(3)
                                            printDeviceInfo()
                                        } else {
                                            print("Error while uploading iBSS", logLevel:.ERROR)
                                            return
                                        }
                                    } else {
                                        if uploadToDevice(bytes, UInt(ibss_size)) == 0 {
                                            print("Uploaded iBSS")
                                            if connectedDeviceModel == "J71" || connectedDeviceModel == "N53" || connectedDeviceModel == "J85" || connectedDeviceModel == "J85m" || connectedDeviceModel == "D22" || connectedDeviceModel == "D21" || connectedDeviceModel == "D20" || connectedDeviceModel == "J71A" {
                                                if uploadToDevice(bytes, UInt(ibss_size)) == 0 {
                                                    print("Uploaded iBSS\n")
                                                } else {
                                                    print("Error while uploading iBSS", logLevel:.ERROR)
                                                    deviceDetectionHandler = true
                                                    return
                                                }
                                            }

                                        } else {
                                            print("Error while uploading iBSS")
                                            return
                                        }
                                    }
                                    
                                    })
                            }
            
            
            DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Sending iBoot...", comment: "")
                self.ProgressB.doubleValue = 60
            }
            if !runTask {DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Canceled", comment: "")}; deviceDetectionHandler = true; return }

let ibec_size = iBEC_data.count
            if ibec_size < 5 {
                print("iBEC skipped")
            } else {
                
                iBEC_data.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> Void in
                    if uploadToDevice(bytes, UInt(ibec_size)) == 0 {
                        print("Uploaded iBEC\n")
                    } else {
                        print("Error while uploading iBEC", logLevel:.ERROR)
                        deviceDetectionHandler = true
                        return
                    }

                    })
            }
            DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Sending diags...", comment: "")
                self.ProgressB.doubleValue = 70
            }
            if !runTask {DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Canceled", comment: "")}; deviceDetectionHandler = true; return }

            if connectedDeviceModel == "J71" || connectedDeviceModel == "J85" || connectedDeviceModel == "J85m" || connectedDeviceModel == "N53" {
                sleep(3)
            }
            let diag_size = Diags_data.count
            if diag_size < 5 {
                print("Diags skipped")
            } else {
                Diags_data.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> Void in
                                 //Use `bytes` inside this closure
                    if uploadToDevice(bytes, UInt(diag_size)) == 0 {
                        print("Uploaded diags\n")
                    } else {
                        print("Error while uploading diags", logLevel:.ERROR)
                        deviceDetectionHandler = true
                        return
                    }
                    })
            }
            DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Executing commands...", comment: "")
                self.ProgressB.doubleValue = 90
            }
            if !runTask {DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Canceled", comment: "")}; deviceDetectionHandler = true; return }
            DispatchQueue.main.async { [self] in
                if USBSERIAL.state == .on {
                    DispatchQueue.global(qos: .background).async {
                        startDiags()
                    }
                } else {
                    DispatchQueue.global(qos: .background).async {
                        startDiags_()
                    }
                }
            }


            DispatchQueue.main.async {
                self.ConnectedString.stringValue = NSLocalizedString("Done!", comment: "")
                self.ProgressB.doubleValue = 100
            }
            deviceDetectionHandler = true

   
        
        } catch {
            print(error, logLevel:.ERROR)
        }
    }
    func deviceDetection() {
        
        if temp_block == true {return}
        temp_block = true
        getDeviceModel()
        let chip_id = chipID
        let board_id = boardID
        let mode = Dmode
        for devices in supportedDevicesJson {
            if chip_id == devices.cpid && board_id == devices.bdid {
                DispatchQueue.main.async { [self] in
                    self.ConnectedString.stringValue = "\(devices.productName) in \(String(cString: Dmode)) Mode"
                    connectedDeviceModel = devices.internalName
                    if String(cString: Dmode) == "DFU" {
                        GoBTN.isEnabled = true
                    } else {
                        GoBTN.isEnabled = false
                    }
                }
            }
        }
        if chip_id == 0 && board_id == 0 {
            DispatchQueue.main.async { [self] in
                self.ConnectedString.stringValue = NSLocalizedString("No device detected...", comment: "")
                connectedDeviceModel = ""
                GoBTN.isEnabled = false
            }
        }
        temp_block = false
}
    
    
    
    
    func eclipsa7000() -> Int32 {
        let task = Process()
        task.launchPath = Bundle.main.url(forResource: "eclipsa7000", withExtension: "", subdirectory: "exploits")?.path
        task.arguments = ["eclipsa7000"]
        task.launch()
        var timer = 8
        while timer > 0 {
            if !task.isRunning {
                return task.terminationStatus
            }
            timer -= 1
            sleep(1)
            print("\(timer) seconds left until timeout")
        }
        if timer <= 0 {
            task.terminate()
            return Int32(1)
        } else {
            return Int32(1)
        }
    }
    func eclipsa7001() -> Int32 {
        let task = Process()
        task.launchPath = Bundle.main.url(forResource: "eclipsa7001", withExtension: "", subdirectory: "exploits")?.path
        task.arguments = ["eclipsa7001"]
        task.launch()
        var timer = 8
        while timer > 0 {
            if !task.isRunning {
                return task.terminationStatus
            }
            timer -= 1
            sleep(1)
            print("\(timer) seconds left until timeout")
        }
        if timer <= 0 {
            task.terminate()
            return Int32(1)
        } else {
            return Int32(1)
        }
    }
    func eclipsa8000() -> Int32 {
        let task = Process()
        task.launchPath = Bundle.main.url(forResource: "eclipsa8000", withExtension: "", subdirectory: "exploits")?.path
        task.arguments = ["eclipsa8000"]
        task.launch()
       var timer = 8
        while timer > 0 {
            if !task.isRunning {
                return task.terminationStatus
            }
            timer -= 1
            sleep(1)
            print("\(timer) seconds left until timeout")
        }
        if timer <= 0 {
            task.terminate()
            return Int32(1)
        } else {
            return Int32(1)
        }
    }
    func eclipsa8003() -> Int32 {
        let task = Process()
        task.launchPath = Bundle.main.url(forResource: "eclipsa8003", withExtension: "", subdirectory: "exploits")?.path
        task.arguments = ["eclipsa8003"]
        task.launch()
        var timer = 8
        while timer > 0 {
            if !task.isRunning {
                return task.terminationStatus
            }
            timer -= 1
            sleep(1)
            print("\(timer) seconds left until timeout")
        }
        if timer <= 0 {
            task.terminate()
            return Int32(1)
        } else {
            return Int32(1)
        }
    }
    func fuguPWN8010() -> Int32 {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.launchPath = Bundle.main.url(forResource: "Fugu", withExtension: "", subdirectory: "exploits/Fugu_8010")?.path
        task.arguments = ["pwn"]
        task.launch()
        var timer = 8
        while timer > 0 {
            if !task.isRunning {
                return task.terminationStatus
            }
            timer -= 1
            sleep(1)
            print("\(timer) seconds left until timeout")
        }
        if timer <= 0 {
            task.terminate()
            return Int32(1)
        } else {
            return Int32(1)
        }
    }
    func ipwndfu8010_rmsignchecks() -> Int32 {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = [Bundle.main.url(forResource: "exploit", withExtension: "sh", subdirectory: "exploits/ipwndfu8010")!.path]
        task.launch()
        var timer = 8
        while timer > 0 {
            if !task.isRunning {
                return task.terminationStatus
            }
            timer -= 1
            sleep(1)
            print("\(timer) seconds left until timeout")
        }
        if timer <= 0 {
            task.terminate()
            return Int32(1)
        } else {
            return Int32(1)
        }
    }
    
    func ipwndfu8015() -> Int32 {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = [Bundle.main.url(forResource: "exploit", withExtension: "sh", subdirectory: "exploits/ipwndfu8015")!.path]
        task.launch()
        var timer = 8
        while timer > 0 {
            if !task.isRunning {
                return task.terminationStatus
            }
            timer -= 1
            sleep(1)
            print("\(timer) seconds left until timeout")
        }
        if timer <= 0 {
            task.terminate()
            return Int32(1)
        } else {
            return Int32(1)
        }
    }
    func ipwndfu_a4() -> Int32 {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = [Bundle.main.url(forResource: "exploit4", withExtension: "sh", subdirectory: "exploits/ipwndfu8015")!.path]
        task.launch()
        var timer = 8
        while timer > 0 {
            if !task.isRunning {
                return task.terminationStatus
            }
            timer -= 1
            sleep(1)
            print("\(timer) seconds left until timeout")
        }
        if timer <= 0 {
            task.terminate()
            return Int32(1)
        } else {
            return Int32(1)
        }
    }
    func ipwndfu_a5(path: String) -> Int32 {
        let task = Process()
        task.launchPath = Bundle.main.url(forResource: "ipwndfu", withExtension: "", subdirectory: "exploits/ipwndfu-a5")!.path
        task.arguments = ["-l",path]
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }

    func ipwndfu_a6() -> Int32 {
        let task = Process()
        task.launchPath = Bundle.main.url(forResource: "pwnedDFU", withExtension: "", subdirectory: "exploits")!.path
        task.arguments = ["-p"]
        task.launch()
        var timer = 20
        while timer > 0 {
            if !task.isRunning {
                return task.terminationStatus
            }
            timer -= 1
            sleep(1)
            print("\(timer) seconds left until timeout")
        }
        if timer <= 0 {
            task.terminate()
            return Int32(1)
        } else {
            return Int32(1)
        }
    }
    func ipwndfu_a7() -> Int32 {
        let task = Process()
        task.launchPath = Bundle.main.url(forResource: "pwnedDFU", withExtension: "", subdirectory: "exploits")!.path
        task.arguments = ["-p","-f"]
        task.launch()
        var timer = 20
        while timer > 0 {
            if !task.isRunning {
                return task.terminationStatus
            }
            timer -= 1
            sleep(1)
            print("\(timer) seconds left until timeout")
        }
        if timer <= 0 {
            task.terminate()
            return Int32(1)
        } else {
            return Int32(1)
        }
    }
    
    @IBOutlet weak var GoBTN: NSButton!
    @IBOutlet weak var ConnectedString: NSTextField!
}




struct supportedDevicesStruct: Codable {
    let productName:String
    let internalName:String
    let cpid:Int32
    let bdid:Int32
}


extension String {
    
    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
}

extension PurpleViewController {
    
    func Go_now() {
        deviceDetectionHandler = false
        runTask = true
    
            
        DispatchQueue.global(qos: .background).async { [self] in
                
                DispatchQueue.main.async {
                    self.ConnectedString.stringValue = NSLocalizedString("Exploiting...", comment: "")
                    self.ProgressB.doubleValue = 20
                }
                DispatchQueue.main.async {
                    self.GoBTN.isEnabled = false
                }
                /// A4
                if self.connectedDeviceModel == "N90" || self.connectedDeviceModel == "N90B" {
                    if self.ipwndfu_a4() == 0 {
                        print("Successfully exploited")
                        self.getBootchain()
                    }else {
                        DispatchQueue.main.async {
                            self.ProgressB.doubleValue = 0
                            self.ConnectedString.stringValue = NSLocalizedString("Error while exploiting\nReboot and try again...", comment: "")
                        }
                        sleep(3)
                        self.deviceDetectionHandler = true

                    }
                }
                
                /// A5 devices
                if self.connectedDeviceModel == "K93A" || self.connectedDeviceModel == "K93" || self.connectedDeviceModel == "P105" || self.connectedDeviceModel == "J1" || self.connectedDeviceModel == "N94" {
                    
                    DispatchQueue.main.async {
                        let alert = NSAlert()
                        alert.messageText = NSLocalizedString("Information", comment: "")
                        alert.informativeText = NSLocalizedString("Please make sure your A5 is already in pwnedDFU. Otherwise diags can't be booted... ", comment: "")
                        alert.addButton(withTitle: NSLocalizedString("Continue", comment: ""))
                        alert.addButton(withTitle: NSLocalizedString("Cancel", comment: ""))
                        let modalResult = alert.runModal()
                        switch modalResult {
                        case .alertFirstButtonReturn:
                            DispatchQueue.global(qos: .background).async {
                                self.getBootchain()
                            }
                        default:
                            self.deviceDetectionHandler = true
                            DispatchQueue.main.async { [self] in
                                self.ProgressB.doubleValue = 0
                            }
                            return
                        }
                    }
                    
                }
                
                /// A6
                if self.connectedDeviceModel == "P101" || self.connectedDeviceModel == "N41" || self.connectedDeviceModel == "N48" {
                    if self.ipwndfu_a6() == 0 {
                        print("Successfully exploited")
                        self.getBootchain()
                    }else {
                        DispatchQueue.main.async {
                            self.ProgressB.doubleValue = 0
                            self.ConnectedString.stringValue = NSLocalizedString("Error while exploiting\nReboot and try again...", comment: "")
                        }
                        sleep(3)
                        self.deviceDetectionHandler = true

                    }
                }
                
                if self.connectedDeviceModel == "J71" || self.connectedDeviceModel == "N53" || self.connectedDeviceModel == "J85" || self.connectedDeviceModel == "J85m" {
                    
                                    if self.ipwndfu_a7() == 0 {
                                        print("Successfully exploited")
                                        if self.connectedDeviceModel == "J71" || self.connectedDeviceModel == "N53" {
                                            DispatchQueue.main.async {
                                                let alert = NSAlert()
                                                alert.messageText = "Information"
                                                alert.informativeText = "Do you wish to downgrade the NAND firmware now to be able to boot the premium diags?"
                                                alert.addButton(withTitle: "No")
                                                alert.addButton(withTitle: "Yes")
                                                let modalResult = alert.runModal()
                                                switch modalResult {
                                                case .alertFirstButtonReturn:
                                                    DispatchQueue.global(qos: .background).async {
                                                        self.getBootchain()
                                                    }
                                                case .alertSecondButtonReturn:
                                                    DispatchQueue.global(qos: .background).async {
                                                        self.getBootchainNANDDowngrade()
                                                    }
                                                    
                                                default:
                                                    DispatchQueue.global(qos: .background).async {
                                                        self.getBootchain()
                                                    }
                                                }
                                            }
                                        } else {
                                            getBootchain()
                                        }
                                    }else {
                                        DispatchQueue.main.async {
                                            self.ProgressB.doubleValue = 0
                                            self.ConnectedString.stringValue = NSLocalizedString("Error while exploiting\nReboot and try again...", comment: "")
                                        }
                                        sleep(3)
                                        self.deviceDetectionHandler = true

                                    }
                                    
                                }

                
                
                /// iPad mini 4
                if self.connectedDeviceModel == "J96" || self.connectedDeviceModel == "N102" || self.connectedDeviceModel == "N56" || self.connectedDeviceModel == "N61"  {
                    
                        if self.eclipsa7000() == 0 {
                            print("Successfully exploited")
                            self.getBootchain()
                        }else {
                            DispatchQueue.main.async {
                                self.ProgressB.doubleValue = 0
                                self.ConnectedString.stringValue = NSLocalizedString("Error while exploiting\nReboot and try again...", comment: "")
                            }
                            sleep(3)
                            self.deviceDetectionHandler = true

                        }
                }
                 /// iPad Air 2
                if self.connectedDeviceModel == "J81" {
                    if self.eclipsa7001() == 0 {
                        print("Successfully exploited")
                        self.getBootchain()
                    }else {
                        DispatchQueue.main.async {
                            self.ProgressB.doubleValue = 0
                            self.ConnectedString.stringValue = NSLocalizedString("Error while exploiting\nReboot and try again...", comment: "")
                        }
                        sleep(3)
                        self.deviceDetectionHandler = true

                    }
                }
                
                /// iPad 5 (2017)
                if self.connectedDeviceModel == "J71S" || self.connectedDeviceModel == "N71" || self.connectedDeviceModel == "N66" || self.connectedDeviceModel == "N69u"  {
                    if self.eclipsa8000() == 0 {
                        print("Successfully exploited")
                        self.getBootchain()
                    }else {
                        DispatchQueue.main.async {
                            self.ProgressB.doubleValue = 0
                            self.ConnectedString.stringValue = NSLocalizedString("Error while exploiting\nReboot and try again...", comment: "")
                        }
                        sleep(3)
                        self.deviceDetectionHandler = true

                    }
                }
                if self.connectedDeviceModel == "J71T" || self.connectedDeviceModel == "N71m" || self.connectedDeviceModel == "N66m" || self.connectedDeviceModel == "N69"  {
                    if self.eclipsa8003() == 0 {
                        print("Successfully exploited")
                        self.getBootchain()
                    }else {
                        DispatchQueue.main.async {
                            self.ProgressB.doubleValue = 0
                            self.ConnectedString.stringValue = NSLocalizedString("Error while exploiting\nReboot and try again...", comment: "")
                        }
                        sleep(3)
                        self.deviceDetectionHandler = true

                    }
                }

                /// iPad 6 (2018), iPad Pro 2nd gen 12,9', iPad Pro 10,5'
                if self.connectedDeviceModel == "J71B" || self.connectedDeviceModel == "J120" || self.connectedDeviceModel == "J207" ||
                    self.connectedDeviceModel == "J171" || self.connectedDeviceModel == "D111" || self.connectedDeviceModel == "D101" {
                    if self.fuguPWN8010() == 0 {
                        print("Successfully exploited")
                        if self.ipwndfu8010_rmsignchecks() == 0 {
                            self.getBootchain()
                        }
                    }else {
                        DispatchQueue.main.async {
                            self.ProgressB.doubleValue = 0
                            self.ConnectedString.stringValue = NSLocalizedString("Error while exploiting\nReboot and try again...", comment: "")
                        }
                        sleep(3)
                        self.deviceDetectionHandler = true

                    }
                }
                
                /// iPhone 8, 8+, X
         if self.connectedDeviceModel == "D20" || self.connectedDeviceModel == "D21" || self.connectedDeviceModel == "D22" {
                 if self.ipwndfu8015() == 0 {
                 print("Successfully exploited")
                 self.getBootchain()
                 } else {
                    DispatchQueue.main.async {
                        self.ProgressB.doubleValue = 0
                        self.ConnectedString.stringValue = NSLocalizedString("Error while exploiting\nReboot and try again...", comment: "")
                    }
                    sleep(3)
                     self.deviceDetectionHandler = true
                 }
                }
                            
            }
       
        
    }
    
    
    
}



func convert_to_mutable_pointer(value: String) -> UnsafeMutablePointer<Int8> {
    let input = (value as NSString).utf8String
    guard  let computed_buffer =  UnsafeMutablePointer<Int8>(mutating: input) else {
        return UnsafeMutablePointer<Int8>(mutating: "")
    }
    return computed_buffer
}
