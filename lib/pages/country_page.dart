
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
  Future<CountryInfo> _countryStatsFuture;
  Future<List<ProvinceInfo>> _provinceStatsFuture;
  

  @override
	initState() {
		super.initState();
    this._getCoutryStats();
    this._getProvinceStats();
		SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
			statusBarColor: Styles.kColourAppPrimary,
			systemNavigationBarColor: Styles.kColourAppPrimary,
		));
	}

  void _getCoutryStats() {
    setState(() {
      _countryStatsFuture = this._coronaApi.getCountryStats(isoCode: this.countryZa);
    });
  }

  void _getProvinceStats() {
    setState(() {
      _provinceStatsFuture = this._coronaApi.getAllCountryProvinceStats(isoCode: this.countryZa);
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

  Widget _countrySummary(BuildContext context, CountryInfo stats) {
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
                  animation: true,
                  percent: 0.75,
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

  Widget _province(CountryInfo countryInfo, ProvinceInfo provinceInfo, BuildContext context) {
    return ProvinceInfoWidget(
      countryInfo: countryInfo,
      provinceInfo: provinceInfo,
      onTap: () => this._gotoProvince(provinceInfo, countryInfo, context),
    );
  }

  Widget _provinces(BuildContext context, CountryInfo countryInfo, List<ProvinceInfo> provinces) {
    int provinceIndex = 0;

    // sort in descending order according to Number Of Infections.
    provinces.sort((ProvinceInfo a, ProvinceInfo b) => b.numInfections.compareTo(a.numInfections));

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            this._province(countryInfo, provinces[provinceIndex++], context),
          ],
        ),
        Row(
          children: <Widget>[
            this._province(countryInfo, provinces[provinceIndex++], context),
            SizedBox(width: 20.0),
            this._province(countryInfo, provinces[provinceIndex++], context),
          ],
        ),
        Row(
          children: <Widget>[
            this._province(countryInfo, provinces[provinceIndex++], context),
            SizedBox(width: 20.0),
            this._province(countryInfo, provinces[provinceIndex++], context),
          ],
        ),
        Row(
          children: <Widget>[
            this._province(countryInfo, provinces[provinceIndex++], context),
            SizedBox(width: 20.0),
            this._province(countryInfo, provinces[provinceIndex++], context),
          ],
        ),
        Row(
          children: <Widget>[
            this._province(countryInfo, provinces[provinceIndex++], context),
            SizedBox(width: 20.0),
            this._province(countryInfo, provinces[provinceIndex++], context),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: LightColors.kLightYellow,
      floatingActionButton: AppMenuWidget(),
      body: SafeArea(
        child: FutureBuilder(
          future: Future.wait([
            this._countryStatsFuture,
            this._provinceStatsFuture,
          ]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final CountryInfo countryInfo = snapshot.data[0];
              final List<ProvinceInfo> provincesInfo = snapshot.data[1];

              return Column(
                children: <Widget>[
                  this._countrySummary(context, countryInfo),
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
                                this._provinces(context, countryInfo, provincesInfo),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            else if (snapshot.hasError) {
              return Text(snapshot.error.toString(), style: TextStyle(color: Colors.black),);
            }

            return Container(
              color: Styles.kColourAppPrimary.withOpacity(0.667),
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Styles.kColourAppTextPrimary,
                )
              )
            );
          }
        )
      ),
    );
  }

  void _gotoProvince(ProvinceInfo provinceInfo, CountryInfo countryInfo, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ProvincePage(provinceInfo, countryInfo);
    }));
  }
}
