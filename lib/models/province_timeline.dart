
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


import 'package:json_annotation/json_annotation.dart';

part 'province_timeline.g.dart';

/// The Province's Corona Info.
@JsonSerializable(explicitToJson: true)
class ProvinceTimeline {
  @JsonKey(name: 'updated_at', required: true)
  DateTime updateAt;

  @JsonKey(name: 'name', nullable: false, required: true)
  String name;

  @JsonKey(name: 'iso_code', nullable: false, required: true)
  String isoCode;

  @JsonKey(name: 'infections', nullable: true)
  int numInfections;

  @JsonKey(name: 'deaths', nullable: true)
  int numDeaths;

  @JsonKey(name: 'recoveries', nullable: true)
  int numRecovered;

  @JsonKey(name: 'tests', nullable: true)
  int numTests;

  ProvinceTimeline({
    this.name,
    this.isoCode,
    this.numDeaths,
    this.numInfections,
    this.numRecovered,
    this.numTests,
    this.updateAt,
  });

  factory ProvinceTimeline.fromJson(Map<String, dynamic> json) => _$ProvinceTimelineFromJson(json);

  Map<String, dynamic> toJson() => _$ProvinceTimelineToJson(this);
}
