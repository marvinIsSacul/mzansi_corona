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

import './pages/country_page.dart';
import './helpers/styles.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Styles.kColourAppPrimary,
    systemNavigationBarColor: Styles.kColourAppPrimary,
  ));
  runApp(MyApp());
}


/// Root of application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mzansi Corona',
      theme: ThemeData(
        primarySwatch: Styles.kColourAppPrimary,
        brightness: Brightness.light,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Styles.kColourAppTextPrimary,
          displayColor: Styles.kColourAppTextPrimary,
          fontFamily: 'Poppins',
        ),
        platform: TargetPlatform.iOS,
        accentColor: Styles.kColourAppPrimary,
        accentColorBrightness: Brightness.light,
      ),
      home: CountryPage(),
    );
  }
}
