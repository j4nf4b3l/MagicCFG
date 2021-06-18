//
//  Checkm8duinoFlash.swift
//  
//
//  Created by Jan Fabel on 20.12.20.
//

import Cocoa
import ORSSerial

class Checkm8duinoFlash: NSViewController, USBWatcherDelegate {
    func deviceAdded(_ device: io_object_t) {
        
    }
    
    func deviceRemoved(_ device: io_object_t) {
        
    }
    
    
    var serialPath = String()
    var selectedVersion = Int()
    func FlashArduino() -> Int32 {
        let task = Process()
        
        task.launchPath = Bundle.main.path(forResource: "avrdude", ofType: "")
        
        task.arguments = ["-C",Bundle.main.path(forResource: "avrdude", ofType: "conf")!,"-c","arduino","-b","115200","-p","m328p","-P","/dev/cu.\(serialPath)","-U",Bundle.main.path(forResource: "\(selectedVersion)", ofType: "bin")!]
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshPort()
        usbWatcher = USBWatcher(delegate: self)
        CPID8940BTN.state = .on
        selectedVersion = 8940
        closeConnection()
        // Do view setup here.
    }
    
    @IBAction func Autodetect(_ sender: Any) {
    }
    
    @IBAction func FlashCode(_ sender: Any) {
        if FlashArduino() == 0 {
            print("Success")
        }
    }
    @IBAction func AutoDetect(_ sender: Any) {
        getDeviceModel()
        let cpid = chipID
        switch cpid {
        case 35136: selectOnlyOne(cpid: 8940)
        case 35138: selectOnlyOne(cpid: 8942)
        case 35141: selectOnlyOne(cpid: 8945)
        default: break
        }
    }
    
    @IBOutlet weak var CPID8940BTN: NSButton!
    @IBOutlet weak var CPID8942BTN: NSButton!
    @IBOutlet weak var CPID8945BTN: NSButton!
    
    @IBAction func Select8940(_ sender: Any) {
        selectedVersion = 8940
        selectOnlyOne(cpid: 8940)
    }
    
    @IBAction func Select8942(_ sender: Any) {
        selectedVersion = 8942
        selectOnlyOne(cpid: 8942)
    }
    
    @IBAction func Select8945(_ sender: Any) {
        selectedVersion = 8945
        selectOnlyOne(cpid: 8945)
    }
    func selectOnlyOne(cpid:Int) {
        switch cpid {
        
        case 8940:
            CPID8940BTN.state = .on
            CPID8942BTN.state = .off
            CPID8945BTN.state = .off
        case 8942:
            CPID8940BTN.state = .off
            CPID8942BTN.state = .on
            CPID8945BTN.state = .off
        case 8945:
            CPID8940BTN.state = .off
            CPID8942BTN.state = .off
            CPID8945BTN.state = .on
        default: break

        }
    }
    
    @IBOutlet weak var FlashProgressLoader: NSProgressIndicator!
    
    @IBAction func Quit(_ sender: Any) {
        self.dismiss(sender)
    }
    var ports_array = [String]()
    @IBOutlet weak var Select_Port_ITEM: NSPopUpButton!
    
    @IBAction func RefreshBTN(_ sender: Any) {
        refreshPort()
    }
    func refreshPort() {
        port.close()
        ports_array.removeAll()
        let ports = ORSSerialPortManager.shared().availablePorts
        for port in ports {
        ports_array.append("\(port)")
        }
        Select_Port_ITEM.removeAllItems()
        Select_Port_ITEM.addItems(withTitles: ports_array)
        Select_Port_ITEM.autoenablesItems = true
        serialPath = ports_array[Select_Port_ITEM.indexOfSelectedItem]
        print(ports_array)
    }
    
}
