
///
/// Marvin Kagiso
/// 18:10 2020/06/06
/// 
// This file is part of mzansi_corona.

// mzansi_corona is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// mzansi_corona is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with mzansi_corona.  If not, see <https://www.gnu.org/licenses/>.


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:popup_menu/popup_menu.dart';
import 'dart:math';


import '../models/country_info.dart';
import '../providers/logger.dart';
import '../helpers/styles.dart';
import '../widgets/app_menu.dart';
import '../models/province_info.dart';
import '../widgets/top_container.dart';
import '../widgets/back_button.dart';
import '../models/province_timeline.dart';
import '../widgets/indicator.dart';
import '../apis/corona_api.dart';


/// Province Page.
class ProvincePage extends StatefulWidget {
	final ProvinceInfo provinceInfo;
  final CountryInfo countryInfo;

	ProvincePage(this.provinceInfo, this.countryInfo) {
		assert(this.provinceInfo != null);
		assert(this.countryInfo != null);
	}

	@override
	_ProvincePageState createState() => _ProvincePageState();
}

class _ProvincePageState extends State<ProvincePage> with TickerProviderStateMixin {

  final GlobalKey _popupBtnMenuKey = GlobalKey();
  TabController _tabCtrl;
  ViewTab _selectedTabIndex = ViewTab.pieChart;
  int _piechartTouchedIndex;
  ProvinceTimeline _selectedMonthTimeline;
  List<ProvinceTimeline> _provincesMonthTimeline;
  List<ProvinceTimeline> _provinceMonthDaysTimeline;
  int _selectedMonth = -1;
  PageState _state = PageState.loading;
  final _coronaApi = CoronaApi();
  dynamic _error;
  Function _lastLoad;

	
	@override
	initState() {
    _tabCtrl = TabController(
      vsync: this,
      length: ViewTab.values.length,
      initialIndex: this._selectedTabIndex.index,
    );

		super.initState();

    this._loadProvinceInfo();

  //  this._initPopupMenu();
	}

	@override
	dispose() {
		super.dispose();
	}

  void _showMenu() {
    final months = this._provincesMonthTimeline.map<int>((ProvinceTimeline d) {
      return d.updateAt.month;
    }).toSet().map<MenuItemProvider>((int monthIndex) {
      return MenuItem(
        title: this._getMonthString(monthIndex),
        userInfo: monthIndex,
      );
    }).toList().reversed.toList();

    final menu = PopupMenu(
      maxColumn: 1,
      backgroundColor: Styles.kColourAppPrimary,
      lineColor: Styles.kColourAppTextPrimary,
      items: months,
      onClickMenu: (MenuItemProvider item) {
        final int selectedMonthIndex = (item as MenuItem).userInfo;
        setState(() {
          final value = this._provincesMonthTimeline.firstWhere((ProvinceTimeline p) => p.updateAt.month == selectedMonthIndex);
          this._selectedMonthTimeline = value;
          if (this._selectedTabIndex == ViewTab.lineGraph) {
            this._loadProvinceMonthlyData();
          }
        });
      },
      stateChanged: (bool) {},
      onDismiss: () {},
    );

    menu.show(widgetKey: this._popupBtnMenuKey);
  }

	Widget _provinceHeader(BuildContext context) {
		final perc = (widget.provinceInfo.numInfections / widget.countryInfo.numInfections) * 100;
    final String provinceBgImage = Styles.provinceImage(widget.provinceInfo);
    final Color provinceColour = Styles.provinceColour(widget.provinceInfo);

		return TopContainerWidget(
			backgroundImage: provinceBgImage,
			backgroundColour: provinceColour,
			child: Container(
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.all(
            Radius.circular(40.0),
          ) 
        ),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: <Widget>[
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: <Widget>[
								BackButtonWidget()
							],
						),
						Padding(
							padding: const EdgeInsets.symmetric(
								horizontal: 0,
								vertical: 0.0
							),
							child: Row(
								crossAxisAlignment: CrossAxisAlignment.center,
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: <Widget>[
									CircularPercentIndicator(
										radius: 90.0,
										lineWidth: 5.0,
										animation: true,
										percent: perc / 100,
										circularStrokeCap: CircularStrokeCap.round,
										progressColor: Colors.white,
										backgroundColor: Colors.black26,
										center: Text('${perc.toStringAsFixed(1)}%'),
									),

									Container(
										child: Text(
											widget.provinceInfo.name,
											textAlign: TextAlign.start,
											style: TextStyle(
											fontSize: 22.0,
											color: Styles.kColourAppTextPrimary,
											fontWeight: FontWeight.w800,
											),
										),
									),
								],
							),
						)
					]
				)
			),
    );
	}

  Widget _renderBody() {
    switch (this._state) {

      case PageState.success:

        return Column(
          children: <Widget>[

            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10.0
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TabBar(
                        controller: this._tabCtrl,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BubbleTabIndicator(
                          indicatorHeight: 25.0,
                          indicatorColor: Styles.kColourAppPrimary,
                          tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        ),
                        labelColor: Styles.kColourAppTextPrimary,
                        isScrollable: false,
                        unselectedLabelColor: Styles.kColourAppSecondary,
                        onTap: (int index) {
                          setState(() {
                            this._selectedTabIndex = ViewTab.values[index];
                            if (this._selectedTabIndex == ViewTab.lineGraph) {
                              this._loadProvinceMonthlyData();
                            }
                          });
                        },
                        tabs: <Widget>[
                          Icon(
                            Icons.pie_chart
                          ),
                          Icon(
                            Icons.linear_scale
                          ),
                          Icon(
                            Icons.text_format
                          ),
                        ],
                      ),
                      SizedBox(height: 32,),

                      this._renderBasedOnTabIndex(context),
                    ],
                  ),
                  ),
                ],
                ),
              ),
          ],
        );
    
      case PageState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  this._error.toString(),
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 32),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  color: Styles.kColourAppPrimary,
                  child: Icon(
                    Icons.refresh,
                    color: Styles.kColourAppTextPrimary,
                  ),
                  onPressed: (){
                    this._lastLoad();
                  },
                )
              ],
            ),
          )
        );

      case PageState.loading: default:
        return Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 32),
              CircularProgressIndicator(
                backgroundColor: Styles.kColourAppTextPrimary,
              )
            ],
          )
        );
    }
  }

	@override
	Widget build(BuildContext context) {
    final bool hasData = this._provincesMonthTimeline != null && this._provincesMonthTimeline.length > 0;

    PopupMenu.context = context;

		return Scaffold(
			floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        child: hasData ? this._renderPopupMenu() : null,
        opacity: hasData ? 1.0 : 0.0,
      ),
			body: SafeArea(
				child: Column(
          children: [
            this._provinceHeader(context),
            this._renderBody(),
          ]
        )
			),
		);
	}

  Widget _renderPopupMenu() {
    return Container(
      child: FloatingActionButton.extended(
        tooltip: 'More Months',
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(8.0)
        // ),
        key: this._popupBtnMenuKey,
        onPressed: () => _showMenu(),
        // color: Styles.kColourAppPrimary,
        icon: Icon(
          Icons.calendar_today,
          color: Styles.kColourAppTextPrimary,
        ),
        label: Text(this._getMonthString(this._selectedMonthTimeline.updateAt.month))
      ),
    );
  }

  Widget _renderBasedOnTabIndex(BuildContext context) {
    final data = this._provincesMonthTimeline;

    switch (this._selectedTabIndex) {
      case ViewTab.textInfo: return this._renderStats(context);
      case ViewTab.lineGraph: return this._renderLineGraph(context);
      case ViewTab.pieChart: return this._renderPieChart(context);

      default: throw 'Unknown Tab Index: ' + this._selectedTabIndex.index.toString();
    }
  }

  Widget _renderStats(BuildContext context) {
    final data = this._provincesMonthTimeline;
    final month = this._selectedMonthTimeline;
    final stats = <Map<String, dynamic>>[
      {
        'title': 'Infections',
        'value': month?.numInfections?.toString() ?? '-',
        'icon': Icons.bug_report,
      },
      {
        'title': 'Tests',
        'value': month?.numTests?.toString() ?? '-',
        'icon': Icons.local_hospital,
      },
      {
        'title': 'Recoveries',
        'value': month?.numInfections?.toString() ?? '-',
        'icon': Icons.accessibility_new,
      },
      {
        'title': 'Deaths',
        'value': month?.numDeaths?.toString() ?? '-',
        'icon': Icons.highlight_off,
      },
    ];

    return Container(
      child: Column(
        children: <Widget>[
          ...stats.map<Widget>((Map<String, dynamic> stat) {
            return Card(
              color: Styles.kColourAppSecondary,
              child: ListTile(
                title: Text(stat['title']),
                subtitle: Text(stat['value']),
                leading: Icon(
                  stat['icon'],
                  color: Styles.kColourAppTextPrimary,
                  size: 32.0,
                ),
              ),
            );
          })
        ],
      )
    );
  }

  LineChartBarData _createLineChart(List<FlSpot> data, Color colour) {
    final LineChartBarData lineChart = LineChartBarData(
      spots: data,
      isCurved: true,
      colors: [
        colour,
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
      ),
    );

    return lineChart;
  }

  Widget _renderLineGraph(BuildContext context) {
    final data = this._provinceMonthDaysTimeline;
    double maxY = 0;
  
    final infections = data.map<FlSpot>((ProvinceTimeline p) {
      maxY = max(maxY, p.numInfections?.toDouble() ?? 0);
      return FlSpot(p.updateAt.month.toDouble(), p.numInfections?.toDouble() ?? 0);
    }).toList();

    final deaths = data.map<FlSpot>((ProvinceTimeline p) {
      maxY = max(maxY, p.numDeaths?.toDouble() ?? 0);
      return FlSpot(p.updateAt.month.toDouble(), p.numDeaths?.toDouble() ?? 0);
    }).toList();

    final tests = data.map<FlSpot>((ProvinceTimeline p) {
      maxY = max(maxY, p.numTests?.toDouble() ?? 0);
      return FlSpot(p.updateAt.month.toDouble(), p.numTests?.toDouble() ?? 0);
    }).toList();

    final recoveries = data.map<FlSpot>((ProvinceTimeline p) {
      maxY = max(maxY, p.numRecovered?.toDouble() ?? 0);
      return FlSpot(p.updateAt.month.toDouble(), p.numRecovered?.toDouble() ?? 0);
    }).toList();

    final infectionsLineChart = this._createLineChart(infections, Styles.kColourInfections);
    final deathsLineChart = this._createLineChart(deaths, Styles.kColourDeaths);
    final testsLineChart = this._createLineChart(tests, Styles.kColourTests);
    final recoveriesLineChart = this._createLineChart(recoveries, Styles.kColourRecoveries);

    return Container(
      margin: EdgeInsets.only(top: 8.0,),
      width: MediaQuery.of(context).size.width * 0.90,
      child: Column(
       // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LineChart(
            LineChartData(
              //minY: 0,
              lineBarsData: [
                infectionsLineChart,
                deathsLineChart,
                testsLineChart,
                recoveriesLineChart
              ],
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(
                // interval: 100,
                  // checkToShowTitle: (minValue, maxValue, sideTitles, appliedInterval, value) {
                    
                  // },
                  showTitles: true,
               //   reservedSize: 1,
                  textStyle: const TextStyle(
                    color: Styles.kColourAppPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  margin: 10,
                  getTitles: (double value) {
                    return value.toInt().toString();
                    return this._getMonthString(value.toInt());
                  },
                ),
                leftTitles: SideTitles(
                  interval: 50,
                  showTitles: true,
                  textStyle: const TextStyle(
                    color: Styles.kColourAppPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                  getTitles: (double value) {
                    //if (isInList(infections, value) /*|| isInList(recoveries, value) || isInList(tests, value) || isInList(deaths, value)*/) {
                      //return value.toInt().toString();
                    //}

                    return value.toInt().toString();
                  },
                  margin: 8,
                //  reservedSize: null,
                ),
              ),
            )
          ),
          const SizedBox(height: 32),
          this._renderIndicators(),
        ]
      ),
    );
  }

  Widget _renderIndicators({bool isSquare = false, double size = 16}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IndicatorWidget(
          color: Styles.kColourInfections,
          text: 'Infections',
          isSquare: isSquare,
          size: size,
        ),
        SizedBox(
          height: 4,
        ),
        IndicatorWidget(
          color: Styles.kColourTests,
          text: 'Tests',
          isSquare: isSquare,
          size: size,
        ),
        SizedBox(
          height: 4,
        ),
        IndicatorWidget(
          color: Styles.kColourRecoveries,
          text: 'Recoveries',
          isSquare: isSquare,
          size: size,
        ),
        SizedBox(
          height: 4,
        ),
        IndicatorWidget(
          color: Styles.kColourDeaths,
          text: 'Deaths',
          isSquare: isSquare,
          size: size,
        ),
      ],
    );
  }

  Widget _renderPieChart(BuildContext context) {
    final data = this._provincesMonthTimeline;
    final province = this._selectedMonthTimeline;
    final total = ((province.numRecovered ?? 0) + (province.numDeaths ?? 0) + (province.numInfections ?? 0) + (province.numTests ?? 0)).toDouble();
    final List<PieChartSectionData> sections = [
      _pieChartSections((province.numInfections ?? 0) / total * 100.0, Styles.kColourInfections, Index.infections),
      _pieChartSections((province.numTests ?? 0) / total * 100.0, Styles.kColourTests, Index.tests),
      _pieChartSections((province.numDeaths ?? 0) / total * 100.0, Styles.kColourDeaths, Index.recoveries),
      _pieChartSections((province.numRecovered ?? 0) / total * 100.0, Styles.kColourRecoveries, Index.deaths),
    ];

    return Column(
      children: [
        PieChart(
          PieChartData(
            pieTouchData: PieTouchData(touchCallback: (PieTouchResponse pieTouchResponse) {
              setState(() {
                if (pieTouchResponse.touchInput is FlLongPressEnd || pieTouchResponse.touchInput is FlPanEnd) {
                  this._piechartTouchedIndex = -1;
                } else {
                  this._piechartTouchedIndex = pieTouchResponse.touchedSectionIndex;
                }
              });
            }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            sections: sections,
          ),
        ),
        this._renderIndicators(),
      ]
    );
  }

  PieChartSectionData _pieChartSections(double value, Color colour, Index index) {
    final isTouched = index.index == this._piechartTouchedIndex;
    final double fontSize = isTouched ? 25 : 16;
    final double radius = isTouched ? 60 : 50;

    return PieChartSectionData(
      color: colour,
      value: value.toDouble(),
      title: value == 0 ? '' : '${value.toStringAsFixed(1)}%',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Styles.kColourAppTextPrimary
      ),
    );
  }

  void _loadProvinceInfo() {
    setState(() {
      this._state = PageState.loading;
      this._lastLoad = this._loadProvinceInfo;
    });
    
    this._coronaApi.getProvinceTimelineMonths(isoCode: this.widget.provinceInfo.isoCode)
      .then((List<ProvinceTimeline> data) {
        this.setState(() {
          this._provincesMonthTimeline = data;
          this._selectedMonthTimeline = this._provincesMonthTimeline.last;  // gets the last element (latest).
          this._state = PageState.success;
        });
      })
      .catchError((error) {
        setState(() {
          this._state = PageState.error;
          this._error = error;
        });
      });
  }

  void _loadProvinceMonthlyData() {
    setState(() {
      this._state = PageState.loading;
      this._lastLoad = this._loadProvinceMonthlyData;
    });

    this._coronaApi.getProvinceTimelineMonthDays(
      isoCode: this.widget.provinceInfo.isoCode,
      year: this._selectedMonthTimeline.updateAt.year,
      month: this._selectedMonthTimeline.updateAt.month
    )
      .then((List<ProvinceTimeline> data) {
        this.setState(() {
          this._provinceMonthDaysTimeline = data;
          this._state = PageState.success;
          
        });
       // print(data.map((e) => e.toJson().toString()).toString());
      })
      .catchError((error) {
        setState(() {
          this._state = PageState.error;
          this._error = error;
        });
      });
  }

  String _getMonthString(int monthInt) {
    switch (monthInt) {
      case DateTime.january: return 'January';
      case DateTime.february: return 'February';
      case DateTime.march: return 'March';
      case DateTime.april: return 'April';
      case DateTime.may: return 'May';
      case DateTime.june: return 'June';
      case DateTime.july: return 'July';
      case DateTime.august: return 'August';
      case DateTime.september: return 'September';
      case DateTime.october: return 'October';
      case DateTime.november: return 'November';
      case DateTime.december: return 'December';
      default: return '';
    }
  }

  _scaleBetween({@required double unscaledNum, double minAllowed = 0, @required double maxAllowed, double min = 0, @required double max}) {
    return (maxAllowed - minAllowed) * (unscaledNum - min) / (max - min) + minAllowed;
  }
}

enum Index {
  infections,
  tests,
  recoveries,
  deaths,
}

enum ViewTab {
  pieChart,
  lineGraph,
  textInfo,
}

enum PageState {
  loading,
  success,
  error,
}
