//
//  ResultsViewController.swift
//  specTro
//
//  Created by Amirsaman Fazelipour on 2020-10-24.
//
import UIKit
import Charts

class ResultsViewController: HomeViewController {
     
    var barChart = BarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVideoPlayerWithVideo(viewName: "Results")
        player?.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        barChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        barChart.center = view.center
        view.addSubview(barChart)
        
        var entries = [BarChartDataEntry]()
        
//        for x in 0..<10 {
//            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
//        }
        
        entries.append(BarChartDataEntry(x: -4, y: 0.67))
        entries.append(BarChartDataEntry(x: -3, y: 2))
        entries.append(BarChartDataEntry(x: -2, y: 7))
        entries.append(BarChartDataEntry(x: -1, y: 12))
        entries.append(BarChartDataEntry(x: 0, y: 20))
        entries.append(BarChartDataEntry(x: 1, y: 12))
        entries.append(BarChartDataEntry(x: 2, y: 7))
        entries.append(BarChartDataEntry(x: 3, y: 2))
        entries.append(BarChartDataEntry(x: 4, y: 0.67))

        
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        
        let data = BarChartData(dataSet: set)
        
        barChart.data = data
    }
    
}
