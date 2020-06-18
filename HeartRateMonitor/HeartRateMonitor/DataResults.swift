//
//  DataResults.swift
//  HeartRateApp
//
//  DataResults.swift displays all the final results and has an option to share them via
//  various channels (mail, messages, etc)
//
//  Created by Final Year Project Account on 2020/2/25.
//  Copyright © 2020 Final Year Project Account. All rights reserved.
//

import UIKit
import Charts

class DataResults: UIViewController {
    // MARK: - Configurations
    
    var maximumHR   : Int     = 0
    var totalTime   : Int     = 0
    var name        : String  = ""
    var age         : String  = ""
    var phobia      : String  = ""
    var chartData   : ChartData!
    var set         : LineChartDataSet!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var phobiaLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var maximumHRLabel: UILabel!
    @IBOutlet weak var chtChart: LineChartView!
    
    // MARK: - Button Creator
    func createButton(color: UIColor, text: String) -> UIButton{
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        btn.setTitle("\(text)", for: .normal)
        btn.backgroundColor = color.withAlphaComponent(0.5)
        btn.isOpaque = false
        btn.titleLabel?.adjustsFontSizeToFitWidth = true;
        btn.titleLabel?.minimumScaleFactor = 0.5;
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }
    
    // MARK: -  View Load
    override func viewDidLoad() {
        if set != nil{
            set.label = "\(name) HR (BPM)"
        }else{
            print("you recorded too fast...")
        }
        chtChart.data = chartData
        setUpChart()
        setUpButtons()
        
        self.chtChart.delegate = self as? ChartViewDelegate
        self.chtChart.noDataTextColor = UIColor.white
        self.chtChart.noDataText = "Press Start button to display the chart"
        
        maximumHRLabel.text         = "Maximum HR: \(maximumHR)"
        timeLabel.text              = measureTime()
        nameLabel.text              = "Name: \(name)"
        ageLabel.text               = "Age: \(age)"
        phobiaLabel.text            = "Phobia: \(phobia)"
        
        
        super.viewDidLoad()
    }
    
    // MARK: - Buttons Set Up
    private func setUpButtons(){
        let btnRestart = createButton(color: UIColor.btnRestart, text: "GO BACK")
        view.addSubview(btnRestart)
        
        
        btnRestart.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        btnRestart.heightAnchor.constraint(equalToConstant: 80).isActive = true
        btnRestart.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        btnRestart.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        btnRestart.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let btnContinue = createButton(color: UIColor.btnContinue, text: "SHARE")
        view.addSubview(btnContinue)
        btnContinue.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        btnContinue.heightAnchor.constraint(equalToConstant: 80).isActive = true
        btnContinue.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        btnContinue.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        btnContinue.addTarget(self, action: #selector(share), for: .touchUpInside)
    }
    
    // MARK: - Time Measurement
    func measureTime() -> String{
        var result:String   = ""
        var minutes:Int     = 0
        
        if totalTime < 60 {
            result = "Time: \(totalTime) seconds"
        }
        else if totalTime >= 60 && totalTime < 3600{
            minutes = totalTime / 60
            result = "Total Time: \(minutes) minutes"
        }
        return result
    }
    
    // MARK: - Chart Set Up
    func setUpChart(){
        //remove vertical grid and labels
        self.chtChart.xAxis.drawGridLinesEnabled = false
        self.chtChart.rightAxis.drawLabelsEnabled = false
        self.chtChart.xAxis.drawLabelsEnabled = false

        //change label 'BPM' color
        self.chtChart.legend.textColor = UIColor.white
        //change left numbers (bpm values)
        self.chtChart.leftAxis.labelTextColor = UIColor.white
        //change right border line color
        self.chtChart.rightAxis.axisLineColor = UIColor.white
        //change left border line to white
        self.chtChart.leftAxis.axisLineColor = UIColor.white

        //following lines add bottom border and change horizontal grid colors
        self.chtChart.xAxis.axisLineColor = UIColor.white
        self.chtChart.rightAxis.gridColor = UIColor.white
        
        self.chtChart.drawBordersEnabled = true
        self.chtChart.borderColor = UIColor.white
        
        //change values from decimal to int on left axis
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.maximumFractionDigits = 0
        fmt.groupingSeparator = ","
        fmt.decimalSeparator = "."
        self.chtChart.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: fmt)
        
        return
    }
    
    // MARK: - Go Back Button Action
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Share Button Action
    @IBAction func share(_ sender: Any) {
        //UIImageWriteToSavedPhotosAlbum(chtChart.getChartImage(transparent: false)!, nil, nil, nil)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: chtChart.bounds.width,height: chtChart.bounds.height), false, 0);
        
        let xCoord = chtChart.frame.origin.x * (-1)
        let yCoord = chtChart.frame.origin.y * (-1)
        
        self.view.drawHierarchy(in: CGRect(x: xCoord,y: yCoord,width: view.bounds.size.width,height: view.bounds.size.height), afterScreenUpdates: true)

        
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
 
        let messageStr = "Name: \(name) \nAge: \(age) \nPhobia: \(phobia) \n\(measureTime()) \nHighest HR: \(maximumHR) BPM"
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [image, messageStr], applicationActivities: nil)
            activityViewController.setValue("HR Data Results" , forKey: "Subject") ;
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.postToFacebook]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}
