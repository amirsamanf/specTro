//
//  ResultsViewController.swift
//  specTro
//
//  Created by Amirsaman Fazelipour on 2020-10-24.
//
import UIKit
import Charts
import MaterialDesignWidgets

class ResultsViewController: HomeViewController {
     
    static let shared = ResultsViewController()
    static var barChart = BarChartView()
    static var lineChart = LineChartView()
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initializeVideoPlayerWithVideo(viewName: "Results")
//        player?.play()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVideoPlayerWithVideo(viewName: "Results")
        player?.play()
        
        // to make it displayed correctly.
        let segmentedControl = MaterialSegmentedControl(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 30.0))
        
        // Configure the view, note that you need to call updateViews in order to apply your cofiguration.
        segmentedControl.selectorColor = .black
        segmentedControl.selectorTextColor = .black
        setSampleSegments(segmentedControl, 18.0)
        segmentedControl.updateViews()
        
        self.view.addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: segmentedControl, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)

        self.view.addConstraints([horizontalConstraint])
        
        
        NSLayoutConstraint.activate([
            segmentedControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            ])
        
        
        
    }

    /**
    Create sample segments for the segmented control.
    - Parameter segmentedControl: The segmented control to put these segments into.
    - Parameter cornerRadius:     The corner radius to be set to segments and selectors.
    */
    private func setSampleSegments(_ segmentedControl: MaterialSegmentedControl, _ cornerRadius: CGFloat) {
        for i in 0..<2 {
            // Button background needs to be clear, it will be set to clear in segmented control anyway.
            if i == 0 {
                let button = MaterialButton(text: "Histogram", textColor: .gray, bgColor: .clear, cornerRadius: cornerRadius)
                segmentedControl.segments.append(button)
            } else {
                let button = MaterialButton(text: "Time Series", textColor: .gray, bgColor: .clear, cornerRadius: cornerRadius)
                segmentedControl.segments.append(button)
            }
            
            
        }
    }
    var lineEntries: [ChartDataEntry] = []
    var entries: [BarChartDataEntry] = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpBarChart()
        setUpLineChart()
        

        
        
        
        
 

    }
    
    func setUpLineChart() {
        ResultsViewController.lineChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        ResultsViewController.lineChart.center = view.center
        view.addSubview(ResultsViewController.lineChart)
        
        var lineEntries = [ChartDataEntry]()
        let PM1 = defaults.object(forKey: "PM1" + selectedAnnotationLat! + selectedAnnotationLon!) as? [Int] ?? [Int]()
        let times: [Float] = Array(stride(from: 0.0, to: Float(PM1.count / 2) + 0.25, by: 0.25))
//        let times = Array(0...PM1.count)
        
        
        for i in 0..<PM1.count {
            let dataPoint = ChartDataEntry(x: Double(times[i]), y: Double(PM1[i]))
            lineEntries.append(dataPoint)
        }
        
        let chartDataSet = LineChartDataSet(entries: lineEntries, label: "")
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
//        chartData.setDrawValues(true)
        chartDataSet.colors = [ChartColorTemplates.joyful()[0]]
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.drawCircleHoleEnabled = false
        chartDataSet.drawFilledEnabled = false
        chartDataSet.drawValuesEnabled = false
        ResultsViewController.lineChart.legend.enabled = false
        ResultsViewController.lineChart.data = chartData
        ResultsViewController.lineChart.fitScreen()
        ResultsViewController.lineChart.extraBottomOffset = 100
        ResultsViewController.lineChart.extraTopOffset = 30
//        ResultsViewController.lineChart.animate(xAxisDuration: 3.0, yAxisDuration: 3.0, easingOption: .easeInOutBounce)

    }
    
    func setUpBarChart() {
        ResultsViewController.barChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        ResultsViewController.barChart.center = view.center
        view.addSubview(ResultsViewController.barChart)
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
        ResultsViewController.barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:labels)
        let data = BarChartData(dataSet: set)
        ResultsViewController.barChart.data = data
        ResultsViewController.barChart.legend.enabled = false
        set.colors = ChartColorTemplates.joyful()
        ResultsViewController.barChart.animate(xAxisDuration: 3.0, yAxisDuration: 3.0, easingOption: .easeInOutBounce)
        ResultsViewController.barChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        ResultsViewController.barChart.xAxis.labelRotationAngle = 90
//        barChart.xAxis.avoidFirstLastClippingEnabled = true
        ResultsViewController.barChart.xAxis.granularity = 1
        ResultsViewController.barChart.xAxis.granularityEnabled = true
        ResultsViewController.barChart.xAxis.labelCount = 999999
        ResultsViewController.barChart.extraBottomOffset = 100
        ResultsViewController.barChart.extraTopOffset = 30
//        chartView.xAxis.avoidFirstLastClippingEnabled = true
        ResultsViewController.barChart.fitScreen()
    }
    
}


open class MaterialSegmentedControl: UIControl {
    
    /**
    The same selected segment index as you used in the default segmented control.
    */
    public var selectedSegmentIndex = 0
    
    /**
    The view that operates as the selector, we put a generic type here which you can
    customize to any other view you would like.
    */
    open var selector: UIView!
    
    /**
    The view that displays as the segments, you can use any other views that inherits
    UIControl, namely views that are clickable.
    */
    open var segments = [UIButton]()
  
    /**
    The stack view we use to arrange segments.
    */
    var stackView: UIStackView!
    
    public var borderWidth: CGFloat = 1.5
    public var textColor: UIColor = .gray
    
    /**
    This defines the selector style that is provided by this post. You may create your
    own selector style here.
    */
    public enum SelectorStyle {
        case fill
        case outline
        case line
    }
    public var selectorStyle: SelectorStyle = .line
    public var selectorColor: UIColor = .gray
    public var selectorTextColor: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews() {
        guard segments.count > 0 else { return }

        for idx in 0..<segments.count {
            // Always set the background to transparent in order to not block the selector.
            segments[idx].backgroundColor = .clear
            
            // Add UITouch event to the button.
            segments[idx].addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            
            // Put a tag on the segment for searching
            segments[idx].tag = idx
        }

        // Create stackView that hold all the segments.
        stackView = UIStackView(arrangedSubviews: segments)
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        (stackView.alignment, stackView.distribution) = (.fill, .fillEqually)

        // Initialize the selector.
        // We put zero here since the AutoLayout will handle the frame in layoutSubviews().
        selector = UIView(frame: .zero)
        if let first = segments.first {
            selector.setCornerBorder(cornerRadius: first.layer.cornerRadius)
        }

        // Configure the selector seperately based on the selector style specified.
        switch selectorStyle {
        case .fill, .line:
            selector.backgroundColor = selectorColor
        case .outline:
            selector.setCornerBorder(color: selectorColor, borderWidth: 1.5)
        }

        // Remove all views from the segmented control if there ever exists.
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }

        // Add views to the view hierarchy
        [selector, stackView].forEach { (view) in
            guard let view = view else { return }
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        // Set the first segment to be selected by default.
        if let firstBtn = segments.first {
            buttonTapped(button: firstBtn)
        }
        self.layoutSubviews()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
           
        selector.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        switch selectorStyle {
        case .fill, .outline:
            selector.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        case .line:
            selector.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        }
        
        if let selector = selector, let first = stackView.arrangedSubviews.first {
            self.addConstraint(NSLayoutConstraint(item: selector, attribute: .width, relatedBy: .equal, toItem: first, attribute: .width, multiplier: 1.0, constant: 0.0))
        }

        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.layoutIfNeeded()
    }
    
    
    @objc func buttonTapped(button: UIButton) {
        for (idx, btn) in segments.enumerated() {
            let image = btn.image(for: .normal)
            btn.setTitleColor(textColor, for: .normal)
            btn.setImage(image)

            if btn.tag == button.tag {
                selectedSegmentIndex = idx
                btn.setImage(image?.colored(selectorTextColor))
                btn.setTitleColor(selectorStyle == .line ? textColor : selectorTextColor, for: .normal)
                moveView(selector, toX: btn.frame.origin.x)
                
                if btn.tag == 0 {
                    ResultsViewController.barChart.isHidden = false
                    ResultsViewController.lineChart.isHidden = true
                    ResultsViewController.barChart.animate(xAxisDuration: 3.0, yAxisDuration: 3.0, easingOption: .easeInOutBounce)
                } else {
                    ResultsViewController.barChart.isHidden = true
                    ResultsViewController.lineChart.isHidden = false
                    ResultsViewController.lineChart.animate(xAxisDuration: 3.0, yAxisDuration: 3.0, easingOption: .easeInElastic)
                    
                }
                
            }
        }
        

        sendActions(for: .valueChanged)
    }

    /**
     Moves the view to the right position.
     - Parameter view:       The view to be moved to new position.
     - Parameter duration:   The duration of the animation.
     - Parameter completion: The completion handler.
     - Parameter toView:     The targetd view frame.
     */
    open func moveView(_ view: UIView, duration: Double = 0.5, completion: ((Bool) -> Void)? = nil, toX: CGFloat) {
        view.transform = CGAffineTransform(translationX: view.frame.origin.x, y: 0.0)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: { () -> Void in
                        view.transform = CGAffineTransform(translationX: toX, y: 0.0)
        }, completion: completion)
    }
    
    
}
