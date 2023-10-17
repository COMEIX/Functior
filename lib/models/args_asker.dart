// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import './arg.dart';

class ArgsAsker extends ChangeNotifier {
  final _particle_samplingRate = TextEditingController();
  final _particle_particleHeight = TextEditingController();
  final _particle_particleTypeId = TextEditingController();
  final _particle_targetColor = TextEditingController();
  final _particle_surface = TextEditingController();

  final _block_samplingRate = TextEditingController();
  final _block_surface = TextEditingController();
  final _block_allowSand = TextEditingController();
  final _block_allowGlass = TextEditingController();

  late final _to_particles = [
    Arg(
        name: '采样率 Sampling Rate',
        icon: Icons.info_outline,
        hintText: '(0,1]',
        controller: _particle_samplingRate,
        defaultValue: 1.0,
        explaination: '采样像素量占总像素量的比值。直接影响到粒子数目和粒子密度\n默认值：1.0'
    ),
    Arg(
        name: '粒子高度 Particle Height',
        icon: Icons.info_outline,
        hintText: '(0,100]',
        controller: _particle_particleHeight,
        defaultValue: 5.0,
        explaination: '所生成粒子画的垂直高度。对应图片的高\n默认值：5.0'
    ),
    Arg(
        name: '粒子ID Particle TypeId',
        icon: Icons.info_outline,
        hintText: 'namespace:identifier',
        controller: _particle_particleTypeId,
        defaultValue: 'minecraft:endrod',
        explaination: '粒子的识别符。通常形似 namespace:identifier\n默认值：minecraft:endrod'
    ),
    Arg(
      name: '目标颜色 Target Color',
      icon: Icons.info_outline,
      hintText: '#000000',
      controller: _particle_targetColor,
      defaultValue: '#000000',
      explaination: '目标识别颜色的十六进制表示。目标颜色处会生成粒子，剩余颜色会被抛弃\n默认值：#000000 (黑)'
    ),
    Arg(
      name: '生成平面 Generation Surface',
      icon: Icons.info_outline,
      hintText: 'xOy/xOz/yOz',
      controller: _particle_surface,
      defaultValue: 'xOy',
      explaination: '所生成粒子画所在平面\n默认值：xOy'
    ),
  ];

  late final _to_blocks = [
    Arg(
        name: '采样率 Sampling Rate',
        icon: Icons.info_outline,
        hintText: '(0,1]',
        controller: _block_samplingRate,
        defaultValue: 1.0,
        explaination: '采样像素量占总像素量的比值。直接影响到像素画大小\n默认值：1.0'
    ),
    Arg(
      name: '生成平面 Generation Surface',
      icon: Icons.info_outline,
      hintText: 'xOy/xOz/yOz',
      controller: _block_surface,
      defaultValue: 'xOy',
      explaination: '所生成像素画所在平面\n默认值：xOy'
    ),
    Arg(
      name: '是否允许存在沙子 Allow Sand',
      icon: Icons.info_outline,
      hintText: 'true/false',
      controller: _block_allowSand,
      defaultValue: 'true',
      explaination: '是否允许所生成像素画中含有沙子类方块\n默认值：true'
    ),
    Arg(
      name: '是否允许存在玻璃 Allow Glass',
      icon: Icons.info_outline,
      hintText: 'true/false',
      controller: _block_allowGlass,
      defaultValue: 'true',
      explaination: '是否允许所生成像素画中含有玻璃类方块\n默认值：true'
    ),
  ];

  List<Arg> get toParticlesArgs => _to_particles;
  List<Arg> get toBlocksArgs => _to_blocks;
}
