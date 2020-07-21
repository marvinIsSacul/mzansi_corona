
import 'dart:async';

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
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';

import '../models/country_info.dart';
import '../helpers/styles.dart';
import '../models/province_info.dart';
import '../widgets/province_info.dart';
import '../widgets/top_container.dart';
import '../widgets/app_menu.dart';
import './province_page.dart';
import '../apis/corona_api.dart';


/// The CountryPage.
class CountryPage extends StatefulWidget {
	CountryPage();

	@override
	_CountryPage createState() => _CountryPage();
}

class _CountryPage extends State<CountryPage> {

  final countryZa = 'ZA';
  final _coronaApi = CoronaApi();
  CountryInfo _countryInfo;
  List<ProvinceInfo> _provincesInfo;
  dynamic _httpError;
  PageState _pageState = PageState.loading;
  int _numDataLoaded = 0;
  Timer _timerLoadData;
  BuildContext _currentContext;
  

  @override
	initState() {
		super.initState();
    this._setupTimer_loadData();
    this._loadData();
	}

  @override
  dispose() {
    this._closeTimer_loadData();
    super.dispose();
  }

  void _setupTimer_loadData() {
    _timerLoadData ??= Timer.periodic(Duration(seconds: 30), (Timer timer) {
      Scaffold.of(_currentContext).showSnackBar(SnackBar(
        content: Text('Refreshing...'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)
        ),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            Scaffold.of(_currentContext).hideCurrentSnackBar();
          },
        ),
      ));
      this._loadData();
    });
  }

  void _closeTimer_loadData() {
    if (_timerLoadData != null && _timerLoadData.isActive) {
      _timerLoadData.cancel();
      _timerLoadData = null;
    }
  }

  void _loadData() {

    // if latest data load attempt, was a fail.
    if (this._numDataLoaded <= 0) {
      setState(() {
        this._pageState = PageState.loading;
      });
    }

    Future.wait([
      this._coronaApi.getCountryStats(isoCode: this.countryZa),
      this._coronaApi.getAllCountryProvinceStats(isoCode: this.countryZa)
    ])
      .then((List results) {
        final CountryInfo countryStats = results[0];
        final List<ProvinceInfo> provincesStats = results[1];

        setState(() {
          this._countryInfo = countryStats;
          this._provincesInfo = provincesStats;
          this._pageState = PageState.success;
          this._numDataLoaded++;
        });
      })
      .catchError((onError) {
        setState(() {
          _httpError = onError;
          this._pageState = PageState.error;
          this._numDataLoaded = 0;
        });
      });
  }

  Widget _subheading(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Styles.kColourAppPrimary,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2
      ),
    );
  }

  Widget _countryStats(String title, int value) {
    return Container(
      alignment: AlignmentDirectional.topStart,
      child: RichText(
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        text: TextSpan(
          style: TextStyle(
            fontSize: 16.0,
            color: Styles.kColourAppTextPrimary,
            fontWeight: FontWeight.w400,
          ),
          children: <TextSpan> [
            TextSpan(
              text: '$title: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '$value'
            )
          ]
        )
      ),
    );
  }

  Widget _countrySummary(BuildContext context) {
    final CountryInfo stats = this._countryInfo;

    return TopContainerWidget(
     // backgroundImage: 'assets/images/zar-flag-md.png',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
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
                  animation: false,
                  percent: 1.0,
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.white,
                  backgroundColor: Colors.black26,
                  center: CircleAvatar(
                    backgroundColor: Styles.kColourAppSecondary,
                    radius: 35.0,
                    backgroundImage: AssetImage(
                      'assets/images/zar-flag-md.png',
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'South Africa',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Styles.kColourAppTextPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    this._countryStats('Infections', stats.numInfections),
                    this._countryStats('Deaths', stats.numDeaths),
                    this._countryStats('Recoveries', stats.numRecovered),
                  ],
                )
              ],
            ),
          )
        ]
      ),
    );
  }

  Widget _province(BuildContext context, ProvinceInfo provinceInfo) {
    return ProvinceInfoWidget(
      countryInfo: this._countryInfo,
      provinceInfo: provinceInfo,
      onTap: () => this._gotoProvince(provinceInfo, this._countryInfo, context),
    );
  }

  Widget _provinces(BuildContext context) {
    int provinceIndex = 0;

    // sort in descending order according to Number Of Infections.
    final provinces = [...this._provincesInfo]..sort((ProvinceInfo a, ProvinceInfo b) => b.numInfections.compareTo(a.numInfections));

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            this._province(context, provinces[provinceIndex++]),
          ],
        ),
        Row(
          children: <Widget>[
            this._province(context, provinces[provinceIndex++]),
            SizedBox(width: 20.0),
            this._province(context, provinces[provinceIndex++]),
          ],
        ),
        Row(
          children: <Widget>[
            this._province(context, provinces[provinceIndex++]),
            SizedBox(width: 20.0),
            this._province(context, provinces[provinceIndex++]),
          ],
        ),
        Row(
          children: <Widget>[
            this._province(context, provinces[provinceIndex++]),
            SizedBox(width: 20.0),
            this._province(context, provinces[provinceIndex++]),
          ],
        ),
        Row(
          children: <Widget>[
            this._province(context, provinces[provinceIndex++]),
            SizedBox(width: 20.0),
            this._province(context, provinces[provinceIndex++]),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (this._pageState) {
      case PageState.success:

        return Column(
          children: <Widget>[
            this._countrySummary(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _subheading('Provinces'),
                          SizedBox(height: 5.0),
                          this._provinces(context),
                        ],
                      ),
                    ),
                  ],
                ),
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
                  this._httpError.toString(),
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
                    this._loadData();
                  },
                )
              ],
            ),
          )
        );
      
      case PageState.loading: default:

        return Container(
          // color: Styles.kColourAppPrimary.withOpacity(0.667),
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Styles.kColourAppTextPrimary,
            )
          )
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: LightColors.kLightYellow,
      //floatingActionButton: AppMenuWidget(),
      body: Builder(
        builder: (BuildContext context) => SafeArea(
          child: this._buildBody(_currentContext = context)
        ),
      ) 
    );
  }

  void _gotoProvince(ProvinceInfo provinceInfo, CountryInfo countryInfo, BuildContext context) {
    this._closeTimer_loadData();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ProvincePage(provinceInfo, countryInfo);
    }))
      .whenComplete(() {
        this._setupTimer_loadData();
      });
  }
}

enum PageState {
  loading,
  success,
  error,
}