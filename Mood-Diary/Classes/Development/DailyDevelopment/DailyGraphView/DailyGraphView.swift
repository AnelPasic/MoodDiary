//
//  DailyGraphView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/24/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import Charts
import Domain
import RxSwift
import RxCocoa

class DailyGraphView: LineChartView {

    var useCase: DevelopmentUseCase! {
        didSet {
            bindViewModel()
        }
    }
    private let disposeBag = DisposeBag()
    
    var rx_date = PublishSubject<Date>()
    
    var currentDate: Date = Date.today() {
        didSet {
            rx_date.onNext(currentDate)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGraphView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGraphView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGraphView()
    }
    
    func setupGraphView() {
        self.maxVisibleCount = 13
        
        let xAxis = self.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 12
        xAxis.valueFormatter = TimeAxisValueFormatter()
        xAxis.axisMaximum = 24
        xAxis.axisMinimum = 0
        xAxis.yOffset = 10

        let leftAxis = self.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 4
        leftAxis.valueFormatter = CompleteLeftValueFormatter()
        leftAxis.axisMaximum = 5
        leftAxis.axisMinimum = 1
        leftAxis.xOffset = 10
        
        self.legend.enabled = false
        self.rightAxis.enabled = false
        self.chartDescription?.enabled = false
        self.pinchZoomEnabled = false
        self.doubleTapToZoomEnabled = false
        
        addTimeIcon()
    }
    
    func addTimeIcon() {
        let timeImageView = UIImageView(image: #imageLiteral(resourceName: "icon_timer"))
        self.addSubview(timeImageView)
        
        timeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            timeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            timeImageView.widthAnchor.constraint(equalToConstant: 10),
            timeImageView.heightAnchor.constraint(equalToConstant: 10)
            ])
    }
    
    func bindViewModel() {
        let viewModel = DailyGraphViewModel(with: useCase)
        let input = DailyGraphViewModel.Input(date: rx_date.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        [output.result.drive(graphBinding),
         output.error.drive(errorBinding)]
            .forEach({$0.disposed(by: disposeBag)})
        
        rx_date.onNext(currentDate)
    }
    
    var graphBinding: Binder<(Note?, Note?, [Note])> {
        return Binder(self, binding: { (vc, result) in
            vc.setGraphData(result.0, nextNote: result.1, result.2)
        })
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            print(error.localizedDescription)
        })
    }
    
    func updateGraph(_ date: Date) {
        currentDate = date
    }
    
    func setGraphData(_ prevNote: Note?, nextNote: Note?, _ notes: [Note]) {
        var lineChartEntry = [ChartDataEntry]()
        
//        if let prevNote = prevNote, let date = Date.getDate(year: prevNote.year, weekOfYear: prevNote.week, weekDay: prevNote.weekDay), let days = currentDate.getDays(from: date) {
//            let value = ChartDataEntry(x: -(Double(days * 12 - prevNote.index) + 0.5), y: Double(prevNote.complete < 1 ? 0: prevNote.complete))
//            lineChartEntry.append(value)
//        }
//        else {
//            let value = ChartDataEntry(x: -0.5, y: 0)
//            lineChartEntry.append(value)
//        }
        
        for i in 1..<Constants.calendarTimeCount {
            let dayNotes = notes.filter({ (note) -> Bool in
                return note.index == i
            }).map{ $0.complete }.filter{ $0 > 0 }
            if dayNotes.count > 0 {
                let value = ChartDataEntry(x: getXValue(i), y: Double(dayNotes.first!))
                lineChartEntry.append(value)
            }
        }
        
//        if let nextNote = nextNote, let date = Date.getDate(year: nextNote.year, weekOfYear: nextNote.week, weekDay: nextNote.weekDay), let days = date.getDays(from: currentDate) {
//            let value = ChartDataEntry(x: Double(days * 12 + nextNote.index) + 0.5, y: Double(nextNote.complete < 1 ? 0 : nextNote.complete))
//            lineChartEntry.append(value)
//        }
//        else {
//            let value = ChartDataEntry(x: lineChartEntry.last!.x + 1, y: 0)
//            lineChartEntry.append(value)
//        }
        
        let line = LineChartDataSet(values: lineChartEntry, label: nil)
        line.colors = [Constants.appColor]
        line.lineWidth = 3
        line.circleRadius = 6
        line.circleColors = [Constants.appColor]
        line.circleHoleColor = Constants.appColor
        let data = LineChartData()
        data.addDataSet(line)
        
        self.data = data
        self.setNeedsDisplay()
    }
    
    private func getXValue(_ index: Int) -> Double {
        if index == 1 {
            return 1.0
        }
        else if index == 2 {
            return 4.0
        }
        else {
            return Double(index) + 3.5
        }
    }

}
