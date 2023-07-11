import 'dart:math';

import 'package:flutter/material.dart';
import 'package:particle_field/particle_field.dart';
import 'package:particles_fly/particles_fly.dart';
import 'package:rnd/rnd.dart';

class ParticleExample extends StatelessWidget {
  const ParticleExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: ParticlesFly(
      height: size.height,
      width: size.width,
      numberOfParticles: 100,
      connectDots: true,
      onTapAnimation: true,
      awayRadius: 20,
      speedOfParticles: 5,
      isRandomColor: true,
    ));
  }
}
