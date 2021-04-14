import 'package:application/Models/Pair.dart';

class UpdateDto {
  Pair challengeDto;
  double distanceTraveled;
  double heightTraveled;
  double timeTaken;

  UpdateDto(this.challengeDto, this.distanceTraveled, this.heightTraveled,
      this.timeTaken);

  UpdateDto.fromJson(Map<String, dynamic> json)
      : challengeDto = json['challengeDto'],
        distanceTraveled = json['distanceTraveled'],
        heightTraveled = json['heightTraveled'],
        timeTaken = json['timeTaken'];

  Map<String, dynamic> toJson() => {
        'challengeDto': challengeDto.toJson(),
        'distanceTraveled': distanceTraveled,
        'heightTraveled': heightTraveled,
        'timeTaken': timeTaken,
      };
}
