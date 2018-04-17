//
//  AllGraphView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/26/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import Charts
import Domain
import RxSwift
import RxCocoa

class AllGraphView: LineChartView {

    var useCase: DevelopmentUseCase! {
        didSet {
            bindViewModel()
        }
    }
    private let disposeBag = DisposeBag()
    
    var rx_year = PublishSubject<Int>()
    
    var currentYear = Date().getYear {
        didSet {
            rx_year.onNext(currentYear)
        }
    }
    
    func setupGraphView() {
        let weekCount = Date.getLastWeekOfYear(year: currentYear)
        
        self.maxVisibleCount = weekCount
        
        let xAxis = self.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.setLabelCount(weekCount, force: true)
        xAxis.valueFormatter = AllAxisValueFormatter()
        xAxis.axisMaximum = Double(weekCount)
        xAxis.axisMinimum = 1
        xAxis.yOffset = 10
        
        let leftAxis = self.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 4
        leftAxis.valueFormatter = CompleteLeftValueFormatter()
        leftAxis.axisMaximum = 5
        leftAxis.axisMinimum = 1
        leftAxis.xOffset = 10
        
        self.extraRightOffset = 15
        
        self.legend.enabled = false
        self.rightAxis.enabled = false
        self.chartDescription?.enabled = false
        self.pinchZoomEnabled = false
        self.doubleTapToZoomEnabled = false
        self.clipsToBounds = false
    }
    
    func bindViewModel() {
        let viewModel = AllGraphViewModel(with: useCase)
        let input = AllGraphViewModel.Input(year: rx_year.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        [output.result.drive(graphBinding),
         output.error.drive(errorBinding)]
            .forEach({$0.disposed(by: disposeBag)})
    }
    
    var graphBinding: Binder<(AllNote?, AllNote?, [AllNote])> {
        return Binder(self, binding: { (vc, result) in
            vc.setupGraphView()
            vc.setGraphData(result.0, result.1, result.2)
        })
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            print(error.localizedDescription)
        })
    }
    
    func updateGraph(_ year: Int) {
        currentYear = year
    }
    
    func setGraphData(_ prevNote: AllNote?, _ nextNote: AllNote?, _ notes: [AllNote]) {
        
        var lineChartEntry = [ChartDataEntry]()
        
        //        if let prevNote = prevNote,
        //            let date = Date.getDate(year: prevNote.year, weekOfYear: prevNote.week, weekDay: prevNote.weekDay),
        //            let startOfWeek = Date.getStartDateOfWeek(year: currentWeek.0, weekOfYear: currentWeek.1),
        //            let days = startOfWeek.getDays(from: date) {
        //            let value = ChartDataEntry(x: -Double(days - 1), y: Double(prevNote.complete < 1 ? 0: prevNote.complete))
        //            lineChartEntry.append(value)
        //        }
        //        else {
        //            let value = ChartDataEntry(x: 0, y: 0)
        //            lineChartEntry.append(value)
        //        }
        
        let weekCount = Date.getLastWeekOfYear(year: currentYear)
        
        var nextWeek = 0
        for i in 0..<weekCount {
            let weekNotes = notes.filter({ (note) -> Bool in
                return note.week == i + 1
            })
            let weekCompletes = weekNotes.map{ $0.complete }.filter{ $0 > 0 }
            if weekCompletes.count > 0 {
                nextWeek = i + 1
                let value = ChartDataEntry(x: Double(nextWeek), y: Double(weekCompletes.first!))
                lineChartEntry.append(value)
            }
        }
        
        nextWeek += 1
        
        //        if let nextNote = nextNote,
        //            let date = Date.getDate(year: nextNote.year, weekOfYear: nextNote.week, weekDay: nextNote.weekDay),
        //            let endOfWeek = Date.getStartDateOfWeek(year: currentWeek.0, weekOfYear: currentWeek.1 + 1, isStartMon: false),
        //            let days = date.getDays(from: endOfWeek) {
        //            let value = ChartDataEntry(x: Double(days + 7), y: Double(nextNote.complete < 1 ? 0 : nextNote.complete))
        //            lineChartEntry.append(value)
        //        }
        //        else {
        //            let value = ChartDataEntry(x: Double(nextDay), y: 0)
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

}
