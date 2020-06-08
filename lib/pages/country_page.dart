
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

import '../helpers/styles.dart';
import '../models/province_info.dart';
import '../widgets/province_info.dart';
import '../widgets/top_container.dart';
import '../widgets/app_menu.dart';
import './province_page.dart';


/// The CountryPage.
class CountryPage extends StatefulWidget {
	CountryPage();

	@override
	_CountryPage createState() => _CountryPage();
}

class _CountryPage extends State<CountryPage> {

  @override
	initState() {
		super.initState();
		SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
			statusBarColor: Styles.kColourAppPrimary,
			systemNavigationBarColor: Styles.kColourAppPrimary,
		));
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
                    this._countryStats('Infections', 12344),
                    this._countryStats('Deaths', 123),
                    this._countryStats('Recoveries', 5000),
                  ],
                )
              ],
            ),
          )
        ]
      ),
    );
  }

  Widget _province(ProvinceInfo info, BuildContext context) {
    return ProvinceInfoWidget(
      numTotal: 10000000,
      info: info,
      onTap: () => this._gotoProvince(info, context),
    );
  }

  Widget _provinces(BuildContext context) {
    final random = Random();
    final int totalInfections = random.nextInt(1234) + random.nextInt(1234567);
    final provinces = <ProvinceInfo>[
      ProvinceInfo(
        name: 'Gauteng',
        numInfections: random.nextInt(totalInfections),
        numDeaths: random.nextInt(totalInfections),
        numRecovered: random.nextInt(totalInfections),
        numTests: random.nextInt(totalInfections),
        colour: Styles.kColourGauteng,
        imageUrlMd: 'assets/images/gp-bg.jpg'
      ),

      ProvinceInfo(
        name: 'Eastern Cape',
        numInfections: random.nextInt(totalInfections),
        numDeaths: random.nextInt(totalInfections),
        numRecovered: random.nextInt(totalInfections),
        numTests: random.nextInt(totalInfections),
        colour: Styles.kColourEasternCape,
        imageUrlMd: 'assets/images/ec-bg.jpg',
      ),

      ProvinceInfo(
        name: 'Western Cape',
        numInfections: random.nextInt(totalInfections),
        numDeaths: random.nextInt(totalInfections),
        numRecovered: random.nextInt(totalInfections),
        numTests: random.nextInt(totalInfections),
        colour: Styles.kColourWesternCape,
        imageUrlMd: 'assets/images/wc-bg.jpg',
      ),

      ProvinceInfo(
        name: 'Northern Cape',
        numInfections: random.nextInt(totalInfections),
        numDeaths: random.nextInt(totalInfections),
        numRecovered: random.nextInt(totalInfections),
        numTests: random.nextInt(totalInfections),
        colour: Styles.kColourNorthenCape,
        imageUrlMd: 'assets/images/nc-bg.jpg',
      ),

      ProvinceInfo(
        name: 'North West',
        numInfections: random.nextInt(totalInfections),
        numDeaths: random.nextInt(totalInfections),
        numRecovered: random.nextInt(totalInfections),
        numTests: random.nextInt(totalInfections),
        colour: Styles.kColourNorthWest,
        imageUrlMd: 'assets/images/nw-bg.jpg',
      ),

      ProvinceInfo(
        name: 'Limpopo',
        numInfections: random.nextInt(totalInfections),
        numDeaths: random.nextInt(totalInfections),
        numRecovered: random.nextInt(totalInfections),
        numTests: random.nextInt(totalInfections),
        colour: Styles.kColourLimpopo,
        imageUrlMd: 'assets/images/lp-bg.jpg',
      ),

      ProvinceInfo(
        name: 'Mpumalanga',
        numInfections: random.nextInt(totalInfections),
        numDeaths: random.nextInt(totalInfections),
        numRecovered: random.nextInt(totalInfections),
        numTests: random.nextInt(totalInfections),
        colour: Styles.kColourMpumalanga,
        imageUrlMd: 'assets/images/mp-bg.jpg',
      ),

      ProvinceInfo(
        name: 'KwaZulu Natal',
        numInfections: random.nextInt(totalInfections),
        numDeaths: random.nextInt(totalInfections),
        numRecovered: random.nextInt(totalInfections),
        numTests: random.nextInt(totalInfections),
        colour: Styles.kColourKZN,
        imageUrlMd: 'assets/images/kzn-bg.jpg'
      ),

      ProvinceInfo(
        name: 'Free State',
        numInfections: random.nextInt(totalInfections),
        numDeaths: random.nextInt(totalInfections),
        numRecovered: random.nextInt(totalInfections),
        numTests: random.nextInt(totalInfections),
        colour: Styles.kColourFreeState,
        imageUrlMd: 'assets/images/fs-bg.jpg'
      ),
    ];
    int provinceIndex = 0;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            this._province(provinces[provinceIndex++], context),
          ],
        ),
        Row(
          children: <Widget>[
            this._province(provinces[provinceIndex++], context),
            SizedBox(width: 20.0),
            this._province(provinces[provinceIndex++], context),
          ],
        ),
        Row(
          children: <Widget>[
            this._province(provinces[provinceIndex++], context),
            SizedBox(width: 20.0),
            this._province(provinces[provinceIndex++], context),
          ],
        ),
        Row(
          children: <Widget>[
            this._province(provinces[provinceIndex++], context),
            SizedBox(width: 20.0),
            this._province(provinces[provinceIndex++], context),
          ],
        ),
        Row(
          children: <Widget>[
            this._province(provinces[provinceIndex++], context),
            SizedBox(width: 20.0),
            this._province(provinces[provinceIndex++], context),
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
        child: Column(
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
        ),
      ),
    );
  }

  void _gotoProvince(ProvinceInfo info, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ProvincePage(info);
    }));
  }
}
