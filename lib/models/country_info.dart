
///
/// Marvin Kagiso
/// 21:49 2020/06/27
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


import 'package:json_annotation/json_annotation.dart';

part 'country_info.g.dart';


/// The Country's Corona Info.
@JsonSerializable(explicitToJson: true)
class CountryInfo {
  @JsonKey(name: 'name', nullable: false, required: true)
  String name;

  @JsonKey(name: 'iso_code', nullable: false, required: true)
  String isoCode;

  @JsonKey(name: 'updated_at', nullable: false, required: true)
  DateTime updatedAt;

  @JsonKey(name: 'infections', nullable: true)
  int numInfections;

  @JsonKey(name: 'deaths', nullable: true)
  int numDeaths;

  @JsonKey(name: 'recoveries', nullable: true)
  int numRecovered;

  @JsonKey(name: 'tests', nullable: true)
  int numTests;

  @JsonKey(name: 'deaths_0_to_9', nullable: true)
  int numDeaths0To9;

  @JsonKey(name: 'deaths_10_to_19', nullable: true)
  int numDeaths10To19;

  @JsonKey(name: 'deaths_20_to_29', nullable: true)
  int numDeaths20To29;

  @JsonKey(name: 'deaths_30_to_39', nullable: true)
  int numDeaths30To39;

  @JsonKey(name: 'deaths_40_to_49', nullable: true)
  int numDeaths40To49;

  @JsonKey(name: 'deaths_50_to_59', nullable: true)
  int numDeaths50To59;

  @JsonKey(name: 'deaths_60_to_69', nullable: true)
  int numDeaths60To69;

  @JsonKey(name: 'deaths_70_to_79', nullable: true)
  int numDeaths70To79;

  @JsonKey(name: 'deaths_80_to_89', nullable: true)
  int numDeaths80To89;

  @JsonKey(name: 'deaths_90_to_99', nullable: true)
  int numDeaths90To99;

  CountryInfo({
    this.name,
    this.numDeaths,
    this.numInfections,
    this.numRecovered,
    this.numTests,
    this.numDeaths0To9,
    this.numDeaths10To19,
    this.numDeaths20To29,
    this.numDeaths30To39,
    this.numDeaths40To49,
    this.numDeaths50To59,
    this.numDeaths60To69,
    this.numDeaths70To79,
    this.numDeaths80To89,
    this.numDeaths90To99
  });

  factory CountryInfo.fromJson(Map<String, dynamic> json) => _$CountryInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CountryInfoToJson(this);
}
