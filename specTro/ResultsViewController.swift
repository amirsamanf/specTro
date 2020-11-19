//
//  ResultsViewController.swift
//  specTro
//
//  Created by Amirsaman Fazelipour on 2020-10-24.
//
import UIKit
import Charts

class ResultsViewController: HomeViewController {
     
    static let shared = ResultsViewController()
    var barChart = BarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVideoPlayerWithVideo(viewName: "Results")
        player?.play()
    }
    
    var entries: [BarChartDataEntry] = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        barChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        barChart.center = view.center
        view.addSubview(barChart)
        
        var entries = [BarChartDataEntry]()
        let a = Double(defaults.integer(forKey: "a0_" + selectedAnnotationLat! + selectedAnnotationLon!))
        let b = Double(defaults.integer(forKey: "a1_" + selectedAnnotationLat! + selectedAnnotationLon!))
        let c = Double(defaults.integer(forKey: "a2_" + selectedAnnotationLat! + selectedAnnotationLon!))
        let d = Double(defaults.integer(forKey: "a3_" + selectedAnnotationLat! + selectedAnnotationLon!))
        let e = Double(defaults.integer(forKey: "a4_" + selectedAnnotationLat! + selectedAnnotationLon!))
        let f = Double(defaults.integer(forKey: "a5_" + selectedAnnotationLat! + selectedAnnotationLon!))
        
        entries.append(BarChartDataEntry(x: 1, y: a-b))
        entries.append(BarChartDataEntry(x: 2, y: b-c))
        entries.append(BarChartDataEntry(x: 3, y: c-d))
        entries.append(BarChartDataEntry(x: 4, y: d-e))
        entries.append(BarChartDataEntry(x: 5, y: e-f))
        entries.append(BarChartDataEntry(x: 6, y: f))

        
        let labels = ["NA", "0.3um to 0.5um", "0.5um to 1.0um", "1.0um to 2.5um", "2.5um to 5.0um", "5.0um to 10.0um", "Above 10.0um"]

        let set = BarChartDataSet(entries: entries, label: "")
        set.drawValuesEnabled = true
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:labels)
        let data = BarChartData(dataSet: set)
        barChart.data = data
        barChart.legend.enabled = false
        set.colors = ChartColorTemplates.joyful()
        barChart.animate(xAxisDuration: 3.0, yAxisDuration: 3.0, easingOption: .easeInOutBounce)
        barChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        barChart.xAxis.labelRotationAngle = 90
//        barChart.xAxis.avoidFirstLastClippingEnabled = true
        barChart.xAxis.granularity = 1
        barChart.xAxis.granularityEnabled = true
        barChart.xAxis.labelCount = 999999
        barChart.extraBottomOffset = 100
        barChart.extraTopOffset = 30
//        chartView.xAxis.avoidFirstLastClippingEnabled = true
        barChart.fitScreen()

        


    }
    
    
    
    
}
