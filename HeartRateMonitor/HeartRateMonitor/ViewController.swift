//
//  ViewController.swift
//  HeartRateMonitor
//
//  Created by Final Year Project Account on 2020/3/12.
//  Copyright © 2020 Final Year Project Account. All rights reserved.
//

import UIKit
import WatchConnectivity
import Charts
import HealthKit

class ViewController: UIViewController{
    // MARK: - Paramaeters
    
    let healthStore         = HKHealthStore()  //constant to store the hr data
    var session: WCSession!                     //watch session delegate
    var maximumHR = 0                           //highest HR value recorded
    var set : LineChartDataSet!                 //chart data set
    var pulseLayer: CAShapeLayer!               //pulse drawing layer
    var shapeLayer: CAShapeLayer!               //button drawing layer
    var beatLayer: CAShapeLayer!                //button overlay drawing layer
    var animationBeat: CABasicAnimation!        //pulse animation
    var time  = 1                               //starting with 1 to initialize time
    var setUpChartData = true                   //data set up before fetching data
    var permissions = false                     //checks whether permissions are given
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var chtChart: LineChartView!
    
    // MARK: - Image Creator
    let image: UIImageView = {
        let imageName = "heart-3.png"
        let image = UIImage(named: imageName)
        let img = UIImageView(image: image!)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // MARK: - TextField Creator
    let text: UITextField = {
        let txt = UITextField()
        txt.text = "HR"
        txt.isUserInteractionEnabled = false
        txt.textColor = .white
       // txt.textContainer.lineBreakMode = NSLineBreakByWordWrapping
        txt.font = UIFont.boldSystemFont(ofSize: 35)
        txt.textAlignment = .center
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    // MARK: - Button Creator
    let button: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        btn.layer.cornerRadius = 75
        btn.setTitle("START", for: .normal)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true;
        btn.titleLabel?.minimumScaleFactor = 0.5;
        btn.setTitleColor(UIColor.white, for: .normal)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    
    // MARK: - Handle Background Interruputions
    private func setUpNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: - Background Handler (Animations)
    @objc private func handleEnterForeground(){
        animateBeat()
        animatePulse()
    }
    
    // MARK: - Create Shapes (circle)
    private func createCircleShapeLavyer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        
        //layer setup
        var center = CGPoint()
        center.x = view.center.x
        center.y = view.frame.maxY - 50 - 75
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 75, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        layer.path = circularPath.cgPath
        layer.lineWidth = 10
        layer.fillColor = fillColor.cgColor
        layer.strokeColor = strokeColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = center
        
        return layer
    }

    // MARK: - View Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNotificationObserver()
        
        self.configureWatchKitSesstion()
        self.setupChart()
        self.setupLayers()
        self.drawBeat()
        self.drawHeart()
        self.setupButton()
        self.checkPermissions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reload), name:NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    // MARK: - Reload View
    @objc func reload() {
        chtChart.clear()
        setUpChartData = true
        time = 1
        maximumHR = 0
        text.text = "HR"
        self.checkPermissions()
    }

    
    // MARK: - Draw Beat
    private func drawBeat(){
        beatLayer = CAShapeLayer()
        let aPath = UIBezierPath()
        
        let centerY = view.center.y
        let pointX = view.frame.maxX - 120
        print(pointX)
        
        print(pointX)
        
        aPath.move(to: CGPoint(x:0, y: centerY + 65))
        aPath.addLine(to: CGPoint(x:30, y:centerY+65))
        aPath.move(to: CGPoint(x:30, y:centerY+65))
        aPath.addCurve(to: CGPoint(x: 40, y: centerY), controlPoint1: CGPoint(x: 34, y: centerY+65), controlPoint2: CGPoint(x: 39, y: centerY+60))
        aPath.addCurve(to: CGPoint(x: 60, y: centerY), controlPoint1: CGPoint(x: 42, y: centerY-30), controlPoint2: CGPoint(x: 58, y: centerY-30))
        aPath.addCurve(to: CGPoint(x: 62, y: centerY+120), controlPoint1: CGPoint(x: 61, y: centerY+60), controlPoint2: CGPoint(x: 61, y: centerY+80))
        aPath.addCurve(to: CGPoint(x: 80, y: centerY+100), controlPoint1: CGPoint(x: 70, y: centerY+130), controlPoint2: CGPoint(x: 79, y: centerY+125))
        aPath.addCurve(to: CGPoint(x: 90, y: centerY+65), controlPoint1: CGPoint(x: 82, y: centerY+90), controlPoint2: CGPoint(x: 83, y: centerY+70))
        aPath.addCurve(to: CGPoint(x: 100, y: centerY+65), controlPoint1: CGPoint(x: 91, y: centerY+61), controlPoint2: CGPoint(x: 99, y: centerY+65))
        aPath.addCurve(to: CGPoint(x: 120, y: centerY+65), controlPoint1: CGPoint(x: 120, y: centerY+65), controlPoint2: CGPoint(x: 120, y: centerY+65))
        
        aPath.move(to: CGPoint(x:pointX, y:centerY+65))
        aPath.addLine(to: CGPoint(x: pointX + 30, y:centerY+65))
        aPath.move(to: CGPoint(x:pointX + 30, y:centerY+65))
        aPath.addCurve(to: CGPoint(x: pointX + 40, y: centerY), controlPoint1: CGPoint(x: pointX + 34, y: centerY+65), controlPoint2: CGPoint(x: pointX + 39, y: centerY+60))
        aPath.addCurve(to: CGPoint(x: pointX + 60, y: centerY), controlPoint1: CGPoint(x: pointX + 42, y: centerY-30), controlPoint2: CGPoint(x: pointX + 58, y: centerY-30))
        aPath.addCurve(to: CGPoint(x: pointX + 62, y: centerY+120), controlPoint1: CGPoint(x: pointX + 61, y: centerY+60), controlPoint2: CGPoint(x: pointX + 61, y: centerY+80))
        aPath.addCurve(to: CGPoint(x: pointX + 80, y: centerY+100), controlPoint1: CGPoint(x: pointX + 70, y: centerY+130), controlPoint2: CGPoint(x: pointX + 79, y: centerY+125))
        aPath.addCurve(to: CGPoint(x: pointX + 90, y: centerY+65), controlPoint1: CGPoint(x: pointX + 82, y: centerY+90), controlPoint2: CGPoint(x: pointX + 83, y: centerY+70))
        aPath.addCurve(to: CGPoint(x: pointX + 100, y: centerY+65), controlPoint1: CGPoint(x:pointX + 91, y: centerY+61), controlPoint2: CGPoint(x: pointX + 99, y: centerY+65))
        aPath.addCurve(to: CGPoint(x: pointX + 120, y: centerY+65), controlPoint1: CGPoint(x: pointX + 120, y: centerY+65), controlPoint2: CGPoint(x: pointX + 120, y: centerY+65))
        
        beatLayer.path = aPath.cgPath
        beatLayer.fillColor = UIColor.clear.cgColor
        beatLayer.lineWidth = 7
        beatLayer.strokeEnd = 0
        beatLayer.strokeColor = UIColor.redColorTest.cgColor
        view.layer.addSublayer(beatLayer)
    }

    // MARK: - Animate Beat
    private func animateBeat(){
        animationBeat = CABasicAnimation(keyPath: "strokeEnd")
        animationBeat.toValue = 1
        animationBeat.duration = 3
        animationBeat.repeatCount = Float.infinity
        animationBeat.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        beatLayer.add(animationBeat, forKey: "beatLayer")
    }
    // MARK: - Draw Heart
    private func drawHeart(){
        view.addSubview(image)
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        image.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 140).isActive = true
        image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 110).isActive = true
        image.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -110).isActive = true
        
        view.addSubview(text)
        text.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        text.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 65).isActive = true

    }
    // MARK: - Chart Setup
    
    private func setupChart(){
        chtChart.noDataTextColor = UIColor.white
        chtChart.noDataText = "Press START button to display the chart"

        //remove vertical grid and labels
        chtChart.xAxis.drawGridLinesEnabled = false
        chtChart.rightAxis.drawLabelsEnabled = false
        chtChart.xAxis.drawLabelsEnabled = false

        //change label 'BPM' color
        chtChart.legend.textColor = UIColor.white
        //change left numbers (bpm values)
        chtChart.leftAxis.labelTextColor = UIColor.white
        //change right border line color
        chtChart.rightAxis.axisLineColor = UIColor.white
        //change left border line to white
        chtChart.leftAxis.axisLineColor = UIColor.white

        //following lines add bottom border and change horizontal grid colors
        chtChart.xAxis.axisLineColor = UIColor.white
        chtChart.rightAxis.gridColor = UIColor.white
        
        chtChart.drawBordersEnabled = true
        chtChart.borderColor = UIColor.white
        
        //change values from decimal to int on left axis
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.maximumFractionDigits = 0
        fmt.groupingSeparator = ","
        fmt.decimalSeparator = "."
        chtChart.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: fmt)

    }
    // MARK: - Layers Setup
    
    private func setupLayers(){
        //pulse
        pulseLayer = createCircleShapeLavyer(strokeColor: .clear, fillColor: UIColor.pulseColorGreen)
        view.layer.addSublayer(pulseLayer)
        animatePulse()
        
        //shape
        shapeLayer = createCircleShapeLavyer(strokeColor: .green, fillColor: view.backgroundColor!)
        view.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - Button Setup
    private func setupButton(){
        //button constraints
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 150).isActive = true
        button.addTarget(self, action: #selector(processActionButton), for: .touchUpInside)
    }
    
    // MARK: - Pulse Animation
    private func animatePulse(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.25
        animation.duration = 1
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        pulseLayer.add(animation, forKey: "pulse")
    }
    
    // MARK: - Configurations (watch)
    
    func configureWatchKitSesstion() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    // MARK: - Button Action
    @objc func processActionButton() {
        //check if watch is connected
        if(session.isPaired){
        }else{
            let alertController = UIAlertController(title: "Missing Paired Watch", message: "Please pair your iWatch to the device", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        //check if watch is in reach
        if let validSession = self.session, validSession.isReachable {
            if !validSession.isWatchAppInstalled {
                let alert = UIAlertController(title: "Heart Rate Monitor", message: "Please download and launch counterapp on your iWatch device", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            if button.currentTitle == "START" {
                animateBeat()
                shapeLayer.strokeColor = UIColor.redColor.cgColor
                pulseLayer.fillColor = UIColor.pulseColorRed.cgColor
                button.setTitle("STOP",for: .normal)
                let data: [String: Any] = ["START": "Data from iPhone" as Any]
                validSession.sendMessage(data, replyHandler: nil, errorHandler: nil)
            }else{
                shapeLayer.strokeColor = UIColor.greenColor.cgColor
                pulseLayer.fillColor = UIColor.pulseColorGreen.cgColor
                button.setTitle("START",for: .normal)
                let data: [String: Any] = ["STOP": "Data from iPhone" as Any]
                validSession.sendMessage(data, replyHandler: nil, errorHandler: nil)
                //start segue -> move to another view
                performSegue(withIdentifier: "popUp", sender: self)
            }
        }else{
            let alert = UIAlertController(title: "Heart Rate Monitor", message: "Please make sure counterpart iWatch app is launched and reachable", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PopUp
        vc.time = time
        vc.maximumHR = Int(maximumHR)
        vc.chartData = chtChart.data
        vc.set = set
    }
}


// MARK: - Session Control

// WCSession delegate functions
extension ViewController: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {}

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("received message: \(message)")
        DispatchQueue.main.async { //6
            if let value = message["watch"] as? Int {
                self.text.text = String(value)
                if (self.setUpChartData){
                    self.set = LineChartDataSet(entries:[ChartDataEntry(x: Double(Int(0)), y: Double(value))], label: "BPM")
                    self.set.drawCirclesEnabled = false
                    self.set.mode = .linear
                    self.set.setColor(UIColor.blueColorTest)
                    self.set.drawValuesEnabled = false
                    self.set.lineWidth = 5.0

                    self.chtChart.data = LineChartData(dataSets: [self.set])
                    self.setUpChartData = false
                }
                //check for maximum HR
                if value > self.maximumHR {
                    self.maximumHR = value
                }
                self.updateCounter(valueHR: value)
            }
            // removing this segment because of found bug in permissions
            /*
            else if let value = message["permissions"] as? Int {
                print(value)
                if (value == 0){
                    print("permission given")
                    self.permissions = true
                }
            }*/
        }
    }
    
    // MARK: - Counter Update
    private func updateCounter(valueHR: Int){
        chtChart.data?.addEntry(ChartDataEntry(x: Double(time), y: Double(valueHR)), dataSetIndex: 0)
        chtChart.setVisibleXRange(minXRange: Double(0), maxXRange: Double(1000))
        chtChart.notifyDataSetChanged()
        chtChart.moveViewToX(Double(time))
        time = time + 1
        //check if exceed one hour
        if self.time >= 3600 {
            self.button.setTitle("STOP", for: .normal)
        }
    }
    
    // MARK: - Check Permissions
    //Do not use as a bug was found when checking permissions on the watch
    private func checkPermissions() -> Void{
        let data: [String: Any] = ["permissions": "Data from iPhone" as Any]
        self.session.sendMessage(data, replyHandler: nil, errorHandler: nil)
    }
}

